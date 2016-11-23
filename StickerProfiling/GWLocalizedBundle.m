//
//  GWLocalizedBundle.m
//  GWFramework
//
//  Created by Mathieu Skulason on 04/08/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "GWLocalizedBundle.h"

@implementation GWLocalizedBundle

static NSBundle *bundle = nil;

+(void)initialize {
    
    NSLocale *currentLocale = [GWLocalizedBundle currentLocale];
    NSString *langPath = [[NSBundle mainBundle] pathForResource:currentLocale.localeIdentifier ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:langPath];
    
}

+(NSBundle*)GWBundle {
    return bundle;
}

+(void)setLanguage:(NSString *)lang {
    NSLog(@"setting language to: %@", lang);
    [GWLocalizedBundle setCurrentLocaleString:lang];
    NSString *localeIdentifier = [GWLocalizedBundle currentLocaleString];
    NSString *langPath = [[NSBundle mainBundle] pathForResource:localeIdentifier ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:langPath];
    NSLog(@"new bundle: %@", bundle);
}

+(NSString*)GWLocalizedStringForKey:(NSString *)key {
    return [bundle localizedStringForKey:key value:@"Value not found" table:@"IntentionLocalizedStrings"];
}

#pragma mark - Locale

+(NSLocale*)currentLocale {
    return [NSLocale localeWithLocaleIdentifier:[GWLocalizedBundle currentLocaleString]];
}

+(NSString*)currentLocaleString {
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"currentLocale"] == nil) {
        
        NSString *preferredLocalization = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
        
        if ([preferredLocalization isEqualToString:@"en"] == YES || [preferredLocalization isEqualToString:@"fr"] == YES || [preferredLocalization isEqualToString:@"es"] == YES) {
            [GWLocalizedBundle setCurrentLocaleString: preferredLocalization];
        }
        else {
            [GWLocalizedBundle setCurrentLocaleString:@"en"];
        }
    }
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"currentLocale"];
}

+(void)setCurrentLocaleString:(NSString *)theLocale {
    
    NSString *partialString = @"";
    if (theLocale.length >= 2) {
        partialString = [theLocale substringWithRange:NSMakeRange(0, 2)];
    }
    
    if ([partialString isEqualToString:@"en"] || [partialString isEqualToString:@"fr"] || [partialString isEqualToString:@"es"]) {
        [[NSUserDefaults standardUserDefaults] setValue:partialString forKey:@"currentLocale"];
    }
    else {
        NSLog(@"not setting current locale string");
    }
}

+(NSString*)currentLocaleAPIString {
    NSString *locale = [GWLocalizedBundle currentLocaleString];
    
    if ([locale hasPrefix:@"fr"]) {
        return @"fr-FR";
    }
    else if([locale hasPrefix:@"en"]) {
        return @"en-EN";
    }
    else if([locale hasPrefix:@"es"]) {
        return @"es-ES";
    }
    else {
        return @"fr-FR";
    }
    
}

@end
