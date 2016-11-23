//
//  GWRecipient.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MNFJsonAdapterDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface GWRecipient : NSManagedObject <MNFJsonAdapterDelegate>

// Insert code here to declare functionality of your managed object subclass
+(GWRecipient *)createGWRecipientOnMainThread;
+(GWRecipient *)createGWRecipient;

+(GWRecipient *)createGWRecipientWithAreaName:(NSString *)theAreaName jsonDict:(NSDictionary *)theJsonDict context:(nullable NSManagedObjectContext *)theContext;

-(void)updateGWRecipientWithAreaName:(NSString *)theAreaName jsonDict:(NSDictionary *)theJsonDict context:(nullable NSManagedObjectContext *)theContext;


@end

NS_ASSUME_NONNULL_END

#import "GWRecipient+CoreDataProperties.h"
