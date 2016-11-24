//
//  StickersOverviewController.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 05/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
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
    
    
    override func viewDidAppear(animated: Bool) {
        
        if let nonNilViewControllerToShow = self.viewControllerToShow {
            self.presentViewController(nonNilViewControllerToShow, animated: false, completion: nil)
            self.viewControllerToShow = nil
        }
        
        if UserDefaults.isMainScreenReached() == false {
            AnalyticsManager().postActionWithType(kGAEventCategoryAppEvent, targetType: kGAMainScreenReached, targetId: nil, targetParameter: nil, actionLocation: nil)
        }
        
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
        
        collectionView = MAXCollectionViewImageAndText(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)))
        collectionView.datasource = viewModel
        collectionView.headerView.backgroundColor = UIColor.c_blueColor()
        
        let stickersTitleLabel = UILabel(frame: CGRectMake(CGRectGetWidth(self.view.frame) * 0.05, 20, CGRectGetWidth(self.view.frame), 44))
        stickersTitleLabel.textAlignment = .Left
        stickersTitleLabel.textColor = UIColor.whiteColor()
        stickersTitleLabel.text = PopularStickersLocalizedString("<AppName>", nil)
        stickersTitleLabel.font = UIFont.c_robotoWithSize(Float(CGRectGetHeight(self.view.frame) * 0.03))
        collectionView.headerView.addSubview(stickersTitleLabel)
        
        var settingsImage = UIImage(named: "SettingsIcon")
        settingsImage = settingsImage?.imageWithRenderingMode(.AlwaysTemplate)
        
        let headerViewHeightWithoutStatusBar = CGRectGetHeight(collectionView.headerView.frame) - 20
        
        let settingsButton = MAXFadeBlockButton(frame: CGRectMake(CGRectGetWidth(self.view.frame) - headerViewHeightWithoutStatusBar * 1.5, 20, headerViewHeightWithoutStatusBar * 1.5, headerViewHeightWithoutStatusBar))
        settingsButton.imageEdgeInsets = UIEdgeInsetsMake(headerViewHeightWithoutStatusBar * 0, headerViewHeightWithoutStatusBar * 0.15, headerViewHeightWithoutStatusBar * 0, headerViewHeightWithoutStatusBar * 0.15)
        settingsButton.setImage(settingsImage, forState: UIControlState.Normal)
        settingsButton.tintColor = UIColor.whiteColor()
        
        settingsButton.buttonTouchUpInsideWithCompletion({
            
            AnalyticsManager.sharedManager().postActionWithType( kGAOptionMenu, targetType: kGAEventCategoryButtonPressed, targetId: nil, targetParameter: nil, actionLocation: nil)
            
            self.showSettingsView()
        })
        
        collectionView.headerView.addSubview(settingsButton)
        
        
        self.view.addSubview(collectionView)
        
        
        
        viewModel.downloadIntentions({
            error -> Void in
            
            self.viewModel.downloadThemes({
                error -> Void in
                
                self.collectionView.collectionView.reloadData()
                
            })
            
        })
        
        viewModel.reloadCellAtIndexPath({
            indexPath -> Void in
            
            self.collectionView.collectionView.reloadItemsAtIndexPaths([indexPath])
            
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
        
        if AppFlow.currentMessengerFlow == MessengerFlow.Send {
            self.backToMessengerButton?.removeFromSuperview()
            self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        }
        else {
            
            if self.backToMessengerButton?.superview == nil {
                self.view.addSubview(self.backToMessengerButton!)
            }
            
            // to hide some of the header view of the collection view that is allocated for the status bar we have 20 in height
            // to remove the other 20
            self.collectionView.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 20)
            
        }
        
    }
    
    // MARK: Navigation
    func showStickerDetailView(label: String?, imagePath: String?, intentionId: String?) {
        
        if UserDefaults.isFirstMoodItemPressed() == false {
            
            if intentionId != nil {
                AnalyticsManager.sharedManager().postActionWithType( kGAFirstMoodItemPressed, targetType: kGAEventCategoryButtonPressed, targetId: intentionId, targetParameter: nil, actionLocation: nil)
            }
            else {
                AnalyticsManager.sharedManager().postActionWithType( kGAMoodItemPressed, targetType: kGAEventCategoryButtonPressed, targetId: imagePath, targetParameter: nil, actionLocation: nil)
            }
                        
        }
        
        let stickerDetailVC = StickersDetailViewController(messengerMetadata: nil)
        stickerDetailVC.selectedStickerTitle = label
        stickerDetailVC.selectedImagePath = imagePath
        stickerDetailVC.selectedIntentionId = intentionId
        
        self.presentViewController(stickerDetailVC, animated: true, completion: nil)
        
    }
    
    func showSettingsView() {
        
        self.presentViewController(SettingsViewController(), animated: true, completion: nil)
        
    }
    
}
