//
//  RecipientPickerViewModel.swift
//  StickerBliss
//
//  Created by Mathieu Skulason on 10/07/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import Foundation

class RecipientItem : NSObject {
    
    var isDownloadingImage: Bool
    
    var recipient: GWRecipient
    var recipientImage: UIImage?
    
    init(recipient: GWRecipient, recipientImage: UIImage?) {
        
        self.isDownloadingImage = false
        
        self.recipient = recipient
        self.recipientImage = recipientImage
        
        super.init()
    }
    
}

class RecipientPickerViewModel: NSObject, MAXCollectionViewImageAndTextDataSource {
    
    let area: String!
    
    var recipients: [GWRecipient]?
    var recipientItems: [RecipientItem]?
    
    var downloadedRecipientImageClosure: ((indexPath: NSIndexPath) -> Void)?
    var selectedRecipientClosure: ((recipient: GWRecipient) -> Void)?
    var selectedIntentionClosure: ((intention: GWIntention) -> Void)?
    
    init(area: String) {
        
        self.area = area
        
        super.init()
    }
    
    func downloadRecipients(completion: (error: NSError?) -> Void) {
        
        GWDataManager().downloadRecipientsWithArea(self.area, completion: {
            downloadedRecipients, error in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if error == nil {
                    
                    self.reloadRecipients()
                    
                }
                
                completion(error: error)
                
            })
            
        })
        
    }
    
    func reloadRecipients() {
        
        self.recipients = GWDataManager().fetchRecipientsWithIds(nil)
        print("recipients are \(self.recipients)")
        self.recipients = self.filterRecipients(self.recipients)
        self.recipients?.sortInPlace({ firstRecpient, secondRecipient -> Bool in
            
            return firstRecpient.importance?.intValue < secondRecipient.importance?.intValue
            
        })
        
        if self.recipients != nil {
            
            self.recipientItems = self.createRecipientItems(self.recipients!)
        
        }
        
    }
    
    
    
    // MARK: Filtering
    
    func filterRecipients(recipientsToFilter: [GWRecipient]?) -> [GWRecipient]? {
        
        if recipientsToFilter != nil {
         
            // only add the recipients opposite to the users' gender
            if let userGender = UserDefaults.userGender() {
                
                var filteredRecipients = [GWRecipient]()
                
                for recipient in recipientsToFilter! {
                    
                    if recipient.recipientId == "LoveInterestF" || recipient.recipientId == "LoveInterestM" || recipient.recipientId == "SweetheartM" || recipient.recipientId == "SweetheartF" {
                        
                        if self.oppositeGender(userGender) == recipient.gender {
                            
                            filteredRecipients.append( recipient )
                            
                        }
                    }
                    else {
                        
                        filteredRecipients.append(recipient)

                        
                    }
                    
                }
                
                return filteredRecipients
                
            }
            else {
                
                // if non are registered don't filter the recipients at all
                return recipientsToFilter
            }
            
        }
        
        return nil
        
    }
    
    func oppositeGender(gender: String) -> String {
        
        if gender == "F" {
            return "H"
        }
        else {
            return "F"
        }
        
    }
    
    // MARK: Setting Up Recipients With Images After Filtering
    
    private func createRecipientItems(recipients: [GWRecipient]) -> [RecipientItem] {
        
        let recipientImages = self.fetchRecipientImages(recipients)
        
        var recipientItems = [RecipientItem]()
        
        for currentRecipient in recipients {
            
            let newRecipientIem = RecipientItem(recipient: currentRecipient, recipientImage: self.matchImageWithRecipient(currentRecipient, images: recipientImages))
            recipientItems.append(newRecipientIem)
            
        }
        
        return recipientItems
    }
    
    private func matchImageWithRecipient(recipient: GWRecipient, images: [GWImage]) -> UIImage? {
        
        if let recipientImageUrl = recipient.imageUrl {
            
            let recipientImageWithoutAPIPath = NSString.removeApiPathFromImagePath( recipientImageUrl )
            
            for currentImage in images {
                
                if currentImage.imageId == recipientImageWithoutAPIPath && currentImage.imageData != nil {
                    
                    return UIImage(data: currentImage.imageData!)
                }
                
            }
            
        }
        
        
        return nil
    }
    
    private func fetchRecipientImages(recipients: [GWRecipient]) -> [GWImage] {
        
        let imagePaths = self.getImagePaths(recipients)
        
        
        return GWImageManager.fetchImagesWithPaths(imagePaths)
        
    }
    
    private func getImagePaths(recipients: [GWRecipient]) -> [String] {
        
        var imageIds = [String]()
        
        for recipient in recipients {
            
            if let imageUrl = recipient.imageUrl {
                imageIds.append(imageUrl)
            }
            
        }
        
        return imageIds
    }
    
    
    // MARK: Collection View Data source
    
    func MAXCollectionViewImageAndTextNumSections() -> Int {
        return 1
    }
    
    func MAXCollectionViewImageAndTextNumItemsInSection(theSection: Int) -> Int {
        
        if self.recipients == nil {
            return 0;
        }
        
        return self.recipients!.count
        
    }
    
    func MAXCollectionViewCell(theCell: MAXCollectionViewCellImageAndText!, atIndex theIndexPath: NSIndexPath!) {
        
        theCell.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        theCell.imageView.layer.masksToBounds = true
        
        if let currentRecipientItem = self.getRecipientItemAtIndexPath(theIndexPath) {
            
            if currentRecipientItem.recipientImage == nil && currentRecipientItem.isDownloadingImage == false && currentRecipientItem.recipient.imageUrl != nil {
                
                currentRecipientItem.isDownloadingImage = true
                theCell.imageView.image = nil
                
                GWImageManager.downloadImageIfNotExistsWithPath(currentRecipientItem.recipient.imageUrl!, imageDataCompletion: {
                    imageId, imageData, error in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if let nonNilImageData = imageData {
                            
                            currentRecipientItem.recipientImage = UIImage(data: nonNilImageData)
                            theCell.imageView.image = currentRecipientItem.recipientImage
                            
                            self.downloadedRecipientImageClosure?(indexPath: theIndexPath)
                        }
                        
                    })
                    
                })
                
            }
            else {
                
                theCell.imageView.image = currentRecipientItem.recipientImage
                theCell.titleLabel.text = self.getRecipientName(currentRecipientItem.recipient)
                
            }
            
        }
        
    }
    
    func MAXSelectedItemInSection(theSection: Int, atIndex theIndex: Int) {
        
        if theIndex < self.recipientItems?.count {
            self.selectedRecipientClosure?(recipient: self.recipientItems![theIndex].recipient)
        }
        
    }
    
    // MARK: Getters For collection view
    
    private func getRecipientItemAtIndexPath(indexPath: NSIndexPath) -> RecipientItem? {
        
        if indexPath.row < self.recipientItems?.count {
            
            return self.recipientItems![indexPath.row]
            
        }
        
        return nil
    }
    
    private func getRecipientName(recipient: GWRecipient) -> String? {
        
        let recipientNameArray = recipient.labels as! [NSDictionary]
        
        var recipientDict: NSDictionary?
        for currentDictionary in recipientNameArray {
            
            let cultureApiString = GWLocalizedBundle.currentLocaleAPIString()
            if currentDictionary.objectForKey( "Culture" ) as! String == cultureApiString {
                recipientDict = currentDictionary
            }
            
        }
        
        return recipientDict?.objectForKey("UserLabel") as? String
    }
}
