//
//  GoogleAnalyticsCommunication.h
//  MaCherie
//
//  Created by Mathieu Skulason on 30/05/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GoogleAnalyticsConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoogleAnalyticsCommunication : NSObject

+(instancetype)sharedInstance;

-(void)sendEventWithCategory:(NSString * _Nullable)eventCategory withAction:(NSString * _Nullable)eventAction withLabel:(NSString * _Nullable)eventLabel wtihValue:(NSNumber * _Nullable)eventValue;
-(void)setScreenName:(NSString*)screenName;

@end

NS_ASSUME_NONNULL_END