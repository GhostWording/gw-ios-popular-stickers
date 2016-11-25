//
//  CustomAnalytics.m
//  MaCherie
//
//  Created by Mathieu Skulason on 30/05/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAnalytics.h"
#import "UserDefaults.h"
#import "GWAnalyticsStore.h"
#import "NSMutableDictionary+NoNilExtension.h"

static NSURLSession *session = nil;

@implementation CustomAnalytics

+(instancetype)sharedInstance {
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(NSURLSession *)p_session {
    
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return session;
    
}

-(id)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(void)postActionWithType:(NSString*)actionType actionLocation:(NSString*)actionLocation targetType:(NSString*)targetType targetId:(NSString*)targetId targetParameter:(NSString*)targetParameter
{
    NSString *versionNumber = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    NSMutableDictionary *analyticsPost = [NSMutableDictionary dictionary];
    [analyticsPost c_setObject: actionType forKey: @"ActionType"];
    [analyticsPost c_setObject: actionLocation forKey: @"ActionLocation"];
    [analyticsPost c_setObject: targetParameter forKey:@"TargetParameter"];
    [analyticsPost c_setObject: targetType forKey: @"TargetType"];
    [analyticsPost c_setObject: targetId forKey: @"TargetId"];
    [analyticsPost c_setObject: [UserDefaults userUniqueId] forKey: @"DeviceId"];
    [analyticsPost c_setObject: versionNumber forKey: @"VersionNumber"];
    [analyticsPost c_setObject: @"iOS" forKey: @"OsType"];
    [analyticsPost c_setObject: [UserDefaults facebookId] forKey: @"FacebookId"];
    [analyticsPost c_setObject: @"MBTIStickers" forKey: @"AreaId"];

    [GWAnalyticsStore addAnalyticsPost: analyticsPost];
    
    NSArray *analyticsPosts = [GWAnalyticsStore analayticsPosts];
    
    NSDate *lastSendTime = [GWAnalyticsStore lastAnalyticsSendTime];
    NSTimeInterval timeIntervalSinceLastSent = [lastSendTime timeIntervalSinceNow];
    
    if (timeIntervalSinceLastSent <= - 60 && analyticsPosts.count > 0) {
        
        [GWAnalyticsStore removeAnalyticsPosts];
        [GWAnalyticsStore setLastAnalyticsSendTime: [NSDate date]];
        
        NSURL *url = [[NSURL alloc] initWithString: @"http://gw-usertracking.azurewebsites.net/userevent/batch"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod: @"POST"];
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:analyticsPosts options: 0 error: nil];
        [request setHTTPBody: jsonData];
        
        [[[self p_session] dataTaskWithRequest: request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error == nil) {
                
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
                NSLog(@"completed request with response: %@ data sent: %@", response, analyticsPosts);
                
            }
            else {
                [GWAnalyticsStore addArrayOfAnalyticsPosts: analyticsPosts];
                [GWAnalyticsStore setLastAnalyticsSendTime: lastSendTime];
            }
            
        }] resume];
        
    }
    
}

-(void)forceSendAllEvents {
    
    NSArray *allEvents = [GWAnalyticsStore analayticsPosts];
    
    if (allEvents.count > 0) {
        [GWAnalyticsStore removeAnalyticsPosts];
        
        NSURL *url = [[NSURL alloc] initWithString: @"http://gw-usertracking.azurewebsites.net/userevent/batch"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod: @"POST"];
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject: allEvents options: 0 error: nil];
        [request setHTTPBody: jsonData];
        
        [[[self p_session] dataTaskWithRequest: request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error == nil) {
                
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
                NSLog(@"force sending completed request with response: %@ data sent: %@", response, allEvents);
                
            }
            else {
                [GWAnalyticsStore addArrayOfAnalyticsPosts: allEvents];
            }
            
        }] resume];
    }
    
}


@end
