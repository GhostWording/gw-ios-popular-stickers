//
//  AnalyticsManager.m
//  LeRoiDuStatutFacebook
//
//  Created by Mathieu Skulason on 06/01/16.
//  Copyright © 2016 Mathieu Skulason. All rights reserved.
//

#import "AnalyticsManager.h"

#import "GoogleAnalyticsCommunication.h"
#import "CustomAnalytics.h"

@implementation AnalyticsManager

+(instancetype)sharedManager {
    static dispatch_once_t token;
    static id instance;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(void)postActionWithType:(NSString*)actionType targetType:(NSString*)targetType targetId:(NSString*)targetId targetParameter:(NSString*)targetParameter actionLocation:(NSString*)actionLocation {
    
    [[CustomAnalytics sharedInstance] postActionWithType:actionType actionLocation:actionLocation targetType:targetType targetId:targetId targetParameter:targetParameter];
    [[GoogleAnalyticsCommunication sharedInstance] sendEventWithCategory:targetType withAction:actionType withLabel:targetId wtihValue:nil];
    
}


@end
