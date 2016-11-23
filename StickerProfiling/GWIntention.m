//
//  GWIntention.m
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import "GWTag.h"
#import "GWDataManager.h"
#import "GWIntention.h"
#import "GWCoreDataManager.h"
#import "MNFJsonAdapter.h"
#import "NSDateValueTransformer.h"

@implementation GWIntention

// Insert code here to add functionality to your managed object subclass

+(GWIntention *)createGWIntention {
    
    GWIntention *intention = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GWIntention class]) inManagedObjectContext:[[GWCoreDataManager sharedInstance] childContext] ];
    
    return intention;
    
}

+(GWIntention *)createGWIntentionOnMainThread {
    
    GWIntention *intention = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GWIntention class]) inManagedObjectContext:[[GWCoreDataManager sharedInstance] childContext]];
    
    return intention;
    
}

+(GWIntention *)createGWIntentionWithAreaName:(NSString *)theAreaName withDict:(NSDictionary *)jsonDict withContext:(NSManagedObjectContext *)theContext {
    
    GWIntention *intention = [GWIntention createGWIntention];
    
    [intention updateIntentionWithAreaName:theAreaName withDict:jsonDict withContext:theContext];
    
    return intention;
}

-(void)updateIntentionWithAreaName:(NSString *)theAreaName withDict:(NSDictionary *)jsonDict withContext:(NSManagedObjectContext *)theContext {
    
    self.areaName = theAreaName;
    [MNFJsonAdapter refreshObject:self delegate:self jsonDict:jsonDict option:kMNFAdapterOptionFirstLetterUppercase error:nil];
    
}

-(NSString *)description {
    return [NSString stringWithFormat:@"intentionId: %@, intentionLabe: %@, areaName: %@ and culture: %@ sortOrderInArea: %@", self.intentionId, self.label, self.areaName, self.culture, self.sortOrderInArea];
}

-(NSArray <NSString *> *)intentionRecipientTags {
    
    NSArray *tags = [self.relationTypesString componentsSeparatedByString:@","];
    
    return tags;
}

#pragma mark - Json Adapter

-(NSDictionary *)propertyValueTransformers {
    return @{ @"updateDate" : [[NSDateValueTransformer alloc] init] };
}


@end
