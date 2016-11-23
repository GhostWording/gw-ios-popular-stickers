//
//  NSObject+RuntimeExtension.m
//  MENIGAAutomaticJson
//
//  Created by Mathieu Grettir Skulason on 10/5/15.
//  Copyright © 2015 Mathieu Grettir Skulason. All rights reserved.
//

#import "NSObject+MenigaRuntimeExtension.h"
#import <objc/runtime.h>

@implementation NSObject (RuntimeExtension)

+(instancetype)initWithClass:(Class)theClass modelDictionary:(NSDictionary *)theDictionary error:(NSError **)theError {
    
    Class someClass = theClass;
    
    id object = [[[someClass class] alloc] init];
    
    for (NSString *key in theDictionary) {
        
        id value = theDictionary[key];
        [object c_validateAndSetValue:value propertyKey:key error:theError];
        
    }
    
    return object;
}

+(instancetype)initWithClass:(Class)theClass modelArray:(NSArray<MNFJsonAdapterKeyAndProperty *> *)theArray error:(NSError *__autoreleasing *)theError {
    
    Class someClass = theClass;
    
    id object = [[[someClass class] alloc] init];
    
    [object c_updateModelWitharray:theArray error:theError];
    
    return object;
}

+(void)c_enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block {
    [block copy];
    
    Class someClass = self;
    BOOL stop = NO;
    
    // compare the class names as we do not want to serialize the properties for the NSObject
    while (stop == NO && someClass != nil && strcmp(object_getClassName([NSObject class]), object_getClassName(someClass)) != 0) {
        
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(someClass, &count);
                
        for (int i = 0; i < count; i++) {
            block(properties[i], &stop);

            if (stop) {
                break;
            }
        }
        
        someClass = [someClass superclass];
        
    }
}

-(void)c_updateModelWitharray:(NSArray<MNFJsonAdapterKeyAndProperty *> *)theArray error:(NSError *__autoreleasing *)theError {
    
    for (MNFJsonAdapterKeyAndProperty *jsonKeyAndPropObj in theArray) {
        NSLog(@"property: %@ value: %@", jsonKeyAndPropObj.propertyKey, jsonKeyAndPropObj.propertyValue);
        [self c_validateAndSetValue:jsonKeyAndPropObj.propertyValue propertyKey:jsonKeyAndPropObj.propertyKey error:theError];
        
    }
    
}

-(void)c_validateAndSetValue:(id)theValue propertyKey:(NSString *)thePropertyKey error:(NSError **)theError {
    
    Class theClass = [self c_classOfPropertyNamed:thePropertyKey];
    
    if (theValue != nil && theClass != nil && [theValue isKindOfClass:theClass] == YES) {
        if (theValue == [NSNull null]) {
            [self setValue:nil forKey:thePropertyKey];
        }
        else {
            [self setValue:theValue forKey:thePropertyKey];
        }
    }
}

-(Class)c_classOfPropertyNamed:(NSString*) propertyName
{
    // Get Class of property to be populated.
    Class propertyClass = nil;
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0)
    {
        // xcdoc://ios//library/prerelease/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    return propertyClass;
}

@end
