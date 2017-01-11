//
//  StickersDetailViewModel.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 06/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

class StickersImageAndPathObject: NSObject {
    
    var imagePath: String?
    var image: UIImage?
    var isDownloading = false
    
}

class StickersDetailViewModel: NSObject, MAXCollectionViewImageAndTextDataSource, FBNativeAdDelegate {

    var imagePath: String?
    var imagesToDownload: [StickersImageAndPathObject]?
    
    var indexPathClosure: ((_ indexPath: IndexPath) -> Void)?
    var selectedImageClosure: ((_ imageName: String?, _ image: UIImage?) -> Void)?
    var itemSize: Float?
    var bottomAdView: FBNativeAd?
    var viewController : StickersDetailViewController?
    
    override init() {
        super.init()
        
        imagesToDownload = [StickersImageAndPathObject]()
        
        if let _ = GWExperiment.variationId() {
            
            bottomAdView = FBNativeAd(placementID: bottomStickerGalleryPlacementId)
            bottomAdView?.delegate = self
            bottomAdView?.mediaCachePolicy = FBNativeAdsCachePolicy.all
            bottomAdView?.load()
            
        }
        
    }
    
    func nameForTheme(_ themes: Array <NSDictionary> , themePath: String) -> String? {
        
        for theme in themes {
            
            if (theme.object(forKey: "Path") as? String) == themePath  {
                
                if let labels = theme.object(forKey: "Labels") as? [NSDictionary] {
                    
                    for labelDict in labels {
                        if (labelDict.object(forKey: "Language") as? String) == GWLocalizedBundle.currentLocaleAPIString() {
                            return (labelDict.object(forKey: "Label") as? String)
                        }
                    }
                    
                }
                
            }
            
        }
        
        return ""
    }
    
    // MARK: Download
    
    func downloadPopularImageIds(_ area: String, intentionId: String, completion: @escaping (_ error: Error?) -> Void) {
        
        GWImageManager.downloadPopularImages(withArea: area, intentionId: intentionId, completion: {
            allPopularImages, error -> Void in
            
            completion(error as Error?)
            
        })
        
    }
    
