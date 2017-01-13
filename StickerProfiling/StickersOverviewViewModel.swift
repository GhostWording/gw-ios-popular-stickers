//
//  StickersOverviewViewModel.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 05/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class StickersThemeAndIntentionInfo {
    
    /**
     @abstract The path to download all images for the intention or theme
    */
    var imagePath: String?
    var title: String?
    /**
     @bastract The path for the image that is displayed in the collection view
     */
    var defaultImagePath: String?
    var image: UIImage?
    var isDownloading = false
    var intentionId: String?
    var sortOrder: Int?
    
}

class StickersOverviewViewModel: NSObject, MAXCollectionViewImageAndTextDataSource {
    
    var themeAndIntentionList: [StickersThemeAndIntentionInfo]?
    var themes: [AnyHashable: Any]?
    
    var downloadImageClosure: ((_ indexPath: IndexPath) -> Void)?
    var selectedStickerClosure: ((_ label: String?, _ imagePath: String?, _ intentionId: String?) -> Void)?

    override init() {
        super.init()
        
        self.themeAndIntentionList = []
    }
    
    // MARK: Reload functions
    
    func reloadData() {
        
        let intentions = GWDataManager().fetchIntentions(withAreaName: nil, culture: GWLocalizedBundle.currentLocaleAPIString(), withIntentionsIds: nil) 
        
        themeAndIntentionList?.removeAll()
        
        var imagePaths = [String]()
        
        for currentIntention in intentions {
            
            let themeAndIntentionInfo = StickersThemeAndIntentionInfo()
            themeAndIntentionInfo.title = currentIntention.label
            themeAndIntentionInfo.imagePath = currentIntention.imagePath
            themeAndIntentionInfo.defaultImagePath = currentIntention.mediaUrl
            themeAndIntentionInfo.intentionId = currentIntention.intentionId
            themeAndIntentionInfo.sortOrder = currentIntention.sortOrderInArea?.intValue
            
            themeAndIntentionList?.append(themeAndIntentionInfo)
            imagePaths.append(themeAndIntentionInfo.defaultImagePath!)
        }
        
        if let themes = self.themes?["Themes"] as? [NSDictionary] {
            
            for themeDict in themes {
                
                
                let themeAndIntentionInfo = StickersThemeAndIntentionInfo()
                themeAndIntentionInfo.title = self.findLabelTitle( GWLocalizedBundle.currentLocaleAPIString(), labelArray: themeDict.object(forKey: "Labels") as! [NSDictionary])
                themeAndIntentionInfo.imagePath = themeDict.object(forKey: "Path") as? String
                themeAndIntentionInfo.defaultImagePath = self.appendApiPathToImage(themeDict.object(forKey: "DefaultImage") as! String)
                
                
                if( themeAndIntentionInfo.imagePath == "themes/nature" ) {
                    themeAndIntentionInfo.sortOrder = 1
                }
                else if( themeAndIntentionInfo.imagePath == "themes/emoticons" ) {
                    themeAndIntentionInfo.sortOrder = 0
                }
                else {
                    themeAndIntentionInfo.sortOrder = 10000
                }
                
                themeAndIntentionList?.append(themeAndIntentionInfo)
                imagePaths.append(themeAndIntentionInfo.defaultImagePath!)
            }
            
        }
        
        let images = GWImageManager.fetchImages(withPaths: imagePaths)
        
        for image in images {
            for themeOrIntention in themeAndIntentionList! {
                
                if let imageData = image.imageData, self.removeApiPathFromImage(themeOrIntention.defaultImagePath) == image.imageId {
                    themeOrIntention.image = UIImage(data: imageData)
                }
                
            }
        }
        
        themeAndIntentionList?.sort(by: {
            firstThemeAndIntention, secondThemeAndIntention -> Bool in
            
            return firstThemeAndIntention.sortOrder < secondThemeAndIntention.sortOrder
            
        })
        
    }
    
    func selectedSticker(_ completion: @escaping (_ label: String?, _ imagePath: String?, _ intentionId: String?) -> Void) {
        selectedStickerClosure = completion
    }
    
    func reloadCellAtIndexPath(_ completion: @escaping (_ indexPath: IndexPath) -> Void) {
        downloadImageClosure = completion
    }
    
    // Collection view delegate
    
    func maxCollectionViewImageAndTextNumItems(inSection theSection: Int) -> Int {
        
        if let intentionAndThemes = self.themeAndIntentionList {
            return intentionAndThemes.count
        }
        
        return 0
    }
    
