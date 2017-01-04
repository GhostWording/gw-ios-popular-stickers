//
//  StringExtension.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/26/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import Foundation

extension NSString {
    
    func heightForStringWithFont(_ font: UIFont, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        
        let size = self.boundingRect(with: CGSize(width: width, height: maxHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:  [NSFontAttributeName : font], context: nil)
        
        return size.height
    }
    
    
}

extension String {
    
    func imageName() -> String? {
        
        let components = self.components(separatedBy: "/")
        
        return components.last
    }
    
}
