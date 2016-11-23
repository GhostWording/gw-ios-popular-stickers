//
//  GWTag.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GWText.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWTag : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(GWTag *)createGWTagOnMainThread;
+(GWTag *)createGWTag;

+(GWTag *)createGWTagWithTagId:(NSString *)theTagId text:(nullable GWText *)theText;
@end

NS_ASSUME_NONNULL_END

#import "GWTag+CoreDataProperties.h"
