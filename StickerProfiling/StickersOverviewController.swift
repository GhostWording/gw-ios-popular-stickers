//
//  StickersOverviewController.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 05/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
import MBProgressHUD
import FBSDKMessengerShareKit
import FBAudienceNetwork

class StickersOverviewController: UIViewController, FBInterstitialAdDelegate {
    
    let viewModel = StickersOverviewViewModel()
    var collectionView: MAXCollectionViewImageAndText!
    var backToMessengerButton: MAXBlockButton?
    
    var viewControllerToShow: UIViewController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        viewControllerToShow = nil
    }
    
    init(pushedVC: UIViewController?) {
        
        super.init(nibName: nil, bundle: nil)
        
        viewControllerToShow = pushedVC
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let nonNilViewControllerToShow = self.viewControllerToShow {
            self.present(nonNilViewControllerToShow, animated: false, completion: nil)
            self.viewControllerToShow = nil
        }
        
        if UserDefaults.isMainScreenReached() == false {
            AnalyticsManager().postAction(withType: kGAMainScreenReached, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: nil)
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
        
        collectionView = MAXCollectionViewImageAndText(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        collectionView.datasource = viewModel
        collectionView.headerView.backgroundColor = UIColor.c_blue()
        
        let stickersTitleLabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.05, y: 20, width: self.view.frame.width, height: 44))
        stickersTitleLabel.textAlignment = .left
        stickersTitleLabel.textColor = UIColor.white
        stickersTitleLabel.text = PopularStickersLocalizedString("<AppName>", nil)
        stickersTitleLabel.font = UIFont.c_roboto(withSize: Float(self.view.frame.height * 0.03))
        collectionView.headerView.addSubview(stickersTitleLabel)
        
        var settingsImage = UIImage(named: "SettingsIcon")
        settingsImage = settingsImage?.withRenderingMode(.alwaysTemplate)
        
        let headerViewHeightWithoutStatusBar = collectionView.headerView.frame.height - 20
        
        let settingsButton = MAXFadeBlockButton(frame: CGRect(x: self.view.frame.width - headerViewHeightWithoutStatusBar * 1.5, y: 20, width: headerViewHeightWithoutStatusBar * 1.5, height: headerViewHeightWithoutStatusBar))
        settingsButton.imageEdgeInsets = UIEdgeInsetsMake(headerViewHeightWithoutStatusBar * 0, headerViewHeightWithoutStatusBar * 0.15, headerViewHeightWithoutStatusBar * 0, headerViewHeightWithoutStatusBar * 0.15)
        settingsButton.setImage(settingsImage, for: UIControlState())
        settingsButton.tintColor = UIColor.white
        
        settingsButton.buttonTouchUpInside(completion: {
            
            AnalyticsManager.shared().postAction( withType: kGAOptionMenu, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAMainScreen)
            
            self.showSettingsView()
        })
        
        collectionView.headerView.addSubview(settingsButton)
        
        
        self.view.addSubview(collectionView)
        
        if self.tabBarController != nil {
            collectionView?.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
        }
        
        
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.indeterminate
        
        viewModel.downloadIntentions({
            error -> Void in
            
            self.viewModel.downloadThemes({
                error -> Void in
                
                self.collectionView.collectionView.reloadData()
                progressHud.hide( animated: true )
                
            })
            
        })
        
        viewModel.reloadCellAtIndexPath({
            indexPath -> Void in
            
            self.collectionView.collectionView.reloadItems(at: [indexPath])
            
        })
        
        viewModel.selectedSticker({
            label, imagePath, intentionId -> Void in
            
            self.showStickerDetailView(label, imagePath: imagePath, intentionId: intentionId)
            
        })
        
        self.addOrRemoveBackToMessengerButton()
        
    }
    
    
    func reloadData() {
        
        viewModel.reloadData()
        collectionView.collectionView.reloadData()
        
        viewModel.downloadIntentions({
            error -> Void in
            
            self.collectionView.collectionView.reloadData()
            
            
        })
        
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
            
            // to hide some of the header view of the collection view that is allocated for the status bar we have 20 in height
            // to remove the other 20
            self.collectionView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20)
            
        }
        
    }
    
    // MARK: Navigation
    func showStickerDetailView(_ label: String?, imagePath: String?, intentionId: String?) {
        
        if UserDefaults.isFirstMoodItemPressed() == false {
            
            if intentionId != nil {
                AnalyticsManager.shared().postAction( withType: kGAFirstMoodItemPressed, targetType: kGATargetTypeIntention, targetId: intentionId, targetParameter: nil, actionLocation: kGAMainScreen)
            }
            else {
                AnalyticsManager.shared().postAction( withType: kGAMoodItemPressed, targetType: kGATargetTypeTheme, targetId: imagePath, targetParameter: nil, actionLocation: kGAMainScreen)
            }
                        
        }
        
        let stickerDetailVC = StickersDetailViewController(messengerMetadata: nil)
        stickerDetailVC.selectedStickerTitle = label
        stickerDetailVC.selectedImagePath = imagePath
        stickerDetailVC.selectedIntentionId = intentionId
        
        self.present(stickerDetailVC, animated: true, completion: nil)
        
    }
    
    func showSettingsView() {
        
        self.present(SettingsViewController(), animated: true, completion: nil)
        
    }
    
}
