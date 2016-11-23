//
//  NSString+MNFExtension.m
//  Meniga-ios-sdk
//
//  Created by Mathieu Grettir Skulason on 10/29/15.
//  Copyright (c) 2015 Meniga. All rights reserved.
//

#import "NSString+MNFExtension.h"

const NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation NSString (MNFExtension)

-(NSString *)c_stringWithOption:(MNFAdapterOption)adapterOption {
    
    if (adapterOption == kMNFAdapterOptionFirstLetterLowercase && self.length >= 1) {
        NSString *firstLetter = [self substringToIndex:1];
        NSString *restOfString = [self substringFromIndex:1];
        return [NSString stringWithFormat:@"%@%@", [firstLetter lowercaseString], restOfString];
    }
    else if(adapterOption == kMNFAdapterOptionFirstLetterUppercase && self.length >= 1) {
        NSString *firstLetter = [self substringToIndex:1];
        NSString *restOfString = [self substringFromIndex:1];
        return [NSString stringWithFormat:@"%@%@", [firstLetter uppercaseString], restOfString];
    }
    else if(adapterOption == kMNFAdapterOptionLowercase) {
        return [self lowercaseString];
    }
    else if(adapterOption == kMNFAdapterOptionUppercase) {
        return [self uppercaseString];
    }
    
    return self;
}

+(NSString *)c_randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((unsigned)[letters length])]];
    }
    
    return randomString;
}

@end