    func maxTitle(inSection theSection: Int, at theIndex: Int) -> String! {
        
        if let themesAndIntentions = self.themeAndIntentionList, theIndex < self.themeAndIntentionList?.count {
            return themesAndIntentions[theIndex].title
        }
        
        return ""
    }
    

    func maxSelectedItem(inSection theSection: Int, at theIndex: Int) {
        
        if let intentionAndTheme = self.themeAndIntentionList?[theIndex], theIndex < themeAndIntentionList?.count {
            self.selectedStickerClosure?(intentionAndTheme.title, intentionAndTheme.imagePath, intentionAndTheme.intentionId)
        }
        
    }
    
    func maxCollectionViewSize(at theIndexPath: IndexPath!) -> CGSize {
        
        let height = UIScreen.main.bounds.width / 2.0
        return CGSize(width: height, height: height + 46)
    }
    
    func maxCollectionViewCell(_ theCell: MAXCollectionViewCellImageAndText!, atIndex theIndexPath: IndexPath!) {
        
        theCell.imageView.contentMode = UIViewContentMode.scaleAspectFill
        theCell.imageView.layer.masksToBounds = true
        
        
        if let image = themeAndIntentionList?[theIndexPath.row].image {
            
            theCell.imageView.image = image
            
        }
        else if self.themeAndIntentionList?[theIndexPath.row].isDownloading == false {
            
            theCell.imageView.image = nil
            
            if let currentImage = self.themeAndIntentionList?[theIndexPath.row], let imagePath = self.themeAndIntentionList?[theIndexPath.row].defaultImagePath {
                
                currentImage.isDownloading = true
                
                GWImageManager.downloadImageIfNotExists(withPath: imagePath, imageDataCompletion: {
                    imageId, imageData, error -> Void in
                    
                    if let nonNilImageData = imageData {
                        
                        currentImage.image = UIImage(data: nonNilImageData)
                        self.downloadImageClosure?(theIndexPath)
                        
                    }
                    
                })
                
            }
            
        }
        else {
            theCell.imageView.image = nil
        }
        
        let halfWidth = UIScreen.main.bounds.width / 2.0
        
        theCell.imageView.frame = CGRect(x: 0, y: 0, width: halfWidth, height: halfWidth)
        theCell.titleLabel.frame = CGRect(x: halfWidth * 0.05, y: halfWidth + 3, width: halfWidth * 0.9, height: 40)
        theCell.titleLabelFrame = theCell.titleLabel.frame
        theCell.titleLabel.numberOfLines = 0
    }
    
    
    // MARK: Downlad intentions
    
    func downloadIntentions(_ completion: @escaping (_ error: Error?) -> Void) {
        GWDataManager().downloadIntentions(withArea: "stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
            intentions, error -> Void in
            
            DispatchQueue.main.async(execute: {
                
                self.reloadData()
                completion(error as Error?)
            })
            
        })
    }
    
    func downloadThemes(_ completion: @escaping (_ error: Error?) -> Void) {
        
        GWDataManager().downloadImageThemes(withPath: "http://gw-static-apis.azurewebsites.net/data/stickers/moodthemes.json", withCompletion: {
            themes, error -> Void in
            
            if error == nil {
                self.themes = themes
            }
            
            DispatchQueue.main.async(execute: {
                
                self.reloadData()
                completion(error as Error?)
                
            })
            
        })
        
    }
    
    func downloadImage(_ path: String, completion: @escaping (_ image: GWImage?, _ error: Error?) -> Void) {
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.low).async(execute: {
            GWDataManager().downloadImagesAndPersistIfNotExist( withUrls: [path] , withCompletion: {
                imageIds, error -> Void in
                
                DispatchQueue.main.async(execute: {
                    let firstImage = GWDataManager().fetchImages( withImagePaths: [path] ).first as? GWImage
                    completion(firstImage, error as Error?)
                })
            })
        })
        
    }
    
    // MARK: Helper methods
    
    func appendApiPathToImage(_ path: String) -> String {
        
        return "http://gw-static.azurewebsites.net/" + path
        
    }
    
    func removeApiPathFromImage(_ path: String?) -> String? {
        
        var newPath = path?.replacingOccurrences(of: "http://gw-static.azurewebsites.net", with: "")
        newPath = newPath?.replacingOccurrences(of: "http://az767698.vo.msecnd.net", with: "")
        
        return newPath
    }
    
    func findLabelTitle(_ culture: String, labelArray: [NSDictionary]) -> String? {
        
        for dict in labelArray {
            
            if (dict.object(forKey: "Language") as? String) == culture {
                return dict.object(forKey: "Label") as? String
            }
            
        }
        
        return nil
    }
    
}
