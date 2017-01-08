//
//  PopularStickersLocalization.m
//  PopularStickers
//
//  Created by Mathieu Skulason on 06/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "PopularStickersLocalization.h"
#import "GWLocalizedBundle.h"

@implementation PopularStickersLocalization

+(nonnull NSString *)popularStickersLocalizedStringForKey:(NSString *)theKey {
    return [[GWLocalizedBundle GWBundle] localizedStringForKey:theKey value:@"Value not found in Popular Stickers" table:@"PopularStickersLocalization"];
}

@end

FOUNDATION_EXPORT NSString * _Nonnull PopularStickersLocalizedString( NSString *key, NSString *comment) {
    return [PopularStickersLocalization popularStickersLocalizedStringForKey:key];
}
