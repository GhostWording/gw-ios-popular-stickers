//
//  GWImage.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface GWImage : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
// Insert code here to declare functionality of your managed object subclass
+(GWImage *)createGWImage;
+(GWImage *)createGWImageOnMainThread;

+(GWImage*)createGWImageWithImagePath:(NSString*)theImagePath withImageData:(NSData*)theImageData withManagedContext:(nullable NSManagedObjectContext*)theContext;
-(void)updateImageWithImagePath:(NSString*)theImagePath withImageData:(NSData*)theImageData;

@end

NS_ASSUME_NONNULL_END

#import "GWImage+CoreDataProperties.h"
