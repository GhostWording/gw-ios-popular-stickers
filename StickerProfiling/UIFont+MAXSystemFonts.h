//
//  UIFont+MAXSystemFonts.h
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 28/02/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (MAXSystemFonts)

+(void)c_printAllFonts;


// MARK: Arial
+(instancetype)c_arialBoldWithSize:(float)size;
+(instancetype)c_arialWithSize:(float)size;
+(instancetype)c_arialItalicWithSize:(float)size;
+(instancetype)c_arialBoldItalicWithSize:(float)size;

// MARK: Helvetica Neue
+(instancetype)c_helveticaNeueWithSize:(float)size;
+(instancetype)c_helveticaNeueItalicWithSize:(float)size;
+(instancetype)c_helveticaNeueBoldWithSize:(float)size;
+(instancetype)c_helveticaNeueBoldItalicWithSize:(float)size;
+(instancetype)c_helveticaNeueMediumWitihSize:(float)size;
+(instancetype)c_helveticaNeueMediumItalicWithSize:(float)size;
+(instancetype)c_helveticaNeueLightWithSize:(float)size;
+(instancetype)c_helveticaNeueLightItalicWithSize:(float)size;
+(instancetype)c_helveticaNeueUltraLightWithSize:(float)size;
+(instancetype)c_helveticaNeueUltraLightItalicWithSize:(float)size;
+(instancetype)c_helveticaNeueThinWithSize:(float)size;
+(instancetype)c_helveticaNeueThinItalicWithSize:(float)size;

// MARK: Noteworthy
+(instancetype)c_noteworthyLightWithSize:(float)size;
+(instancetype)c_noteworthyBoldWithSize:(float)size;

// MARK: Apple SD Gothic Neo
+(instancetype)c_appleSDGothicNeoBoldWithSize:(float)size;
+(instancetype)c_appleSDGothicNeoSemiBoldWithSize:(float)size;
+(instancetype)c_appleSDGothicNeoMediumWithSize:(float)size;
+(instancetype)c_appleSDGothicNeoRegularWithSize:(float)size;
+(instancetype)c_appleSDGothicNeoLightWithSize:(float)size;
+(instancetype)c_appleSDGothicNeoThinWithSize:(float)size;

@end
