//
//  GWImageManager.h
//  PopularStickers
//
//  Created by Mathieu Skulason on 08/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GWImage;

NS_ASSUME_NONNULL_BEGIN

@interface NSString (GWImageManagerCategory)

/**
 @abstract removes a slash from the path if there is a slash as the first character for the url.
 */
+(NSString *)removeSlashFromPath:(NSString *)thePath;

/**
 @abstract Adds a slash for path if there is none at the beginning of the url.
 */
+(NSString *)addSlashForPath:(NSString *)thePath;

/**
 @abstract Adds the api path to the image path passed in, checks if a backslash is missing or if it is required.
 */
+(NSString *)addApiPathToImagePath:(NSString *)thePath;

/**
 @abstract Removes an api path from the image path, leaving it with a backslash at the beginning of the path.
 */
+(NSString *)removeApiPathFromImagePath:(NSString *)thePath;

/**
 @abstract Gets the name for the image by finding its last component from the path.
 */
+(NSString *)getImageNameFromPath:(NSString *)thePath;

@end

@interface GWImageManager : NSObject

// MARK: Image Fetching

/**
 @abstract Fetches the image with path, removes all its components and only takes the actual image name, works as a better unique id than the whole path.
 */
+(GWImage  * _Nullable )fetchImageWithPath:(NSString *)thePath;

/**
 @abstract Fetchs the image with paths by removing all its components and only takes the actual image name as a unique id instead of the whole path.
 */
+(NSArray <GWImage *> *)fetchImagesWithPaths:(NSArray <NSString *> *)thePaths;

/**
 @abstract Fetches all images that contain a partial path for example to find all images for a specific intention.
 */
+(NSArray <GWImage *> *)fetchImagesContainingPartialPath:(NSString *)thePartialPath;



// MARK: Popular Image Download

+(NSURLSessionTask *_Nullable)downloadPopularImagesWithArea:(NSString *)theArea intentionId:(NSString *)theIntentionId completion:(void (^)(NSDictionary * _Nullable textDict, NSError * _Nullable error))completion;



// MARK: Image download with persistance

/**
 @abstract Downloads the image if it does not exist, creates it and returns its data on the main thread since NSData and NSString are both thread safe. If the image exist we send its data with the completion block.
 */
+(NSURLSessionTask * _Nullable)downloadImageIfNotExistsWithPath:(NSString *)thePath imageDataCompletion:(void (^)(NSString *_Nullable imageId, NSData *_Nullable imageData, NSError *_Nullable error))completion;

/**
 @abstract Downloads the image if it does not exist, creates it and returns it on the main thread. If it exists it returns the image on the main thread.
 */
+(NSURLSessionTask * _Nullable)downloadImagesIfNotExistsWithPath:(NSString *)thePath persistedGWImageCompletion:(void (^)(GWImage * _Nullable image, NSError * _Nullable error))completion;


// MARK: Image Downloading without persistance

+(NSURLSessionTask *)downloadImageWithPath:(NSString *)thePath completion:(void (^)(NSString *_Nullable imageId, NSData *_Nullable imageData, NSError *_Nullable error))completion;

/**
 @abstract Download images with the given paths and send one completion block when all images have been downloaded
 @warning currently not implemented
 */
+(NSArray <NSURLSessionTask *> *)downloadImagesWithPaths:(NSArray <NSString *> *)thePaths completion:(void (^)(NSArray <NSString *> * _Nullable imageIds, NSArray <NSData *> * _Nullable dataForImages, NSError * _Nullable error))completion;

/**
 @abstract download images with the given paths and call the completion block for each and every image downloaded
 */
+(NSArray <NSURLSessionTask *> *)downloadImagesWithPaths:(NSArray <NSString *> *)thePaths singleImageCompletion:(void (^)(NSString *_Nullable imageId, NSData *_Nullable imageData, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END