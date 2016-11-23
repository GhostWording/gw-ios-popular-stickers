//
//  GWArea+CoreDataProperties.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GWArea.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWArea (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *areaId;
@property (nullable, nonatomic, retain) NSDate *lastChangeTime;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<GWAreaCulture *> *availableCultures;

@end

@interface GWArea (CoreDataGeneratedAccessors)

- (void)addAvailableCulturesObject:(GWAreaCulture *)value;
- (void)removeAvailableCulturesObject:(GWAreaCulture *)value;
- (void)addAvailableCultures:(NSSet<GWAreaCulture *> *)values;
- (void)removeAvailableCultures:(NSSet<GWAreaCulture *> *)values;

@end

NS_ASSUME_NONNULL_END
