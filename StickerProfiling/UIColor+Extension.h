//
//  UIColor+Extension.h
//  Gloops
//
//  Created by Mathieu Skulason on 24/04/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

// UI Color Service functions
+(NSString *)c_hexValuesFromUIColor:(UIColor *)color;
+(UIColor *)c_colorWithHexString:(NSString *)hexString;
+(UIColor *)c_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+(UIColor *)c_greenColor;
+(UIColor *)c_blueCheckMarkColor;
+(UIColor *)c_pinkColor;
+(UIColor *)c_halfBlackColor;
+(UIColor *)c_halfWhiteColor;
+(UIColor *)c_blueColor;
+(UIColor *)c_greenFadedColor;
+(UIColor *)c_lightGrayIndicatorColor;
+(UIColor *)c_textDarkGrayColor;
+(UIColor *)c_textLightGrayColor;
+(UIColor *)c_bannerGrayColor;
+(UIColor *)c_backToMessengerBannerColor;
+(UIColor *)c_lightBlueCellHighlightColor;
+(UIColor *)c_facebookBlueColor;
+(UIColor *)c_lightGrayBackgroundColor;
+(UIColor *)c_tabBarGrayColor;
+(UIColor *)c_tabBarItemDeselectColor;
@end
