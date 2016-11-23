//
//  GWImageManager.m
//  PopularStickers
//
//  Created by Mathieu Skulason on 08/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "GWImageManager.h"
#import "GWCoreDataManager.h"
#import "GWDataManager.h"
#import "GWImage.h"
#import "GWImageWithThumb.h"

static NSURLSession *_session = nil;

@implementation GWImageManager


#pragma mark - GWImageWithThumb fetching



#pragma mark - GWImage fetching


+(GWImage *)fetchImageWithPath:(NSString *)thePath {
    
    NSString *imageId = [NSString removeApiPathFromImagePath:thePath];
    
    NSArray *images = [[GWDataManager new] fetchImagesWithImagePaths: @[imageId] ];
    
    return images.firstObject;
}

+(NSArray <GWImage *> *)fetchImagesWithPaths:(NSArray <NSString *> *)thePaths {
    
    NSMutableArray *newImageIds = [NSMutableArray arrayWithArray:thePaths];
    
    for (NSString *path in thePaths) {
        [newImageIds addObject: [NSString removeApiPathFromImagePath:path] ];
    }
    
    NSArray *images = [[GWDataManager new] fetchImagesWithImagePaths: newImageIds ];
    
    return images;
}

+(NSArray <GWImage *> *)fetchImagesContainingPartialPath:(NSString *)thePartialPath {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId CONTAINS[cd] %@", thePartialPath];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([GWImage class])];
    [request setPredicate:predicate];
    
    NSArray *images = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:request error:nil];
    
    return images;
    
}



#pragma mark - Popular Image Download

+(NSURLSessionTask * _Nullable)downloadPopularImagesWithArea:(NSString *)theArea intentionId:(NSString *)theIntentionId completion:(void (^)(NSDictionary *, NSError *))completion {
    [completion copy];
    
    NSString *thePath = [NSString stringWithFormat:@"http://api.cvd.io/popular/%@/popularimages/intention/%@", theArea, theIntentionId];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: thePath]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionTask *task = [[self p_session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            completion(dict, nil);
        }
        else {
            completion(nil, error);
        }
        
    }];
    
    [task resume];
    
    return task;
}



#pragma mark - Image download and persistance


+(NSURLSessionTask *)downloadImageIfNotExistsWithPath:(NSString *)thePath imageDataCompletion:(void (^)(NSString *, NSData *, NSError *))completion {
    [completion copy];
    
    GWImage *image = [self fetchImageWithPath:thePath];
    if (image != nil) {
        completion(image.imageId, image.imageData, nil);
        return nil;
    }
    
    return [self downloadImageWithPath:thePath completion:^(NSString *imagePath, NSData *imageData, NSError *error) {
        
        if (error == nil) {
            NSString *imageIdWithoutPath = [NSString addSlashForPath:[NSString removeApiPathFromImagePath:imagePath]];

            [GWImage createGWImageWithImagePath:imageIdWithoutPath withImageData:imageData withManagedContext:nil];
            [[[GWCoreDataManager sharedInstance] childContext] save:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(imageIdWithoutPath, imageData, error);
                
            });
            
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(nil, nil, error);
                
            });
            
        }
        
    }];
}


+(NSURLSessionTask *)downloadImagesIfNotExistsWithPath:(NSString *)thePath persistedGWImageCompletion:(void (^)(GWImage * _Nullable, NSError * _Nullable))completion {
    
    GWImage *image = [self fetchImageWithPath:thePath];
    if (image != nil) {
        completion(image, nil);
        return nil;
    }
    
    return [self downloadImageWithPath:thePath completion:^(NSString * _Nullable imageId, NSData *_Nullable imageData, NSError *_Nullable error) {
        
        if (error == nil) {
            NSString *uniqueId = [NSString getImageNameFromPath:thePath];
            GWImage *newImage = [GWImage createGWImageWithImagePath:uniqueId withImageData:imageData withManagedContext:nil];
            completion(newImage, nil);
        }
        else {
            completion(nil, error);
        }
        
    }];
}



#pragma mark - Image Downloading

