//
//  AppDelegate.swift
//  StickerProfiling
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//  Copyright © 2016 Konta. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKMessengerShareKit
import FBAudienceNetwork

let sessionResumesPlacementId = "1594200494225037_1684892605155825"
let firstTimeMainScreenReachedPlacementId = "1594200494225037_1684883995156686"
let bottomStickerGalleryPlacementId = "1594200494225037_1688239298154489"

var s_sentWithMessengerInDailyIdeas = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, FBSDKMessengerURLHandlerDelegate, FBInterstitialAdDelegate {

    var window: UIWindow?
    let messengerUrlHandler = FBSDKMessengerURLHandler()
    var replyContext: FBSDKMessengerContext?
    var composerContext: FBSDKMessengerContext?
    var sessionResumesInterstitialAd : FBInterstitialAd!
    var firstTimeMainScreenReachedInterstitialAd : FBInterstitialAd?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        messengerUrlHandler.delegate = self
        
        let facebookLaunch = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Fabric.with([Crashlytics.self])
        
        if UserDefaults.dateInstalled() == nil {
            UserDefaults.setDateInstalled(Date())
        }
        
        // get the experiment for the user
        if GWExperiment.variationId() == nil || GWExperiment.experimentId() == nil {
            GWExperiment.fetch(withArea: "stickers", withCompletion: {
                experimentId, variationId, error in
                
                if let nonNilVariationId = variationId {
                    
                    AnalyticsManager.shared().postAction(withType: kGAReadVariation, targetType: kGATargetTypeApp, targetId:  "\(nonNilVariationId)", targetParameter: nil, actionLocation: nil)
                    
                }
                
            })
        }
        
        NotificationManager().downloadAndSaveNotificationTexts(completion: {
            error -> Void in
        })
        
        GWDataManager().downloadAllTextsWithBlock(forArea: "stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
            textIds, error -> Void in
            
            
            print("Downloaded all texts")
            
        })
        
        
        self.setupCoreDataObjectsOnFirstLaunch()
        
        // white status bar with no for view controller based status bar appearance in info plist
        if UserDefaults.isFirstLaunch() == true {
            
            self.window?.rootViewController = LoginViewController()
            
            if let countryCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String {
                AnalyticsManager.shared().postAction(withType: kGACountry, targetType: kGATargetTypeApp, targetId: countryCode, targetParameter: nil, actionLocation: nil)
            }
            
            
            AnalyticsManager.shared().postAction(withType: kGAFirstLaunch, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: nil)
            AnalyticsManager.shared().postAction(withType: kGAAppLaunch, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: nil)
        }
        else {
            
            AnalyticsManager.shared().postAction(withType: kGAAppLaunch, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: nil)
            
            
            self.window?.rootViewController = UITabBarController.createTabBarController()
            self.showGlobalAdIfAppropriate()
        }
        
        
        return facebookLaunch
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        UserDefaults.setIsNewInstall( false )
        GWCoreDataManager.sharedInstance().saveContext()
        CustomAnalytics.sharedInstance().forceSendAllEvents()
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

        
        AppFlow.currentMessengerFlow = MessengerFlow.send
        self.updateViewControllerForMessenger(self.window?.rootViewController)
        self.showGlobalAdIfAppropriate()
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
        
        if s_sentWithMessengerInDailyIdeas == true {
            
            if UserDefaults.isNotificationRegistered() == false {
                let application = UIApplication.shared
                application.registerUserNotificationSettings( UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound] , categories: nil))
            }
            
            s_sentWithMessengerInDailyIdeas = false
            
        }
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        UserDefaults.setIsNewInstall( false )
        GWCoreDataManager.sharedInstance().saveContext()
        CustomAnalytics.sharedInstance().forceSendAllEvents()
        
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if messengerUrlHandler.canOpen(url, sourceApplication: sourceApplication) == true {
            messengerUrlHandler.open(url, sourceApplication: sourceApplication)
        }
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return handled
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        return self.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options [UIApplicationOpenURLOptionsKey.annotation] as Any)
    }
    
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        if notificationSettings.types != UIUserNotificationType() {
            AnalyticsManager.shared().postAction(withType: kGAAcceptNotifications, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: nil)
        }
        else {
            AnalyticsManager.shared().postAction(withType: kGACancelNotifications, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: nil)
        }
        
    }
    
    // MARK: Ads
    
    
    func showGlobalAdIfAppropriate() {
        
        if let nonNilDate = UserDefaults.lastDateAdWasShown() {
            
            let timeInterval = nonNilDate.timeIntervalSinceNow
            
            if timeInterval < -120 {
                self.sessionResumesInterstitialAd = self.loadInterstitialAd()
            }
            
        }
        else {
            
            self.sessionResumesInterstitialAd = self.loadInterstitialAd()
            
        }
        
    }
    
    func showFirstTimeMainScreenReachedAd() {
        
        self.firstTimeMainScreenReachedInterstitialAd = self.loadfirstTimeMainScreenReachedAd()
        
    }
    
    // MARK: Ads
    
    fileprivate func loadInterstitialAd() -> FBInterstitialAd {
        
        AnalyticsManager().postAction(withType: kGAAdRequested, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: nil)
        
        return self.createAdWithPlacementId( sessionResumesPlacementId )
    }
    
    fileprivate func loadfirstTimeMainScreenReachedAd() -> FBInterstitialAd {
        
        
        return self.createAdWithPlacementId( firstTimeMainScreenReachedPlacementId )
    }

    fileprivate func createAdWithPlacementId(_ placementId: String) -> FBInterstitialAd {
        
        let interstitialAd = FBInterstitialAd(placementID: placementId)
        interstitialAd.delegate = self
        
        interstitialAd.load()
        
        
        return interstitialAd
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        
        if interstitialAd.placementID == sessionResumesPlacementId {
            UserDefaults.setLastDateAdWasShown( Date() )
            AnalyticsManager().postAction(withType: kGAAdDisplayed, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: nil)
        }
        
        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            
            interstitialAd.show(fromRootViewController: tabBarController.findActiveViewController())
        }
        else if let viewController = self.window?.rootViewController {
            
            interstitialAd.show( fromRootViewController: viewController.topMostController() )
            
        }
        
    }
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        print("add error \(error) with ad placement id \(interstitialAd.placementID)")
    }
    
    // MARK: Update View Controllers with back to messenger buttons
    
    /**
     @description Loop through all the view controllers and update their ui to add a back to messenger
     button or to remove it.
     */
    func updateViewControllerForMessenger(_ viewController: UIViewController?) {
        
        if let nonNilViewController = viewController {
            self.updateBackToMessengerButton(nonNilViewController)
            self.updateViewControllerForMessenger(nonNilViewController.presentedViewController)
        }
        
    }
    
    func updateBackToMessengerButton(_ viewController: UIViewController) {
        
        if let stickerOverview = viewController as? StickersOverviewController {
            stickerOverview.addOrRemoveBackToMessengerButton()
        }
        
        if let stickerDetail = viewController as? StickersDetailViewController {
            stickerDetail.addOrRemoveBackToMessengerButton()
        }
        
    }
    
    // MARK Messenger Delegate Optimization
    
    /** when users use the compose from the messenger app this delegate is called
     */
    func messengerURLHandler(_ messengerURLHandler: FBSDKMessengerURLHandler!, didHandleOpenFromComposerWith context: FBSDKMessengerURLHandlerOpenFromComposerContext!) {
        
        composerContext = context
        
        AppFlow.composeContext = context
        AppFlow.currentMessengerFlow = MessengerFlow.compose
        
        self.updateViewControllerForMessenger(self.window?.rootViewController)
        
    }
    
    // when users use the reply from the messenger this delegate is called
    func messengerURLHandler(_ messengerURLHandler: FBSDKMessengerURLHandler!, didHandleReplyWith context: FBSDKMessengerURLHandlerReplyContext!) {
        
        replyContext = context
        AppFlow.replyContext = context
        AppFlow.currentMessengerFlow = MessengerFlow.reply
        
        AnalyticsManager.shared().postAction(withType: kGAReplyFromMessenger, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: nil)
        
        if let userIds = context.userIDs {
            
            for currentId in userIds {
                AnalyticsManager.shared().postAction(withType: kGAReplyingToFacebookContact, targetType: kGATargetTypeApp, targetId: currentId as? String, targetParameter: nil, actionLocation: nil)
            }
            
        }
        if let metadata = context.metadata {
            
            if let data = metadata.data(using: String.Encoding.utf8) {
                
                do {
                    
                    if let dict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSDictionary {
                        
                        DispatchQueue.main.async(execute: {
                            
                            if let intentionId = dict.object(forKey: "intentionId") as? String {
                                
                                if AppFlow.shouldAnswerWithSameIntention(intentionId) == true {
                                    
                                    let stickersDetail = StickersDetailViewController(messengerMetadata: dict)
                                    self.window?.rootViewController = StickersOverviewController(vc: stickersDetail)
                                    
                                    
                                }
                                else if AppFlow.shouldAnswerWithThankYou(intentionId) == true {
                                    
                                    let mutableDict = NSMutableDictionary(dictionary: dict)
                                    mutableDict.setObject("1778B7", forKey: "intentionId" as NSCopying)
                                    mutableDict.setObject(PopularStickersLocalizedString("<ThankYouIntentionLabel>", ""), forKey: "stickerTitle" as NSCopying)
                                    
                                    let stickersDetail = StickersDetailViewController(messengerMetadata: mutableDict)
                                    self.window?.rootViewController = StickersOverviewController(vc: stickersDetail)
                                    //self.window?.rootViewController?.presentViewController(stickersDetail, animated: false, completion: nil)
                                    
                                }
                                else {
                                    
                                    self.window?.rootViewController = StickersOverviewController()
                                    
                                }
                                
                                
                            }
                            else if let _ = dict.object(forKey: "imagePath") as? String {
                                
                                let stickersDetail = StickersDetailViewController(messengerMetadata: dict)
                                self.window?.rootViewController = StickersOverviewController(vc: stickersDetail)
                                //self.window?.rootViewController?.presentViewController(stickersDetail, animated: false, completion: nil)
                                
                            }
                            else {
                                
                                let stickersOverview = StickersOverviewController()
                                self.window?.rootViewController = stickersOverview
                            }
                            
                            
                        })
                        
                    }
                    
                    
                } catch {
                    
                }
            }
        }
        
        self.updateViewControllerForMessenger(self.window?.rootViewController)
    }
    
    // MARK: Tab Bar Selection
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if tabBarController.selectedIndex == 0 {
            AnalyticsManager.shared().postAction(withType: kGASelectTab, targetType: kGATargetTypeApp, targetId: kGACategories, targetParameter: nil, actionLocation: nil)
        }
        else if tabBarController.selectedIndex == 1 {
            AnalyticsManager.shared().postAction(withType: kGASelectTab, targetType: kGATargetTypeApp, targetId: kGADailyIdeas, targetParameter: nil, actionLocation: nil)
        }
        
        tabBarButtonImageView?.tintColor = UIColor.black
        
    }
    
    // MARK: Core Data Launch
    
    func setupCoreDataObjectsOnFirstLaunch() {
        
        if UserDefaults.isCoreDataSetup() == false {
            
            UserDefaults.setIsCoreDataSetup(true)
            
            let natureImagePathsString = "/themes/nature/small/10156089_858852450798056_6807786655617414689_n.jpg,/themes/nature/small/10256897_639810416130232_6411597551677797304_n.jpg,/themes/nature/small/10360831_724912404330258_6641454566323408599_n.jpg,/themes/nature/small/10987377_662955520525947_5015081769844664549_n.jpg,/themes/nature/small/11014753_738225902955349_1481825315505557861_n.jpg,/themes/nature/small/11145134_724912407663591_5475768188966799967_n.jpg,/themes/nature/small/11222076_743315982446341_4426545188299261442_n.jpg,/themes/nature/small/11695794_10153895138201564_2593053477546873278_n.jpg,/themes/nature/small/11703162_731971940247412_883108781472375381_n.jpg,/themes/nature/small/11825896_764214243689848_3596818458732942394_n.jpg,/themes/nature/small/11873652_752156508228955_1550348514504451991_n.jpg,/themes/nature/small/11933470_662955447192621_6757899536936182170_n.jpg,/themes/nature/small/11986427_662955563859276_906453675381673354_n.jpg,/themes/nature/small/11988669_764214673689805_3511463888887270881_n.jpg,/themes/nature/small/12003179_767552543356018_7796098376900383986_n.jpg,/themes/nature/small/12063324_727952594026239_6274812461560024682_n.jpg,/themes/nature/small/134416_488589671175581_1129828197_o.jpg,/themes/nature/small/148384_336937636417513_1644915437_n.jpg,/themes/nature/small/150731_740473516063921_4003008884160515976_n.jpg,/themes/nature/small/177050_10151947140316564_1351334080_o.jpg,/themes/nature/small/205592_466709553367839_911718846_n.jpg,/themes/nature/small/207441_464807846891343_1091179721_n.jpg,/themes/nature/small/246693_487711634596718_1346930056_n.jpg,/themes/nature/small/285610_343130539131556_1265333839_n.jpg,/themes/nature/small/308084_487560691278479_577381743_n.jpg,/themes/nature/small/30999_4565675953069_884528511_n.jpg,/themes/nature/small/323017_10150555001298641_191505283640_8863497_288634533_o.jpg,/themes/nature/small/3426339366_a72fffe1b4.jpg,/themes/nature/small/389263_371237079598447_851341884_n.jpg,/themes/nature/small/3f4eb74a.jpg,/themes/nature/small/420914_489742481060300_1303290161_n.jpg,/themes/nature/small/44568.jpg,/themes/nature/small/449854.jpg,/themes/nature/small/525099_339885382745665_270215839712620_836597_821983391_n.jpg,/themes/nature/small/534441_276906645753946_349998502_n.jpg,/themes/nature/small/536222_347246478729741_1334000328_n.jpg,/themes/nature/small/53927_487718201262728_1329606100_o.jpg,/themes/nature/small/540811_369272123155486_581224156_n.jpg,/themes/nature/small/556897_513318718702676_2111213949_n.jpg,/themes/nature/small/561570_489787391055809_1992142749_n.jpg,/themes/nature/small/564096_488543411180207_983071024_n.jpg,/themes/nature/small/56932_171115472912201_6888355_o.jpg,/themes/nature/small/621345_488584727842742_1085889824_o.jpg,/themes/nature/small/74775_306806669430610_1152613767_n.jpg,/themes/nature/small/820875_549877038380177_2075057112_o.jpg,/themes/nature/small/9682_346520508802338_271896173_n.jpg,/themes/nature/small/998385_394290847348858_240754470_n.jpg,/themes/nature/small/bridges.jpg,/themes/nature/small/cherry-blossoms-in-Japan.jpg,/themes/nature/small/cherry-blossoms.jpg,/themes/nature/small/Cherry_Blossom_Flowers.jpg,/themes/nature/small/iStock_000006631415_Medium.jpg,/themes/nature/small/iStock_000008144180_Medium.jpg,/themes/nature/small/iStock_000008988892_Medium.jpg,/themes/nature/small/iStock_000012946878_Medium.jpg,/themes/nature/small/iStock_000017646835_Medium.jpg,/themes/nature/small/iStock_000020104594_Medium.jpg,/themes/nature/small/iStock_000021188949_Medium.jpg,/themes/nature/small/iStock_000024355449_Medium.jpg,/themes/nature/small/iStock_000030077764_Medium.jpg,/themes/nature/small/iStock_000043400332_Medium.jpg,/themes/nature/small/iStock_000070676665_Medium.jpg,/themes/nature/small/nordic.jpg,/themes/nature/small/pic12.jpg,/themes/nature/small/pink-cherry-blossom.jpg,/themes/nature/small/sakura_hamamatsu.jpg,/themes/nature/small/Salix-Babylonica-1.jpg,/themes/nature/small/shutterstock_101022454.jpg,/themes/nature/small/tumblr_mwxou6f78h1qz6f9yo5_1280.jpg,/themes/nature/small/tumblr_o1sawl0dvK1qz6f9yo2_1280.jpg"
            let natureXcodePathString = natureImagePathsString.replacingOccurrences(of: "/", with: ":")
            let natureImageXcodePaths = natureXcodePathString.components(separatedBy: ",")
            
            
            for natureImageName in natureImageXcodePaths {
                
                let filePath = Bundle.main.path(forResource: natureImageName.replacingOccurrences(of: ".jpg", with: ""), ofType: "jpg")
                let data = try? Data(contentsOf: URL(fileURLWithPath: filePath!))
                let imagePath = natureImageName.replacingOccurrences(of: ":", with: "/")
                
                if let imageData = data {
                    GWImage.createGWImage(withImagePath: imagePath, withImageData: imageData, withManagedContext: nil)
                }
            }
            
            let emojiImagePathsString = "/themes/emoticons/small/000005546115.jpg,/themes/emoticons/small/000006421564.jpg,/themes/emoticons/small/000006428888.jpg,/themes/emoticons/small/000006429076.jpg,/themes/emoticons/small/000006429664.jpg,/themes/emoticons/small/000012424481.jpg,/themes/emoticons/small/000014438449.jpg,/themes/emoticons/small/000014745476.jpg,/themes/emoticons/small/000014939205.jpg,/themes/emoticons/small/000014961298.jpg,/themes/emoticons/small/000015195705.jpg,/themes/emoticons/small/000015392841.jpg,/themes/emoticons/small/000015643227.jpg,/themes/emoticons/small/000015846854.jpg,/themes/emoticons/small/000016009511.jpg,/themes/emoticons/small/000016089832.jpg,/themes/emoticons/small/000017381928.jpg,/themes/emoticons/small/000018292730.jpg,/themes/emoticons/small/000018386450.jpg,/themes/emoticons/small/000019012368.jpg,/themes/emoticons/small/000019663067.jpg,/themes/emoticons/small/000020164920.jpg,/themes/emoticons/small/000020168136.jpg,/themes/emoticons/small/000021110679.jpg,/themes/emoticons/small/000021212042.jpg,/themes/emoticons/small/000021623715.jpg,/themes/emoticons/small/000021892641.jpg,/themes/emoticons/small/000021895308.jpg,/themes/emoticons/small/000021970940.jpg,/themes/emoticons/small/000021990738.jpg,/themes/emoticons/small/000022011350.jpg,/themes/emoticons/small/000022012096.jpg,/themes/emoticons/small/000022035117.jpg,/themes/emoticons/small/000022287357.jpg,/themes/emoticons/small/000022299764.jpg,/themes/emoticons/small/000022873097.jpg,/themes/emoticons/small/000023111360.jpg,/themes/emoticons/small/000023490229.jpg,/themes/emoticons/small/000023827073.jpg,/themes/emoticons/small/000023863413.jpg,/themes/emoticons/small/000024582637.jpg,/themes/emoticons/small/000025279016.jpg,/themes/emoticons/small/000025281057.jpg,/themes/emoticons/small/000025388355.jpg,/themes/emoticons/small/000025398744.jpg,/themes/emoticons/small/000025784084.jpg,/themes/emoticons/small/000026020008.jpg,/themes/emoticons/small/000026087999.jpg,/themes/emoticons/small/000026450377.jpg,/themes/emoticons/small/000034266584.jpg,/themes/emoticons/small/000034359092.jpg,/themes/emoticons/small/000035875176.jpg,/themes/emoticons/small/000036022054.jpg,/themes/emoticons/small/000036902428.jpg,/themes/emoticons/small/000040597904.jpg,/themes/emoticons/small/000041261174.jpg,/themes/emoticons/small/000041677478.jpg,/themes/emoticons/small/000044638174.jpg,/themes/emoticons/small/000045983934.jpg,/themes/emoticons/small/000046281694.jpg,/themes/emoticons/small/000048048778.jpg,/themes/emoticons/small/000051960638.jpg,/themes/emoticons/small/000052035816.jpg,/themes/emoticons/small/000053627786.jpg,/themes/emoticons/small/000054532722.jpg,/themes/emoticons/small/000055718818.jpg,/themes/emoticons/small/000057875906.jpg,/themes/emoticons/small/000058035830.jpg,/themes/emoticons/small/000058490600.jpg,/themes/emoticons/small/000061412788.jpg,/themes/emoticons/small/000061413640.jpg,/themes/emoticons/small/000061413650.jpg,/themes/emoticons/small/000061413836.jpg,/themes/emoticons/small/000061413936.jpg,/themes/emoticons/small/000061414208.jpg,/themes/emoticons/small/000061467256.jpg,/themes/emoticons/small/000061467386.jpg,/themes/emoticons/small/000061467924.jpg,/themes/emoticons/small/000066099509.jpg,/themes/emoticons/small/000066749713.jpg,/themes/emoticons/small/000067631141.jpg,/themes/emoticons/small/000067952085.jpg,/themes/emoticons/small/000068850269.jpg,/themes/emoticons/small/000073674261.jpg,/themes/emoticons/small/000073674269.jpg,/themes/emoticons/small/000073674725.jpg,/themes/emoticons/small/000073674773.jpg,/themes/emoticons/small/000075070105.jpg,/themes/emoticons/small/000075070113.jpg,/themes/emoticons/small/000077561445.jpg,/themes/emoticons/small/000078443459.jpg,/themes/emoticons/small/000081458149.jpg,/themes/emoticons/small/000082434317.jpg,/themes/emoticons/small/000083882747.jpg,/themes/emoticons/small/000084168591.jpg,/themes/emoticons/small/000085087061.jpg,/themes/emoticons/small/000086355355.jpg,/themes/emoticons/small/000089090941.jpg,/themes/emoticons/small/iStock_000065867241_Medium.jpg,/themes/emoticons/small/iStock_000065867555_Medium.jpg,/themes/emoticons/small/iStock_000065868013_Medium.jpg"
            
            let emojiXcodePathString = emojiImagePathsString.replacingOccurrences(of: "/", with: ":")
            let emojiImageXcodePaths = emojiXcodePathString.components(separatedBy: ",")
            
            for emojiImageName in emojiImageXcodePaths {
                
                let filePath = Bundle.main.path(forResource: emojiImageName.replacingOccurrences(of: ".jpg", with: ""), ofType: "jpg")
                let data = try? Data(contentsOf: URL(fileURLWithPath: filePath!))
                let imagePath = emojiImageName.replacingOccurrences(of: ":", with: "/")
                
                if let imageData = data {
                    GWImage.createGWImage(withImagePath: imagePath , withImageData: imageData, withManagedContext: nil)
                }
                
            }
            
            GWCoreDataManager.sharedInstance().saveContext()
        }
        
    }

}

