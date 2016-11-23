//
//  UIFont+MAXRobotoExtension.m
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 28/02/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "UIFont+MAXRobotoExtension.h"

@implementation UIFont (MAXRobotoExtension)

+(UIFont*)c_robotoUltraBoldWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-Black" size:size];
}

+(UIFont*)c_robotoUltraBoldItalicWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-BlackItalic" size:size];
}

+(UIFont*)c_robotoBoldWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-Bold" size:size];
}

+(UIFont*)c_robotoBoldItalicWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-BoldItalic" size:size];
}

+(UIFont*)c_robotoMediumWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-Medium" size:size];
}

+(UIFont*)c_robotoMediumItalicWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-MediumItalic" size:size];
}

+(UIFont*)c_robotoWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-Regular" size:size];
}

+(UIFont*)c_robotoItalicWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-Italic" size:size];
}

+(UIFont*)c_robotoLightWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-Light" size:size];
}

+(UIFont*)c_robotoLightItalicWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-LightItalic" size:size];
}

+(UIFont*)c_robotoThinWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-Thin" size:size];
}

+(UIFont*)c_robotoThinItalicWithSize:(float)size {
    return [UIFont fontWithName:@"Roboto-ThinItalic" size:size];
}

@end
