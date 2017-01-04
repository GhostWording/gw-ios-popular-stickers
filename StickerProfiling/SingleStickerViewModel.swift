//
//  SingleStickerViewModel.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 08/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
///

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class ScoreObject: NSObject {
    
    var denseRank: Int = 0
    var nbShares: Int = 0
    var rank: Int = 0
    var score: Double = 0
    
    var text: GWText?
    
}

class SingleStickerViewModel: NSObject {

    var textsAndRanking: [ScoreObject]?
    var intentionId: String?
    var imagePath: String?
    
    var textFilter: GWTextFilter?
    
    override init() {
        super.init()
        textsAndRanking = [ScoreObject]()
        
    }
    
    func reloadTextsAsIntentions() {
        
        if  self.textFilter != nil {
            
            var texts = GWDataManager().fetchTexts(withIntentionIds: nil, withTagsStrings: nil, withCulture: GWLocalizedBundle.currentLocaleAPIString())
            
            texts = self.textFilter!.filterTexts(texts)
            
            let randomTexts = self.randomTexts(20, texts: texts)
            
            self.textsAndRanking = [ScoreObject]()
            
            self.addRandomTexts(randomTexts)
            
            return ;
        }
        
        if let nonNilIntentionId = intentionId {
            
            var texts = GWDataManager().fetchTexts( withIntentionIds: [nonNilIntentionId], withTagsStrings: nil, withCulture: GWLocalizedBundle.currentLocaleAPIString())
            
            
            let filter = GWTextFilter()
            filter.senderGender = UserDefaults.userGender()
            texts = filter.filterTexts(texts)
            
            
            let randomTexts = self.randomTexts(10, texts: texts)
            
            self.addRandomTexts(randomTexts)
            
        }
        else if imagePath == "themes/emoticons" {
            
            var texts = GWDataManager().fetchTexts(withIntentionIds: ["2E2986"], withTagsStrings: nil, withCulture: GWLocalizedBundle.currentLocaleAPIString())
            
            
            let textFilter = GWTextFilter()
            textFilter.senderGender = UserDefaults.userGender()
            texts = textFilter.filterTexts(texts)
            
            
            let randomTexts = self.randomTexts(10, texts: texts)
            
            self.addRandomTexts(randomTexts)
            
        }
        
    }
    
