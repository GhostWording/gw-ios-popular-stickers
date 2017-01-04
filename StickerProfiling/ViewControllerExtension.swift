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
    
    func createImage(image: UIImage, text: String) -> UIImage {
        
        let imageView = UIImageView(image: image)
        
        let biggerSide = imageView.frame.size.width
        
        let fontSize  = biggerSide / 16.0
        let font = UIFont.c_robotoLight(withSize: Float(fontSize))
        
        let fontHeight = NSString.c_findHeight(forText: text, havingWidth: imageView.frame.size.width * 0.8, andFont: font)
        
        let label = UILabel(frame: CGRect(x: imageView.frame.width * 0.1, y: imageView.frame.maxY + 40, width: imageView.frame.width * 0.8, height: fontHeight + 6))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.textColor = UIColor.black
        
        
        let snapshotView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: label.frame.maxY + 40))
        snapshotView.backgroundColor = UIColor.white
        snapshotView.addSubview(imageView)
        snapshotView.addSubview(label)
        
        
        return snapshotView.imageByRenderingView()
        
    }

    
}