+(NSURLSession *)p_session {
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.HTTPMaximumConnectionsPerHost = 6;
        
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    return _session;
}

+(NSArray <NSURLSessionTask *> *)downloadImagesWithPaths:(NSArray<NSString *> *)thePaths singleImageCompletion:(void (^)(NSString * _Nullable, NSData * _Nullable, NSError * _Nullable))completion {
    [completion copy];
    
    NSMutableArray *sessionTasks = [NSMutableArray array];
    
    for (NSString *path in thePaths) {
        NSURLSessionTask *task = [self downloadImageWithPath:path completion:completion];
        [sessionTasks addObject:task];
    }
    
    return sessionTasks;
}

+(NSArray <NSURLSessionTask *> *)downloadImagesWithPaths:(NSArray <NSString *> *)thePaths completion:(void (^)(NSArray <NSString *> *imagePaths, NSArray <NSData *> *dataForImages, NSError *error))completion {
    [completion copy];
    
    NSMutableArray *sessionTasks = [NSMutableArray array];
    
    for (NSString *path in thePaths) {
        NSURLSessionTask *task = [self downloadImageWithPath:path completion:^(NSString *imagePath, NSData *imageData, NSError *error) {
            
        }];
        [sessionTasks addObject:task];
    }
    
    return sessionTasks;
}




+(NSURLSessionTask *)downloadImageWithPath:(NSString *)thePath completion:(void (^)(NSString * _Nullable imagePath, NSData * _Nullable imageData, NSError * _Nullable error))completion {
    [completion copy];
    
    NSURL *url = [NSURL URLWithString: [NSString addApiPathToImagePath:thePath] ];
    
    NSURLSessionTask *task =[[self p_session] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *downloadedData = [NSData dataWithContentsOfURL:location];
        
        completion(thePath, downloadedData, error);
        
        
    }];
    
    [task resume];
    
    return task;
}


@end


@implementation NSString (GWImageManagerCategory)

#pragma mark - String Category Helpers

+(NSString *)removeSlashFromPath:(NSString *)thePath {
    
    NSMutableString *theNewPath = [NSMutableString stringWithString:thePath];
    
    if ([theNewPath hasPrefix:@"/"] == YES) {
        return [theNewPath stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    
    return theNewPath;
}

+(NSString *)addSlashForPath:(NSString *)thePath {
    
    NSString *theNewPath = [NSString stringWithString:thePath];
    
    if ([theNewPath hasPrefix:@"/"] == NO) {
        theNewPath = [NSString stringWithFormat:@"/%@", thePath];
    }
    
    return theNewPath;
}

+(NSString *)addApiPathToImagePath:(NSString *)thePath {
    
    NSString *theNewPath = [NSString stringWithString: thePath];
    
    if ([theNewPath hasPrefix:@"http://gw-static.azurewebsites.net/"] == NO && [theNewPath hasPrefix:@"http://az767698.vo.msecnd.net/"] == NO) {
        theNewPath = [NSString stringWithFormat:@"%@%@", @"http://gw-static.azurewebsites.net/", [self addSlashForPath:thePath] ];
    }
    
    return theNewPath;
}

+(NSString *)removeApiPathFromImagePath:(NSString *)thePath {
    
    NSMutableString *mutableImageId = [NSMutableString stringWithString:thePath];
    if ([thePath hasPrefix:@"http://gw-static.azurewebsites.net"] == YES) {
        [mutableImageId deleteCharactersInRange:NSMakeRange(0, [NSString stringWithFormat:@"http://gw-static.azurewebsites.net"].length)];
    }
    else if([thePath hasPrefix:@"http://az767698.vo.msecnd.net"] == YES) {
        [mutableImageId deleteCharactersInRange:NSMakeRange(0, [NSString stringWithFormat:@"http://az767698.vo.msecnd.net"].length)];
    }
    
    return mutableImageId;
}

+(NSString *)getImageNameFromPath:(NSString *)thePath {
    
    NSString *theNewPath = [NSString stringWithString:thePath];
    
    NSArray *pathComponents = [theNewPath componentsSeparatedByString:@"/"];
    
    return [pathComponents lastObject];
}

@end
