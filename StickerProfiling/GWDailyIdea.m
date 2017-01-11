//
//  GWDailyIdea.m
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/21/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "GWDailyIdea.h"
#import "MNFJsonAdapter.h"

@interface GWDailyIdea () <MNFJsonAdapterDelegate>

@end

@implementation GWDailyIdea

+(void)fetchDailyIdeasWithCulture:(NSString *)culture newCards:(BOOL)newCards withCompletion:(void (^)(NSArray<GWDailyIdea *> *, NSError *))completion {
    [completion copy];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.cvd.io/popular/stickers/IdeasOfTheDay/ByIntention"];
    
    if (newCards == true) {
        urlString = [urlString stringByAppendingString:@"?new=true"];
    }
    
    NSURL *url = [NSURL URLWithString: urlString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL: url];
    
    [urlRequest setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [urlRequest setValue: culture forHTTPHeaderField: @"Accept-Language"];
    [urlRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    urlRequest.timeoutInterval = 30;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest: urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error == nil && data != nil) {
                
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
                NSArray <GWDailyIdea *> *ideas = [MNFJsonAdapter objectsOfClass: [GWDailyIdea class] jsonArray: jsonArray option: kMNFAdapterOptionFirstLetterUppercase error: nil];
                
                completion( ideas, nil);
                
            }
            else {
                completion( nil, error );
            }
            
        });
        
    }];
    
    [task resume];
}

+(void)setDailyIdeas:(NSArray<GWDailyIdea *> *)dailyIdeas {
    
    if (dailyIdeas != nil) {
        
         NSData *dailyIdeasData = [NSKeyedArchiver archivedDataWithRootObject: dailyIdeas];
        [[NSUserDefaults standardUserDefaults] setObject: dailyIdeasData forKey: @"GWCachedDailyIdeas"];
        
    }
    
}

+(NSArray <GWDailyIdea *> *)cachedDailyIdeas {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey: @"GWCachedDailyIdeas"] == nil) {
        [GWDailyIdea setDailyIdeas: @[]];
    }
    
    NSData *ideaData = [[NSUserDefaults standardUserDefaults] objectForKey: @"GWCachedDailyIdeas"];
    
    if (ideaData != nil) {
        
        NSArray <GWDailyIdea *> *ideas = [NSKeyedUnarchiver unarchiveObjectWithData: ideaData];
        
        return ideas;
    }
    
    return @[];
}

+(void)setTimeSinceLastDailyIdea:(NSDate *)lastDailyIdea {
    
    if (lastDailyIdea != nil) {
        [[NSUserDefaults standardUserDefaults] setObject: lastDailyIdea forKey: @"GWLastDailyIdea"];
    }
    
    
}

+(NSDate *)timeSinceLastDailyIdea {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey: @"GWLastDailyIdea"] == nil) {
        
        return [NSDate date];
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"GWLastDailyIdea"];
}

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        self.intentionId = [aDecoder decodeObjectForKey: @"intentionId"];
        self.intentionSlug = [aDecoder decodeObjectForKey: @"intentionSlug"];
        self.prototypeId = [aDecoder decodeObjectForKey: @"prototypeId"];
        self.textId = [aDecoder decodeObjectForKey: @"textId"];
        self.content = [aDecoder decodeObjectForKey: @"content"];
        self.imageName = [aDecoder decodeObjectForKey: @"imageName"];
        self.imageLink = [aDecoder decodeObjectForKey: @"imageLink"];
        self.sender = [aDecoder decodeObjectForKey: @"sender"];
        self.recipient = [aDecoder decodeObjectForKey: @"recipient"];
        self.imageCardUrl = [aDecoder decodeObjectForKey: @"imageCardUrl"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject: _intentionId forKey: @"intentionId"];
    [aCoder encodeObject: _intentionSlug forKey: @"intentionSlug"];
    [aCoder encodeObject: _prototypeId forKey: @"prototypeId"];
    [aCoder encodeObject: _textId forKey: @"textId"];
    [aCoder encodeObject: _content forKey: @"content"];
    [aCoder encodeObject: _imageName forKey: @"imageName"];
    [aCoder encodeObject: _imageLink forKey: @"imageLink"];
    [aCoder encodeObject: _sender forKey: @"sender"];
    [aCoder encodeObject: _recipient forKey: @"recipient"];
    [aCoder encodeObject: _imageCardUrl forKey: @"imageCardUrl"];
    
}

@end
