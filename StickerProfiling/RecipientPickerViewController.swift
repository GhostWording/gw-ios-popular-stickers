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
    
    var selectedRecipientAndIntentionClosure: ((_ recipient: GWRecipient, _ intention: GWIntention) -> Void)?
    
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
            
            self.collectionViewContainer.collectionView.reloadItems(at: [indexPath])
        }
        
        
        self.viewModel.selectedRecipientClosure = {
            selectedRecipient in
            
            let intentionPicker = IntentionPickerViewController(recipient: selectedRecipient)
            intentionPicker.selectedRecipientAndIntentionClosure = {
                recipient, intention in
                
                
                //intentionPicker.dismissViewControllerAnimated(true, completion: nil)
                self.dismiss(animated: false, completion: nil)
                self.dismiss(animated: true, completion: {
                    self.selectedRecipientAndIntentionClosure?(recipient, intention)
                })
                
            }
            
            self.present(intentionPicker, animated: true, completion: {
                
            })
            
        }
        
        self.collectionViewContainer = MAXCollectionViewImageAndText(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.collectionViewContainer.datasource = self.viewModel
        self.collectionViewContainer.headerView.backgroundColor = UIColor.c_blue()
        
        self.view.addSubview(self.collectionViewContainer)
        
        
        var backButtonImage = UIImage(named: "BackArrow")
        backButtonImage = backButtonImage?.withRenderingMode(.alwaysTemplate)
        
        
        let backButton = MAXFadeBlockButton(frame: CGRect(x: 0, y: 20, width: 44 * 1.5, height: 44))
        backButton.setImage( backButtonImage, for: UIControlState())
        backButton.tintColor = UIColor.white
        backButton.imageEdgeInsets = UIEdgeInsetsMake(44 * 0.3, 44 * 0.3, 44 * 0.3, 44 * 0.8)
        
        backButton.buttonTouchUpInside(completion: {
            
            self.dismiss(animated: true, completion: nil)
            
        })

        self.collectionViewContainer.headerView.addSubview( backButton )
        
        
        let stickersTitleLabel = UILabel(frame: CGRect( x: backButton.frame.maxX + self.view.frame.width * 0.05, y: 20, width: self.view.frame.width - backButton.frame.maxX - self.view.frame.width * 0.1, height: 44))
        stickersTitleLabel.textAlignment = .left
        stickersTitleLabel.textColor = UIColor.white
        stickersTitleLabel.text = PopularStickersLocalizedString("<SelectRecipientTitle>", nil)
        stickersTitleLabel.font = UIFont.c_roboto(withSize: Float(self.view.frame.height * 0.03))
        
        collectionViewContainer.headerView.addSubview(stickersTitleLabel)
        
        
        
    }
    
}
