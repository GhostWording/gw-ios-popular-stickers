//
//  GWIntention.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MNFJsonAdapter.h"
#import "MNFJsonAdapterDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWIntention : NSManagedObject <MNFJsonAdapterDelegate>

// Insert code here to declare functionality of your managed object subclass

+(GWIntention*)createGWIntention;

+(GWIntention *)createGWIntentionOnMainThread;

// Insert code here to declare functionality of your managed object subclass
+(GWIntention*)createGWIntentionWithAreaName:(NSString*)theAreaName withDict:(NSDictionary *)jsonDict withContext:(nullable NSManagedObjectContext *)theContext;

/* Updates the intention with the given json dictionary values. **/
-(void)updateIntentionWithAreaName:(NSString*)theAreaName withDict:(NSDictionary *)jsonDict withContext:(nullable NSManagedObjectContext *)theContext;

-(NSArray <NSString *> *)intentionRecipientTags;

@end

NS_ASSUME_NONNULL_END

#import "GWIntention+CoreDataProperties.h"
