//
//  CustomAnalytics.h
//  MaCherie
//
//  Created by Mathieu Skulason on 30/05/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomAnalytics : NSObject

+(instancetype)sharedInstance;

-(void)postActionWithType:(NSString*)actionType actionLocation:(NSString*)actionLocation targetType:(NSString*)targetType targetId:(NSString*)targetId targetParameter:(NSString*)targetParameter;

-(void)forceSendAllEvents;

@end
