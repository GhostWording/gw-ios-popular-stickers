//
//  SwiftConstants.swift
//  StickerProfiling
//
//  Created by Mathieu Grettir Skulason on 1/13/17.
//  Copyright © 2017 Konta. All rights reserved.
//

import Foundation

struct AppConfig {
    
    static var appAdvertDelay : TimeInterval {
        
        get {
            
            if UserDefaults.developerModeEnabled() == true {
                
                return -10
            }
            
            return -180
        }
    }
    
}
