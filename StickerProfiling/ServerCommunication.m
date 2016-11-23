//
//  ServerCommunication.m
//  GWFramework
//
//  Created by Mathieu Skulason on 20/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "ServerCommunication.h"

const NSString *apiPath = @"http://api.cvd.io/";
const NSString *apiImagePath = @"http://gw-static.azurewebsites.net";

static NSURLSession *s_session;

@implementation ServerCommunication

#pragma mark - Initialization


+(NSURLSession *)p_session {
    if (s_session == nil) {
        s_session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    return s_session;
}


#pragma mark - Personality Questions

+(void)downloadPersonalityQuestionsWithPath:(NSString *)thePath completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    [completion copy];
    
    NSURL *url;
    if (thePath != nil) {
        url = [NSURL URLWithString: thePath];
    }
    else {
        url = [NSURL URLWithString: @"http://gw-static-apis.azurewebsites.net/data/questions/questions.json"];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[self p_session] dataTaskWithRequest: request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil && data != nil) {
            NSDictionary *personalityDict = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
            NSArray <NSDictionary *> *questions = [personalityDict objectForKey: @"Questions"];
            completion(questions, nil);
        }
        else {
            completion(nil, error);
        }
        
    }] resume];
    
}

+(void)downloadPersonalityQuestionsToAskWithPath:(NSString *)thePath completion:(void (^)(NSArray<NSString *> *, NSError *))completion {
    [completion copy];
    
    NSURL *url;
    if (thePath == nil) {
        url = [NSURL URLWithString: @"http://gw-static-apis.azurewebsites.net/data/questions/initialQuestionIds.json"];
    }
    else {
        url = [NSURL URLWithString: thePath];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[self p_session] dataTaskWithRequest: request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil && error == nil) {
            
            NSDictionary *personalityDict = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
            NSArray <NSString *> *questionIds = [personalityDict objectForKey:@"Ids"];
            
            completion(questionIds, nil);
            
        }
        else {
            completion(nil, error);
        }
        
    }] resume];
    
}

#pragma mark - Recipients

+(void)downloadRecipientsWithPath:(NSString *)thePath completion:(void (^)(NSArray *, NSError *))completion {
    [completion copy];
    
    NSURL *url = [NSURL URLWithString:thePath];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil && data != nil) {
            NSArray *recipients = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            completion(recipients, nil);
        }
        else {
            completion(nil, error);
        }
        
    }] resume];
    
}

#pragma mark - Image Themes Download

+(void)downloadImageThemesWithPath:(NSString *)thePath withCompletion:(void (^)(NSDictionary *, NSError *))block {
    [block copy];
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gw-static-apis.azurewebsites.net/data/liptip/moodthemes.json"]];
    
    NSURL *url = [NSURL URLWithString:thePath];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            NSDictionary *themes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            block(themes, nil);
        }
        else {
            block(nil, error);
        }
        
    }] resume];
    
    
    
}

+(void)downloadImageThemesWithRelativePath:(NSString *)theRelativePath withCompletion:(void (^)(NSDictionary *, NSError *error))block {
    [block copy];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gw-static-apis.azurewebsites.net/%@", theRelativePath]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
       
        
    }] resume];
    
}


#pragma mark - Matching Images and texts

+(void)downloadMatchingTextsForImageWithAreaName:(NSString *)theAreaName imageName:(NSString *)theImageName culture:(NSString *)theCulture withCompletion:(void (^)(NSDictionary *, NSError *))completion {
    [completion copy];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.cvd.io/popular/%@/matchingtexts/image/%@?culture=%@", theAreaName, theImageName, theCulture]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            completion(array.firstObject, error);
        }
        else {
            completion(nil, error);
        }
        
    }] resume];
    
}


#pragma mark - Image Downloading

+(void)downloadImageIdsForRelativePath:(NSString *)theRelativePath withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gw-static.azurewebsites.net/container/files/%@?size=small", theRelativePath]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            if (data != nil) {
                NSMutableArray *allImagePaths = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [allImagePaths removeLastObject];
                NSOrderedSet *imagePathsWithoutDoubles = [NSOrderedSet orderedSetWithArray:allImagePaths];
                NSArray *uniqueImagePaths = [imagePathsWithoutDoubles array];
                
                block(uniqueImagePaths, error);
            }
            else {
                
                // MARK: what to do when error and data is nil?
                
                block([NSArray array], nil);
            }
        }
        else {
            block(nil, error);
        }
        
    }] resume];
}

+(void)downloadImageIdsForIntentionSlug:(NSString *)theIntentionSlug withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gw-static.azurewebsites.net/container/files/specialoccasions/%@/default?size=small", theIntentionSlug]];
    NSLog(@"the url: %@", url);
    
    //good-night
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            if (data != nil) {
                NSMutableArray *allImagePaths = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [allImagePaths removeLastObject];
                NSOrderedSet *imagePathsWithoutDoubles = [NSOrderedSet orderedSetWithArray:allImagePaths];
                NSArray *uniqueImagePaths = [imagePathsWithoutDoubles array];
                
                block(uniqueImagePaths, error);
            }
            else {
                // MARK: What to do when error and data is nil?
                block([NSArray array], nil);
            }
        }
        else {
            block(nil, error);
        }
        
    }] resume];
}

