//
//  IntentionPickerViewModel.swift
//  StickerBliss
//
//  Created by Mathieu Skulason on 11/07/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import Foundation

class IntentionItem : NSObject {
    
    var intentionImage: UIImage?
    
    var intention: GWIntention
    var isDownloadingImage: Bool
    
    init(intention: GWIntention, image: UIImage?) {
        
        self.intention = intention
        self.intentionImage = image
        self.isDownloadingImage = false
        
        super.init()
    }
    
}

class IntentionPickerViewModel: NSObject {

    var intentions: [GWIntention]?
    var intentionItems: [IntentionItem]?
    
    var selectedRecipient: GWRecipient
        
    init(recipient: GWRecipient) {
        
        self.selectedRecipient = recipient
        
        super.init()
    }
    
    func downloadIntentions(completion: () -> Void) {
        
        GWDataManager().downloadIntentionsWithArea("stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
            intentionIds, error in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.reloadIntentions()
                
                completion()
                
            })
            
        })
        
    }
    
    func reloadIntentions() {
        
        self.intentions = GWDataManager().fetchIntentionsWithAreaName("stickers", culture: GWLocalizedBundle.currentLocaleAPIString(), withIntentionsIds: nil)
        
        print("intention sort order before: \(self.intentions)")
        
        self.intentions?.sortInPlace({
            intentionOne, intentionTwo -> Bool in
            
            return intentionOne.sortOrderInArea?.intValue < intentionTwo.sortOrderInArea?.intValue
            
        })
        
        print("intention sort order after: \(self.intentions)")
        
        self.intentions = self.filterIntentions(self.intentions)
        
        if intentions != nil {
            self.intentionItems = self.createIntentionItems(intentions!)
        }
        
    }
    
    // MARK: Filter intentions
    
    func filterIntentions(intentions: [GWIntention]?) -> [GWIntention]? {
        
        if intentions != nil {
            
            var filteredIntentions = [GWIntention]()
            
            
            for currentIntention in intentions! {
                
                print("relation types string \(currentIntention.relationTypesString) and recipient id \(selectedRecipient.relationTypeTag)")
                
                if currentIntention.relationTypesString?.containsString(selectedRecipient.relationTypeTag!) == true {
                    filteredIntentions.append(currentIntention)
                }
                
            }
            
            return filteredIntentions
            
        }
        
        return nil
    }
    
    func createIntentionItems(intentions: [GWIntention]) -> [IntentionItem] {
        
        let intentionImages = self.fetchIntentionImages(intentions)
        
        var intentionItems = [IntentionItem]()
        
        for currentIntention in intentions {
            
            let newIntentionItem = IntentionItem(intention: currentIntention, image: self.matchImageWithIntention(currentIntention, images: intentionImages))
            intentionItems.append(newIntentionItem)
            
        }
        
        return intentionItems
    }
    
    private func matchImageWithIntention(intention: GWIntention, images: [GWImage]) -> UIImage? {
        
        if let nonNilIntentionImageUrl = intention.mediaUrl {
            
            let intentionUrlWithoutPath = NSString.removeApiPathFromImagePath(nonNilIntentionImageUrl)
            
            for currentImage in images {
                
                if currentImage.imageId == intentionUrlWithoutPath && currentImage.imageData != nil {
                    
                    return UIImage(data: currentImage.imageData!)
                }
                
            }
            
        }
        
        return nil
        
    }
    
    private func fetchIntentionImages(intentions: [GWIntention]) -> [GWImage] {
        
        let intentionImagePaths = self.getImagePaths(intentions)
        
        return GWImageManager.fetchImagesWithPaths(intentionImagePaths)
        
    }
    
    private func getImagePaths(intentions: [GWIntention]) -> [String] {
        
        var imagePaths = [String]()
        
        for currentIntention in intentions {
            
            if let imageUrl = currentIntention.mediaUrl {
                
                imagePaths.append(imageUrl)
            }
            
        }
        
        
        return imagePaths
    }
    
    
    // MARK: Table View Getters 
    
    func intention(index: Int) -> GWIntention? {
        
        if index < intentionItems?.count && intentionItems != nil {
            return intentionItems![index].intention
        }
        
        return nil
    }
    
    func numIntentionItems() -> Int {
        
        if intentionItems == nil {
            
            return 0
        }
        
        return intentionItems!.count
    }
    
    func intentionTitle(index: Int) -> String? {
        
        if let intention = self.intention(index) {
            
            return intention.label
        }
        
        return nil
    }
    
    func intentionImage(index: Int) -> UIImage? {
        
        if index < intentionItems?.count && intentionItems != nil {
            
            return intentionItems![index].intentionImage
        }
        
        return nil
    }
    
    func downloadImage(index: Int, completion: (error: NSError?) -> Void) {
        
        if index < intentionItems?.count && intentionItems != nil {
            
            let intentionItem = intentionItems![index]
            
            if intentionItem.isDownloadingImage == false && intentionItem.intentionImage == nil && intentionItem.intention.mediaUrl != nil {
                
                intentionItem.isDownloadingImage = true
                
                GWImageManager.downloadImageWithPath(intentionItem.intention.mediaUrl!, completion: {
                    imageId, imageData, error in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if imageData != nil {
                            
                            intentionItem.intentionImage = UIImage(data: imageData!)
                            completion(error: error)
                        }
                        
                    })
                    
                })
                
            }
            
        }
        
    }
    
    
}