    func downloadImageIds(_ completion: @escaping (_ error: Error?) -> Void) {
        
        if let imageDownloadPath = self.imagePath {
            
            GWDataManager().downloadImagePaths(withRelativePath: imageDownloadPath, withCompletion: {
                theImagePaths, error -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    
                    if let imagePaths = theImagePaths as? [String] {
                        
                        var allImagesPaths = [String]()
                        let randomImagePaths = self.randomizeImagePaths(imagePaths)
                        
                        for path in randomImagePaths {
                            
                            if self.imageExists(path) == false {
                                let stickerImages = StickersImageAndPathObject()
                                stickerImages.imagePath = self.appendApiPathToImage(path)
                                self.imagesToDownload?.append(stickerImages)
                                
                                if let imageDownloadPath = stickerImages.imagePath {
                                    allImagesPaths.append(imageDownloadPath)
                                }
                            }
                            
                        }
                        
                        var persistedImages = GWImageManager.fetchImages(withPaths: allImagesPaths)
                        
                        persistedImages = self.randomizeImages( persistedImages )
                        
                        
                        for persistedImage in persistedImages {
                            for stickerImage in self.imagesToDownload! {
                                if let imageData = persistedImage.imageData, stickerImage.imagePath == persistedImage.imageId && stickerImage.image == nil {
                                    stickerImage.image = UIImage(data: imageData)
                                }
                            }
                        }
                        
                        
                    }
                    
                    completion(error as Error?)
                })
                
            })
            
        }
        
    }
    
    func reloadData() {
        
        if self.imagePath != nil {
            
            imagesToDownload = [StickersImageAndPathObject]()
            
            var persistedImages =  GWImageManager.fetchImagesContainingPartialPath(self.imagePath!)
            
            persistedImages = self.randomizeImages( persistedImages )
            
            
            for persistedImage in persistedImages {
                
                let stickerImage = StickersImageAndPathObject()
                
                stickerImage.imagePath = self.appendApiPathToImage(persistedImage.imageId!)
                
                if let imageData = persistedImage.imageData {
                    stickerImage.image = UIImage(data: imageData)
                }
                
                imagesToDownload?.append(stickerImage)
            }
            
        }
        
    }
    
    func reloadIndexPath(_ closure: @escaping (_ indexPath: IndexPath) -> Void) {
        indexPathClosure = closure
    }
    
    func selectedImage(_ closure: @escaping (_ imageName: String?, _ image: UIImage?) -> Void) {
        selectedImageClosure = closure
    }
    
    func imageExists(_ path: String) -> Bool {
        
        for currentThemeOrIntention in imagesToDownload! {
            
            if currentThemeOrIntention.imagePath == self.appendApiPathToImage(path) {
                return true
            }
            
        }
        
        return false
    }
    
    func imageIndex(_ path: String) -> Int? {
        
        var index = 0
        for currentThemeOrIntention in imagesToDownload! {
            
            if currentThemeOrIntention.imagePath == self.appendApiPathToImage(path) {
                return index
            }
            
            index += 1
            
        }
        
        return nil
    }
    
    // MARK: Collection View
    
    func maxCollectionViewImageAndTextNumItems(inSection theSection: Int) -> Int {
        
        if let count = imagesToDownload?.count {
            return count
        }
        
        return 0
    }
    
    func maxCollectionViewSize(at theIndexPath: IndexPath!) -> CGSize {
        
        if theIndexPath.row == imagesToDownload?.count {
            
            return CGSize(width: UIScreen.main.bounds.width, height: 340)
        }
        
        if let size = self.itemSize {
            return CGSize(width: CGFloat(size), height: CGFloat(size))
        }
        
        return CGSize.zero
    }
    

    func maxCollectionViewCell(_ theCell: MAXCollectionViewCellImageAndText!, atIndex theIndexPath: IndexPath!) {
        
        theCell.imageView.contentMode = UIViewContentMode.scaleAspectFill
        theCell.layer.masksToBounds = true
        
        if theIndexPath.row == imagesToDownload!.count {
            
            theCell.type = MAXCellType.advert
            
            theCell.imageView.image = nil
            
            
            if let nonNilAd = bottomAdView {
                if nonNilAd.isAdValid == true {
                    
                    nonNilAd.registerView( forInteraction: theCell, with: self.viewController)
                    nonNilAd.icon?.loadAsync(block: {
                        image in
                        
                        theCell.logoImageView.contentMode = UIViewContentMode.scaleAspectFit
                        theCell.logoImageView.layer.masksToBounds = true
                        theCell.logoImageView.image = image
                        
                    })
                    
                    theCell.adChoiceLabel.nativeAd = nonNilAd
                    theCell.adMediaView.nativeAd = nonNilAd
                    
                    theCell.titleLabel.text = nonNilAd.title
                    theCell.titleLabel.font = UIFont.c_robotoBold( withSize: 14.0 )
                    theCell.titleLabel.textAlignment = .left
                    theCell.titleLabel.textColor = UIColor.c_textDarkGray()
                    
                    theCell.sponsoredLabel.text = "Sponsored"
                    theCell.sponsoredLabel.textAlignment = .left
                    theCell.sponsoredLabel.font = UIFont.c_robotoLight( withSize: 12.0 )
                    theCell.sponsoredLabel.textColor = UIColor.c_textLightGray()
                    
                    theCell.adSocialContextLabel.text = nonNilAd.socialContext
                    theCell.adSocialContextLabel.textAlignment = .left
                    theCell.adSocialContextLabel.textColor = UIColor.c_textLightGray()
                    theCell.adSocialContextLabel.font = UIFont.c_robotoLight( withSize: 12.0 )
                    
                    theCell.adBodyLabel.text = nonNilAd.body
                    theCell.adBodyLabel.textAlignment = .left
                    theCell.adBodyLabel.font = UIFont.c_robotoMedium( withSize: 12.0 )
                    theCell.adBodyLabel.textColor = UIColor.c_textLightGray()
                    theCell.adBodyLabel.numberOfLines = 0
                    
                    theCell.adChoiceLabel.corner = UIRectCorner.topRight
                    
                    theCell.callToActionButton.setTitle(nonNilAd.callToAction, for: UIControlState())
                    theCell.callToActionButton.layer.cornerRadius = 4.0
                    theCell.callToActionButton.layer.backgroundColor = UIColor.c_blue().cgColor
                    theCell.callToActionButton.titleLabel?.font = UIFont.c_robotoMedium( withSize: 12.0)
                    
                }
                
            }
            
            
            return
        }
        
        theCell.type = MAXCellType.image
        
        if let image = self.imagesToDownload?[theIndexPath.row].image {
            
            theCell.imageView.image = image
            
            
        }
        else if self.imagesToDownload?[theIndexPath.row].isDownloading == false {
            
            theCell.imageView.image = nil
            
            if let currentImage = self.imagesToDownload?[theIndexPath.row], let imagePath = self.imagesToDownload?[theIndexPath.row].imagePath {
                currentImage.isDownloading = true
                
                GWImageManager.downloadImageIfNotExists(withPath: imagePath, imageDataCompletion: {
                    imageId, imageData, error -> Void in
                    
                    if let nonNilImageData = imageData {
                        currentImage.image = UIImage(data: nonNilImageData)
                        self.indexPathClosure?(theIndexPath)
                    }
                    
                })
                
            }
        }
        else {
            theCell.imageView.image = nil
        }
        
        theCell.imageViewFrame = CGRect(x: 0, y: 0, width: CGFloat(self.itemSize!), height: CGFloat(self.itemSize!))
        theCell.titleLabelFrame = CGRect.zero
        
    }
    
    func maxSelectedItem(inSection theSection: Int, at theIndex: Int) {
        
        if let selectedImage = self.imagesToDownload?[theIndex].image, let imageName = self.imagesToDownload?[theIndex].imagePath {
            self.selectedImageClosure?(imageName, selectedImage)
        }
       
    }
    
    
    func appendApiPathToImage(_ path: String) -> String {
        
        return "http://gw-static.azurewebsites.net" + path
        
    }
    
    /**
     @description If the intention id is one of the following we should set the intention id to the same as was
     sent to answer the message: I like you (64B504), I love you (5CDCF2), Miss you (8ED62C), Good morning (030FD0), Good night (D392C1), Happy new year (938493), I would like to see you again, I think of you (016E91), I miss you (8ED62C), I want you (F4566D), Joke (0B1EA1), Facebook status (2E2986), Polite/Humorous insults (0ECC82)
     

    */
    func shouldAnswerWithSameIntention(_ intentionId: String) -> Bool {
        
        return false
    }
    
    /**
     @description If the intention id is one of the following we should set the intention
     to thank you to answer the message: Happy birthday (A730B4), Have a nice trip (EEDAC3), I'm here for you (03B6E4),
     Come over for dinner (D19840), Celebrate the occasion (EB020F), Retirement congratulation (577D28), congratulations on the birth of your baby (63BF3A), Wedding congratulations (764A35), Condolences (B47AE0)
    */
    func shouldAnswerWithThankYou(_ intentionId: String?) -> Bool {
        
        
        if intentionId == "A730B4" || intentionId == "EEDAC3" || intentionId == "03B6E4" || intentionId == "D19840" {
            
            return true
        }
        
        return false
        
    }
    
    fileprivate func randomizeImagePaths(_ paths: [String]) -> [String] {
        var paths = paths
        
        var index = 0
        for _ in paths {
            
            let pos = Int( arc4random_uniform( UInt32(paths.count) ) )
            if index != pos {
                swap(&paths[index], &paths[pos])
            }
            
            index += 1
        }
        
        return paths
    }
    
    fileprivate func randomizeImages(_ images: [GWImage]) -> [GWImage] {
        
        var images = images
        
        var index = 0
        for _ in images {
            
            let pos = Int( arc4random_uniform( UInt32(images.count) ) )
            if index != pos {
                swap(&images[index], &images[pos])
            }
            
            index += 1
            
        }
        
        return images
    }
}
