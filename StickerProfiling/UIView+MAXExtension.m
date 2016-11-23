//
//  UIView+MAXExtension.m
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 25/02/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "UIView+MAXExtension.h"

@implementation UIView (MAXExtension)

-(void)c_setOriginX:(float)x {
    CGRect theFrame = self.frame;
    theFrame.origin.x = x;
    self.frame = theFrame;
}

-(void)c_setOriginY:(float)y {
    CGRect theFrame = self.frame;
    theFrame.origin.y = y;
    self.frame = theFrame;
}

-(void)c_setWidth:(float)theWidth {
    CGRect theFrame = self.frame;
    theFrame.size.width = theWidth;
}

-(void)c_setHeight:(float)theHeight {
    CGRect theFrame = self.frame;
    theFrame.size.height = theHeight;
    self.frame = theFrame;
}

@end
