//
//  UIViewControllerExtension.swift
//  StickerProfiling
//
//  Created by Mathieu Grettir Skulason on 1/13/17.
//  Copyright © 2017 Konta. All rights reserved.
//

import Foundation

extension UIViewController {
    
    class func findActiveViewController(_ viewController: UIViewController) -> UIViewController {
        
        if viewController is UITabBarController {
            
            return self.findActiveViewController(tabBarController: viewController as! UITabBarController)
        }
        else if viewController is UINavigationController {
            
            return self.findActiveViewController(navController: viewController as! UINavigationController)
        }
        else if viewController.presentedViewController != nil {
            
            return self.findActiveViewController( viewController.presentedViewController! )
        }
        
        return viewController
    }
    
    class func findActiveViewController(tabBarController: UITabBarController) -> UIViewController {
        
        if let currentController = tabBarController.selectedViewController {
            
            return self.findActiveViewController( currentController )
        }
        
        return tabBarController
    }
    
    class func findActiveViewController(navController: UINavigationController) -> UIViewController {
        
        if let currentController = navController.visibleViewController {
            
            return self.findActiveViewController( currentController )
            
        }
        
        return navController
    }
    
}
