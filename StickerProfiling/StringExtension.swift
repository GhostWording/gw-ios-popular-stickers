//
//  StringExtension.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/26/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import Foundation

extension NSString {
    
    func heightForStringWithFont(font: UIFont, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        
        let size = self.boundingRectWithSize(CGSizeMake(width, maxHeight), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:  [NSFontAttributeName : font], context: nil)
        
        return size.height
    }
    
    
}

extension String {
    
    func imageName() -> String? {
        
        let components = self.componentsSeparatedByString("/")
        
        return components.last
    }
    
}