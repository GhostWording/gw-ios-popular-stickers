//
//  MAXBlockButton.h
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 18/02/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAXBlockButton : UIButton

@property (nonatomic, strong, nullable) void (^buttonTouchDownCompletionBlock)(void);
@property (nonatomic, strong, nullable) void (^buttonTouchUpCompletionBlock)(void);

// completion blocks for touch events
-(void)buttonTouchDownWithCompletion:(void (^)(void))block;
-(void)buttonTouchDownRepeatWithCompletion:(void (^)(void))block;
-(void)buttonTouchDragInsideWithCompletion:(void (^)(void))block;
-(void)buttonTouchDragOutsideWithCompletion:(void (^)(void))block;
-(void)buttonTouchDragEnterWithCompletion:(void (^)(void))block;
-(void)buttonTouchDragExitWithCompletion:(void (^)(void))block;
-(void)buttonTouchUpInsideWithCompletion:(void (^)(void))block;
-(void)buttonTouchUpOutsideWithCompletion:(void (^)(void))block;
-(void)buttonTouchCancelWithCompletion:(void (^)(void))block;
-(void)buttonTouchAllEventsWithCompletion:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
