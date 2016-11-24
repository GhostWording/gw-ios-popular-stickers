//
//  SingleStickerViewModel.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 08/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
///

import UIKit

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
            
            var texts = GWDataManager().fetchTextsWithIntentionIds(nil, withTagsStrings: nil, withCulture: GWLocalizedBundle.currentLocaleAPIString())
            
            texts = self.textFilter!.filterTexts(texts)
            
            let randomTexts = self.randomTexts(20, texts: texts)
            
            self.textsAndRanking = [ScoreObject]()
            
            self.addRandomTexts(randomTexts)
            
            return ;
        }
        
        if let nonNilIntentionId = intentionId {
            
            var texts = GWDataManager().fetchTextsWithIntentionIds( [nonNilIntentionId], withTagsStrings: nil, withCulture: GWLocalizedBundle.currentLocaleAPIString())
            
            
            let filter = GWTextFilter()
            filter.senderGender = UserDefaults.userGender()
            texts = filter.filterTexts(texts)
            
            
            let randomTexts = self.randomTexts(10, texts: texts)
            
            self.addRandomTexts(randomTexts)
            
        }
        else if imagePath == "themes/emoticons" {
            
            var texts = GWDataManager().fetchTextsWithIntentionIds(["2E2986"], withTagsStrings: nil, withCulture: GWLocalizedBundle.currentLocaleAPIString())
            
            
            let textFilter = GWTextFilter()
            textFilter.senderGender = UserDefaults.userGender()
            texts = textFilter.filterTexts(texts)
            
            
            let randomTexts = self.randomTexts(10, texts: texts)
            
            self.addRandomTexts(randomTexts)
            
        }
        
    }
    
    func addRandomTexts(texts: [GWText]) {
        
        for text in texts {
            
            let scoreObject = ScoreObject()
            scoreObject.text = text
            
            textsAndRanking?.append(scoreObject)
        }
        
    }
    
    
    func randomTexts(numTexts: Int, texts: [GWText]) -> [GWText] {
        
        var textsLessThan29 = [GWText]()
        for text in texts {
            if text.sortBy?.intValue <= 29 {
                textsLessThan29.append(text)
            }
        }
        
        var randomTexts = [GWText]()
        
        for _ in 0..<numTexts {
            
            if textsLessThan29.count > 0 {
                
                let index = Int( arc4random_uniform(UInt32(textsLessThan29.count)) )
                randomTexts.append(textsLessThan29[index])
                textsLessThan29.removeAtIndex(index)
                
            }
            else {
                break;
            }
            
        }
        
        return randomTexts
    }
    
    
    func downloadPopularTexts(imageName: String?, completion: (error: NSError?) -> Void) {
        
        if imagePath != "themes/emoticons" {
            let lastImagePathName = self.getImageName(imageName)
            ServerCommunication.downloadMatchingTextsForImageWithAreaName("stickers", imageName: lastImagePathName, culture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                matchingTextsDict, error -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if error == nil {

                        if let textDict = matchingTextsDict {
                            let castTextDict = textDict["Texts"] as? [NSDictionary]
                            self.textsAndRanking?.insertContentsOf(self.createScoredTexts(castTextDict!), at: 0)
                        }
                        
                        
                    }
                    
                    completion(error: error)
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
    
    func textContent(atIndex: Int) -> String? {
        
        if let textContent = self.textsAndRanking?[atIndex].text?.content {
            return textContent
        }
        
        return nil
    }
    
    func textId(atIndex: Int) -> String? {
        
        if let textId = self.textsAndRanking?[atIndex].text?.textId {
            return textId
        }
        
        return nil
    }
    
    func textPrototypeId(atIndex: Int) -> String? {
        
        if let textPrototypeId = self.textsAndRanking?[atIndex].text?.prototypeId {
            return textPrototypeId
        }
        
        return nil
    }
    
    func textHeight(atIndex: Int, width: CGFloat, font: UIFont) -> CGFloat {
        
        if let text = self.textContent(atIndex) {
            return NSString.c_findHeightForText(text, havingWidth:width, andFont: font)
        }
        
        return 0
        
    }
    
    func textNumberOfShares(atIndex: Int) -> String? {
        
        if let scoreObject = self.textsAndRanking?[atIndex] {
            
            if scoreObject.nbShares == 0 {
                return ""
            }
            
            return "\(scoreObject.nbShares)"
        }
        
        return nil
        
    }
    
    
    func textIsDisplayedAndShared(atIndex: Int) -> Bool {
        
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
    
    private func createScoredTexts(texts: [NSDictionary]) -> [ScoreObject] {
        
        var scoredTexts = [ScoreObject]()
        
        let hasMoreThanTwoDisplays = self.containsTextWithMoreThanTwoDisplays(texts)
        
        for scoredTextDict: NSDictionary in texts {
            
            let scoreDict = scoredTextDict.objectForKey("Scoring") as! NSDictionary
            let textDict = scoredTextDict.objectForKey("Text") as! NSDictionary
            
            if intentionId != nil && (scoreDict.objectForKey("NbShares") as! Int) > 1 && self.scoredTextContainsTag(intentionId, tagIds: textDict.objectForKey("TagIds") as? [String]) == true{
                
                self.populateScoredTexts(&scoredTexts, scoredTextDict: scoredTextDict)
                
            }
            else if hasMoreThanTwoDisplays == true && (scoreDict.objectForKey("NbShares") as! Int) > 1 && self.scoredTextContainsTag(intentionId, tagIds: textDict.objectForKey("TagIds") as? [String]) == true {
                
                self.populateScoredTexts(&scoredTexts, scoredTextDict: scoredTextDict)
                
            }
            else if hasMoreThanTwoDisplays == false {
                
                self.populateScoredTexts(&scoredTexts, scoredTextDict: scoredTextDict)
            }
            
        }
        
        return scoredTexts
    }
    
    func populateScoredTexts(inout scoredTexts: [ScoreObject], scoredTextDict: NSDictionary) {
        
        let scoreDict = scoredTextDict.objectForKey("Scoring") as? NSDictionary
        let textDict = scoredTextDict.objectForKey("Text") as? NSDictionary
        
        let scoreText = ScoreObject()
        scoreText.denseRank = scoreDict?.objectForKey("DenseRank") as! Int
        scoreText.nbShares = scoreDict?.objectForKey("NbShares") as! Int
        scoreText.rank = scoreDict?.objectForKey("Rank") as! Int
        scoreText.score = scoreDict?.objectForKey("Score") as! Double
        scoredTexts.append(scoreText)
        
        if let text = GWDataManager().fetchTextWithTextId(textDict?.objectForKey("TextId") as? String, withCulture: GWLocalizedBundle.currentLocaleAPIString()) {
            scoreText.text = text
        }
        else {
            scoreText.text = GWText.createGWTextWithDict(textDict as! [NSObject : AnyObject], withContext: nil)
        }
        
    }
    
    private func containsTextWithMoreThanTwoDisplays(scoredTextDictionaries: [NSDictionary] ) -> Bool {
        
        for scoredTextDict: NSDictionary in scoredTextDictionaries {
            let scoreDict = scoredTextDict.objectForKey("Scoring") as! NSDictionary
            if (scoreDict.objectForKey("NbShares") as! Int) > 1 {
                return true
            }
        }
        
        return false
    }
    
    private func getImageName(imageName: String?) -> String? {
    
        let components = imageName?.componentsSeparatedByString("/")
        
        return components?.last
    }
    
    func scoredTextContainsTag(tag: String?, tagIds: [String]?) -> Bool {
        
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
