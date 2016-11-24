//
//  GWIntention+CoreDataProperties.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GWIntention.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWIntention (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *areaName;
@property (nullable, nonatomic, retain) NSString *culture;
@property (nullable, nonatomic, retain) NSNumber *hasImage;
@property (nullable, nonatomic, retain) NSString *imagePath;
@property (nullable, nonatomic, retain) NSString *impersonal;
@property (nullable, nonatomic, retain) NSString *intentionDescription;
@property (nullable, nonatomic, retain) NSString *intentionId;
@property (nullable, nonatomic, retain) NSString *label;
@property (nullable, nonatomic, retain) NSArray *labels;
@property (nullable, nonatomic, retain) NSString *mediaUrl;
@property (nullable, nonatomic, retain) NSDate *mostRecentTextUpdate;
@property (nullable, nonatomic, retain) NSNumber *mostRecentTextUpdateEpoch;
@property (nullable, nonatomic, retain) NSString *recurring;
@property (nullable, nonatomic, retain) NSString *relationTypesString;
@property (nullable, nonatomic, retain) NSString *slug;
@property (nullable, nonatomic, retain) NSString *slugPrototypeLink;
@property (nullable, nonatomic, retain) NSNumber *sortOrder;
@property (nullable, nonatomic, retain) NSNumber *sortOrderInArea;
@property (nullable, nonatomic, retain) NSDate *updateDate;
@property (nullable, nonatomic, retain) NSNumber *weightingCoefficient;

@end

NS_ASSUME_NONNULL_END