    func addRandomTexts(_ texts: [GWText]) {
        
        for text in texts {
            
            let scoreObject = ScoreObject()
            scoreObject.text = text
            
            textsAndRanking?.append(scoreObject)
        }
        
    }
    
    
    func randomTexts(_ numTexts: Int, texts: [GWText]) -> [GWText] {
        
        var textsLessThan29 = [GWText]()
        for text in texts {
            if text.sortBy?.int32Value <= 29 {
                textsLessThan29.append(text)
            }
        }
        
        var randomTexts = [GWText]()
        
        for _ in 0..<numTexts {
            
            if textsLessThan29.count > 0 {
                
                let index = Int( arc4random_uniform(UInt32(textsLessThan29.count)) )
                randomTexts.append(textsLessThan29[index])
                textsLessThan29.remove(at: index)
                
            }
            else {
                break;
            }
            
        }
        
        return randomTexts
    }
    
    
    func downloadPopularTexts(_ imageName: String?, completion: @escaping (_ error: Error?) -> Void) {
        
        if imagePath != "themes/emoticons" {
            let lastImagePathName = self.getImageName(imageName)
            ServerCommunication.downloadMatchingTextsForImage(withAreaName: "stickers", imageName: lastImagePathName, culture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                matchingTextsDict, error -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    if error == nil {

                        if let textDict = matchingTextsDict {
                            let castTextDict = textDict["Texts"] as? [NSDictionary]
                            self.textsAndRanking?.insert(contentsOf: self.createScoredTexts(castTextDict!), at: 0)
                        }
                        
                        
                    }
                    
                    completion(error as Error?)
                })
                
            })
        }
    }
    
    func numberOfTexts() -> Int {
        
        if let numTexts = self.textsAndRanking?.count {
            return numTexts
        }
        
        return 0
    }
    
    func textContent(_ atIndex: Int) -> String? {
        
        if let textContent = self.textsAndRanking?[atIndex].text?.content {
            return textContent
        }
        
        return nil
    }
    
    func textId(_ atIndex: Int) -> String? {
        
        if let textId = self.textsAndRanking?[atIndex].text?.textId {
            return textId
        }
        
        return nil
    }
    
    func textPrototypeId(_ atIndex: Int) -> String? {
        
        if let textPrototypeId = self.textsAndRanking?[atIndex].text?.prototypeId {
            return textPrototypeId
        }
        
        return nil
    }
    
    func textHeight(_ atIndex: Int, width: CGFloat, font: UIFont) -> CGFloat {
        
        if let text = self.textContent(atIndex) {
            return NSString.c_findHeight(forText: text, havingWidth:width, andFont: font)
        }
        
        return 0
        
    }
    
    func textNumberOfShares(_ atIndex: Int) -> String? {
        
        if let scoreObject = self.textsAndRanking?[atIndex] {
            
            if scoreObject.nbShares == 0 {
                return ""
            }
            
            return "\(scoreObject.nbShares)"
        }
        
        return nil
        
    }
    
    
    func textIsDisplayedAndShared(_ atIndex: Int) -> Bool {
        
        if let scoreObject = self.textsAndRanking?[atIndex] {
            if scoreObject.nbShares == 0 {
                return false
            }
            else {
                return true
            }
        }
        
        return false
        
    }
    
    fileprivate func createScoredTexts(_ texts: [NSDictionary]) -> [ScoreObject] {
        
        var scoredTexts = [ScoreObject]()
        
        let hasMoreThanTwoDisplays = self.containsTextWithMoreThanTwoDisplays(texts)
        
        for scoredTextDict: NSDictionary in texts {
            
            let scoreDict = scoredTextDict.object(forKey: "Scoring") as! NSDictionary
            let textDict = scoredTextDict.object(forKey: "Text") as! NSDictionary
            
            if intentionId != nil && (scoreDict.object(forKey: "NbShares") as! Int) > 1 && self.scoredTextContainsTag(intentionId, tagIds: textDict.object(forKey: "TagIds") as? [String]) == true{
                
                self.populateScoredTexts(&scoredTexts, scoredTextDict: scoredTextDict)
                
            }
            else if hasMoreThanTwoDisplays == true && (scoreDict.object(forKey: "NbShares") as! Int) > 1 && self.scoredTextContainsTag(intentionId, tagIds: textDict.object(forKey: "TagIds") as? [String]) == true {
                
                self.populateScoredTexts(&scoredTexts, scoredTextDict: scoredTextDict)
                
            }
            else if hasMoreThanTwoDisplays == false {
                
                self.populateScoredTexts(&scoredTexts, scoredTextDict: scoredTextDict)
            }
            
        }
        
        return scoredTexts
    }
    
    func populateScoredTexts(_ scoredTexts: inout [ScoreObject], scoredTextDict: NSDictionary) {
        
        let scoreDict = scoredTextDict.object(forKey: "Scoring") as? NSDictionary
        let textDict = scoredTextDict.object(forKey: "Text") as? NSDictionary
        
        let scoreText = ScoreObject()
        scoreText.denseRank = scoreDict?.object(forKey: "DenseRank") as! Int
        scoreText.nbShares = scoreDict?.object(forKey: "NbShares") as! Int
        scoreText.rank = scoreDict?.object(forKey: "Rank") as! Int
        scoreText.score = scoreDict?.object(forKey: "Score") as! Double
        scoredTexts.append(scoreText)
        
        if let text = GWDataManager().fetchText(withTextId: textDict?.object(forKey: "TextId") as? String, withCulture: GWLocalizedBundle.currentLocaleAPIString()) {
            scoreText.text = text
        }
        else {
            scoreText.text = GWText.createGWText(withDict: textDict as! [AnyHashable: Any], with: nil)
        }
        
    }
    
    fileprivate func containsTextWithMoreThanTwoDisplays(_ scoredTextDictionaries: [NSDictionary] ) -> Bool {
        
        for scoredTextDict: NSDictionary in scoredTextDictionaries {
            let scoreDict = scoredTextDict.object(forKey: "Scoring") as! NSDictionary
            if (scoreDict.object(forKey: "NbShares") as! Int) > 1 {
                return true
            }
        }
        
        return false
    }
    
    fileprivate func getImageName(_ imageName: String?) -> String? {
    
        let components = imageName?.components(separatedBy: "/")
        
        return components?.last
    }
    
    func scoredTextContainsTag(_ tag: String?, tagIds: [String]?) -> Bool {
        
        if let nonNilTagIds = tagIds {
            for currentTag in nonNilTagIds {
                if tag == currentTag {
                    return true
                }
            }
        }
        
        return false
    }
}
