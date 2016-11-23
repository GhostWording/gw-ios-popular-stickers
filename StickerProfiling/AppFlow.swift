//
//  AppFlow.swift
//  StickerBliss
//
//  Created by Mathieu Skulason on 21/06/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
import FBSDKMessengerShareKit

enum MessengerFlow {
    case Reply
    case Compose
    case Send
}

class AppFlow: NSObject {

    static var currentMessengerFlow = MessengerFlow.Send
    
    static var replyContext: FBSDKMessengerContext?
    static var composeContext: FBSDKMessengerContext?
    
    static func currentContext() -> FBSDKMessengerContext {
        
        if  let context = replyContext where self.currentMessengerFlow == MessengerFlow.Reply {
            return context
        }
        
        if let context = composeContext where self.currentMessengerFlow == MessengerFlow.Compose {
            return context
        }
        
        return FBSDKMessengerBroadcastContext()
    }
    
    /**
     @description If the intention id is one of the following we should set the intention id to the same as was
     sent to answer the message: I like you (64B504), I love you (5CDCF2), Miss you (8ED62C), Good morning (030FD0), Good night (D392C1), Happy new year (938493), I would like to see you again (BD7387), I think of you (016E91), I miss you (8ED62C), I want you (F4566D), Joke (0B1EA1), Facebook status (2E2986), Polite/Humorous insults (0ECC82)
     
     
     */
    static func shouldAnswerWithSameIntention(intentionId: String) -> Bool {
        
        if intentionId == "64B504" || intentionId == "5CDCF2" || intentionId == "8ED62C" || intentionId == "030FD0" || intentionId == "D392C1" || intentionId == "938493" || intentionId == "BD7387" || intentionId == "016E91" || intentionId == "8ED62C" || intentionId == "F4566D" || intentionId == "0B1EA1" || intentionId == "2E2986" || intentionId == "0ECC82" {
            return true
        }
        
        return false
    }
    
    /**
     @description If the intention id is one of the following we should set the intention
     to thank you to answer the message: Happy birthday (A730B4), Have a nice trip (EEDAC3), I'm here for you (03B6E4),
     Come over for dinner (D19840), Celebrate the occasion (EB020F), Retirement congratulation (577D28), congratulations on the birth of your baby (63BF3A), Wedding congratulations (764A35), Condolences (B47AE0)
     */
    static func shouldAnswerWithThankYou(intentionId: String?) -> Bool {
        
        
        if intentionId == "A730B4" || intentionId == "EEDAC3" || intentionId == "03B6E4" || intentionId == "D19840" || intentionId == "EB020F" || intentionId == "577D28" || intentionId == "63BF3A" || intentionId == "764A35" || intentionId == "B47AE0" {
            
            return true
        }
        
        return false
        
    }
    
}
