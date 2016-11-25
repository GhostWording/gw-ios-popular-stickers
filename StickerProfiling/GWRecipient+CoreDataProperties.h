//
//  GWRecipient+CoreDataProperties.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GWRecipient.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWRecipient (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *areaName;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSNumber *importance;
@property (nullable, nonatomic, retain) NSArray *labels;
@property (nullable, nonatomic, retain) NSString *localLabel;
@property (nullable, nonatomic, retain) NSString *politeForm;
@property (nullable, nonatomic, retain) NSString *recipientId;
@property (nullable, nonatomic, retain) NSString *relationTypeTag;
@property (nullable, nonatomic, retain) NSNumber *subscribableRecipient;
@property (nullable, nonatomic, retain) NSNumber *usualRecipient;

@end

NS_ASSUME_NONNULL_END
