//
//  PopularStickersLocalization.h
//  PopularStickers
//
//  Created by Mathieu Skulason on 06/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopularStickersLocalization : NSObject

+(nonnull NSString *)popularStickersLocalizedStringForKey:(NSString * _Nonnull)theKey;

@end

FOUNDATION_EXPORT NSString * _Nonnull PopularStickersLocalizedString( NSString * _Nonnull key, NSString * _Nullable comment);
