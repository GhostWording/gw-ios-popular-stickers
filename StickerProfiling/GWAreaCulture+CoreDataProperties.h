//
//  GWAreaCulture+CoreDataProperties.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GWAreaCulture.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWAreaCulture (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) GWArea *area;

@end

NS_ASSUME_NONNULL_END
