//
//  TabBarControllerExtensions.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/26/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import Foundation

extension UITabBarController {
    
    class func createTabBarController() -> UITabBarController {
        
        let stickersOverview = StickersOverviewController()
        stickersOverview.tabBarItem = UITabBarItem(title: PopularStickersLocalizedString("<CategoryTabBarString>", nil), image: UIImage(named: "GridIcon")?.imageScaledToSize(CGSize(width: 30, height: 30)), tag: 1)
        
        
        let dailyIdeas = LMDailyIdeasViewController()
        dailyIdeas.tabBarItem = UITabBarItem(title: PopularStickersLocalizedString("<DailyIdeaTabBarString>", nil), image: UIImage(named: "LightBulbIcon")?.imageScaledToSize(CGSize(width: 30, height: 30)), tag: 2)
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers( [stickersOverview, dailyIdeas], animated: true)
        tabBarController.tabBar.tintColor = UIColor.c_blue()
        
        tabBarController.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        
        
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
