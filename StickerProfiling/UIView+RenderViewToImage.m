//
//  UIView+RenderViewToImage.m
//  MaCherie
//
//  Created by Mathieu Skulason on 05/05/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "UIView+RenderViewToImage.h"

@implementation UIView (RenderViewToImage)

- (UIImage *)imageByRenderingView
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

@end
