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

class StickersDetailViewModel: NSObject, MAXCollectionViewImageAndTextDataSource {

    var imagePath: String?
    var imagesToDownload: [StickersImageAndPathObject]?
    
    var indexPathClosure: ((indexPath: NSIndexPath) -> Void)?
    var selectedImageClosure: ((imageName: String?, image: UIImage?) -> Void)?
    var itemSize: Float?
    
    override init() {
        super.init()
        
        imagesToDownload = [StickersImageAndPathObject]()
        
    }
    
    func nameForTheme(themes: Array <NSDictionary> , themePath: String) -> String? {
        
        for theme in themes {
            
            if (theme.objectForKey("Path") as? String) == themePath  {
                
                if let labels = theme.objectForKey("Labels") as? [NSDictionary] {
                    
                    for labelDict in labels {
                        if (labelDict.objectForKey("Language") as? String) == GWLocalizedBundle.currentLocaleAPIString() {
                            return (labelDict.objectForKey("Label") as? String)
                        }
                    }
                    
                }
                
            }
            
        }
        
        return ""
    }
    
    // MARK: Download
    
    func downloadPopularImageIds(area: String, intentionId: String, completion: (error: NSError?) -> Void) {
        
        GWImageManager.downloadPopularImagesWithArea(area, intentionId: intentionId, completion: {
            allPopularImages, error -> Void in
            
            print("popular images are \(allPopularImages)")
            
            completion(error: error)
            
        })
        
    }
    
    func downloadImageIds(completion: (error: NSError?) -> Void) {
        
        if let imageDownloadPath = self.imagePath {
            
            GWDataManager().downloadImagePathsWithRelativePath(imageDownloadPath, withCompletion: {
                theImagePaths, error -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    
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
                        
                        var persistedImages = GWImageManager.fetchImagesWithPaths(allImagesPaths)
                        
                        persistedImages = self.randomizeImages( persistedImages )
                        
                            /*
                        else {
                            
                            for var i = 0; i < imagePaths.count; i += 1 {
                            
                                let currentPath = imagePaths[i]
                                let imageIndexForPath = self.imageIndex(currentPath)
                                
                                if let index = imageIndexForPath where i != imageIndexForPath {
                                    
                                    swap( &self.imagesToDownload![i] , &self.imagesToDownload![index] )
                                    
                                }
                                
                                
                            }
 
                        }*/
                        
                        for persistedImage in persistedImages {
                            for stickerImage in self.imagesToDownload! {
                                if let imageData = persistedImage.imageData where stickerImage.imagePath == persistedImage.imageId && stickerImage.image == nil {
                                    stickerImage.image = UIImage(data: imageData)
                                }
                            }
                        }
                        
                        
                    }
                    
                    completion(error: error)
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
    
    func reloadIndexPath(closure: (indexPath: NSIndexPath) -> Void) {
        indexPathClosure = closure
    }
    
    func selectedImage(closure: (imageName: String?, image: UIImage?) -> Void) {
        selectedImageClosure = closure
    }
    
    func imageExists(path: String) -> Bool {
        
        for currentThemeOrIntention in imagesToDownload! {
            
            if currentThemeOrIntention.imagePath == self.appendApiPathToImage(path) {
                return true
            }
            
        }
        
        return false
    }
    
    func imageIndex(path: String) -> Int? {
        
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
    
    func MAXCollectionViewImageAndTextNumItemsInSection(theSection: Int) -> Int {
        
        if let count = imagesToDownload?.count {
            return count
        }
        
        return 0
    }
    
    func MAXCollectionViewSizeAtIndexPath(theIndexPath: NSIndexPath!) -> CGSize {
        
        if let size = self.itemSize {
            return CGSizeMake(CGFloat(size), CGFloat(size))
        }
        
        return CGSizeZero
    }
    

    func MAXCollectionViewCell(theCell: MAXCollectionViewCellImageAndText!, atIndex theIndexPath: NSIndexPath!) {
        
        theCell.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        theCell.layer.masksToBounds = true
        
        if let image = self.imagesToDownload?[theIndexPath.row].image {
            
            theCell.imageView.image = image
            
            
        }
        else if self.imagesToDownload?[theIndexPath.row].isDownloading == false {
            
            theCell.imageView.image = nil
            
            if let currentImage = self.imagesToDownload?[theIndexPath.row], let imagePath = self.imagesToDownload?[theIndexPath.row].imagePath {
                currentImage.isDownloading = true
                
                GWImageManager.downloadImageIfNotExistsWithPath(imagePath, imageDataCompletion: {
                    imageId, imageData, error -> Void in
                    
                    if let nonNilImageData = imageData {
                        currentImage.image = UIImage(data: nonNilImageData)
                        self.indexPathClosure?(indexPath: theIndexPath)
                    }
                    
                })
                
            }
        }
        else {
            theCell.imageView.image = nil
        }
        
        theCell.imageViewFrame = CGRectMake(0, 0, CGFloat(self.itemSize!), CGFloat(self.itemSize!))
        theCell.titleLabelFrame = CGRectZero
        
    }
    
    func MAXSelectedItemInSection(theSection: Int, atIndex theIndex: Int) {
        
        if let selectedImage = self.imagesToDownload?[theIndex].image, let imageName = self.imagesToDownload?[theIndex].imagePath {
            self.selectedImageClosure?(imageName: imageName, image: selectedImage)
        }
       
    }
    
    
    func appendApiPathToImage(path: String) -> String {
        
        return "http://gw-static.azurewebsites.net" + path
        
    }
    
    /**
     @description If the intention id is one of the following we should set the intention id to the same as was
     sent to answer the message: I like you (64B504), I love you (5CDCF2), Miss you (8ED62C), Good morning (030FD0), Good night (D392C1), Happy new year (938493), I would like to see you again, I think of you (016E91), I miss you (8ED62C), I want you (F4566D), Joke (0B1EA1), Facebook status (2E2986), Polite/Humorous insults (0ECC82)
     

    */
    func shouldAnswerWithSameIntention(intentionId: String) -> Bool {
        
        return false
    }
    
    /**
     @description If the intention id is one of the following we should set the intention
     to thank you to answer the message: Happy birthday (A730B4), Have a nice trip (EEDAC3), I'm here for you (03B6E4),
     Come over for dinner (D19840), Celebrate the occasion (EB020F), Retirement congratulation (577D28), congratulations on the birth of your baby (63BF3A), Wedding congratulations (764A35), Condolences (B47AE0)
    */
    func shouldAnswerWithThankYou(intentionId: String?) -> Bool {
        
        
        if intentionId == "A730B4" || intentionId == "EEDAC3" || intentionId == "03B6E4" || intentionId == "D19840" {
            
            return true
        }
        
        return false
        
    }
    
    private func randomizeImagePaths(paths: [String]) -> [String] {
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
    
    private func randomizeImages(images: [GWImage]) -> [GWImage] {
        
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
