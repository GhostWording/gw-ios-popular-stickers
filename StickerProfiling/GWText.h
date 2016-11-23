//
//  GWText.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MNFJsonAdapterDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class GWTag;

@interface GWText : NSManagedObject <MNFJsonAdapterDelegate>

// Insert code here to declare functionality of your managed object subclass
+(GWText *)createGWTextOnMainThread;
+(GWText *)createGWText;

+(instancetype)createGWTextWithDict:(NSDictionary *)jsonDict withContext:(nullable NSManagedObjectContext*)theContext;

-(void)updateTextWithDict:(NSDictionary*)jsonDict withContext:(nullable NSManagedObjectContext*)theContext;

-(NSArray <NSString *> *)textTags;

@end

NS_ASSUME_NONNULL_END

#import "GWText+CoreDataProperties.h"
