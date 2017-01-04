//
//  RecipientPickerViewModel.swift
//  StickerBliss
//
//  Created by Mathieu Skulason on 10/07/16.
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
    
    var downloadedRecipientImageClosure: ((_ indexPath: IndexPath) -> Void)?
    var selectedRecipientClosure: ((_ recipient: GWRecipient) -> Void)?
    var selectedIntentionClosure: ((_ intention: GWIntention) -> Void)?
    
    init(area: String) {
        
        self.area = area
        
        super.init()
    }
    
    func downloadRecipients(_ completion: @escaping (_ error: NSError?) -> Void) {
        
        GWDataManager().downloadRecipients(withArea: self.area, completion: {
            downloadedRecipients, error in
            
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    
                    self.reloadRecipients()
                    
                }
                
                completion(error as NSError?)
                
            })
            
        })
        
    }
    
    func reloadRecipients() {
        
        self.recipients = GWDataManager().fetchRecipients(withIds: nil)
        print("recipients are \(self.recipients)")
        self.recipients = self.filterRecipients(self.recipients)
        self.recipients?.sort(by: { firstRecpient, secondRecipient -> Bool in
            
            return firstRecpient.importance?.int32Value < secondRecipient.importance?.int32Value
            
        })
        
        if self.recipients != nil {
            
            self.recipientItems = self.createRecipientItems(self.recipients!)
        
        }
        
    }
    
    
    
    // MARK: Filtering
    
    func filterRecipients(_ recipientsToFilter: [GWRecipient]?) -> [GWRecipient]? {
        
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
    
    func oppositeGender(_ gender: String) -> String {
        
        if gender == "F" {
            return "H"
        }
        else {
            return "F"
        }
        
    }
    
    // MARK: Setting Up Recipients With Images After Filtering
    
    fileprivate func createRecipientItems(_ recipients: [GWRecipient]) -> [RecipientItem] {
        
        let recipientImages = self.fetchRecipientImages(recipients)
        
        var recipientItems = [RecipientItem]()
        
        for currentRecipient in recipients {
            
            let newRecipientIem = RecipientItem(recipient: currentRecipient, recipientImage: self.matchImageWithRecipient(currentRecipient, images: recipientImages))
            recipientItems.append(newRecipientIem)
            
        }
        
        return recipientItems
    }
    
    fileprivate func matchImageWithRecipient(_ recipient: GWRecipient, images: [GWImage]) -> UIImage? {
        
        if let recipientImageUrl = recipient.imageUrl {
            
            let recipientImageWithoutAPIPath = NSString.removeApiPath( fromImagePath: recipientImageUrl )
            
            for currentImage in images {
                
                if currentImage.imageId == recipientImageWithoutAPIPath && currentImage.imageData != nil {
                    
                    return UIImage(data: currentImage.imageData!)
                }
                
            }
            
        }
        
        
        return nil
    }
    
    fileprivate func fetchRecipientImages(_ recipients: [GWRecipient]) -> [GWImage] {
        
        let imagePaths = self.getImagePaths(recipients)
        
        
        return GWImageManager.fetchImages(withPaths: imagePaths)
        
    }
    
    fileprivate func getImagePaths(_ recipients: [GWRecipient]) -> [String] {
        
        var imageIds = [String]()
        
        for recipient in recipients {
            
            if let imageUrl = recipient.imageUrl {
                imageIds.append(imageUrl)
            }
            
        }
        
        return imageIds
    }
    
    
    // MARK: Collection View Data source
    
    func maxCollectionViewImageAndTextNumSections() -> Int {
        return 1
    }
    
    func maxCollectionViewImageAndTextNumItems(inSection theSection: Int) -> Int {
        
        if self.recipients == nil {
            return 0;
        }
        
        return self.recipients!.count
        
    }
    
    func maxCollectionViewCell(_ theCell: MAXCollectionViewCellImageAndText!, atIndex theIndexPath: IndexPath!) {
        
        theCell.imageView.contentMode = UIViewContentMode.scaleAspectFill
        theCell.imageView.layer.masksToBounds = true
        
        if let currentRecipientItem = self.getRecipientItemAtIndexPath(theIndexPath) {
            
            if currentRecipientItem.recipientImage == nil && currentRecipientItem.isDownloadingImage == false && currentRecipientItem.recipient.imageUrl != nil {
                
                currentRecipientItem.isDownloadingImage = true
                theCell.imageView.image = nil
                
                GWImageManager.downloadImageIfNotExists(withPath: currentRecipientItem.recipient.imageUrl!, imageDataCompletion: {
                    imageId, imageData, error in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if let nonNilImageData = imageData {
                            
                            currentRecipientItem.recipientImage = UIImage(data: nonNilImageData)
                            theCell.imageView.image = currentRecipientItem.recipientImage
                            
                            self.downloadedRecipientImageClosure?(theIndexPath)
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
    
    func maxSelectedItem(inSection theSection: Int, at theIndex: Int) {
        
        if theIndex < self.recipientItems?.count {
            self.selectedRecipientClosure?(self.recipientItems![theIndex].recipient)
        }
        
    }
    
    // MARK: Getters For collection view
    
    fileprivate func getRecipientItemAtIndexPath(_ indexPath: IndexPath) -> RecipientItem? {
        
        if indexPath.row < self.recipientItems?.count {
            
            return self.recipientItems![indexPath.row]
            
        }
        
        return nil
    }
    
    fileprivate func getRecipientName(_ recipient: GWRecipient) -> String? {
        
        let recipientNameArray = recipient.labels as! [NSDictionary]
        
        var recipientDict: NSDictionary?
        for currentDictionary in recipientNameArray {
            
            let cultureApiString = GWLocalizedBundle.currentLocaleAPIString()
            if currentDictionary.object( forKey: "Culture" ) as! String == cultureApiString {
                recipientDict = currentDictionary
            }
            
        }
        
        return recipientDict?.object(forKey: "UserLabel") as? String
    }
}
