//
//  MNFJsonAdapterValueTransformer.m
//  Meniga-ios-sdk
//
//  Created by Mathieu Grettir Skulason on 3/23/16.
//  Copyright © 2016 Meniga. All rights reserved.
//

#import "MNFJsonAdapterValueTransformer.h"

static Class s_class;

@interface MNFJsonAdapterValueTransformer ()

@property (nonatomic) MNFAdapterOption option;
@property (nonatomic, weak) id <MNFJsonAdapterDelegate> delegate;

@end

@implementation MNFJsonAdapterValueTransformer

+(instancetype)transformerWithClass:(Class)theClass delegate:(id<MNFJsonAdapterDelegate>)theDelegate option:(MNFAdapterOption)theOption {
    
    MNFJsonAdapterValueTransformer *valueTransformer = [[MNFJsonAdapterValueTransformer alloc] init];
    valueTransformer.option = theOption;
    valueTransformer.delegate = theDelegate;
    
    s_class = theClass;
    
    return valueTransformer;
    
}

+(BOOL)allowsReverseTransformation {
    return YES;
}


-(id)transformedValue:(id)value error:(NSError **)theError {
    
    if (value == nil || value == [NSNull null]) {
        return value;
    }
    
    if ([value isKindOfClass:[NSArray class]] == YES) {
        
        NSArray *array = (NSArray*)value;
        
        NSArray *objects = [MNFJsonAdapter objectsOfClass:s_class delegate:_delegate jsonArray:array option:_option error:theError];
        
        return objects;
        
    }
    else if([value isKindOfClass:[NSDictionary class]] == YES) {
        
        NSDictionary *dict = (NSDictionary*)value;
        
        id object = [MNFJsonAdapter objectOfClass:s_class delegate:_delegate jsonDict:dict option:_option error:theError];
        
        return object;
        
    }
    
    return nil;
}

-(id)reverseTransformedValue:(id)value error:(NSError *__autoreleasing *)theError {
    
    if (value == nil || value == [NSNull null]) {
        return value;
    }
    
    if ([value isKindOfClass:[NSArray class]] == YES) {
        
        NSArray *array = (NSArray*)value;
        NSLog(@"array is: %@", array);
        NSArray *objects = [MNFJsonAdapter JSONArrayFromArray:array option:_option error:theError];
        NSLog(@"objects are: %@", objects);
        return objects;
        
    }
    else {
        
        NSDictionary *object = [MNFJsonAdapter JSONDictFromObject:value option:_option error:theError];
        
        return object;
        
    }
    
    return nil;
}

@end
