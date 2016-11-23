//
//  GWText.m
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import "GWText.h"
#import "GWTag.h"
#import "MNFJsonAdapter.h"
#import "GWDataManager.h"
#import "GWCoreDataManager.h"
#import "NSDateValueTransformer.h"

@implementation GWText

#pragma mark - Helper Create Methods

+(GWText *)createGWTextOnMainThread {
    GWText *text = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GWText class]) inManagedObjectContext:[GWCoreDataManager sharedInstance].mainObjectContext];
    
    return text;
}

+(GWText *)createGWText {
    GWText *text = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GWText class]) inManagedObjectContext:[[GWCoreDataManager sharedInstance] childContext]];
    
    return text;
}

+(instancetype)createGWTextWithDict:(NSDictionary *)jsonDict withContext:(NSManagedObjectContext *)theContext {
    GWText *text = [self createGWText];
    
    [text updateTextWithDict:jsonDict withContext:nil];
    
    return text;
}

-(void)updateTextWithDict:(NSDictionary *)jsonDict withContext:(NSManagedObjectContext *)theContext {
    
    [MNFJsonAdapter refreshObject:self delegate:self jsonDict:jsonDict option:kMNFAdapterOptionFirstLetterUppercase error:nil];
    
}

-(NSArray <NSString *> *)textTags {
    
    NSArray *tags = [self.tagsString componentsSeparatedByString:@","];
    
    return tags;
}

#pragma mark - Description

-(NSString *)description {
    return [NSString stringWithFormat:@"GWText textId: %@, content: %@, intentionId: %@, culture: %@, sender: %@, target: %@", self.textId, self.content, self.intentionId, self.culture, self.sender, self.target];
}

#pragma mark - Json Adapter Delegate

-(NSDictionary *)jsonKeysMapToProperties {
    return @{ @"updateDate" : @"Updated", @"createDate" : @"Created" };
}

-(NSDictionary *)propertyValueTransformers {
    return @{ @"updateDate" : [[NSDateValueTransformer alloc] init], @"createDate" : [[NSDateValueTransformer alloc] init] };
}

-(NSSet *)propertiesToIgnoreJsonDeserialization {
    return [NSSet setWithObjects:@"updated", @"tagIds", nil];
}


@end
