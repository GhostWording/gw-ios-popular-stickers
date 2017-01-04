//
//  UIViewExtension.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/26/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import Foundation

extension UIImage {
    
    func imageScaledToSize(_ size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
