//
//  GWExperiment.h
//  StickerProfiling
//
//  Created by Mathieu Grettir Skulason on 12/6/16.
//  Copyright © 2016 Konta. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GWExperiment : NSObject

/**
 @description Fetches the current experiment id from user defaults, if none exists an experiment should be fetched. Same applies to variation id.
 */
+(nullable NSString *)experimentId;

/**
 @description Fetches the current variation id from user defaults, if non exists an experiment should be fetched. Same applies to experiment id.
 */
+(nullable NSNumber *)variationId;

+(void)fetchExperimentWithArea:(NSString *)theArea withCompletion:(void (^)(NSString * _Nullable experimentId, NSNumber * _Nullable variationId, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END