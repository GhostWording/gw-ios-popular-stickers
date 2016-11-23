//
//  PopularStickersLocalization.h
//  PopularStickers
//
//  Created by Mathieu Skulason on 06/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopularStickersLocalization : NSObject

+(NSString *)popularStickersLocalizedStringForKey:(NSString *)theKey;

@end

FOUNDATION_EXPORT NSString * PopularStickersLocalizedString( NSString *key, NSString *comment) {
    return [PopularStickersLocalization popularStickersLocalizedStringForKey:key];
}