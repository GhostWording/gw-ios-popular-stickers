//
//  AdLoader.swift
//  StickerProfiling
//
//  Created by Mathieu Grettir Skulason on 1/11/17.
//  Copyright © 2017 Konta. All rights reserved.
//

import UIKit
import FBAudienceNetwork

enum InterstitialAdPosition : String {
    case StickerCategoriesBottom = "1594200494225037_1707587439553008"
    case DailyIdeasBottom = "1594200494225037_1707586212886464"
}

class AdLoader: NSObject, FBInterstitialAdDelegate {

    var interstitialAd : FBInterstitialAd?
    var completionClosure : ((Error?) -> Void)?
    
    override init() {
        
        super.init()
    }
    
    convenience init(adPosition: InterstitialAdPosition, completion: @escaping (Error?)-> Void) {
        
        self.init()
        
        interstitialAd = FBInterstitialAd.init(placementID: adPosition.rawValue)
        completionClosure = completion
        
        interstitialAd?.delegate = self
    }
    
    func createAdAtPosition(adPosition: InterstitialAdPosition, completion: @escaping (Error?) -> Void) -> FBInterstitialAd {
        
        completionClosure = completion
        interstitialAd = FBInterstitialAd.init(placementID: adPosition.rawValue)
        interstitialAd?.delegate = self
        interstitialAd?.load()

        return interstitialAd!
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        
        completionClosure?( nil )
        
    }
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        
        completionClosure?( error )
        
    }
    
}
