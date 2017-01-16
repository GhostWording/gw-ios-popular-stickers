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

class StickersOverviewController: RootViewController, FBInterstitialAdDelegate {
    
    let viewModel = StickersOverviewViewModel()
    var collectionView: MAXCollectionViewImageAndText!
    var backToMessengerButton: MAXBlockButton?
    let showTabBarButton = MAXFadeBlockButton()
    
    let adLoader = AdLoader()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        if UserDefaults.isMainScreenReached() == false {
            AnalyticsManager().postAction(withType: kGAMainScreenReached, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAMainScreen)
            UserDefaults.setIsMainScreenReached( true )
        }
        
        self.developerModeUpdate()
    }
    
    func developerModeUpdate() {
        
        weak var wSelf = self
        
        if UserDefaults.developerModeEnabled() == true {
            showTabBarButton.frame = CGRect(x: self.view.frame.width - 64 * 1.5 * 2, y: 20, width: 64, height: 44)
            self.updateTabBarShowButtonTitle()
            
            showTabBarButton.buttonTouchUpCompletionBlock = {
                wSelf?.tabBarController?.tabBar.isHidden = !(self.tabBarController?.tabBar.isHidden == true)
                wSelf?.updateTabBarShowButtonTitle()
            }
            if showTabBarButton.superview != self.collectionView?.headerView {
                wSelf?.collectionView?.headerView.addSubview( showTabBarButton )
            }
            
            self.collectionView?.headerView.removeFromSuperview()
            
        }
        else {
            
            self.showTabBarButton.removeFromSuperview()
            self.tabBarController?.tabBar.isHidden = false
            
        }
        
        if UserDefaults.developerModeEnabled() == true && self.collectionView != nil {
            self.collectionView?.isHeaderPartOfCollectionView = true
        }
        else if self.collectionView != nil {
            self.collectionView?.isHeaderPartOfCollectionView = false
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    func updateTabBarShowButtonTitle() {
        
        if self.tabBarController?.tabBar.isHidden == true {
            showTabBarButton.setTitle("Hide", for: UIControlState())
        }
        else {
            showTabBarButton.setTitle("Show", for: UIControlState())
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var wSelf = self
        
        _ = self.adLoader.createAdAtPosition(adPosition: InterstitialAdPosition.StickerCategoriesBottom, completion: { error in
            
            if error == nil {
                print("ad loaded")
            }
            else {
                print("ad error")
                
                if UserDefaults.developerModeEnabled() == true {
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.present( BlocksAlertController.init(title: "Error", message: (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert, firstActionTitle: "Ok", secondActionTitle: nil, thirdActionTitle: nil, fourthActionTitle: nil, completion: {
                            index in
                        }), animated: true, completion: nil)
                        
                    })
                    
                }
                
            }
            
        })

        
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
        
        self.view.addSubview( collectionView )
        
        if self.tabBarController != nil {
            collectionView?.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
        }
        
        
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.indeterminate
        
        viewModel.downloadIntentions({
            error -> Void in
            
            wSelf?.viewModel.downloadThemes({
                error -> Void in
                
                wSelf?.collectionView.collectionView.reloadData()
                progressHud.hide( animated: true )
                
            })
            
        })
        
        viewModel.reloadCellAtIndexPath({
            indexPath -> Void in
            
            wSelf?.collectionView.collectionView.reloadItems(at: [indexPath])
            
        })
        
        viewModel.selectedSticker({
            label, imagePath, intentionId -> Void in
            
            wSelf?.showStickerDetailView(label, imagePath: imagePath, intentionId: intentionId)
            
        })
        
        self.addOrRemoveBackToMessengerButton()
        
        let view = UIView(frame: CGRect(x: 200, y: 200, width: 200, height: 200) )
        view.backgroundColor = UIColor.red
        //self.view.addSubview( view )
        
        collectionView.reachedBottomBlock = {
            
            if let nonNilAd = wSelf?.adLoader.interstitialAd {
                if nonNilAd.isAdValid == true {
                    
                    let time = UserDefaults.lastDateAdWasShown().timeIntervalSinceNow
                    
                    if time < AppConfig.appAdvertDelay {
                        
                        wSelf?.showAdAfterDelay( nonNilAd )
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    func reloadData() {
        
        viewModel.reloadData()
        collectionView.collectionView.reloadData()
        
        weak var wSelf = self
        
        viewModel.downloadIntentions({
            error -> Void in
            
            wSelf?.collectionView.collectionView.reloadData()
            
            
        })
        
    }
    
    override func forceReload() {
        
        weak var wSelf = self
        
        viewModel.downloadIntentions({
            error -> Void in
            
            self.viewModel.downloadThemes({
                error -> Void in
                
                wSelf?.collectionView?.collectionView.reloadData()
                
            })
            
        })
        
    }
    
    override var prefersStatusBarHidden : Bool {
        
        if UserDefaults.developerModeEnabled() == true {
            return true
        }
        
        return false
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
                
        if let nonNilNav = self.navigationController {
            nonNilNav.pushViewController(stickerDetailVC, animated: true)
        }
        else {
            self.present(stickerDetailVC, animated: true, completion: nil)

        }
        
    }
    
    func showSettingsView() {
        
        self.present(SettingsViewController(), animated: true, completion: nil)
        
    }
    
    func showAdAfterDelay(_ nonNilAd: FBInterstitialAd) {
        let date = Date()
        UserDefaults.setLastDateAdWasShown( date )
        
        weak var wSelf = self
        
        if UserDefaults.developerModeEnabled() == true {
            
            self.present( BlocksAlertController.init(title: "Succeeded", message: "Showing an ad at this location, disable developer mode to see the ad", preferredStyle: UIAlertControllerStyle.alert, firstActionTitle: "Ok", secondActionTitle: nil, thirdActionTitle: nil, fourthActionTitle: nil, completion: { alertIndex in
                
            }), animated: true, completion: {
                
                //nonNilAd.show(fromRootViewController: wSelf)
                
            })
        }
        else {
            nonNilAd.show(fromRootViewController: wSelf)
        }
        
        
        _ = self.adLoader.createAdAtPosition(adPosition: InterstitialAdPosition.StickerCategoriesBottom, completion: {
            error in
            
            if error != nil {
                if UserDefaults.developerModeEnabled() == true {
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.present( BlocksAlertController.init(title: "Error", message: (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert, firstActionTitle: "Ok", secondActionTitle: nil, thirdActionTitle: nil, fourthActionTitle: nil, completion: {
                            index in
                        }), animated: true, completion: nil)
                        
                    })
                    
                }
            }
            
        })
        
        AnalyticsManager().postAction(withType: kGAAdDisplayed, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAStickerCategory)
    }

    
}
