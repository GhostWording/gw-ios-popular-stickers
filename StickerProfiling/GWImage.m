//
//  GWImage.m
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import "GWImage.h"
#import "GWCoreDataManager.h"

@implementation GWImage

// Insert code here to add functionality to your managed object subclass
+(GWImage *)createGWImage {
    GWImage *image = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GWImage class]) inManagedObjectContext:[[GWCoreDataManager sharedInstance] childContext]];
    return image;
}

+(GWImage *)createGWImageOnMainThread {
    GWImage *image = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GWImage class]) inManagedObjectContext:[[GWCoreDataManager sharedInstance] mainObjectContext]];
    
    return image;
}

+(GWImage *)createGWImageWithImagePath:(NSString *)theImagePath withImageData:(NSData *)theImageData withManagedContext:(NSManagedObjectContext *)theContext {
    
    GWImage *image = [GWImage createGWImage];
    
    [image updateImageWithImagePath:theImagePath withImageData:theImageData];
    
    return image;
    
}

-(void)updateImageWithImagePath:(NSString *)theImagePath withImageData:(NSData *)theImageData {
    
    self.imageId = theImagePath;
    self.imageData = theImageData;
    
}

@end
