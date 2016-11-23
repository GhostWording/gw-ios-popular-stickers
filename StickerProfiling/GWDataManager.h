//
//  GWDataManager.h
//  GWFramework
//
//  Created by Mathieu Skulason on 24/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GWText, GWTag, GWArea, GWIntention, GWImage, GWRecipient, GWPersonalityQuestion;

/*
        Look into a different design for managed object contexts
        As portrayed here: http://www.cocoanetics.com/2012/07/multi-context-coredata/
*/

NS_ASSUME_NONNULL_BEGIN

@interface NSString (GWExtension)

/**
 @abstract Removes the following api urls from a newly creating string if they exist: http://az767698.vo.msecnd.net or http://gw-static.azurewebsites.net and returns the new copy without it.
 */
-(NSString*)c_stringByRemovingApiUrls;

@end

@interface GWDataManager : NSObject

#pragma mark - Local Data Store Methods Main Thread


// MARK: Designated Personality Question

-(GWPersonalityQuestion *)fetchPersonalityQuestionWithId:(NSString *)theId;
-(NSArray <GWPersonalityQuestion *> *)fetchPersonalityQuestionsWithIds:(nullable NSArray <NSString *> *)theIds;

// MARK: Designated Fetch Recipients
-(GWRecipient *)fetchRecipientWithId:(NSString *)theId;
-(NSArray <GWRecipient *> *)fetchRecipientsWithIds:(nullable NSArray *)theIds;

// MARK: New Designated Fetch Area Methods

-(NSArray*)fetchAreasOnMainThreadWithIds:(NSArray*)theAreaIds withAreaNames:(NSArray*)theAreaNames;
-(NSArray*)fetchAreasWithIds:(NSArray *)theAreaIds withAreaNames:(NSArray *)theAreaNames;


// MARK: New designated fetch intention methods

-(NSArray <GWIntention *> *)fetchIntentionsOnMainThreadWithAreaName:(nullable NSString*)theAreaName withIntentionIds:(nullable NSArray*)theIntentionIds;
-(NSArray <GWIntention *> *)fetchIntentionsWithAreaName:(nullable NSString*)theAreaName withIntentionsIds:(nullable NSArray*)theIntentionIds;


-(NSArray <GWIntention *> *)fetchIntentionsOnMainThreadWithAreaName:(nullable NSString *)theAreaName culture:(nullable NSString *)theCulture withIntentionIds:(nullable NSArray *)theIntentionIds;

-(NSArray <GWIntention *> *)fetchIntentionsWithAreaName:(nullable NSString *)theAreaName culture:(nullable NSString *)theCulture withIntentionsIds:(nullable NSArray *)theIntentionIds;


/* Returns the number of texts in the database **/
-(NSInteger)fetchNumTexts;

-(GWText* _Nullable)fetchTextOnMainThreadWithTextId:(nullable NSString*)theTextId withCulture:(nullable NSString*)theCulture;
-(GWText * _Nullable)fetchTextWithTextId:(nullable NSString*)theTextId withCulture:(nullable NSString*)theCulture;
-(NSArray <GWText *> *)fetchTextWithTextIds:(nonnull NSArray <NSString *> *)theTextIds withCulture:(nonnull NSString *)theCulture;

-(NSArray*)fetchTextsOnMainThreadWithIntentionIds:(nullable NSArray <NSString *> *)theIntentionIds withTag:(nullable NSString*)theTag withCulture:(nullable NSString*)theCulture;
-(NSArray*)fetchTextsWithIntentionIds:(nullable NSArray <NSString *> *)theIntentionIds withTag:(nullable NSString*)theTag withCulture:(nullable NSString*)theCulture;;
-(NSArray*)fetchTextsOnMainThreadIgnoringIntentionIds:(nullable NSArray <NSString *> *)theIntentionIds withTag:(nullable NSString*)theTag withCulture:(nullable NSString*)theCulture;
-(NSArray*)fetchTextsIgnoringIntentionIds:(nullable NSArray <NSString *> *)theIntentionIds withTag:(nullable NSString*)theTag withCulture:(nullable NSString*)theCulture;

/**
 New method that does exactly thesame kind of fetch as the other methods exact the tags that are used for the match or fetched from the tags string as they don't have any kind of relations to a tag objects.
 */
