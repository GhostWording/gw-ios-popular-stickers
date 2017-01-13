//
//  BlocksAlertController.h
//  StickerProfiling
//
//  Created by Mathieu Grettir Skulason on 1/13/17.
//  Copyright © 2017 Konta. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BlockAlertIndex) {
    BlockAlertFirstIndex = 0,
    BlockAlertSecondIndex,
    BlockAlertThirdIndex,
    BlockAlertFourthIndex
};

@interface BlocksAlertController : UIAlertController

+(instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle  actions:(NSArray <UIAlertAction *> *)actions;

+(instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle firstActionTitle:(NSString *)firstActionTitle secondActionTitle:(nullable NSString *)secondActionTitle thirdActionTitle:(nullable NSString *)thirdActionTitle fourthActionTitle:(nullable NSString *)fourthActionTitle completion:(void  (^)(BlockAlertIndex index))completion;

@end

NS_ASSUME_NONNULL_END
