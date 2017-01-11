//
//  LMDailyIdeasViewController.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/19/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

import FBSDKMessengerShareKit
import MBProgressHUD

class LMDailyIdeasViewController: RootViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {

    var backToMessengerButton: MAXBlockButton?
    var collectionView : UICollectionView?
    let viewModel = DailyIdeasViewModel()
    
    var rememberMethodSwitch : MBSwitch?
    var overlayView : UIView?
    
    var prototypeId : String?
    var indexPath : IndexPath?
    
    var refreshControl : UIRefreshControl?
    var headerView: UIView!
    
    let showTabBarButton = MAXFadeBlockButton()
    let cellFont = UIFont.c_robotoLight( withSize: 16.0 )
    
    let adLoader = AdLoader()
    var reachedBottomBlock : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        _ = adLoader.createAdAtPosition(adPosition: InterstitialAdPosition.DailyIdeasBottom, completion: {
            error in
            
            print("bottom of daily ideas ad loaded")
            
        })
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        headerView.backgroundColor = UIColor.c_blue()
        self.view.addSubview( headerView )
        
        backToMessengerButton = MAXBlockButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        backToMessengerButton?.backgroundColor = UIColor.c_backToMessengerBanner()
        backToMessengerButton?.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        backToMessengerButton?.setTitle("Touch to return to messenger", for: UIControlState())
        backToMessengerButton?.setTitleColor(UIColor.white, for: UIControlState())
        backToMessengerButton?.titleLabel?.font = UIFont.c_roboto(withSize: 13.0)
        
        backToMessengerButton?.buttonTouchUpInside(completion: {
            
            FBSDKMessengerSharer.openMessenger()
            
        })
        
