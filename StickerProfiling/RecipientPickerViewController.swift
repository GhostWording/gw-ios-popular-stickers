//
//  RecipientPickerViewController.swift
//  StickerBliss
//
//  Created by Mathieu Skulason on 10/07/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

class RecipientPickerViewController: UIViewController {

    let viewModel: RecipientPickerViewModel!
    var collectionViewContainer: MAXCollectionViewImageAndText!
    
    var selectedRecipientAndIntentionClosure: ((recipient: GWRecipient, intention: GWIntention) -> Void)?
    
    var selectedRecipient: GWRecipient?
    var selectedIntention: GWIntention?
    
    init(area: String) {
        
        self.viewModel = RecipientPickerViewModel(area: area)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.viewModel.downloadRecipients({
            error in
            
            self.collectionViewContainer.collectionView.reloadData()
            
        })
        
        self.viewModel.downloadedRecipientImageClosure = {
            indexPath in
            
            self.collectionViewContainer.collectionView.reloadItemsAtIndexPaths([indexPath])
        }
        
        
        self.viewModel.selectedRecipientClosure = {
            selectedRecipient in
            
            let intentionPicker = IntentionPickerViewController(recipient: selectedRecipient)
            intentionPicker.selectedRecipientAndIntentionClosure = {
                recipient, intention in
                
                
                //intentionPicker.dismissViewControllerAnimated(true, completion: nil)
                self.dismissViewControllerAnimated(false, completion: nil)
                self.dismissViewControllerAnimated(true, completion: {
                    self.selectedRecipientAndIntentionClosure?(recipient: recipient, intention: intention)
                })
                
            }
            
            self.presentViewController(intentionPicker, animated: true, completion: {
                
            })
            
        }
        
        self.collectionViewContainer = MAXCollectionViewImageAndText(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)))
        self.collectionViewContainer.datasource = self.viewModel
        self.collectionViewContainer.headerView.backgroundColor = UIColor.c_blueColor()
        
        self.view.addSubview(self.collectionViewContainer)
        
        
        var backButtonImage = UIImage(named: "BackArrow")
        backButtonImage = backButtonImage?.imageWithRenderingMode(.AlwaysTemplate)
        
        
        let backButton = MAXFadeBlockButton(frame: CGRectMake(0, 20, 44 * 1.5, 44))
        backButton.setImage( backButtonImage, forState: UIControlState.Normal)
        backButton.tintColor = UIColor.whiteColor()
        backButton.imageEdgeInsets = UIEdgeInsetsMake(44 * 0.3, 44 * 0.3, 44 * 0.3, 44 * 0.8)
        
        backButton.buttonTouchUpInsideWithCompletion({
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })

        self.collectionViewContainer.headerView.addSubview( backButton )
        
        
        let stickersTitleLabel = UILabel(frame: CGRectMake( CGRectGetMaxX(backButton.frame) + CGRectGetWidth(self.view.frame) * 0.05, 20, CGRectGetWidth(self.view.frame) - CGRectGetMaxX(backButton.frame) - CGRectGetWidth(self.view.frame) * 0.1, 44))
        stickersTitleLabel.textAlignment = .Left
        stickersTitleLabel.textColor = UIColor.whiteColor()
        stickersTitleLabel.text = PopularStickersLocalizedString("<SelectRecipientTitle>", nil)
        stickersTitleLabel.font = UIFont.c_robotoWithSize(Float(CGRectGetHeight(self.view.frame) * 0.03))
        
        collectionViewContainer.headerView.addSubview(stickersTitleLabel)
        
        
        
    }
    
}
