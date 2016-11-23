//
//  NSMutableDictionary+NoNilExtension.h
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/14/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (NoNilExtension)

/**
 @description sets an object if and only if it is nil for the corresponding key.
 */
-(void)c_setObject:(id)object forKey:(NSString *)key;

@end
