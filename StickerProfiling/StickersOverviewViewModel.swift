//
//  StickersOverviewViewModel.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 05/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

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
    var themes: [NSObject : AnyObject]?
    
    var downloadImageClosure: ((indexPath: NSIndexPath) -> Void)?
    var selectedStickerClosure: ((label: String?, imagePath: String?, intentionId: String?) -> Void)?

    override init() {
        super.init()
        
        self.themeAndIntentionList = []
    }
    
    // MARK: Reload functions
    
    func reloadData() {
        
        let intentions = GWDataManager().fetchIntentionsWithAreaName(nil, culture: GWLocalizedBundle.currentLocaleAPIString(), withIntentionsIds: nil) 
        
        themeAndIntentionList?.removeAll()
        
        var imagePaths = [String]()
        
        for currentIntention in intentions {
            
            let themeAndIntentionInfo = StickersThemeAndIntentionInfo()
            themeAndIntentionInfo.title = currentIntention.label
            themeAndIntentionInfo.imagePath = currentIntention.imagePath
            themeAndIntentionInfo.defaultImagePath = currentIntention.mediaUrl
            themeAndIntentionInfo.intentionId = currentIntention.intentionId
            themeAndIntentionInfo.sortOrder = currentIntention.sortOrderInArea?.integerValue
            
            themeAndIntentionList?.append(themeAndIntentionInfo)
            imagePaths.append(themeAndIntentionInfo.defaultImagePath!)
        }
        
        if let themes = self.themes?["Themes"] as? [NSDictionary] {
            
            for themeDict in themes {
                
                
                let themeAndIntentionInfo = StickersThemeAndIntentionInfo()
                themeAndIntentionInfo.title = self.findLabelTitle( GWLocalizedBundle.currentLocaleAPIString(), labelArray: themeDict.objectForKey("Labels") as! [NSDictionary])
                themeAndIntentionInfo.imagePath = themeDict.objectForKey("Path") as? String
                themeAndIntentionInfo.defaultImagePath = self.appendApiPathToImage(themeDict.objectForKey("DefaultImage") as! String)
                
                
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
        
        let images = GWImageManager.fetchImagesWithPaths(imagePaths)
        
        for image in images {
            for themeOrIntention in themeAndIntentionList! {
                
                if let imageData = image.imageData where self.removeApiPathFromImage(themeOrIntention.defaultImagePath) == image.imageId {
                    themeOrIntention.image = UIImage(data: imageData)
                }
                
            }
        }
        
        themeAndIntentionList?.sortInPlace({
            firstThemeAndIntention, secondThemeAndIntention -> Bool in
            
            return firstThemeAndIntention.sortOrder < secondThemeAndIntention.sortOrder
            
        })
        
    }
    
    func selectedSticker(completion: (label: String?, imagePath: String?, intentionId: String?) -> Void) {
        selectedStickerClosure = completion
    }
    
    func reloadCellAtIndexPath(completion: (indexPath: NSIndexPath) -> Void) {
        downloadImageClosure = completion
    }
    
    // Collection view delegate
    
    func MAXCollectionViewImageAndTextNumItemsInSection(theSection: Int) -> Int {
        
        if let intentionAndThemes = self.themeAndIntentionList {
            return intentionAndThemes.count
        }
        
        return 0
    }
    
    func MAXTitleInSection(theSection: Int, atIndex theIndex: Int) -> String! {
        
        if let themesAndIntentions = self.themeAndIntentionList where theIndex < self.themeAndIntentionList?.count {
            return themesAndIntentions[theIndex].title
        }
        
        return ""
    }
    

    func MAXSelectedItemInSection(theSection: Int, atIndex theIndex: Int) {
        
        if let intentionAndTheme = self.themeAndIntentionList?[theIndex] where theIndex < themeAndIntentionList?.count {
            self.selectedStickerClosure?(label: intentionAndTheme.title, imagePath: intentionAndTheme.imagePath, intentionId: intentionAndTheme.intentionId)
        }
        
    }
    
    func MAXCollectionViewSizeAtIndexPath(theIndexPath: NSIndexPath!) -> CGSize {
        
        let height = CGRectGetWidth(UIScreen.mainScreen().bounds) / 2.0
        return CGSizeMake(height, height + 46)
    }
    
    func MAXCollectionViewCell(theCell: MAXCollectionViewCellImageAndText!, atIndex theIndexPath: NSIndexPath!) {
        
        theCell.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        theCell.imageView.layer.masksToBounds = true
        
        
        if let image = themeAndIntentionList?[theIndexPath.row].image {
            
            theCell.imageView.image = image
            
        }
        else if self.themeAndIntentionList?[theIndexPath.row].isDownloading == false {
            
            theCell.imageView.image = nil
            
            if let currentImage = self.themeAndIntentionList?[theIndexPath.row], let imagePath = self.themeAndIntentionList?[theIndexPath.row].defaultImagePath {
                
                currentImage.isDownloading = true
                
                GWImageManager.downloadImageIfNotExistsWithPath(imagePath, imageDataCompletion: {
                    imageId, imageData, error -> Void in
                    
                    if let nonNilImageData = imageData {
                        
                        currentImage.image = UIImage(data: nonNilImageData)
                        self.downloadImageClosure?(indexPath: theIndexPath)
                        
                    }
                    
                })
                
            }
            
        }
        else {
            theCell.imageView.image = nil
        }
        
        let halfWidth = CGRectGetWidth(UIScreen.mainScreen().bounds) / 2.0
        
        theCell.imageView.frame = CGRectMake(0, 0, halfWidth, halfWidth)
        theCell.titleLabel.frame = CGRectMake(halfWidth * 0.05, halfWidth + 3, halfWidth * 0.9, 40)
        theCell.titleLabelFrame = theCell.titleLabel.frame
        theCell.titleLabel.numberOfLines = 0
    }
    
    
    // MARK: Downlad intentions
    
    func downloadIntentions(completion: (error: NSError?) -> Void) {
        GWDataManager().downloadIntentionsWithArea("stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
            intentions, error -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.reloadData()
                completion(error: error)
            })
            
        })
    }
    
    func downloadThemes(completion: (error: NSError?) -> Void) {
        
        GWDataManager().downloadImageThemesWithPath("http://gw-static-apis.azurewebsites.net/data/stickers/moodthemes.json", withCompletion: {
            themes, error -> Void in
            
            if error == nil {
                self.themes = themes
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.reloadData()
                completion(error: error)
            })
            
        })
        
    }
    
    func downloadImage(path: String, completion: (image: GWImage?, error: NSError?) -> Void) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            GWDataManager().downloadImagesAndPersistIfNotExistWithUrls( [path] , withCompletion: {
                imageIds, error -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    let firstImage = GWDataManager().fetchImagesWithImagePaths( [path] ).first as? GWImage
                    completion(image: firstImage, error: error)
                })
            })
        })
        
    }
    
    // MARK: Helper methods
    
    func appendApiPathToImage(path: String) -> String {
        
        return "http://gw-static.azurewebsites.net/" + path
        
    }
    
    func removeApiPathFromImage(path: String?) -> String? {
        
        var newPath = path?.stringByReplacingOccurrencesOfString("http://gw-static.azurewebsites.net", withString: "")
        newPath = newPath?.stringByReplacingOccurrencesOfString("http://az767698.vo.msecnd.net", withString: "")
        
        return newPath
    }
    
    func findLabelTitle(culture: String, labelArray: [NSDictionary]) -> String? {
        
        for dict in labelArray {
            
            if (dict.objectForKey("Language") as? String) == culture {
                return dict.objectForKey("Label") as? String
            }
            
        }
        
        return nil
    }
    
}