+(void)downloadImageIdsForRecipientId:(NSString *)theRecipientId withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    NSString *recipientPath = nil;
    
    if ([theRecipientId isEqualToString:@"9E2D23"]) {
        recipientPath = @"sweetheart";
    }
    else if([theRecipientId isEqualToString:@"47B7E9"]) {
        recipientPath = @"loveinterest";
    }
    else if([theRecipientId isEqualToString:@"64C63D"] || [theRecipientId isEqualToString:@"BCA601"]) {
        recipientPath = @"parent";
    }
    else if([theRecipientId isEqualToString:@"87F524"] || [theRecipientId isEqualToString:@"3B9BF2"] || [theRecipientId isEqualToString:@"35AE93"] || [theRecipientId isEqualToString:@"2B4F14"]) {
        recipientPath = @"friend";
    }
    else if([theRecipientId isEqualToString:@"6E7DFB"]) {
        recipientPath = @"fbfriend";
    }
    else {
        recipientPath = @"sweetheart";
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gw-static.azurewebsites.net/container/files/cvd/%@?size=small", recipientPath]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            
            if (data != nil) {
                NSMutableArray *allImagePaths = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [allImagePaths removeLastObject];
                NSOrderedSet *imagePathsWithoutDoubles = [NSOrderedSet orderedSetWithArray:allImagePaths];
                NSArray *uniqueImagePaths = [imagePathsWithoutDoubles array];
                
                block(uniqueImagePaths, nil);
            }
            else {
                
                // MARK: what if the error gives us no data and no error?
                
                block([NSArray array], nil);
            }
            
        }
        else {
            block(nil, error);
        }

        
    }] resume];
}

+(NSData*)downloadImageWithRelativeImagePath:(NSString *)theImagePath {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", apiImagePath, theImagePath]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    return imageData;
    
}

+(NSData*)downloadImageWithImageURL:(NSString *)theImagePath {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", theImagePath]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    return imageData;
}

#pragma mark - Text Downloading


+(void)downloadTextsWithAreaName:(NSString *)theAreaName withIntentionId:(NSString *)theIntentionId withCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/intention/%@/texts", apiPath, theAreaName, theIntentionId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:theCulture forHTTPHeaderField:@"Accept-Language"];
    
    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            if (data != nil) {
                NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                block(array, error);
            }
            else {
                                
                block([NSArray array], nil);
            }
        }
        else {
            block(nil, error);
        }
        
    }] resume];
    
}

+(void)downloadTextsWithAreaName:(NSString *)theAreaName withIntentionSlug:(NSString *)theIntentionSlug withCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/texts", apiPath, theAreaName, theIntentionSlug]];
    
    NSLog(@"url for texts with intention slug: %@", url.absoluteString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:theCulture forHTTPHeaderField:@"Accept-Language"];
    

    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            if (data != nil) {
                NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                //NSLog(@"texts with intention slug: %@", array);
                
                block(array, error);
            }
            else {
                block([NSArray array], nil);
            }
        }
        else {
            block(nil, error);
        }
        
    }] resume];
     
}



#pragma mark - Intentions Downloading

+(void)downloadAllIntentionsWithCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/intentions", apiPath]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:theCulture forHTTPHeaderField:@"Accept-Language"];
    
    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
        if (error == nil) {
            if (data != nil) {
                NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                //NSLog(@"received all intentions: %@", array);
                
                block(array, error);
            }
            else {
                
                // MARK: What do do when data and error is nil?
                block([NSArray array], nil);
            }
        }
        else {
            block(nil, error);
        }
        
    }] resume];
}

+(NSURLSessionDataTask *)downloadIntentionsWithArea:(NSString *)theArea withCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/intentions", apiPath, theArea]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:theCulture forHTTPHeaderField:@"Accept-Language"];
    
    NSURLSessionDataTask *dataTask = [[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
        if (error == nil) {
            if (data != nil) {
                NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                block(array, error);
            }
            else {
                
                // MARK: What to do when data and error is nil
                
                block([NSArray array], nil);
            }
        }
        else {
            block(nil, error);
        }
        
    }];
    
    [dataTask resume];
    
    return dataTask;
    
}

#pragma mark - Area Downloading

+(void)downloadAllAreasWithCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/areas", apiPath]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:theCulture forHTTPHeaderField:@"Accept-Language"];
    
    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            if (data != nil) {
                NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"received areas: %@", array);
                
                block(array, error);
            }
            else {
                
                // Mark: What to do when data and error is nil
                
                block([NSArray array], nil);
            }
        }
        else {
            
            block(nil,error);
        }
        
    }] resume];
}

+(void)downloadArea:(NSString *)theAreaName withCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", apiPath, theAreaName]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:theCulture forHTTPHeaderField:@"Accept-Language"];
    
    [[[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
        if (error == nil) {
            if (data != nil) {
                NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"Received are: %@", array);
                
                block(array, error);
            }
            else {
                
                // MARK: What to do when error and data is nil
                
                block([NSArray array], nil);
            }
        }
        else {
            block(nil, error);
        }
        
    }] resume];
    
}

@end
