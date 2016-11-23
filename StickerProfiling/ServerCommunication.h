//
//  ServerCommunication.h
//  GWFramework
//
//  Created by Mathieu Skulason on 20/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerCommunication : NSObject

// MARK: Personality Questions
+(void)downloadPersonalityQuestionsWithPath:(NSString *)thePath completion:(void (^)(NSArray  <NSDictionary *> *questions, NSError *error))completion;
+(void)downloadPersonalityQuestionsToAskWithPath:(NSString *)thePath completion:(void (^)(NSArray <NSString *> *questionIds, NSError *error))completion;

// MARK: Recipient download
+(void)downloadRecipientsWithPath:(NSString *)thePath completion:(void (^)(NSArray *recipients, NSError *error))completion;

// Mark: Theme download
+(void)downloadImageThemesWithPath:(NSString *)thePath withCompletion:(void (^)(NSDictionary *, NSError *))block;

// MARK: Image download
+(void)downloadImageIdsForRelativePath:(NSString*)theRelativePath withCompletion:(void (^)(NSArray *theImagePaths, NSError *error))block;
+(void)downloadImageIdsForIntentionSlug:(NSString*)theIntentionSlug withCompletion:(void (^)(NSArray *theImagePaths, NSError *error))block;
+(void)downloadImageIdsForRecipientId:(NSString*)theRecipientId withCompletion:(void (^)(NSArray *theImagePaths, NSError *error))block;
+(NSData*)downloadImageWithRelativeImagePath:(NSString*)theImagePath;
+(NSData*)downloadImageWithImageURL:(NSString *)theImagePath;


// MARK: Matching Text Downloads
+(void)downloadMatchingTextsForImageWithAreaName:(NSString *)theAreaName imageName:(NSString *)theImageName culture:(NSString *)theCulture withCompletion:(void (^)(NSDictionary *matchingsTextsForImage, NSError *error))completion;

// MARK: Text Downloads
+(void)downloadTextsWithAreaName:(NSString*)theAreaName withIntentionId:(NSString*)theIntentionId withCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *theTexts, NSError *error))block;
+(void)downloadTextsWithAreaName:(NSString *)theAreaName withIntentionSlug:(NSString *)theIntentionSlug withCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *, NSError *))block;

// MARK: Intention downloads

/* Currently not supported as the data is not fully constructed **/
+(void)downloadAllIntentionsWithCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *intentions, NSError *error))block;
+(NSURLSessionDataTask *)downloadIntentionsWithArea:(NSString*)theArea withCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *intentions, NSError *error))block;

// MARK: Area Downloads

+(void)downloadAllAreasWithCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *theAreas, NSError *error))block;
+(void)downloadArea:(NSString*)theAreaName withCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *intentions, NSError *error))block;

@end
