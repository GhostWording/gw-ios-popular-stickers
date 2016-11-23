//
//  GWRecipient.m
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import "GWRecipient.h"
#import "MNFJsonAdapter.h"
#import "GWCoreDataManager.h"

@implementation GWRecipient

// Insert code here to add functionality to your managed object subclass
// Insert code here to add functionality to your managed object subclass
+(GWRecipient *)createGWRecipientOnMainThread {
    GWRecipient *recipient = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GWRecipient class]) inManagedObjectContext:[[GWCoreDataManager sharedInstance] mainObjectContext]];
    
    return recipient;
}

+(GWRecipient *)createGWRecipient {
    
    GWRecipient *recipient = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GWRecipient class]) inManagedObjectContext: [[GWCoreDataManager sharedInstance] childContext]];
    
    return recipient;
}

+(GWRecipient *)createGWRecipientWithAreaName:(NSString *)theAreaName jsonDict:(NSDictionary *)theJsonDict context:(NSManagedObjectContext *)theContext {
    
    GWRecipient *recipient = [GWRecipient createGWRecipient];
    
    [recipient updateGWRecipientWithAreaName:theAreaName jsonDict:theJsonDict context:theContext];
    
    return recipient;
}

-(void)updateGWRecipientWithAreaName:(NSString *)theAreaName jsonDict:(NSDictionary *)theJsonDict context:(NSManagedObjectContext *)theContext {
    
    self.areaName = theAreaName;
    
    [MNFJsonAdapter refreshObject:self withJsonDict:theJsonDict option:kMNFAdapterOptionFirstLetterUppercase error:nil];
    
}


#pragma mark - Json Adapter

-(NSDictionary *)jsonKeysMapToProperties {
    return @{ @"recipientId" : @"Id" };
}

-(NSDictionary *)propertyKeysMapToJson {
    return @{ @"recipientId" : @"Id" };
}



@end
