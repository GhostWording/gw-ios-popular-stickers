//
//  NSMutableDictionary+NoNilExtension.m
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/14/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "NSMutableDictionary+NoNilExtension.h"

@implementation NSMutableDictionary (NoNilExtension)

-(void)c_setObject:(id)object forKey:(NSString *)key {
    
    if (object != nil) {
        [self setObject: object forKey: key];
    }
    
}

@end
