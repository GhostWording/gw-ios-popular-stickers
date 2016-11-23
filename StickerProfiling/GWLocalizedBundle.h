//
//  GWLocalizedBundle.h
//  GWFramework
//
//  Created by Mathieu Skulason on 04/08/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWLocalizedBundle : NSObject

+(void)initialize;
+(void)setLanguage:(NSString*)lang;
+(NSString*)GWLocalizedStringForKey:(NSString*)key;
+(NSBundle*)GWBundle;

/* Returns the current locale associated with the current locale string. **/
+(NSLocale*)currentLocale;
/* returns fr (French), en (English), es (Spanish). **/
+(NSString*)currentLocaleString;
/* returns the locale api string in the format: fr-FR, en-EN, es-ES. **/
+(NSString*)currentLocaleAPIString;
/* currently only fr, en, es locales are supported. **/
+(void)setCurrentLocaleString:(NSString*)theLocale;

@end
