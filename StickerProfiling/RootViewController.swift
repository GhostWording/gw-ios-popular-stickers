//
//  RootViewController.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/28/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

var tabBarCenterButton : MAXFadeBlockButton?
var tabBarButtonImageView : UIImageView?

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animateAlertDailyIdeas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        
        if self.tabBarController == nil {
            self.createCenterTabBarButton().isHidden = true
        }
        else {
            self.createCenterTabBarButton().isHidden = false
        }
        
        
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
    
    func createCenterTabBarButton() -> MAXFadeBlockButton {
        
        if(tabBarCenterButton == nil) {
            tabBarCenterButton = MAXFadeBlockButton(frame: CGRect(x: self.view.frame.size.width / 2.0 - 25, y: self.view.frame.size.height - 70, width: 50, height: 50))
            
            //centerTabBarButton = MAXFadeBlockButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            
            var image = UIImage(named: "LightBulbIcon")!.imageScaledToSize( CGSize(width: 36, height: 36) )
            image = image.withRenderingMode( UIImageRenderingMode.alwaysTemplate )
            
            tabBarButtonImageView = UIImageView(frame: CGRect(x: tabBarCenterButton!.frame.size.width / 2.0 - 18, y: tabBarCenterButton!.frame.size.height / 2.0 - 18, width: 36, height: 36) )
            tabBarButtonImageView!.contentMode = .scaleAspectFit
            tabBarButtonImageView?.image = image
            tabBarButtonImageView?.tintColor = UIColor.black
            
            tabBarCenterButton?.addSubview( tabBarButtonImageView! )
            
            //tabBarCenterButton!.setImage( image!.imageScaledToSize( CGSize(width: 32, height: 32)), for: UIControlState.normal)
            tabBarCenterButton?.layer.backgroundColor = UIColor.c_tabBarGray().cgColor
            tabBarCenterButton?.layer.cornerRadius = tabBarCenterButton!.frame.size.width / 2.0
            tabBarCenterButton?.fadeAnimationTime = 0
            tabBarCenterButton?.fadeAlphaValue = 1.0
            
            tabBarCenterButton?.buttonTouchUpInside { [weak self] in
                
                if self?.tabBarController?.selectedIndex != 1 {
                    
                    UserDefaults.setHasViewedDailyIdeas( true )
                    self?.stopAnimationAlertDailyIdeas()
                    
                    if let items = self?.tabBarController?.tabBar.items as? [RAMAnimatedTabBarItem] {
                        
                        let deselectItem = items[self!.tabBarController!.selectedIndex]
                        deselectItem.deselectAnimation()
                        
                        let selectedItem = items[1]
                        selectedItem.playAnimation()
                        self?.playBounceAnimation()
                        
                        self?.tabBarController?.selectedIndex = 1
                        
                    }
                    else {
                        self?.tabBarController?.selectedIndex = 1
                    }
                    
                }
                
            }
            
            //let keyWindow = UIApplication.shared.keyWindow
            //keyWindow?.addSubview( tabBarCenterButton! )
            self.tabBarController?.view.addSubview( tabBarCenterButton! )
        }
        
        return tabBarCenterButton!
    }
    
    func playBounceAnimation() {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval( 0.5 )
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        tabBarButtonImageView!.layer.add(bounceAnimation, forKey: nil)
        tabBarButtonImageView!.tintColor = self.tabBarController?.tabBar.tintColor
        
        
    }
    
    func animateAlertDailyIdeas(){
        
        weak var wSelf = self
        
        if UserDefaults.hasViewedDailyIdeas() == false {
            
            UIView.animate(withDuration: 0.6, delay: 0, options: [UIViewAnimationOptions.repeat, UIViewAnimationOptions.autoreverse], animations: {
                
                tabBarButtonImageView?.tintColor = UIColor.red
                
            }, completion: { completed in
                
                if UserDefaults.hasViewedDailyIdeas() == true {
                    
                    tabBarButtonImageView?.tintColor = UIColor.c_blue()
                    
                }
                else {
                    UIView.animate(withDuration: 0.6, animations: {
                        tabBarButtonImageView?.tintColor = UIColor.black
                    }, completion: {
                        succeeded in
                        
                        
                        if UserDefaults.hasViewedDailyIdeas() == false {
                            tabBarButtonImageView?.tintColor = UIColor.black

                            wSelf?.animateAlertDailyIdeas()
                        }
                        else {
                            tabBarButtonImageView?.tintColor = UIColor.c_blue()
                        }
                    })
                }
                
            })
            
        }
        
    }
    
    func stopAnimationAlertDailyIdeas() {
        
        UIView.animate(withDuration: 0.6, animations: {
            tabBarButtonImageView?.tintColor = UIColor.c_blue()

        })
        
    }
    
}
