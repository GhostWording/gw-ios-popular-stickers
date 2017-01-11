//
//  TabBarControllerExtensions.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/26/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import Foundation
import RAMAnimatedTabBarController

extension UITabBarController {
    
    class func createTabBarController() -> RAMAnimatedTabBarController {
        
        
        let stickersOverview = StickersOverviewController()
        let stickersOverviewTabBarItem = RAMAnimatedTabBarItem(title: PopularStickersLocalizedString("<CategoryTabBarString>", nil), image: UIImage(named: "GridIcon")?.imageScaledToSize(CGSize(width: 28, height: 28)), tag: 1)
        stickersOverviewTabBarItem.animation = RAMBounceAnimation()
        stickersOverview.tabBarItem = stickersOverviewTabBarItem
        
        let navOne = UINavigationController(rootViewController: stickersOverview)
        navOne.navigationBar.isHidden = true

        navOne.tabBarItem = stickersOverviewTabBarItem
        
        let dailyIdeas = LMDailyIdeasViewController()
        let dailyIdeasTabBarItem = RAMAnimatedTabBarItem(title: PopularStickersLocalizedString("<DailyIdeaTabBarString>", nil), image: UIImage(named: "LightBulbIcon")?.imageScaledToSize(CGSize(width: 1, height: 1)), tag: 2)
        dailyIdeasTabBarItem.animation = RAMBounceAnimation()
        dailyIdeas.tabBarItem = dailyIdeasTabBarItem
        
        let settingsVC = SettingsViewController()
        let settingsTabBarItem = RAMAnimatedTabBarItem(title: PopularStickersLocalizedString("<SettingsTitle>", nil), image: UIImage(named: "SettingsIcon2")?.imageScaledToSize( CGSize(width: 28, height: 28) ), tag: 3)
        settingsTabBarItem.animation = RAMBounceAnimation()
        settingsVC.tabBarItem = settingsTabBarItem
        
        let tabBarController = RAMAnimatedTabBarController(viewControllers: [navOne, dailyIdeas, settingsVC] )
        tabBarController.tabBar.tintColor = UIColor.c_blue()
        tabBarController.tabBar.barTintColor = UIColor.c_tabBarGray()
        tabBarController.tabBar.isTranslucent = false
        
        let application = UIApplication.shared.delegate as! AppDelegate
        tabBarController.delegate = application
        
        
        return tabBarController
    }
    
    /*
    class func createTabBarWithLink(intentionId: String?, imageName: String?, imageTheme: String?, recipient: String?, prototypeId: String?, imagePath: String?, name: String?, textId: String?, shouldLoadIntentionTexts: Bool) -> UITabBarController {
        
        let stickersOverview = StickersOverviewController(vc: nil)
        stickersOverview.tabBarItem = UITabBarItem(title: PopularStickersLocalizedString("<CategoryTabBarString>", nil), image: UIImage(named: "GridIcon")?.imageScaledToSize(CGSize(width: 30, height: 30)), tag: 1)
        
        
        let stickerDetailView = SingleStickerDetailViewController(viewControllerMode: StickersDetailViewModel.PrefixedText)
        stickerDetailView.imageName = imageName
        stickerDetailView.selectedStickerTitle = name
        stickerDetailView.viewModel.imagePath = imageName
        stickerDetailView.viewModel.intentionId = intentionId
        stickerDetailView.downloadImage()
        
        if let nonNilTextId = textId {
            stickerDetailView.downloadText(withId: nonNilTextId)
        }
        
        if shouldLoadIntentionTexts == true && intentionId != nil {
            stickerDetailView.downloadTextsForIntentionId()
        }
        
        stickersOverview.viewControllerToShow = stickerDetailView
        
        let dailyIdeas = LMDailyIdeasViewController()
        dailyIdeas.tabBarItem = UITabBarItem(title: PopularStickersLocalizedString("<DailyIdeaTabBarString>", nil), image: UIImage(named: "LightBulbIcon")?.imageScaledToSize(CGSize(width: 30, height: 30)), tag: 2)
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers( [stickersOverview, dailyIdeas], animated: true)
        tabBarController.tabBar.tintColor = UIColor.c_blue()
        tabBarController.selectedIndex = 0
        
        tabBarController.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        
        
        return tabBarController
        
    }
 */
 
    func forceReloadTabBarController() {
        
        if let nonNilViewControllers = self.viewControllers {
            
            for controller in nonNilViewControllers {
                
                self.loopThroughControllers( controller )
                
            }
        }
        
    }
    
    func loopThroughControllers(_ viewController: UIViewController) {
        
        if viewController is RootViewController {
            (viewController as! RootViewController).forceReload()
        }
        
        if let presentVC = viewController.presentedViewController  {
            self.loopThroughControllers( presentVC )
        }
        
    }
    
    func findActiveViewController() -> UIViewController? {
        
        if let nonNilViewControllers = self.viewControllers {
            
            let currentViewController = nonNilViewControllers[self.selectedIndex]
            
            return currentViewController.topMostController()
        }
        
        return nil
    }
    
}
