//
//  NSString+MAXHeightExtension.m
//  PopularStickers
//
//  Created by Mathieu Skulason on 17/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "NSString+MAXHeightExtension.h"

@implementation NSString (MAXHeightExtension)

+ (CGFloat)c_findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    CGFloat result = font.pointSize + 4;
    if (text)
    {
        CGSize textSize = { widthValue, CGFLOAT_MAX };       //Width and height of text area
        CGSize size;
        
        //iOS 7
        CGRect frame = [text boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:font }
                                          context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height+1);
       
        result = MAX(size.height, result); //At least one row
    }
    return result;
}

+ (NSString *)c_generateRandStringWithLength:(int)length {
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    
    NSMutableString *string = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        u_int32_t pos = arc4random()%[alphabet length];
        unichar c = [alphabet characterAtIndex:pos];
        
        [string appendFormat:@"%C", c];
    }
    
    
    return string;
}

@end
