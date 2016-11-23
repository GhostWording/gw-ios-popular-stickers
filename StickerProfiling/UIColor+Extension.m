//
//  UIColor+Extension.m
//  Gloops
//
//  Created by Mathieu Skulason on 24/04/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

#pragma mark - 
#pragma mark Color Manipulation

+(UIColor *)c_colorWithHexString:(NSString *)hexString {
    
    
    return [self c_colorWithHexString:hexString alpha:1.0];
}

+(UIColor *)c_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    
    if ([hexString length] != 6) {
        return nil;
    }
    
    // Brutal and not-very elegant test for non hex-numeric characters
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-fA-F|0-9]" options:0 error:NULL];
    NSUInteger match = [regex numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, [hexString length])];
    
    if (match != 0) {
        return nil;
    }
    
    NSRange rRange = NSMakeRange(0, 2);
    NSString *rComponent = [hexString substringWithRange:rRange];
    unsigned int rVal = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:rComponent];
    [rScanner scanHexInt:&rVal];
    float rRetVal = (float)rVal / 254;
    
    
    NSRange gRange = NSMakeRange(2, 2);
    NSString *gComponent = [hexString substringWithRange:gRange];
    unsigned int gVal = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:gComponent];
    [gScanner scanHexInt:&gVal];
    float gRetVal = (float)gVal / 254;
    
    NSRange bRange = NSMakeRange(4, 2);
    NSString *bComponent = [hexString substringWithRange:bRange];
    unsigned int bVal = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:bComponent];
    [bScanner scanHexInt:&bVal];
    float bRetVal = (float)bVal / 254;
    
    if (alpha > 1.0) {
        alpha = 1.0;
    }
    
    return [UIColor colorWithRed:rRetVal green:gRetVal blue:bRetVal alpha:alpha];
    
}

+(NSString *)c_hexValuesFromUIColor:(UIColor *)color {
    
    if (color == nil) {
        return nil;
    }
    
    if (color == [UIColor whiteColor]) {
        // Special case, as white doesn't fall into the RGB color space
        return @"ffffff";
    }
    
    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int redDec = (int)(red * 255);
    int greenDec = (int)(green * 255);
    int blueDec = (int)(blue * 255);
    
    NSString *returnString = [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)redDec, (unsigned int)greenDec, (unsigned int)blueDec];
    
    return returnString;
    
}

+(UIColor *)c_greenColor {
   return [self c_colorWithHexString:@"009e01"];
}

+(UIColor *)c_blueCheckMarkColor {
    return [self c_colorWithHexString:@"0f7afc"];
}

+(UIColor *)c_pinkColor {
    return [self c_colorWithHexString:@"f51963"];
}

+(UIColor *)c_halfBlackColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

+(UIColor *)c_halfWhiteColor {
    return [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
}

+(UIColor *)c_blueColor {
    return [self c_colorWithHexString:@"1e93f0"];
}

+(UIColor *)c_greenFadedColor {
    return [self c_colorWithHexString:@"a7c4a6"];
}

+(UIColor *)c_lightGrayIndicatorColor {
    return [self c_colorWithHexString:@"ceced0"];
}

+(UIColor *)c_textDarkGrayColor {
    return [self c_colorWithHexString:@"637162"];
}

+(UIColor *)c_textLightGrayColor {
    return [self c_colorWithHexString:@"646464"];
}

+(UIColor *)c_bannerGrayColor {
    return [self c_colorWithHexString:@"efefef"];
}

+(UIColor *)c_backToMessengerBannerColor {
    return [self c_colorWithHexString:@"0084ff"];
}

+(UIColor *)c_lightBlueCellHighlightColor {
    
    return [self c_colorWithHexString:@"1e93f0" alpha:0.3];
}

+(UIColor *)c_facebookBlueColor {
    
    return [self c_colorWithHexString:@"3b5998"];
}

+(UIColor *)c_lightGrayBackgroundColor {
    
    return [self c_colorWithHexString: @"e6e8ea"];
}

@end
