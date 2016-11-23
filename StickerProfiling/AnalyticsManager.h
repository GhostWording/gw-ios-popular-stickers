//
//  AnalyticsManager.h
//  LeRoiDuStatutFacebook
//
//  Created by Mathieu Skulason on 06/01/16.
//  Copyright © 2016 Mathieu Skulason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsManager : NSObject

+(instancetype)sharedManager;

-(void)postActionWithType:(NSString*)actionType targetType:(NSString*)targetType targetId:(NSString*)targetId targetParameter:(NSString*)targetParameter actionLocation:(NSString*)actionLocation;

@end
