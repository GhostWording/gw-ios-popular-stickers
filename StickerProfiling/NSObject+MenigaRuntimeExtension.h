//
//  NSObject+RuntimeExtension.h
//  MENIGAAutomaticJson
//
//  Created by Mathieu Grettir Skulason on 10/5/15.
//  Copyright © 2015 Mathieu Grettir Skulason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "MNFJsonAdapterKeyAndProperty.h"

@interface NSObject (MenigaRuntimeExtension)

/** Instantiates an object of any class type with a dictionary of values. */
+(instancetype)initWithClass:(Class)theClass modelDictionary:(NSDictionary *)theDictionary error:(NSError **)theError;

/** Instantiates an object of any class type with an array of MNFJJsonAdapterKeyAndProperty object which replaces the default dictionary that was being used before. */
+(instancetype)initWithClass:(Class)theClass modelArray:(NSArray <MNFJsonAdapterKeyAndProperty*> *)theArray error:(NSError *__autoreleasing *)theError;

/** Checks the value is nil and sets the property to Null in that case. No other checks are currently done in this method. Used to populate the objects properties in the convenience method initWithModelDictionary: . */
-(void)c_validateAndSetValue:(id)theValue propertyKey:(NSString *)thePropertyKey error:(NSError **)theError;

/** An alternative to just initializing a model with key/value information we can also just update it with that same information. Which is used internally by initWithClass:modelArray:error:. */
-(void)c_updateModelWitharray:(NSArray <MNFJsonAdapterKeyAndProperty *> *)theArray error:(NSError * __autoreleasing *)theError;

/** Returns all the objective-c runtiem properties associated with the class. The Stop variable is used to stop the enumeration of the object. */
+(void)c_enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block;

/** Returns the class of the property with 'propertyName' if it exists. */
-(Class)c_classOfPropertyNamed:(NSString*)propertyName;


@end