-(NSArray <GWText *> *)fetchTextsWithIntentionIds:(nullable NSArray *)theIntentionIds withTagsStrings:(nullable NSArray <NSString *> *)theTagsStrings withCulture:(nullable NSString *)theCulture;
-(NSArray <GWText *>*)fetchTextsIgnoringIntentionIds:(nullable NSArray*)theIntentionIds withTagsStrings:(nullable NSArray <NSString *> *)theTagsStrings withCulture:(nullable NSString*)theCulture;


// MARK: Tag methods

/** Designated Method Pattern */
-(GWTag *)fetchTagWithId:(NSString *)tagId;
-(NSArray *)fetchAllTagsOnMainThread;
-(NSArray *)fetchAllTags;
-(NSArray*)fetchTagsOnMainThreadWithNames:(NSArray*)theNames;
-(NSArray*)fetchTagsWithNames:(NSArray*)theNames;

/* **/
-(NSArray*)randomIndexesFromArray:(NSArray*)theArray withNumRandomIndexes:(NSInteger)numRandomIndexes;


// MARK: Images

/* Returns the number of images in the datastore. **/
-(NSInteger)fetchNumImages;

/* Fetches the gives number of images randomly in the database, images are not repeated. **/
-(NSArray*)fetchRandomImagesWithNum:(int)numImages;

//
-(NSArray*)fetchRandomImagesWithPredicate:(NSPredicate *)thePredicate withNum:(int)numImages;

-(NSArray*)fetchRandomImagesWithNum:(int)numImages ignoringImages:(NSArray*)theImageIdsIgnore numberOfImagesInDatabase:(int)numDBImages;

/** Fetch set images. */
-(NSSet *)fetchImageSetWithImagePaths:(NSArray *)theImagePaths;

/* Fetches all images. **/
-(NSArray*)fetchImages;

/* Fetches specific images based on the image path (id) in the data store if they exist. **/
-(NSArray*)fetchImagesWithImagePaths:(NSArray*)theImagePaths;

-(NSArray*)fetchRandomImagesOnBackgroundThreadWithNum:(int)numImages;
-(NSArray*)fetchImagesOnBackgroundThread;
-(NSArray*)fetchImagesWithImagePathsOnBackgroundThread:(NSArray*)theImagePaths;



#pragma mark - Local Data Store Helper Methods

-(NSArray *)updatedTextsWithArea:(NSString *)theArea intentionId:(NSString *)theIntentionId culture:(NSString *)theCulture texts:(NSArray *)theTexts;
/* takes the text dictionary serialized from the json and checks the array fetched from the local datastore if it exists, if it exists it returns,
 that object if not it returns a newly created GWText instance.**/
-(GWText*)persistTextOrUpdateWithJson:(NSDictionary*)textJson withArray:(NSArray*)theArray withContext:(NSManagedObjectContext*)theContext;
/* takes the area dictionary serialized from the json and checks the array fetched from the local datastore if it exists, if it exists it returns
 that object if not it returns a newly created GWText instance. **/
-(GWArea*)persistAreaOrUpdateWithJson:(NSDictionary*)areaJson withArray:(NSArray*)theArray withContext:(NSManagedObjectContext*)theContext;


-(GWText*)textWithId:(NSString*)theTextId inArray:(NSArray*)theArray;
-(GWTag*)tagWithId:(NSString*)theTagId inArray:(NSArray*)theArray;
-(GWIntention*)intentionWithId:(NSString*)theIntentionId inArray:(NSArray*)theArray;
-(GWArea*)areaWithId:(NSString*)theAreaId inArray:(NSArray*)theArray;
-(GWImage*)imageWithId:(NSString*)theImageId inArray:(NSArray*)theArray;

// MARK: Image helpers

/* Takes an array of strings (image paths in this case), and a second array which are removed from the first array if they match and returns the image paths left.  **/
-(NSArray*)removeImagePathsInArray:(NSArray*)theImagePaths withImagePathsToRemove:(NSArray*)theImagePathsToRemove;
/* Takes an array of strings (image paths in this case), and a second array of GWImage object and removes all paths that match with the image paths in the first array and returns an array with the image paths left. **/
-(NSArray *)removeImagePathsInArray:(NSArray*)theImagePaths withImagesToRemove:(NSArray*)theImagesToRemove;

