//
//  GWDailyIdea.h
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/21/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWDailyIdea : NSObject <NSCoding>

@property (nonatomic, strong, nonnull) NSString *intentionId;
@property (nonatomic, strong, nonnull) NSString *intentionSlug;
@property (nonatomic, strong, nonnull) NSString *prototypeId;
@property (nonatomic, strong, nonnull) NSString *textId;
@property (nonatomic, strong, nonnull) NSString *content;
@property (nonatomic, strong, nonnull) NSString *imageName;
@property (nonatomic, strong, nonnull) NSString *imageLink;
@property (nonatomic, strong, nonnull) NSString *sender;
@property (nonatomic, strong, nonnull) NSString *recipient;
@property (nonatomic, strong, nonnull) NSString *imageCardUrl;

+(void)fetchDailyIdeasWithCulture:(nonnull NSString *)culture newCards:(BOOL)newCard withCompletion:(nonnull void (^)(NSArray <GWDailyIdea *> * _Nullable ideas, NSError * _Nullable  error))completion;

+(void)setDailyIdeas:(nullable NSArray <GWDailyIdea *> *)dailyIdeas;
+(nonnull NSArray <GWDailyIdea *> *)cachedDailyIdeas;

+(void)setTimeSinceLastDailyIdea:(nonnull NSDate *)lastDailyIdea;
+(nonnull NSDate *)timeSinceLastDailyIdea;

@end
