//
//  GWAnalyticsStore.m
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/14/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "GWAnalyticsStore.h"

@implementation GWAnalyticsStore

+(void)addAnalyticsPost:(NSDictionary *)analyticsPost {
    
    if (analyticsPost != nil) {
        NSMutableArray *posts = [[self analayticsPosts] mutableCopy];
        [posts addObject: analyticsPost];
        
        [self setAnalyticsPosts: posts];
    }
    
}

+(void)addArrayOfAnalyticsPosts:(NSArray<NSDictionary *> *)analyticsPosts {
    
    for (NSDictionary *dict in analyticsPosts) {
        [self addAnalyticsPost: dict];
    }
    
}

+(NSArray <NSDictionary *> *)analayticsPosts {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"GWAnalyticsPosts"] == nil) {
        return @[];
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"GWAnalyticsPosts"];
}

+(void)setAnalyticsPosts:(NSArray <NSDictionary *> *)posts {
    
    if (posts != nil) {
        [[NSUserDefaults standardUserDefaults] setObject: posts forKey:@"GWAnalyticsPosts"];
    }
    
}

+(void)removeAnalyticsPosts {
    
    [[NSUserDefaults standardUserDefaults] setObject: @[] forKey:@"GWAnalyticsPosts"];
    
}


+(void)setLastAnalyticsSendTime:(NSDate *)sendTime {
    
    [[NSUserDefaults standardUserDefaults] setObject: sendTime forKey: @"GWLastSendTime"];
    
}

+(NSDate *)lastAnalyticsSendTime {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey: @"GWLastSendTime"] == nil) {
        
        [self setLastAnalyticsSendTime: [NSDate date]];
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"GWLastSendTime"];
}

@end