#pragma mark - Download Methods

#pragma mark - Personality Question Download Method

-(void)downloadPersonalityQuestionsWithPath:(nullable NSString *)thePath completion:(void (^)(NSArray <GWPersonalityQuestion *> * _Nullable questions, NSError * _Nullable error))completion;

#pragma mark - Recipient Download Method

-(void)downloadRecipientsWithArea:(NSString *)theArea completion:(void (^)(NSArray <GWRecipient *> *recipients, NSError * _Nullable error))completion;

#pragma mark - Theme Download Method

// Mark: Theme download
-(void)downloadImageThemesWithPath:(NSString *)thePath withCompletion:(void (^)(NSDictionary  * _Nullable theImageThemes, NSError *_Nullable error))block;

#pragma mark - Image Download Methods

/**
 @abstract First it fetches all of the images that exist in the database and checks if any of the images with the given urls exist and only downloads those that do not currently exist in the database.
 */
-(void)downloadImagesAndPersistIfNotExistWithUrls:(NSArray <NSString *> *)theUrls withCompletion:(void (^)(NSArray *_Nullable theImageIds, NSError *_Nullable error))completion;
-(void)downloadImagesAndPersistWithUrls:(NSArray <NSString *> *)theUrls withCompletion:(void (^)(NSArray *_Nullable theImageIds, NSError *_Nullable error))block;
-(void)downloadImagesAndPersistWithRelativePath:(NSString*)theRelativePath withNumImagesToDownload:(NSInteger)theNumImages withCompletion:(void(^)(NSArray *theImageIds, NSError *error))block;
-(void)downloadImagesAndPersistWithIntentionSlug:(NSString*)theIntentionSlug withNumImagesToDownload:(NSInteger)theNumImages withCompletion:(void (^)(NSArray *theImageIds, NSError *error))block;
-(void)downloadImagesAndPersistWithRecipientId:(NSString*)theRecipientId withNumImagesToDownload:(NSInteger)theNumImages withCompletion:(void (^)(NSArray *theImageIds, NSError *error))block;

// without persistance
-(void)downloadImagePathsWithRelativePath:(NSString*)theRelativePath withCompletion:(void (^)(NSArray *theImagePaths, NSError *error))block;
-(void)downloadImagePathsWithIntentionSlug:(NSString*)theIntentionSlug withCompletion:(void (^)(NSArray *theImagePaths, NSError *error))block;
-(void)downloadImagePathsWithRecipientId:(NSString*)theRecipientId withCompletion:(void (^)(NSArray *theImagePaths, NSError *error))block;
-(void)downloadImagesWithUrls:(NSArray *)theImageUrls isRelativeURL:(BOOL)isRelative withCompletion:(void (^)(NSArray *, NSError *))block;
-(void)downloadImageWithRelativeUrl:(NSString*)theImageUrl withCompletion:(void (^)(NSString *imageId, NSError *error))block;

#pragma mark - Text Download Methods

-(void)downloadAllTextsWithBlockForArea:(NSString *)theArea withCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block;

-(void)downloadAllTextsForArea:(NSString *)theArea withCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *, NSError *))block;

/* Downloads all the texts with the given intention id in the array and returns all the textIds associated. **/
-(void)downloadTextsWithArea:(NSString*)theArea withIntentionIds:(NSArray*)theIntentionsIds withCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *textIds, NSError *error))block;
/* Downloads the texts for a given intention id with an asynchruous NSURLSession data task. **/
-(void)downloadTextsWithArea:(NSString*)theArea withIntentionId:(NSString*)intentionId withCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *textIds, NSError *error))block;



#pragma mark - Intention Download Methods

/* Downloads all the intentions associated with an area. **/
-(NSURLSessionDataTask *)downloadIntentionsWithArea:(NSString*)theArea withCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *intentionIds, NSError *_Nullable error))block;

#pragma mark - Text Dwonload Methods

/* Downloads all areas  **/
-(void)downloadAllAreasWithCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *areaIds, NSError *error))block;
/* Download Area for the given area name with the given culture **/
-(void)downloadArea:(NSString*)theAreaName withCulture:(NSString*)theCulture withCompletion:(void (^)(NSString *areaId, NSError *error))block;

@end

NS_ASSUME_NONNULL_END
