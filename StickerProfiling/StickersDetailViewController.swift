//
//  StickersDetailViewController.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 06/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
import FBSDKMessengerShareKit

class StickersDetailViewController: RootViewController {

    var selectedStickerTitle: String?
    var selectedImagePath: String?
    var selectedIntentionId: String?
    var collectionView: MAXCollectionViewImageAndText!
    var backToMessengerButton: MAXBlockButton?
    var stickersTitleLabel = UILabel()
    weak var wSelf : StickersDetailViewController?
    
    let viewModel = StickersDetailViewModel()
    
    init(messengerMetadata: NSDictionary?) {
        
        super.init()
        
        //self.selectedStickerTitle = messengerMetadata?.objectForKey("stickerTitle") as? String
        self.selectedImagePath = messengerMetadata?.object(forKey: "imagePath") as? String
        self.selectedIntentionId = messengerMetadata?.object(forKey: "intentionId") as? String
        
        // send events if messenger metadata is integrated
        if messengerMetadata != nil {
            
            if let nonNilIntentionId = messengerMetadata?.object(forKey: "imagePath") as? String {
                AnalyticsManager.shared().postAction(withType: kGAReplyingIntention, targetType: kGATargetTypeIntention, targetId: nonNilIntentionId, targetParameter: nil, actionLocation: kGACategoryListScreen)
            }
            
            if let nonNilPrototypeTextId = messengerMetadata?.object(forKey: "prototypeId") as? String {
                AnalyticsManager.shared().postAction(withType: kGAReplyingTextPrototypeId, targetType: kGATargetTypeText, targetId: nonNilPrototypeTextId, targetParameter: nil, actionLocation: kGACategoryListScreen)
            }
            
            if let nonNilImageId = messengerMetadata?.object(forKey: "imageName") as? String {
                AnalyticsManager.shared().postAction(withType: kGAReplyingImageName, targetType: kGATargetTypeImage, targetId: nonNilImageId.imageName(), targetParameter: nil, actionLocation: kGACategoryListScreen)
            }
            
        }
        
        if let nonNilIntentionId = self.selectedIntentionId {
            
            let intentions = GWDataManager().fetchIntentionsOnMainThread(withAreaName: "stickers", withIntentionIds: [ nonNilIntentionId ] )

            if let singleIntention = intentions.first {

                self.selectedStickerTitle = singleIntention.label
                self.selectedImagePath = singleIntention.imagePath
                self.viewModel.imagePath = singleIntention.imagePath
                
            }
            else {
                
                GWDataManager().downloadIntentions(withArea: "stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    intentions, error in
                    
                    DispatchQueue.main.async(execute: { [weak self] in
                        
                        if error == nil {
                            let fetchedIntentions = GWDataManager().fetchIntentionsOnMainThread(withAreaName: "stickers", culture: GWLocalizedBundle.currentLocaleAPIString(), withIntentionIds: [ nonNilIntentionId ] )
                            self?.stickersTitleLabel.text = fetchedIntentions.first?.label
                            self?.selectedStickerTitle = fetchedIntentions.first?.label
                            self?.selectedImagePath = fetchedIntentions.first?.imagePath
                            self?.viewModel.imagePath = fetchedIntentions.first?.imagePath
                            self?.collectionView.collectionView.reloadData()
                        }
                        
                    })
                    
                })
                
            }
            
        }
        else if let nonNilImagePath = self.selectedImagePath {
            
            GWDataManager().downloadImageThemes(withPath: "http://gw-static-apis.azurewebsites.net/data/stickers/moodthemes.json", withCompletion: {
                themeDict, error in
                
                DispatchQueue.main.async(execute: { [weak self] in
                    
                    if let nonNilThemes = themeDict?["Themes"] as? [NSDictionary] {
                        print("non nil themes \(nonNilThemes) and image path \(nonNilImagePath)")
                        self?.stickersTitleLabel.text = self?.viewModel.nameForTheme(nonNilThemes, themePath: nonNilImagePath)
                        self?.selectedStickerTitle = self?.viewModel.nameForTheme(nonNilThemes, themePath: nonNilImagePath)
                        
                    }
                    
                })
                
            })
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        if UserDefaults.isMainScreenReached() == false {
            AnalyticsManager().postAction(withType: kGAMainScreenReached, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAMainScreen)
            UserDefaults.setIsMainScreenReached( true )
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backToMessengerButton = MAXBlockButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        backToMessengerButton?.backgroundColor = UIColor.c_backToMessengerBanner()
        backToMessengerButton?.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        backToMessengerButton?.setTitle("Touch to return to messenger", for: UIControlState())
        backToMessengerButton?.setTitleColor(UIColor.white, for: UIControlState())
        backToMessengerButton?.titleLabel?.font = UIFont.c_roboto(withSize: 13.0)
        
        backToMessengerButton?.buttonTouchUpInside(completion: {
            
            FBSDKMessengerSharer.openMessenger()
            
        })
        
        if self.selectedIntentionId != nil {
            
            AnalyticsManager.shared().postAction( withType: kGAMoodIntention, targetType: kGATargetTypeIntention, targetId: selectedIntentionId, targetParameter: nil, actionLocation: kGACategoryListScreen)
        
        }
        else {
            
            AnalyticsManager.shared().postAction( withType: kGAMoodTheme, targetType: kGATargetTypeTheme, targetId: selectedImagePath, targetParameter: nil, actionLocation: kGACategoryListScreen)
        
        }
        
        viewModel.imagePath = selectedImagePath
        viewModel.itemSize = Float( self.view.frame.width / 2.0 )
        
        collectionView = MAXCollectionViewImageAndText(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        collectionView.datasource = viewModel
        
        if self.tabBarController != nil {
            self.collectionView.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
        }
        
        collectionView.headerView.backgroundColor = UIColor.c_blue()
        
        var backButtonImage = UIImage(named: "BackArrow")
        backButtonImage = backButtonImage?.withRenderingMode(.alwaysTemplate)
        
        
        let backButton = MAXFadeBlockButton(frame: CGRect(x: 0, y: 20, width: 44 * 1.5, height: 44))
        backButton.setImage( backButtonImage, for: UIControlState())
        backButton.tintColor = UIColor.white
        backButton.imageEdgeInsets = UIEdgeInsetsMake(44 * 0.3, 44 * 0.3, 44 * 0.3, 44 * 0.8)
        
        backButton.buttonTouchUpInside(completion: { [weak self] in
            
            AnalyticsManager.shared().postAction( withType: kGABackFromThemes, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGACategoryListScreen)
            
            UserDefaults.incrementNumBackToMainMenu()
            
            if let nonNilNav = self?.navigationController {
                nonNilNav.popViewController(animated: true)
                self?.backPressed()
            }
            else {
                self?.dismiss(animated: true, completion: {
                    
                    self?.backPressed()
                    
                })
            }
        })
        
        collectionView.headerView.addSubview(backButton)
        
        stickersTitleLabel.frame = CGRect( x: backButton.frame.maxX + self.view.frame.width * 0.05, y: 20, width: self.view.frame.width - backButton.frame.maxX - self.view.frame.width * 0.1, height: 44)
        stickersTitleLabel.textAlignment = .left
        stickersTitleLabel.textColor = UIColor.white
        stickersTitleLabel.text = self.selectedStickerTitle
        stickersTitleLabel.font = UIFont.c_roboto(withSize: Float(self.view.frame.height * 0.03))
        collectionView.headerView.addSubview(stickersTitleLabel)
        
        self.view.addSubview(collectionView)
        
        weak var wSelf = self
        
        viewModel.downloadImageIds({
            error -> Void in
            

            wSelf?.collectionView.collectionView.reloadData()
            
        })
        
        viewModel.reloadIndexPath({
            indexPath -> Void in

            wSelf?.collectionView.collectionView.reloadItems(at: [indexPath])
            
        })
        
        viewModel.selectedImage({
            imageName, selectedImage -> Void in
            
            AnalyticsManager.shared().postAction( withType: kGAImageSelected, targetType: kGATargetTypeImage, targetId: imageName?.imageName(), targetParameter: nil, actionLocation: kGACategoryListScreen)
            
            wSelf?.showSingleStickerDetail(imageName, image: selectedImage)
            
        })
        
        viewModel.reloadData()
        collectionView.collectionView.reloadData()
        
        self.addOrRemoveBackToMessengerButton()
        
    }
    
    func backPressed() {
        
        if (UserDefaults.numBackToMainMenu() == 4 || UserDefaults.numBackToMainMenu() == 10 || UserDefaults.numBackToMainMenu() == 20) && UserDefaults.wantsNotification() == false {
            
            let alertView = BlocksAlertView(title: PopularStickersLocalizedString("<NotificationAlertTitle>", ""), message: PopularStickersLocalizedString("<NotificationAlertMessage>", ""), delegate: nil, cancelButtonTitle: PopularStickersLocalizedString("<NotificationAlertCancelTitle>", ""), otherButtonTitles: PopularStickersLocalizedString("<NotificationAlertAcceptTitle>", ""))
            
            alertView.show()
            
            alertView.buttonPressed(completion: {
                index, alertView -> Void in
                
                if index == 0 {
                    // false statement, said in the alert view
                    UserDefaults.setWantsNotification(false)
                    
                }
                else {
                    // true statement, said in the alert view
                    let application = UIApplication.shared
                    application.registerUserNotificationSettings( UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound] , categories: nil))
                    
                    UserDefaults.setWantsNotification(true)
                    
                }
            })
            
        }

        
    }
    
    // MARK: Messenger Integration
    
    func addOrRemoveBackToMessengerButton() {
        
        if AppFlow.currentMessengerFlow == MessengerFlow.send {
            self.backToMessengerButton?.removeFromSuperview()
            self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
        else {
            
            if self.backToMessengerButton?.superview == nil {
                self.view.addSubview(self.backToMessengerButton!)
            }
            
            self.collectionView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20)
            
        }
        
    }
    
    
    // MARK: Navigation
    
    func showSingleStickerDetail(_ imageName: String?, image: UIImage?) -> Void {
        
        let singleStickerVC = SingleStickerDetailViewController()
        singleStickerVC.imageToShow = image
        singleStickerVC.imageName = imageName
        singleStickerVC.viewModel.imagePath = selectedImagePath
        singleStickerVC.viewModel.intentionId = selectedIntentionId
        singleStickerVC.selectedStickerTitle = self.selectedStickerTitle

        if let nonNilNav = self.navigationController {
            nonNilNav.pushViewController(singleStickerVC, animated: true)
        }
        else {
            self.present(singleStickerVC, animated: true, completion: nil)
        }
        
    }
    
    deinit {
        print("deinit sticker category list")
    }
    
}