        let stickersTitleLabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.05, y: 20, width: self.view.frame.width, height: 44))
        stickersTitleLabel.textAlignment = .left
        stickersTitleLabel.textColor = UIColor.white
        stickersTitleLabel.text = PopularStickersLocalizedString("<AppName>", nil)
        stickersTitleLabel.font = UIFont.c_roboto(withSize: Float(self.view.frame.height * 0.03))
        headerView.addSubview(stickersTitleLabel)
        
        
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: headerView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - headerView.frame.maxY), collectionViewLayout: layout)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.backgroundColor = UIColor.c_lightGrayBackground()
        
        self.collectionView?.register(DailyIdeasCollectionViewCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        self.collectionView?.register(DailyIdeasSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderIdentifier")
        
        self.view.addSubview( collectionView! )
        
        weak var wSelf = self
        
        self.reachedBottomBlock = {
            
            // Do whatever you want here.
            if let nonNilAd = wSelf?.adLoader.interstitialAd {
                if nonNilAd.isAdValid == true {
                    
                    if let timeSinceAd = UserDefaults.lastDateAdWasShown()?.timeIntervalSinceNow {
                        
                        if timeSinceAd < -180 {
                            
                            UserDefaults.setLastDateAdWasShown( Date() )
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                
                                nonNilAd.show(fromRootViewController: wSelf)
                                _ = wSelf?.adLoader.createAdAtPosition(adPosition: InterstitialAdPosition.DailyIdeasBottom, completion: {
                                    error in
                                })
                                
                            })
                            
                        }
                        
                    }
                    else {
                        
                        UserDefaults.setLastDateAdWasShown( Date() )
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                            
                            nonNilAd.show(fromRootViewController: wSelf)
                            _ = wSelf?.adLoader.createAdAtPosition(adPosition: InterstitialAdPosition.DailyIdeasBottom, completion: {
                                error in
                            })
                            
                        })
                        
                    }
                    
                }
                
            }
            
        }
        
        self.refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        refreshControl!.addTarget(self, action: #selector(refreshContent), for: UIControlEvents.valueChanged)
        self.collectionView?.addSubview( refreshControl! )
        
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.indeterminate
        
        self.viewModel.fetchDailyIdeasWithCompletion(fetchFromCache: true, forceReload: true, completion: {
            shouldRefresh, error in
            
            if error == nil {
                self.collectionView?.reloadData()
            }
            
            progressHud.hide(animated: true)
            
        })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        self.developerModeUpdate()
        
    }
    
    func developerModeUpdate() {
        
        if UserDefaults.developerModeEnabled() == true {
            
            showTabBarButton.frame = CGRect(x: self.view.frame.width - 64 * 1.5 * 2, y: 20, width: 64, height: 44)
            self.updateTabBarShowButtonTitle()
            
            showTabBarButton.buttonTouchUpCompletionBlock = {
                self.tabBarController?.tabBar.isHidden = !(self.tabBarController?.tabBar.isHidden == true)
                self.updateTabBarShowButtonTitle()
            }
            if showTabBarButton.superview != self.headerView {
                self.headerView.addSubview( showTabBarButton )
            }
            
            self.headerView.removeFromSuperview()
            self.collectionView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.collectionView?.reloadData()
            
        }
        else {
            
            self.showTabBarButton.removeFromSuperview()
            self.tabBarController?.tabBar.isHidden = false
            
            self.collectionView?.frame = CGRect(x: 0, y: headerView.frame.height, width: self.view.frame.width, height: self.view.frame.height - headerView.frame.height)
            self.collectionView?.reloadData()
            
            if self.headerView.superview != self.view {
                self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
                self.view.addSubview( self.headerView )
            }
            
            
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
    
    override var prefersStatusBarHidden : Bool {
        
        if UserDefaults.developerModeEnabled() == true {
            return true
        }
        
        return false
    }
    
    
    // MARK: Refresh Control
    
    func refreshContent() {
        
        self.viewModel.fetchDailyIdeasWithCompletion(fetchFromCache: true, forceReload: true, completion: {
            shouldRefresh, error in
            
            if let nonNilRefreshControl = self.refreshControl {
                nonNilRefreshControl.endRefreshing()
            }
            
            if shouldRefresh == true {
                self.collectionView?.reloadData()
            }
            
        })
        
    }
    
    override func forceReload() {
        
        self.viewModel.fetchDailyIdeasWithCompletion(fetchFromCache: false, forceReload: false, completion: {
            shouldRefresh, error in
            
            self.collectionView?.reloadData()
            
        })
        
    }
    
    // MARK: Choose send method
    
    func chooseSendMethod() {
        
        if UserDefaults.sendMethodForMessage() == MessageSendMethod.noMethod {
            
            if let nonNilIndexPath = indexPath {
                AnalyticsManager.shared().postAction(withType: kGASendMenuOpened, targetType: kGATargetTypeApp, targetId: self.viewModel.textIdAtIndexPath(nonNilIndexPath), targetParameter: self.viewModel.getImageName(nonNilIndexPath)?.imageName(), actionLocation: kGADailyIdeasScreen)
            }
            
            
            overlayView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width , height: self.view.frame.height))
            overlayView?.backgroundColor = UIColor.c_color(withHexString: UIColor.c_hexValues(from: UIColor.black), alpha:  0.3)
            overlayView?.alpha = 0.0
            
            let backgroundButton = MAXFadeBlockButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            backgroundButton.backgroundColor = UIColor.clear
            backgroundButton.buttonTouchUpInside(completion: {
                self.fadeOutOverlayView(nil)
            })
            
            overlayView?.addSubview( backgroundButton )
            
            self.view.addSubview( overlayView! )
            
            let chooseMethodView = UIView(frame: CGRect(x: self.view.frame.width * 0.15, y: self.view.frame.height * 0.3, width: self.view.frame.width * 0.7, height: self.view.frame.width * 0.7))
            chooseMethodView.layer.backgroundColor = UIColor.white.cgColor
            chooseMethodView.layer.borderColor = UIColor.c_blue().cgColor
            chooseMethodView.layer.borderWidth = 2.0
            chooseMethodView.layer.cornerRadius = 5.0
            chooseMethodView.layer.masksToBounds = true
            
            overlayView!.addSubview( chooseMethodView )
            
            
            let titleLabel = UILabel(frame:  CGRect(x: 0, y: 0, width: chooseMethodView.frame.width, height: chooseMethodView.frame.height * 0.15))
            titleLabel.font = UIFont.c_robotoBold( withSize: 16.0 )
            titleLabel.textColor = UIColor.c_textDarkGray()
            titleLabel.textAlignment = .center
            titleLabel.text = PopularStickersLocalizedString("<ChooseSendMethod>", nil)
            
            chooseMethodView.addSubview( titleLabel )
            
            
            let messengerButtonContainerRow = MAXFadeBlockButton(frame: CGRect(x: 0, y: chooseMethodView.frame.height * 0.16 - chooseMethodView.frame.width * 0.035, width: chooseMethodView.frame.width , height: chooseMethodView.frame.width * 0.18 + chooseMethodView.frame.width * 0.07))
            chooseMethodView.addSubview( messengerButtonContainerRow )
            
            
            let messengerButton = FBSDKMessengerShareButton.circularButton( with: FBSDKMessengerShareButtonStyle.blue )
            messengerButton?.frame = CGRect(x: chooseMethodView.frame.width * 0.06, y: chooseMethodView.frame.height * 0.035, width: chooseMethodView.frame.width * 0.18, height: chooseMethodView.frame.width * 0.18)
            messengerButton?.isUserInteractionEnabled = false
            
            messengerButtonContainerRow.addSubview( messengerButton! )
            
            let messengerTitle = UILabel(frame: CGRect(x: (messengerButton?.frame.maxX)! + 10, y: (messengerButton?.frame.minY)!, width: chooseMethodView.frame.width * 0.6, height: (messengerButton?.frame.height)!))
            messengerTitle.textAlignment = .left
            messengerTitle.textColor = UIColor.c_textDarkGray()
            messengerTitle.font = UIFont.c_robotoMedium( withSize: 15.0 )
            messengerTitle.text = PopularStickersLocalizedString("<MessengerMethod>", nil)
            
            messengerButtonContainerRow.addSubview( messengerTitle )
            
            let otherButtonContainerRow = MAXFadeBlockButton(frame: CGRect(x: 0, y: messengerButtonContainerRow.frame.maxY - chooseMethodView.frame.width * 0.02, width: chooseMethodView.frame.width, height: chooseMethodView.frame.width * 0.18 + chooseMethodView.frame.width * 0.07))
            chooseMethodView.addSubview( otherButtonContainerRow )
            
            let otherButton = MAXFadeBlockButton(frame: CGRect(x: (messengerButton?.frame.minX)!, y: chooseMethodView.frame.width * 0.035, width: chooseMethodView.frame.width * 0.18, height: chooseMethodView.frame.width * 0.18))
            otherButton.backgroundColor = UIColor.c_green()
            otherButton.layer.cornerRadius = otherButton.frame.width / 2.0
            otherButton.isUserInteractionEnabled = false
            
            
            
            var smsImage = UIImage(named: "SmsIcon")
            smsImage = smsImage?.withRenderingMode( UIImageRenderingMode.alwaysTemplate )
            
            let smsImageView = UIImageView(frame: CGRect(x: otherButton.frame.width * 0.22, y: otherButton.frame.height * 0.17, width: otherButton.frame.width * 0.26, height: otherButton.frame.width * 0.26))
            smsImageView.image = smsImage
            smsImageView.tintColor = UIColor.white
            otherButton.addSubview( smsImageView )
            
            var whatsAppImage = UIImage(named: "WhatsAppIcon")
            whatsAppImage = whatsAppImage?.withRenderingMode( UIImageRenderingMode.alwaysTemplate )
            
            let whatsAppImageView = UIImageView(frame: CGRect(x: otherButton.frame.width * 0.58, y: otherButton.frame.height * 0.32, width: otherButton.frame.width * 0.3, height: otherButton.frame.width * 0.3))
            whatsAppImageView.image = whatsAppImage
            whatsAppImageView.tintColor = UIColor.white
            otherButton.addSubview( whatsAppImageView )
            
            var emailImage = UIImage(named:  "EmailIcon")
            emailImage = emailImage?.withRenderingMode( UIImageRenderingMode.alwaysTemplate )
            
            let emailImageView = UIImageView(frame: CGRect(x: otherButton.frame.width * 0.2, y: otherButton.frame.height * 0.55, width: otherButton.frame.width * 0.33, height: otherButton.frame.width * 0.33))
            emailImageView.image = emailImage
            emailImageView.tintColor = UIColor.white
            otherButton.addSubview( emailImageView )
            
            
            otherButtonContainerRow.addSubview( otherButton )
            
            let otherSendMethodTitleLabel = UILabel(frame: CGRect(x: otherButton.frame.maxX + 10, y: otherButton.frame.minY, width: chooseMethodView.frame.width * 0.6, height: otherButton.frame.height))
            otherSendMethodTitleLabel.textAlignment = .left
            otherSendMethodTitleLabel.textColor = UIColor.c_textDarkGray()
            otherSendMethodTitleLabel.font = UIFont.c_robotoMedium( withSize: 15.0 )
            otherSendMethodTitleLabel.text = PopularStickersLocalizedString("<OtherMethod>", nil)
            
            otherButtonContainerRow.addSubview( otherSendMethodTitleLabel )
            
            let bottomBlueFooter = UIView(frame: CGRect(x: 0, y: chooseMethodView.frame.height * 0.84, width: chooseMethodView.frame.width , height: chooseMethodView.frame.height * 0.16 ))
            bottomBlueFooter.backgroundColor = UIColor.c_blue()
            
            chooseMethodView.addSubview( bottomBlueFooter )
            
            if  UserDefaults.hasSentImageOrText() == true {
                
                self.rememberMethodSwitch = MBSwitch(frame: CGRect(x: chooseMethodView.frame.width * 0.08, y: otherButtonContainerRow.frame.maxY + chooseMethodView.frame.width * 0.035, width: chooseMethodView.frame.width * 0.15, height: chooseMethodView.frame.width * 0.1))
                self.rememberMethodSwitch!.onTintColor = UIColor.c_blue()
                chooseMethodView.addSubview( rememberMethodSwitch! )
                
                let rememberTitleLabel = UILabel(frame: CGRect(x: self.rememberMethodSwitch!.frame.maxX + 10, y: self.rememberMethodSwitch!.frame.minY, width: chooseMethodView.frame.width * 0.7, height: chooseMethodView.frame.width * 0.1))
                rememberTitleLabel.textAlignment = .left
                rememberTitleLabel.textColor = UIColor.c_textDarkGray()
                rememberTitleLabel.font = UIFont.c_robotoMedium( withSize: 15.0 )
                rememberTitleLabel.text = PopularStickersLocalizedString("<RememberSendMethod>", nil)
                chooseMethodView.addSubview( rememberTitleLabel )
                
            }
            else {
                
                messengerButtonContainerRow.frame = CGRect(x: 0, y: chooseMethodView.frame.height * 0.2, width: chooseMethodView.frame.width , height: chooseMethodView.frame.width * 0.18 + chooseMethodView.frame.width * 0.07)
                otherButtonContainerRow.frame = CGRect(x: 0, y: messengerButtonContainerRow.frame.maxY + chooseMethodView.frame.width * 0.05, width: chooseMethodView.frame.width, height: chooseMethodView.frame.width * 0.18 + chooseMethodView.frame.width * 0.07)
                
                
            }
            
            let cancelButton = MAXFadeBlockButton(frame: CGRect(x: 0, y: 0, width: bottomBlueFooter.frame.width, height: bottomBlueFooter.frame.height))
            cancelButton.setTitle(PopularStickersLocalizedString("<NotificationAlertCancelTitle>", nil), for: UIControlState())
            cancelButton.titleLabel!.font = UIFont.c_robotoMedium( withSize: 15.0 )
            cancelButton.setTitleColor(UIColor.white, for: UIControlState())
            
            
            cancelButton.buttonTouchUpInside(completion: {
                
                self.fadeOutOverlayView(nil)
                
            })
            
            bottomBlueFooter.addSubview( cancelButton )
            
            
            messengerButtonContainerRow.buttonTouchUpInside(completion: {
                
                if UserDefaults.hasSentImageOrText() == true && self.rememberMethodSwitch != nil {
                    
                    if self.rememberMethodSwitch!.isOn == true {
                        UserDefaults.setSendMethodForMessage( MessageSendMethod.messenger )
                    }
                    
                }
                
                self.fadeOutOverlayView(nil)
                
                self.sendWithMessenger()
                
            })
            
            otherButtonContainerRow.buttonTouchUpInside(completion: {
                
                if UserDefaults.hasSentImageOrText() == true && self.rememberMethodSwitch != nil {
                    if self.rememberMethodSwitch!.isOn == true {
                        UserDefaults.setSendMethodForMessage(  MessageSendMethod.OS )
                    }
                }
                
                self.fadeOutOverlayView(nil)
                
                self.sendWithOS()
                
            })
            
            UIView.animate(withDuration: 0.1, animations: {
                self.overlayView!.alpha = 1.0
            })
        }
        else if UserDefaults.sendMethodForMessage() == MessageSendMethod.messenger {
            
            self.sendWithMessenger()
        }
        else if UserDefaults.sendMethodForMessage() == MessageSendMethod.OS {
            
            self.sendWithOS()
        }
        
    }
    
    func fadeOutOverlayView(_ completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.overlayView!.alpha = 0.0
            }, completion: {
                finished -> Void in
                
                self.overlayView!.removeFromSuperview()
                
        })
    }

    
    func sendWithMessenger() {
        
        AnalyticsManager.shared().postAction( withType: kGASendMessenger, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGADailyIdeasScreen)
        
        
        if let nonNilIndexPath = indexPath {
            // when index path is not nil we sent it with a text
            AnalyticsManager.shared().postAction( withType: kGASendMessenger, targetType: kGATargetTypeText, targetId: self.viewModel.textIdAtIndexPath( nonNilIndexPath ), targetParameter: nil, actionLocation: kGADailyIdeasScreen)
            
            AnalyticsManager.shared().postAction( withType: kGASendMessenger, targetType: kGATargetTypeImage, targetId: self.viewModel.getImageName( self.indexPath! ), targetParameter: nil, actionLocation: kGADailyIdeasScreen)
            
            AnalyticsManager.shared().postAction( withType: kGALinkEvents, targetType: kGATargetTypeApp, targetId: self.viewModel.textIdAtIndexPath( nonNilIndexPath ), targetParameter: self.viewModel.getImageName( self.indexPath! ), actionLocation: kGADailyIdeasScreen)
        }
        else {
            AnalyticsManager.shared().postAction( withType: kGASendMessenger, targetType: kGATargetTypeImage, targetId: self.viewModel.getImageName( self.indexPath! ), targetParameter: nil, actionLocation: kGADailyIdeasScreen)
        }
        
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.indeterminate
        
        if self.overlayView != nil {
            self.fadeOutOverlayView(nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.2 ) * Int64( NSEC_PER_SEC )) / Double(NSEC_PER_SEC), execute: {
            
            self.showMessengerExtension( self.createImage(image: self.viewModel.imageAtIndexPath( self.indexPath! )! , text: self.viewModel.textAtIndexPath( self.indexPath! )! ), imageId: self.viewModel.getImageName( self.indexPath! ), prototypeId: nil)
            UserDefaults.setHasSentImageOrText( true )
            s_sentWithMessengerInDailyIdeas = true
            
        });
        
    }
    
    func sendWithOS() {
        
        let activityVC = UIActivityViewController(activityItems: [self.createImage(image: self.viewModel.imageAtIndexPath( self.indexPath! )!, text: self.viewModel.textAtIndexPath( self.indexPath! )!)], applicationActivities: nil)
        
        if #available(iOS 9.0, *) {
            let excludedActivities = [UIActivityType.openInIBooks]
            activityVC.excludedActivityTypes = excludedActivities
        }
        
        AnalyticsManager.shared().postAction( withType: kGAShareViaIntent, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGADailyIdeasScreen)
        
        if let nonNilIndexPath = indexPath {
            
            AnalyticsManager.shared().postAction( withType: kGAShareViaIntent, targetType: kGATargetTypeText, targetId: self.viewModel.textIdAtIndexPath( nonNilIndexPath ), targetParameter: nil, actionLocation: kGADailyIdeasScreen)
            
            AnalyticsManager.shared().postAction( withType: kGAShareViaIntent, targetType: kGATargetTypeImage, targetId: self.viewModel.getImageName( self.indexPath! ), targetParameter: nil, actionLocation: kGADailyIdeasScreen)
            
            AnalyticsManager.shared().postAction( withType: kGALinkEvents, targetType: kGATargetTypeApp, targetId: self.viewModel.textIdAtIndexPath( nonNilIndexPath ), targetParameter: self.viewModel.getImageName( self.indexPath! ), actionLocation: kGADailyIdeasScreen)
            
        }
        else {
            AnalyticsManager.shared().postAction( withType: kGAShareViaIntent, targetType: kGATargetTypeImage, targetId: self.viewModel.getImageName( self.indexPath! ), targetParameter: nil, actionLocation: kGADailyIdeasScreen)
        }
        
        
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.indeterminate
        
        activityVC.completionWithItemsHandler = {
            activityType, completed, returnedItems, error in
            
            if completed == true {
                
                if let nonNilActivityType = activityType as? String {
                    AnalyticsManager.shared().postAction(withType: kGASendWith, targetType: kGATargetTypeApp, targetId: nonNilActivityType, targetParameter: nil, actionLocation: kGADailyIdeasScreen)
                }
                
                if UserDefaults.isNotificationRegistered() == false {
                    let application = UIApplication.shared
                    application.registerUserNotificationSettings( UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound] , categories: nil))
                }
                
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.2 ) * Int64( NSEC_PER_SEC )) / Double(NSEC_PER_SEC), execute: {
            self.present(activityVC, animated: true, completion: {
                progressHud.hide(animated: true)
                UserDefaults.setHasSentImageOrText( true )
            })
        });
        
    }

    func showMessengerExtension(_ image: UIImage?, imageId: String?, prototypeId: String?) {
        
        if let nonNilImage = image, let _ = imageId {
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            let options = FBSDKMessengerShareOptions()
            
            options.contextOverride = AppFlow.currentContext()
            options.metadata = self.createMetadataJsonString(imageId, prototypeId: prototypeId)
            FBSDKMessengerSharer.share(nonNilImage, with: options)
            
            
        }
        
    }

    
    // MARK: Create Metadata Json String
    
    func createMetadataJsonString(_ imageId: String?, prototypeId: String?) -> String? {
        
        let mutableDict = NSMutableDictionary()
        
        mutableDict.setObject(1, forKey: "version" as NSCopying)
        
        if let intentionId = self.viewModel.getIntentionIdAtIndexPath( indexPath! ) {
            mutableDict.setObject(intentionId, forKey: "intentionId" as NSString)
        }
        else {
            mutableDict.setObject(NSNull(), forKey: "intentionId" as NSCopying)
        }
        
        if let imagePath = self.viewModel.getImagePathAtIndexPath( self.indexPath! ) {
            mutableDict.setObject(imagePath, forKey: "imagePath" as NSString)
        }
        
        // not supported yet
        if let nonNilPrototypeId = prototypeId {
            mutableDict.setObject(nonNilPrototypeId, forKey: "prototypeId" as NSCopying)
        }
        else {
            mutableDict.setObject(NSNull(), forKey: "prototypeId" as NSCopying)
        }
        mutableDict.setObject(NSNull(), forKey: "recipientType" as NSCopying)
        
        
        if let imageName = imageId {
            
            if let lastComponent = imageName.components(separatedBy: "/").last {
                mutableDict.setObject(lastComponent, forKey: "imageName" as NSCopying)
            }
        }
        
        
        do {
            let data = try JSONSerialization.data(withJSONObject: mutableDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let jsonString = String(data: data, encoding: String.Encoding.utf8)
            
            return jsonString
            
        }
        catch {
            
        }
        
        return nil
    }
    
    
    // MARK: Collection View Delegate & Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.viewModel.numDailyIdeas()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as! DailyIdeasCollectionViewCell
        
        self.viewModel.downloadOrFetchImageAtIndexPath(indexPath, completion: {
            image, error in
            
            if error == nil {
                collectionView.reloadItems( at: [indexPath] )
            }
            
        })
        
        cell.imageView.image = self.viewModel.imageAtIndexPath( indexPath )
        cell.titleLabel.text = self.viewModel.textAtIndexPath( indexPath )
        cell.titleLabel.font = cellFont
        
        cell.sendButton.setTitle(PopularStickersLocalizedString("<Send>", nil), for: UIControlState())
        cell.sendButton.buttonTouchUpCompletionBlock = {
            
            self.indexPath = indexPath
            self.chooseSendMethod()
            
        }
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let imageHeight = self.view.frame.width * 0.7
        let buttonSpaceAndHeight : CGFloat = 60
        
        var textHeight : CGFloat = 40
        
        if let nonNilText = self.viewModel.textAtIndexPath( indexPath ) {
            
            let height = (nonNilText as NSString).heightForStringWithFont(cellFont!, width: self.view.frame.width * 0.8 * 0.8, maxHeight: 500)
            textHeight += height
            
        }
        
        return CGSize(width: self.view.frame.width * 0.8, height: imageHeight + textHeight + buttonSpaceAndHeight )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(20, 0, 69, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderIdentifier", for: indexPath) as! DailyIdeasSectionHeaderView
    
        sectionHeader.headerView = self.headerView
        
        return sectionHeader
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if UserDefaults.developerModeEnabled() == true {
            
            return self.headerView.frame.size
        }
        
        return CGSize.zero
    }
    
    // MARK: Scroll View Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if bottomEdge >= scrollView.contentSize.height {
            reachedBottomBlock?()
        }
        
    }
    
    
    // MARK: Navigation
    func showSettingsView() {
        
        self.present(SettingsViewController(), animated: true, completion: nil)
        
    }
}
