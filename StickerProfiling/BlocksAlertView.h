//
//  BlocksAlertView.h
//  MaCherie
//
//  Created by Mathieu Skulason on 19/09/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlocksAlertView : UIAlertView

-(void)buttonPressedWithCompletion:(void (^)(int buttonIndex, UIAlertView *alert))block;

@end
