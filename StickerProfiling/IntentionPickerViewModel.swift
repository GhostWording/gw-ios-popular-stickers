//
//  IntentionPickerViewModel.swift
//  StickerBliss
//
//  Created by Mathieu Skulason on 11/07/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import Foundation
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
    
    func downloadIntentions(_ completion: @escaping () -> Void) {
        
        GWDataManager().downloadIntentions(withArea: "stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
            intentionIds, error in
            
            DispatchQueue.main.async(execute: {
                
                self.reloadIntentions()
                
                completion()
                
            })
            
        })
        
    }
    
    func reloadIntentions() {
        
        self.intentions = GWDataManager().fetchIntentions(withAreaName: "stickers", culture: GWLocalizedBundle.currentLocaleAPIString(), withIntentionsIds: nil)
        
        print("intention sort order before: \(self.intentions)")
        
        self.intentions?.sort(by: {
            intentionOne, intentionTwo -> Bool in
            
            return intentionOne.sortOrderInArea?.int32Value < intentionTwo.sortOrderInArea?.int32Value
            
        })
        
        print("intention sort order after: \(self.intentions)")
        
        self.intentions = self.filterIntentions(self.intentions)
        
        if intentions != nil {
            self.intentionItems = self.createIntentionItems(intentions!)
        }
        
    }
    
    // MARK: Filter intentions
    
    func filterIntentions(_ intentions: [GWIntention]?) -> [GWIntention]? {
        
        if intentions != nil {
            
            var filteredIntentions = [GWIntention]()
            
            
            for currentIntention in intentions! {
                
                print("relation types string \(currentIntention.relationTypesString) and recipient id \(selectedRecipient.relationTypeTag)")
                
                if currentIntention.relationTypesString?.contains(selectedRecipient.relationTypeTag!) == true {
                    filteredIntentions.append(currentIntention)
                }
                
            }
            
            return filteredIntentions
            
        }
        
        return nil
    }
    
    func createIntentionItems(_ intentions: [GWIntention]) -> [IntentionItem] {
        
        let intentionImages = self.fetchIntentionImages(intentions)
        
        var intentionItems = [IntentionItem]()
        
        for currentIntention in intentions {
            
            let newIntentionItem = IntentionItem(intention: currentIntention, image: self.matchImageWithIntention(currentIntention, images: intentionImages))
            intentionItems.append(newIntentionItem)
            
        }
        
        return intentionItems
    }
    
    fileprivate func matchImageWithIntention(_ intention: GWIntention, images: [GWImage]) -> UIImage? {
        
        if let nonNilIntentionImageUrl = intention.mediaUrl {
            
            let intentionUrlWithoutPath = NSString.removeApiPath(fromImagePath: nonNilIntentionImageUrl)
            
            for currentImage in images {
                
                if currentImage.imageId == intentionUrlWithoutPath && currentImage.imageData != nil {
                    
                    return UIImage(data: currentImage.imageData!)
                }
                
            }
            
        }
        
        return nil
        
    }
    
    fileprivate func fetchIntentionImages(_ intentions: [GWIntention]) -> [GWImage] {
        
        let intentionImagePaths = self.getImagePaths(intentions)
        
        return GWImageManager.fetchImages(withPaths: intentionImagePaths)
        
    }
    
    fileprivate func getImagePaths(_ intentions: [GWIntention]) -> [String] {
        
        var imagePaths = [String]()
        
        for currentIntention in intentions {
            
            if let imageUrl = currentIntention.mediaUrl {
                
                imagePaths.append(imageUrl)
            }
            
        }
        
        
        return imagePaths
    }
    
    
    // MARK: Table View Getters 
    
    func intention(_ index: Int) -> GWIntention? {
        
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
    
    func intentionTitle(_ index: Int) -> String? {
        
        if let intention = self.intention(index) {
            
            return intention.label
        }
        
        return nil
    }
    
    func intentionImage(_ index: Int) -> UIImage? {
        
        if index < intentionItems?.count && intentionItems != nil {
            
            return intentionItems![index].intentionImage
        }
        
        return nil
    }
    
    func downloadImage(_ index: Int, completion: @escaping (_ error: Error?) -> Void) {
        
        if index < intentionItems?.count && intentionItems != nil {
            
            let intentionItem = intentionItems![index]
            
            if intentionItem.isDownloadingImage == false && intentionItem.intentionImage == nil && intentionItem.intention.mediaUrl != nil {
                
                intentionItem.isDownloadingImage = true
                
                GWImageManager.downloadImage(withPath: intentionItem.intention.mediaUrl!, completion: {
                    imageId, imageData, error in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if imageData != nil {
                            
                            intentionItem.intentionImage = UIImage(data: imageData!)
                            completion(error as Error?)
                        }
                        
                    })
                    
                })
                
            }
            
        }
        
    }
    
    
}
