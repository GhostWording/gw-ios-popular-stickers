//
//  DailyIdeasViewModel.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/19/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import Foundation

class DailyIdeaContainer : NSObject {
    
    let dailyIdea : GWDailyIdea
    var image : UIImage?
    var isDownloading : Bool = false
    
    init(dailyIdea: GWDailyIdea) {
        self.dailyIdea = dailyIdea
        super.init()
    }
    
}

class DailyIdeasViewModel: NSObject {
    
    var dailyIdeas : [GWDailyIdea]?
    var dailyIdeasContainer : [DailyIdeaContainer]?

    func fetchDailyIdeasWithCompletion(fetchFromCache cache: Bool, forceReload: Bool, completion: @escaping (Bool, Error?) -> Void) {
        
        let timeSinceLastDailyIdea = GWDailyIdea.timeSinceLast().timeIntervalSinceNow
        if GWDailyIdea.cachedDailyIdeas().count != 0 && (timeSinceLastDailyIdea > -60 * 60) == true  && cache == true && UserDefaults.developerModeEnabled() == false {
            
            var ideas = [DailyIdeaContainer]()
            let nonNilDailyIdeas = GWDailyIdea.cachedDailyIdeas()
            
            for currentIdea in nonNilDailyIdeas {
                let ideaContainer = DailyIdeaContainer(dailyIdea: currentIdea)
                ideas.append( ideaContainer )
            }
            
            self.dailyIdeasContainer = ideas
            completion(false, nil )
            
        }
        else {
            
            GWDailyIdea.fetchDailyIdeas(withCulture: GWLocalizedBundle.currentLocaleAPIString(), newCards: forceReload, withCompletion: {
                dailyIdeas, error in
                
                if let nonNilDailyIdeas = dailyIdeas {
                    
                    GWDailyIdea.setDailyIdeas( nonNilDailyIdeas )
                    GWDailyIdea.setTimeSinceLast( Date() )
                    
                    var ideas = [DailyIdeaContainer]()
                    
                    for currentIdea in nonNilDailyIdeas {
                        let ideaContainer = DailyIdeaContainer(dailyIdea: currentIdea)
                        ideas.append( ideaContainer )
                    }
                    
                    self.dailyIdeasContainer = ideas
                    
                }
                
                completion(true, error )
                
            })
            
        }
        
    }
    
    
    func numDailyIdeas() -> Int {
        
        if let nonNilDailyIeas = dailyIdeasContainer {
            return nonNilDailyIeas.count
        }
        
        return 0
        
    }
    
    func dailyIdeaContainerAtIndexPath(_ indexPath: IndexPath) -> DailyIdeaContainer? {
        
        if let nonNilDailyIdeas = dailyIdeasContainer {
            
            if indexPath.item < nonNilDailyIdeas.count {
                
                return nonNilDailyIdeas[indexPath.item]
            }
            
        }
        
        return nil
    }
    
    func imageAtIndexPath(_ indexPath: IndexPath) -> UIImage? {
        
        let ideaContainer = self.dailyIdeaContainerAtIndexPath( indexPath )
        
        return ideaContainer?.image
    }
    
    func textAtIndexPath(_ indexPath: IndexPath) -> String? {
        
        let ideaContainer = self.dailyIdeaContainerAtIndexPath( indexPath )
        
        return ideaContainer?.dailyIdea.content
    }
    
    func textIdAtIndexPath(_ indexPath: IndexPath) -> String? {
        
        let ideaContainer = self.dailyIdeaContainerAtIndexPath( indexPath )
        
        return ideaContainer?.dailyIdea.textId
        
    }
    
    func getImageName(_ indexPath: IndexPath) -> String? {
        
        let ideaContainer = self.dailyIdeaContainerAtIndexPath( indexPath )
        
        if let nonNilIdeaContainer = ideaContainer {
            
            let imageName = nonNilIdeaContainer.dailyIdea.imageName
            
            return imageName.imageName()
            
        }
        
        return nil
    }
    
    func getIntentionIdAtIndexPath(_ indexPath: IndexPath) -> String? {
        
        let ideaContainer = self.dailyIdeaContainerAtIndexPath( indexPath )
        
        if let nonNilIdeaContainer = ideaContainer {
            
            let intentionId = nonNilIdeaContainer.dailyIdea.intentionId
            
            return intentionId
            
        }
        
        return nil
    }
    
    func getImagePathAtIndexPath(_ indexPath: IndexPath) -> String? {
    
        let ideaContainer = self.dailyIdeaContainerAtIndexPath( indexPath )
        
        if let nonNilIdeaContainer = ideaContainer {
            
            let imagePath = nonNilIdeaContainer.dailyIdea.imageLink
            
            return imagePath
            
        }
        
        return nil
    }
    
    func downloadOrFetchImageAtIndexPath(_ indexPath: IndexPath, completion:@escaping (UIImage?, Error?) -> Void) {
        
        if let ideaContainer = self.dailyIdeaContainerAtIndexPath( indexPath ) {
            
            if ideaContainer.isDownloading == false {
                ideaContainer.isDownloading = true
                GWImageManager.downloadImageIfNotExists( withPath: ideaContainer.dailyIdea.imageLink, imageDataCompletion: {
                    imageName, data, error in
                    
                    if error == nil && data != nil {
                        ideaContainer.image = UIImage(data: data!)
                        completion( ideaContainer.image, nil)
                    }
                    else {
                        completion( nil, error )
                    }
                    
                })
            }
        }
        else {
            completion( nil, nil)
        }
        
    }
    
}
