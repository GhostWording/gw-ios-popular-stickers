//
//  GWTag.m
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import "GWTag.h"
#import "GWCoreDataManager.h"

@implementation GWTag

// Insert code here to add functionality to your managed object subclass
// Insert code here to add functionality to your managed object subclass
+(GWTag *)createGWTagOnMainThread {
    GWTag *tag = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GWTag class]) inManagedObjectContext:[GWCoreDataManager sharedInstance].mainObjectContext];
    
    return tag;
}

+(GWTag *)createGWTag {
    GWTag *tag = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GWTag class]) inManagedObjectContext:[[GWCoreDataManager sharedInstance] childContext]];
    
    return tag;
}

+(GWTag *)createGWTagWithTagId:(NSString *)theTagId text:(nullable GWText *)theText {
    
    GWTag *tag = [self createGWTag];
    tag.tagId = theTagId;
    
    return tag;
}


@end
