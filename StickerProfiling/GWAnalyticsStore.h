//
//  GWAnalyticsStore.h
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/14/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWAnalyticsStore : NSObject

+(void)addAnalyticsPost:(NSDictionary *)analyticsPost;
+(void)addArrayOfAnalyticsPosts:(NSArray <NSDictionary *> *)analyticsPosts;
+(void)removeAnalyticsPosts;
+(NSArray <NSDictionary *> *)analayticsPosts;

+(void)setLastAnalyticsSendTime:(NSDate *)sendTime;
+(NSDate *)lastAnalyticsSendTime;

@end
