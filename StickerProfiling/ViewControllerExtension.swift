//
//  ViewControllerExtension.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 10/23/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func topMostController() -> UIViewController {
        
        var topMostVC = UIApplication.shared.keyWindow!.rootViewController
        
        while topMostVC!.presentedViewController != nil {
            topMostVC = topMostVC!.presentedViewController
        }
        
        return topMostVC!
    }
    
}
