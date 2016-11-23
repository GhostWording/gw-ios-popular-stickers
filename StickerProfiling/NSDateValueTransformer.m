//
//  NSDateValueTransformer.m
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 14/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "NSDateValueTransformer.h"

static NSDateFormatter *s_secondsDateFormatter;
static NSDateFormatter *s_milliSecondsDateFormatter;

@implementation NSDateValueTransformer

+(NSDateFormatter *)secondsDateFormatter {
    if (s_secondsDateFormatter == nil) {
        s_secondsDateFormatter = [[NSDateFormatter alloc] init];
        [s_secondsDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    
    return s_secondsDateFormatter;
}

+(BOOL)allowsReverseTransformation {
    return YES;
}

-(id)transformedValue:(id)value {
    
    if ([value isKindOfClass:[NSString class]] == YES) {
        
        NSArray *dateSeparated = [(NSString *)value componentsSeparatedByString:@"."];
        NSString *firstObject = [dateSeparated firstObject];
        
        NSDate *secondsDate = [[NSDateValueTransformer secondsDateFormatter] dateFromString:firstObject];
        if (secondsDate != nil) {
            return secondsDate;
        }
        
    }
    
    
    return nil;
}

-(id)reverseTransformedValue:(id)value {
    
    if ([value isKindOfClass:[NSDate class]] == YES) {
        
        NSString *dateString = [[NSDateValueTransformer secondsDateFormatter] stringFromDate:value];
        
        if (dateString != nil) {
            return dateString;
        }
    }
    
    return nil;
}

@end
