//
//  GWTag+CoreDataProperties.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GWTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWTag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *tagId;

@end

NS_ASSUME_NONNULL_END
