//
//  BlocksAlertView.m
//  MaCherie
//
//  Created by Mathieu Skulason on 19/09/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "BlocksAlertView.h"

@interface BlocksAlertView () <UIAlertViewDelegate> {
    void (^completionBlock)(int buttonIndex, UIAlertView *alert);
}

@end

@implementation BlocksAlertView

-(id)init {
    if (self = [super init]) {
        completionBlock = nil;
        self.delegate = self;
    }
    
    return self;
}

-(void)buttonPressedWithCompletion:(void (^)(int buttonIndex, UIAlertView *alert))block {
    completionBlock = [block copy];
}

-(void)setDelegate:(id)delegate {
    
    if (self.delegate != self) {
        [super setDelegate:self];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (completionBlock != nil) {
        
        if (buttonIndex == [alertView cancelButtonIndex]) {
            completionBlock((int)buttonIndex, self);
        }
        else {
            completionBlock((int)buttonIndex, self);
        }
        
    }
}

@end
