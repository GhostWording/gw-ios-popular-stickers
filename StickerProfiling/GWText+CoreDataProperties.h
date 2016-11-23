//
//  GWText+CoreDataProperties.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GWText.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWText (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *abstract;
@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSString *culture;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *impersonal;
@property (nullable, nonatomic, retain) NSString *intentionId;
@property (nullable, nonatomic, retain) NSString *intentionLabel;
@property (nullable, nonatomic, retain) NSNumber *isQuote;
@property (nullable, nonatomic, retain) NSString *politeForm;
@property (nullable, nonatomic, retain) NSString *prototypeId;
@property (nullable, nonatomic, retain) NSString *proximity;
@property (nullable, nonatomic, retain) NSString *referenceUrl;
@property (nullable, nonatomic, retain) NSString *sender;
@property (nullable, nonatomic, retain) NSNumber *sortBy;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *tagsString;
@property (nullable, nonatomic, retain) NSString *target;
@property (nullable, nonatomic, retain) NSString *textId;
@property (nullable, nonatomic, retain) NSDate *updateDate;

@end

NS_ASSUME_NONNULL_END
