//
//  NSString+MAXHeightExtension.h
//  PopularStickers
//
//  Created by Mathieu Skulason on 17/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MAXHeightExtension)

+ (CGFloat)c_findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;
+ (NSString *)c_generateRandStringWithLength:(int)length;

@end
