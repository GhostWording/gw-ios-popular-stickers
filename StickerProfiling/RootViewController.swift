//
//  RootViewController.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/28/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var viewControllerToShow : UIViewController?
    var nextViewControllerToPresent : UIViewController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewControllerToShow = nil
    }
    
    convenience init(vc vcToShow: UIViewController?) {
        
        self.init()
        
        viewControllerToShow = vcToShow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        if let nonNilVC = viewControllerToShow {
            
            self.present(nonNilVC, animated: animated, completion: nil)
            viewControllerToShow = nil
            
            if let vc = nonNilVC as? RootViewController, nextViewControllerToPresent != nil {
                vc.viewControllerToShow = nextViewControllerToPresent
            }
            
        }
        
    }
    
    func forceReload() {
        
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        
        if viewControllerToShow == nil {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
        else if viewControllerToShow == viewControllerToPresent {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
        else {
            // do not show a view controller if we are going to show one.
            nextViewControllerToPresent = viewControllerToPresent
        }
        
    }
    
}
