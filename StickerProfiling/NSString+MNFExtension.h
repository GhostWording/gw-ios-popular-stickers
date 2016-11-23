//
//  NSString+MNFExtension.h
//  Meniga-ios-sdk
//
//  Created by Mathieu Grettir Skulason on 10/29/15.
//  Copyright (c) 2015 Meniga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNFJsonAdapter.h"

@interface NSString (MNFExtension)

-(NSString *)c_stringWithOption:(MNFAdapterOption)adapterOption;
+(NSString *)c_randomStringWithLength: (int) len;

@end
