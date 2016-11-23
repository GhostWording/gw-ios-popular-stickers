//
//  NSSetValueTransformer.m
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 14/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "NSSetValueTransformer.h"

@implementation NSSetValueTransformer

+(instancetype)transformer {
    NSSetValueTransformer *set = [[NSSetValueTransformer alloc] init];
    return set;
}

+(BOOL)allowsReverseTransformation {
    return YES;
}

-(id)transformedValue:(id)value {
    
    if ([value isKindOfClass:[NSArray class]] == YES) {
        return [NSSet setWithArray:value];
    }
    
    return [NSSet setWithObject:value];
    
}

-(id)reverseTransformedValue:(id)value {
    
    if ([value isKindOfClass:[NSSet class]] == YES) {
        return [(NSSet*)value allObjects];
    }
    
    return nil;
}

@end
