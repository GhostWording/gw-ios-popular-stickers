//
//  GWExperiment.m
//  StickerProfiling
//
//  Created by Mathieu Grettir Skulason on 12/6/16.
//  Copyright © 2016 Konta. All rights reserved.
//

#import "GWExperiment.h"

static NSString *variationIdString = @"GWVariationId";
static NSString *experimentIdString = @"GWExperimentId";

@implementation GWExperiment

+(nullable NSString *)experimentId {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey: experimentIdString];
}

+(void)setExperimentId:(nullable NSString *)experimentId {
    
    [[NSUserDefaults standardUserDefaults] setObject: experimentId forKey: experimentIdString];
}

+(nullable NSNumber *)variationId {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey: variationIdString];
}

+(void)setVariationId:(nullable NSString *)variationId {
    
    [[NSUserDefaults standardUserDefaults] setObject: variationId forKey: variationIdString];
}

+(void)fetchExperimentWithArea:(nonnull NSString *)theArea withCompletion:(void (^)(NSString * _Nullable, NSNumber * _Nullable, NSError * _Nullable))completion {
    [completion copy];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"http://api.cvd.io/%@/experiment/current", theArea]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest: request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil && data != nil) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
            [self setExperimentId: [dict objectForKey: @"ExperimentId"]];
            [self setVariationId: [dict objectForKey: @"VariationId"]];
            
            completion([self experimentId], [self variationId], error);
        }
        else {
            completion(nil, nil, error);
        }
        
    }] resume];
}

@end
