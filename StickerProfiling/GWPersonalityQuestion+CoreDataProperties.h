//
//  GWPersonalityQuestion+CoreDataProperties.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GWPersonalityQuestion.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWPersonalityQuestion (CoreDataProperties)

@property (nullable, nonatomic, retain) NSArray *answers;
@property (nullable, nonatomic, retain) NSString *defaultImage;
@property (nullable, nonatomic, retain) NSString *personalityQuestionId;
@property (nullable, nonatomic, retain) NSArray *question;

@end

NS_ASSUME_NONNULL_END
