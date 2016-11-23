//
//  GoogleAnalyticsCommunication.m
//  MaCherie
//
//  Created by Mathieu Skulason on 30/05/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "GoogleAnalyticsCommunication.h"

@interface GoogleAnalyticsCommunication () {
    id <GAITracker> tracker;
}

@end

@implementation GoogleAnalyticsCommunication

+(instancetype)sharedInstance {
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(id)init {
    
    if (self = [super init]) {
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        [GAI sharedInstance].dispatchInterval = 5;
        [[[GAI sharedInstance] logger] setLogLevel: kGAILogLevelWarning];
        [[GAI sharedInstance] trackerWithTrackingId: @"UA-47718196-18"];
        
        tracker = [[GAI sharedInstance] defaultTracker];
        tracker.allowIDFACollection = YES;
    }
    
    return self;
}

-(void)sendEventWithCategory:(NSString *)eventCategory withAction:(NSString *)eventAction withLabel:(NSString *)eventLabel wtihValue:(NSNumber *)eventValue {
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventCategory action:eventAction label:eventLabel value:eventValue] build]];
}

-(void)setScreenName:(NSString *)screenName {
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
