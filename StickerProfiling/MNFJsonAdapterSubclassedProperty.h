//
//  MNFJsonAdapterSubclassedProperty.h
//  Meniga-ios-sdk
//
//  Created by Mathieu Grettir Skulason on 4/13/16.
//  Copyright © 2016 Meniga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNFJsonAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface MNFJsonAdapterSubclassedProperty : NSObject

@property (nonatomic, strong) Class propertyClass;
@property (nonatomic, strong) id <MNFJsonAdapterDelegate> propertyDelegate;
@property (nonatomic) MNFAdapterOption propertyOption;

+(instancetype)subclassedPropertyWithClass:(Class)theClass delegate:(nullable id <MNFJsonAdapterDelegate>)theDelegate option:(MNFAdapterOption)theOption;

-(instancetype)initWithClass:(Class)theClass delegate:(id <MNFJsonAdapterDelegate>)theDelegate option:(MNFAdapterOption)theOption;


@end

NS_ASSUME_NONNULL_END