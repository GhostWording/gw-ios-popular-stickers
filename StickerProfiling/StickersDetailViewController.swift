//
//  StickersDetailViewController.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 06/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
import FBSDKMessengerShareKit

class StickersDetailViewController: UIViewController {

    var selectedStickerTitle: String?
    var selectedImagePath: String?
    var selectedIntentionId: String?
    var collectionView: MAXCollectionViewImageAndText!
    var backToMessengerButton: MAXBlockButton?
    var stickersTitleLabel = UILabel()

    
    let viewModel = StickersDetailViewModel()
    
    init(messengerMetadata: NSDictionary?) {
        
        super.init(nibName: nil, bundle: nil)
        
        //self.selectedStickerTitle = messengerMetadata?.objectForKey("stickerTitle") as? String
        self.selectedImagePath = messengerMetadata?.objectForKey("imagePath") as? String
        self.selectedIntentionId = messengerMetadata?.objectForKey("intentionId") as? String
        
        // send events if messenger metadata is integrated
        if messengerMetadata != nil {
            
            if let nonNilIntentionId = messengerMetadata?.objectForKey("imagePath") as? String {
                AnalyticsManager.sharedManager().postActionWithType(kGAReplyingIntention, targetType: kGATargetTypeIntention, targetId: nonNilIntentionId, targetParameter: nil, actionLocation: kGACategoryListScreen)
            }
            
            if let nonNilPrototypeTextId = messengerMetadata?.objectForKey("prototypeId") as? String {
                AnalyticsManager.sharedManager().postActionWithType(kGAReplyingTextPrototypeId, targetType: kGATargetTypeText, targetId: nonNilPrototypeTextId, targetParameter: nil, actionLocation: kGACategoryListScreen)
            }
            
            if let nonNilImageId = messengerMetadata?.objectForKey("imageName") as? String {
                AnalyticsManager.sharedManager().postActionWithType(kGAReplyingImageName, targetType: kGATargetTypeImage, targetId: nonNilImageId, targetParameter: nil, actionLocation: kGACategoryListScreen)
            }
            
        }
        
        if let nonNilIntentionId = self.selectedIntentionId {
            
            let intentions = GWDataManager().fetchIntentionsOnMainThreadWithAreaName("stickers", withIntentionIds: [ nonNilIntentionId ] )

            if let singleIntention = intentions.first {

                self.selectedStickerTitle = singleIntention.label
                self.selectedImagePath = singleIntention.imagePath
                self.viewModel.imagePath = singleIntention.imagePath
                
            }
            else {
                
                GWDataManager().downloadIntentionsWithArea("stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    intentions, error in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if error == nil {
                            let fetchedIntentions = GWDataManager().fetchIntentionsOnMainThreadWithAreaName("stickers", culture: GWLocalizedBundle.currentLocaleAPIString(), withIntentionIds: [ nonNilIntentionId ] )
                            self.stickersTitleLabel.text = fetchedIntentions.first?.label
                            self.selectedStickerTitle = fetchedIntentions.first?.label
                            self.selectedImagePath = fetchedIntentions.first?.imagePath
                            self.viewModel.imagePath = fetchedIntentions.first?.imagePath
                            self.collectionView.collectionView.reloadData()
                        }
                        
                    })
                    
                })
                
            }
            
        }
        else if let nonNilImagePath = self.selectedImagePath {
            
            GWDataManager().downloadImageThemesWithPath("http://gw-static-apis.azurewebsites.net/data/stickers/moodthemes.json", withCompletion: {
                themeDict, error in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if let nonNilThemes = themeDict?["Themes"] as? [NSDictionary] {
                        print("non nil themes \(nonNilThemes) and image path \(nonNilImagePath)")
                        self.stickersTitleLabel.text = self.viewModel.nameForTheme(nonNilThemes, themePath: nonNilImagePath)
                        self.selectedStickerTitle = self.viewModel.nameForTheme(nonNilThemes, themePath: nonNilImagePath)
                        
                    }
                    
                })
                
            })
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backToMessengerButton = MAXBlockButton(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40))
        backToMessengerButton?.backgroundColor = UIColor.c_backToMessengerBannerColor()
        backToMessengerButton?.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        backToMessengerButton?.setTitle("Touch to return to messenger", forState: UIControlState.Normal)
        backToMessengerButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        backToMessengerButton?.titleLabel?.font = UIFont.c_robotoWithSize(13.0)
        
        backToMessengerButton?.buttonTouchUpInsideWithCompletion({
            
            FBSDKMessengerSharer.openMessenger()
            
        })
        
        if self.selectedIntentionId != nil {
            
            AnalyticsManager.sharedManager().postActionWithType( kGAMoodIntention, targetType: kGATargetTypeIntention, targetId: selectedIntentionId, targetParameter: nil, actionLocation: kGACategoryListScreen)
        
        }
        else {
            
            AnalyticsManager.sharedManager().postActionWithType( kGAMoodTheme, targetType: kGATargetTypeTheme, targetId: selectedImagePath, targetParameter: nil, actionLocation: kGACategoryListScreen)
        
        }
        
        viewModel.imagePath = selectedImagePath
        viewModel.itemSize = Float( CGRectGetWidth(self.view.frame) / 2.0 )
        
        collectionView = MAXCollectionViewImageAndText(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)))
        collectionView.datasource = viewModel
        
        
        collectionView.headerView.backgroundColor = UIColor.c_blueColor()
        
        var backButtonImage = UIImage(named: "BackArrow")
        backButtonImage = backButtonImage?.imageWithRenderingMode(.AlwaysTemplate)
        
        
        let backButton = MAXFadeBlockButton(frame: CGRectMake(0, 20, 44 * 1.5, 44))
        backButton.setImage( backButtonImage, forState: UIControlState.Normal)
        backButton.tintColor = UIColor.whiteColor()
        backButton.imageEdgeInsets = UIEdgeInsetsMake(44 * 0.3, 44 * 0.3, 44 * 0.3, 44 * 0.8)
        
        backButton.buttonTouchUpInsideWithCompletion({
            
            AnalyticsManager.sharedManager().postActionWithType( kGABackFromThemes, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGACategoryListScreen)
            
            UserDefaults.incrementNumBackToMainMenu()
            
            self.dismissViewControllerAnimated(true, completion: {
                
                if (UserDefaults.numBackToMainMenu() == 4 || UserDefaults.numBackToMainMenu() == 10 || UserDefaults.numBackToMainMenu() == 20) && UserDefaults.wantsNotification() == false {
                    
                    let alertView = BlocksAlertView(title: PopularStickersLocalizedString("<NotificationAlertTitle>", ""), message: PopularStickersLocalizedString("<NotificationAlertMessage>", ""), delegate: nil, cancelButtonTitle: PopularStickersLocalizedString("<NotificationAlertCancelTitle>", ""), otherButtonTitles: PopularStickersLocalizedString("<NotificationAlertAcceptTitle>", ""))
                    
                    alertView.show()
                    
                    alertView.buttonPressedWithCompletion({
                        index, alertView -> Void in
                        
                        if index == 0 {
                            // false statement, said in the alert view                            
                            UserDefaults.setWantsNotification(false)
                            
                        }
                        else {
                            // true statement, said in the alert view
                            let application = UIApplication.sharedApplication()
                            application.registerUserNotificationSettings( UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound] , categories: nil))
                            
                            UserDefaults.setWantsNotification(true)
                            
                        }
                    })
                    
                }
                
                
            })
        })
        
        collectionView.headerView.addSubview(backButton)
        
        stickersTitleLabel.frame = CGRectMake( CGRectGetMaxX(backButton.frame) + CGRectGetWidth(self.view.frame) * 0.05, 20, CGRectGetWidth(self.view.frame) - CGRectGetMaxX(backButton.frame) - CGRectGetWidth(self.view.frame) * 0.1, 44)
        stickersTitleLabel.textAlignment = .Left
        stickersTitleLabel.textColor = UIColor.whiteColor()
        stickersTitleLabel.text = self.selectedStickerTitle
        stickersTitleLabel.font = UIFont.c_robotoWithSize(Float(CGRectGetHeight(self.view.frame) * 0.03))
        collectionView.headerView.addSubview(stickersTitleLabel)
        
        self.view.addSubview(collectionView)
        
        
        viewModel.downloadImageIds({
            error -> Void in
            

            self.collectionView.collectionView.reloadData()
            
        })
        
        viewModel.reloadIndexPath({
            indexPath -> Void in

            self.collectionView.collectionView.reloadItemsAtIndexPaths([indexPath])
            
        })
        
        viewModel.selectedImage({
            imageName, selectedImage -> Void in
            
            AnalyticsManager.sharedManager().postActionWithType( kGAImageSelected, targetType: kGATargetTypeImage, targetId: imageName, targetParameter: nil, actionLocation: kGACategoryListScreen)
            
            self.showSingleStickerDetail(imageName, image: selectedImage)
            
        })
        
        viewModel.reloadData()
        collectionView.collectionView.reloadData()
        
        self.addOrRemoveBackToMessengerButton()
        
    }
    
    // MARK: Messenger Integration
    
    func addOrRemoveBackToMessengerButton() {
        
        if AppFlow.currentMessengerFlow == MessengerFlow.Send {
            self.backToMessengerButton?.removeFromSuperview()
            self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        }
        else {
            
            if self.backToMessengerButton?.superview == nil {
                self.view.addSubview(self.backToMessengerButton!)
            }
            
            self.collectionView.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 20)
            
        }
        
    }
    
    
    // MARK: Navigation
    
    func showSingleStickerDetail(imageName: String?, image: UIImage?) -> Void {
        
        let singleStickerVC = SingleStickerDetailViewController()
        singleStickerVC.imageToShow = image
        singleStickerVC.imageName = imageName
        singleStickerVC.viewModel.imagePath = selectedImagePath
        singleStickerVC.viewModel.intentionId = selectedIntentionId
        singleStickerVC.selectedStickerTitle = self.selectedStickerTitle

        
        self.presentViewController(singleStickerVC, animated: true, completion: nil)
        
    }
    
}
