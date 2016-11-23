//
//  GWImageWithThumb+CoreDataProperties.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GWImageWithThumb.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWImageWithThumb (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, retain) NSString *imageId;
@property (nullable, nonatomic, retain) NSData *thumbImageData;

@end

NS_ASSUME_NONNULL_END
