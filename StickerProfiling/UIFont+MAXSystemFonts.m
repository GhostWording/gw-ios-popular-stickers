//
//  UIFont+MAXSystemFonts.m
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 28/02/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "UIFont+MAXSystemFonts.h"

@implementation UIFont (MAXSystemFonts)

+(void)c_printAllFonts {
    
    for (NSString *familyName in [UIFont familyNames]) {
        NSLog(@"Family name is: %@", familyName);
        NSArray *fontsForFamily = [UIFont fontNamesForFamilyName:familyName];
        for (NSString *fontName in fontsForFamily) {
            NSLog(@"Font name is: %@", fontName);
        }
    }
}

#pragma mark - Arial

+(instancetype)c_arialBoldWithSize:(float)size {
    return [UIFont fontWithName:@"Arial-BoldMT" size:size];
}

+(instancetype)c_arialWithSize:(float)size {
    return [UIFont fontWithName:@"ArialMT" size:size];
}

+(instancetype)c_arialItalicWithSize:(float)size {
    return [UIFont fontWithName:@"Arial-ItalicMT" size:size];
}

+(instancetype)c_arialBoldItalicWithSize:(float)size {
    return [UIFont fontWithName:@"Arial-BoldItalicMT" size:size];
}

#pragma mark - Helvetica Neue

+(instancetype)c_helveticaNeueWithSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+(instancetype)c_helveticaNeueItalicWithSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue-Italic" size:size];
}

+(instancetype)c_helveticaNeueBoldWithSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

+(instancetype)c_helveticaNeueBoldItalicWithSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:size];
}

+(instancetype)c_helveticaNeueMediumWitihSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+(instancetype)c_helveticaNeueMediumItalicWithSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:size];
}

+(instancetype)c_helveticaNeueLightWithSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+(instancetype)c_helveticaNeueLightItalicWithSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:size];
}

+(instancetype)c_helveticaNeueUltraLightWithSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:size];
}

+(instancetype)c_helveticaNeueUltraLightItalicWithSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:size];
}

+(instancetype)c_helveticaNeueThinWithSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
}

+(instancetype)c_helveticaNeueThinItalicWithSize:(float)size {
    return [UIFont fontWithName:@"HelveticaNeue-ThinItalic" size:size];
}

#pragma mark - Noteworthy

+(instancetype)c_noteworthyLightWithSize:(float)size {
    return [UIFont fontWithName:@"Noteworthy-Light" size:size];
}

+(instancetype)c_noteworthyBoldWithSize:(float)size {
    return [UIFont fontWithName:@"Noteworthy-Bold" size:size];
}

#pragma mark - Apple SD Gothic Neo

+(instancetype)c_appleSDGothicNeoBoldWithSize:(float)size {
    return [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:size];
}

+(instancetype)c_appleSDGothicNeoSemiBoldWithSize:(float)size {
    return [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:size];
}

+(instancetype)c_appleSDGothicNeoMediumWithSize:(float)size {
    return [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:size];
}

+(instancetype)c_appleSDGothicNeoRegularWithSize:(float)size {
    return [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:size];
}

+(instancetype)c_appleSDGothicNeoLightWithSize:(float)size {
    return [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:size];
}

+(instancetype)c_appleSDGothicNeoThinWithSize:(float)size {
    return [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:size];
}



@end
