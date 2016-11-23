//
//  GWDataManager.m
//  GWFramework
//
//  Created by Mathieu Skulason on 24/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "GWDataManager.h"
#import "ServerCommunication.h"
#import "GWCoreDataManager.h"

// data Objects
#import "GWArea.h"
#import "GWIntention.h"
#import "GWText.h"
#import "GWTag.h"
#import "GWImage.h"
#import "GWRecipient.h"
#import "GWPersonalityQuestion.h"

@interface GWDataManager () {

}

@end

// Text category

@implementation NSString (GWExtension)

-(NSString*)c_stringByRemovingApiUrls {
    
    NSString *newString = [self copy];
    
    newString = [newString stringByReplacingOccurrencesOfString:@"http://az767698.vo.msecnd.net" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"http://gw-static.azurewebsites.net" withString:@""];
    
    return newString;
}

@end

@implementation GWDataManager

-(id)init {
    if (self = [super init]) {

    }
    
    return self;
}

#pragma mark - Fetch Personality Question

-(GWPersonalityQuestion *)fetchPersonalityQuestionWithId:(NSString *)theId {
    
    return [[self fetchPersonalityQuestionsWithIds: @[theId]] firstObject];
}

-(NSArray <GWPersonalityQuestion *> *)fetchPersonalityQuestionsWithIds:(NSArray<NSString *> *)theIds {
    
    NSMutableString *predicateString = [NSMutableString string];
    NSMutableArray *arguments = [NSMutableArray array];
    
    if (theIds != nil) {
        
        for (int i = 0; i < theIds.count; i++) {
            
            NSString *questionId = [theIds objectAtIndex: i];
            
            [predicateString appendString:[NSString stringWithFormat:@"personalityQuestionId == '%@'", questionId]];
            [arguments addObject: questionId];
            
            if (predicateString.length != 0 && i < theIds.count - 1) {
                [predicateString appendString: @" OR "];
            }
            
        }
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: NSStringFromClass([GWPersonalityQuestion class])];
    
    if (predicateString.length != 0) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString argumentArray: arguments]];
    }
    
    NSArray <GWPersonalityQuestion *> *questions = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest: fetchRequest error: nil];
    
    return questions;
}

#pragma mark - Fetching Recipients Designated method pattern

-(GWRecipient *)fetchRecipientWithId:(NSString *)theId {
    
    NSMutableString *predicateString = [NSMutableString string];
    NSMutableArray *arguments = [NSMutableArray array];
    
    [predicateString appendString:[NSString stringWithFormat:@"recipientId == '%@'", theId]];
    [arguments addObject:theId];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([GWRecipient class])];
    
    [request setPredicate:[NSPredicate predicateWithFormat:predicateString argumentArray:arguments]];
    
    NSArray *recipients = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:request error:nil];
    
    return [recipients firstObject];
    
}

-(NSArray *)fetchRecipientsWithIds:(NSArray *)theIds {
    
    NSMutableString *predicateString = [NSMutableString string];
    NSMutableArray *arguments = [NSMutableArray array];
    
    if (theIds != nil) {
        int i = 0;
        for (NSString *currentId in theIds) {
            
            [predicateString appendString:[NSString stringWithFormat:@"recipientId == '%@'", currentId]];
            [arguments addObject:currentId];
            
            i++;
            if (predicateString.length != 0 && i != theIds.count) {
                [predicateString appendString:@" OR "];
            }
        }
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([GWRecipient  class])];
    
    if (predicateString.length != 0) {
        [request setPredicate:[NSPredicate predicateWithFormat:predicateString argumentArray:arguments]];
    }
    
    NSArray *recipients = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:request error:nil];
    
    return recipients;
    
}

#pragma mark - Tag Designated Method Pattern

-(NSArray*)d_fetchTagsWithNames:(NSArray *)theNames {
    
    NSMutableString *predicateString = [[NSMutableString alloc] init];
    NSMutableArray *arguments = [NSMutableArray array];
    
    if (theNames != nil) {
        
        int count = 0;
        for (NSString *tagName in theNames) {
            
            [arguments addObject:tagName];
            
            count++;
            [predicateString appendString:[NSString stringWithFormat:@"tagId == '%@'", tagName]];
            
            if (count != theNames.count) {
                [predicateString appendString:@" OR "];
            }
            
        }
        
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GWTag"];
    
    if (predicateString.length != 0) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString argumentArray:arguments]];
    }
    
    NSArray *tags = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:fetchRequest error:nil];
    
    return tags;
    
}

-(GWTag *)fetchTagWithId:(NSString *)tagId {
    NSArray *tags = [self d_fetchTagsWithNames:@[tagId]];
    if (tags.count == 0) {
        return nil;
    }
    
    return [tags firstObject];
}

-(NSArray *)fetchAllTagsOnMainThread {
    [self assertMainThread];
    
    return [self d_fetchTagsWithNames:nil];
}

-(NSArray *)fetchAllTags {
    return [self d_fetchTagsWithNames:nil];
}

-(NSArray*)fetchTagsOnMainThreadWithNames:(NSArray *)theNames {
    
    [self assertMainThread];
    
    return [self d_fetchTagsWithNames:theNames];
}

-(NSArray*)fetchTagsWithNames:(NSArray *)theNames {
    return [self d_fetchTagsWithNames:theNames];
}

#pragma mark - Text Designated Method Pattern

-(GWText*)d_fetchTextWithTextId:(NSString*)theTextId withCulture:(NSString*)theCulture {
    
    NSMutableString *predicateString = [[NSMutableString alloc] init];
    
    if (theTextId == nil) {
        return nil;
    }
    
    [predicateString appendString:[NSString stringWithFormat:@"textId LIKE[c] '%@'", theTextId]];
    
    if (theCulture != nil) {
        [predicateString appendString:[NSString stringWithFormat:@" AND culture LIKE[c] '%@'", theCulture]];
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWText"];
    [request setPredicate:[NSPredicate predicateWithFormat:predicateString]];
    
    NSArray *texts = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:request error:nil];
    
    return [texts firstObject];
}

-(NSArray*)d_fetchTextsWithIntentionIds:(NSArray *)theIntentionIds inverseIntentionIdsSelection:(BOOL)inverseIntentionIdsSelection withTag:(NSString *)theTag withCulture:(NSString *)theCulture {
    
    NSMutableString *predicateString = [[NSMutableString alloc] init];
    NSMutableArray *arguments = [NSMutableArray array];
    
    if (theIntentionIds != nil) {
        
        [arguments addObject:theIntentionIds];
        
        if (inverseIntentionIdsSelection == YES) {
            
            
            for (NSString *currentIntentionIdToIgnore in theIntentionIds) {
                
                if (predicateString.length > 0) {
                    [predicateString appendString:@" AND "];
                }
                
                [predicateString appendString:[NSString stringWithFormat:@"intentionId != '%@'", currentIntentionIdToIgnore]];
                
            }
            
        }
        else {
            
            // as this is an or statement we need to guard it with parenthesis
            
            [predicateString appendString:@"("];
            
            for (NSString *currentIntentionId in theIntentionIds) {
                
                if (predicateString.length > 1 ) {
                    [predicateString appendString:@" OR "];
                }
                
                [predicateString appendString:[NSString stringWithFormat:@"intentionId LIKE[c] '%@'", currentIntentionId]];
            }
            
            [predicateString appendString:@")"];

        }
    }
    
    
    if (theTag != nil) {
        
        [arguments addObject:theTag];
        
        if (predicateString.length != 0) {
            [predicateString appendString:@" AND "];
        }
        
        //
        [predicateString appendString:[NSString stringWithFormat:@"'%@' IN tagIds.tagId", theTag]];
    }
    
    if (theCulture != nil) {
        
        [arguments addObject:theCulture];
        
        if (predicateString.length != 0) {
            [predicateString appendString:@" AND "];
        }
        
        [predicateString appendString:[NSString stringWithFormat:@"culture LIKE[c] '%@'", theCulture]];
    }
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWText"];
    if (predicateString != nil && predicateString.length != 0) {
        [request setPredicate:[NSPredicate predicateWithFormat:predicateString argumentArray:arguments]];
    }
    
    NSArray *theTexts = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:request error:nil];
    
    return theTexts;
}

-(NSArray*)d_fetchTextsWithIntentionIds:(NSArray *)theIntentionIds inverseIntentionIdsSelection:(BOOL)inverseIntentionIdsSelection withTagsString:(NSArray *)theTagsStrings withCulture:(NSString *)theCulture {
    
    NSMutableString *predicateString = [[NSMutableString alloc] init];
    NSMutableArray *arguments = [NSMutableArray array];
    
    if (theIntentionIds != nil) {
        
        [arguments addObject:theIntentionIds];
        
        if (inverseIntentionIdsSelection == YES) {
            
            
            for (NSString *currentIntentionIdToIgnore in theIntentionIds) {
                
                if (predicateString.length > 0) {
                    [predicateString appendString:@" AND "];
                }
                
                [predicateString appendString:[NSString stringWithFormat:@"intentionId != '%@'", currentIntentionIdToIgnore]];
                
            }
            
        }
        else {
            
            // as this is an or statement we need to guard it with parenthesis
            
            [predicateString appendString:@"("];
            
            for (NSString *currentIntentionId in theIntentionIds) {
                
                if (predicateString.length > 1 ) {
                    [predicateString appendString:@" OR "];
                }
                
                [predicateString appendString:[NSString stringWithFormat:@"intentionId LIKE[c] '%@'", currentIntentionId]];
            }
            
            [predicateString appendString:@")"];
            
        }
    }
    
    
    if (theTagsStrings != nil && theTagsStrings.count != 0) {
        
        
        if (predicateString.length != 0) {
            [predicateString appendString:@" AND "];
        }
        
        int i = 0;
        for (NSString *tagId in theTagsStrings) {
            
            [arguments addObject:tagId];
            
            if (i != 0) {
                [predicateString appendString:@" AND "];
            }
            
            [predicateString appendString:[NSString stringWithFormat:@"tagsString contains[c] '%@'", tagId]];
            
            i++;
        }
        
        NSLog(@"predicate string after tags is: %@", predicateString);
        
    }
    
    if (theCulture != nil) {
        
        [arguments addObject:theCulture];
        
        if (predicateString.length != 0) {
            [predicateString appendString:@" AND "];
        }
        
        [predicateString appendString:[NSString stringWithFormat:@"culture LIKE[c] '%@'", theCulture]];
    }
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWText"];
    if (predicateString != nil && predicateString.length != 0) {
        [request setPredicate:[NSPredicate predicateWithFormat:predicateString argumentArray:arguments]];
    }
    
    NSArray *theTexts = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:request error:nil];
    
    return theTexts;
    
}

-(GWText*)fetchTextOnMainThreadWithTextId:(NSString*)theTextId withCulture:(NSString*)theCulture {
    
    [self assertMainThread];
    
    GWText *text = [self d_fetchTextWithTextId:theTextId withCulture:theCulture];

    return text;
}

-(GWText*)fetchTextWithTextId:(NSString *)theTextId withCulture:(NSString *)theCulture {
    
    return [self d_fetchTextWithTextId:theTextId withCulture:theCulture];
}


-(NSArray*)fetchTextsOnMainThreadWithIntentionIds:(NSArray *)theIntentionIds withTag:(NSString *)theTag withCulture:(NSString *)theCulture {
    
    [self assertMainThread];
    
    NSArray *texts = [self d_fetchTextsWithIntentionIds:theIntentionIds inverseIntentionIdsSelection:NO withTag:theTag withCulture:theCulture];
    
    return texts;
}

-(NSArray*)fetchTextsWithIntentionIds:(NSArray *)theIntentionIds withTag:(NSString *)theTag withCulture:(NSString *)theCulture {
    
    return [self d_fetchTextsWithIntentionIds:theIntentionIds inverseIntentionIdsSelection:NO withTag:theTag withCulture:theCulture];
}

-(NSArray*)fetchTextsOnMainThreadIgnoringIntentionIds:(NSArray *)theIntentionIds withTag:(NSString *)theRecipientType withCulture:(NSString *)theCulture {
    
    [self assertMainThread];
    
    NSArray *texts = [self d_fetchTextsWithIntentionIds:theIntentionIds inverseIntentionIdsSelection:YES withTag:theRecipientType withCulture:theCulture];
    
    return texts;
}

-(NSArray*)fetchTextsIgnoringIntentionIds:(NSArray *)theIntentionIds withTag:(NSString *)theRecipientType withCulture:(NSString *)theCulture {
    
    return [self d_fetchTextsWithIntentionIds:theIntentionIds inverseIntentionIdsSelection:YES withTag:theRecipientType withCulture:theCulture];
}


// MARK: Using Tags Strings

-(NSArray *)fetchTextsIgnoringIntentionIds:(NSArray *)theIntentionIds withTagsStrings:(NSArray<NSString *> *)theTagsStrings withCulture:(NSString *)theCulture {
    
    return [self d_fetchTextsWithIntentionIds:theIntentionIds inverseIntentionIdsSelection:YES withTagsString:theTagsStrings withCulture:theCulture];
    
}

-(NSArray *)fetchTextsWithIntentionIds:(NSArray *)theIntentionIds withTagsStrings:(NSArray<NSString *> *)theTagsStrings withCulture:(NSString *)theCulture {
    
    return [self d_fetchTextsWithIntentionIds:theIntentionIds inverseIntentionIdsSelection:NO withTagsString:theTagsStrings withCulture:theCulture];
    
}

#pragma mark - Intention Designated Method Pattern

-(NSArray <GWIntention *> *)d_fetchIntentionsWithAreaName:(NSString *)theAreaName culture:(NSString *)theCulture withIntentionId:(NSArray *)theIntentionIds {
    
    NSMutableString *predicateString = [[NSMutableString alloc] init];
    NSMutableArray *arguments = [NSMutableArray array];
    
    if (theAreaName != nil) {
        [arguments addObject:theAreaName];
        [predicateString appendString:[NSString stringWithFormat:@"areaName == '%@'", theAreaName]];
    }
    
    if (theCulture != nil) {
        
        if (predicateString.length != 0) {
            [predicateString appendString:@" AND "];
        }
        
        [arguments addObject:theCulture];
        [predicateString appendString:[NSString stringWithFormat:@"culture == '%@'", theCulture]];
        
    }
    
    if (theIntentionIds != nil) {
        
        if (predicateString.length != 0) {
            [predicateString appendString:@" AND "];
        }
        
        [predicateString appendString:@"("];
        
        int count = 0;
        for (NSString *intentionId in theIntentionIds) {
            
            count++;
            
            [arguments addObject:intentionId];
            [predicateString appendString:[NSString stringWithFormat:@"intentionId == '%@'", intentionId]];
            
            if (count != theIntentionIds.count) {
                [predicateString appendString:@" OR "];
            }
            
        }
        
        [predicateString appendString:@")"];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GWIntention"];
    if (predicateString.length != 0) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString argumentArray:arguments]];
    }
    
    NSArray *intentions = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:fetchRequest error:nil];
    
    return intentions;
}

-(NSArray <GWIntention *> *)fetchIntentionsOnMainThreadWithAreaName:(NSString *)theAreaName withIntentionIds:(NSArray *)theIntentionIds {
    
    [self assertMainThread];
    
    return [self d_fetchIntentionsWithAreaName:theAreaName culture:nil withIntentionId:theIntentionIds];
}

-(NSArray <GWIntention *> *)fetchIntentionsWithAreaName:(NSString*)theAreaName withIntentionsIds:(NSArray*)theIntentionIds {
    
    return [self d_fetchIntentionsWithAreaName:theAreaName culture:nil withIntentionId:theIntentionIds];
    
}

-(NSArray <GWIntention *> *)fetchIntentionsOnMainThreadWithAreaName:(NSString *)theAreaName culture:(NSString *)theCulture withIntentionIds:(NSArray *)theIntentionIds {
    
    [self assertMainThread];
    
    return [self d_fetchIntentionsWithAreaName:theAreaName culture:theCulture withIntentionId:theIntentionIds];
}

-(NSArray <GWIntention *> *)fetchIntentionsWithAreaName:(nullable NSString *)theAreaName culture:(nullable NSString *)theCulture withIntentionsIds:(nullable NSArray *)theIntentionIds {
    
    return [self d_fetchIntentionsWithAreaName:theAreaName culture:theCulture withIntentionId:theIntentionIds];
}

#pragma mark - Area Designated Method Pattern

-(NSArray*)d_fetchAreasWithIds:(NSArray*)theAreaIds withAreaNames:(NSArray*)theAreaNames {
    
    NSMutableString *predicateString = [[NSMutableString alloc] init];
    NSMutableArray *arguments = [NSMutableArray array];
    
    if (theAreaIds != nil) {
        
        [predicateString appendString:@"( "];
        
        int count = 0;
        for (NSString *areaId in theAreaIds) {
            
            count++;
            
            [arguments addObject:areaId];
            [predicateString appendString:[NSString stringWithFormat:@"areaId == '%@'", areaId]];
            
            if (count != theAreaIds.count) {
                [predicateString appendString:@" OR "];
            }
            
        }
        
        [predicateString appendString:@" )"];
        
    }
    
    if (theAreaNames != nil) {
        
        if (predicateString.length != 0) {
            [predicateString appendString:@" AND "];
        }
        
        [predicateString appendString:@"( "];
        
        int count = 0;
        for (NSString *areaName in theAreaNames) {
            
            count++;
            [arguments addObject:areaName];
            [predicateString appendString:[NSString stringWithFormat:@"name == '%@'", areaName]];
            
            if (count != theAreaNames.count) {
                [predicateString appendString:@" OR "];
            }
            
        }
        
        [predicateString appendString:@" )"];
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWArea"];
    if (predicateString.length != 0) {
        [request setPredicate:[NSPredicate predicateWithFormat:predicateString argumentArray:arguments]];
    }
    
    NSArray *areas = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:request error:nil];
    
    return areas;
    
}

-(NSArray*)fetchAreasOnMainThreadWithIds:(NSArray *)theAreaIds withAreaNames:(NSArray *)theAreaNames {
    
    [self assertMainThread];
    
    return [self d_fetchAreasWithIds:theAreaIds withAreaNames:theAreaNames];
}

-(NSArray*)fetchAreasWithIds:(NSArray *)theAreaIds withAreaNames:(NSArray *)theAreaNames {
    return [self d_fetchAreasWithIds:theAreaIds withAreaNames:theAreaNames];
}

#pragma mark - Designated Method Helper

-(void)assertMainThread {
    if ([NSThread isMainThread] == NO) {
        NSLog(@"running a main thread method in the background");
        abort();
    }
}

#pragma mark - Local data store

// MARK: Area methods

-(NSArray*)fetchAreas {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWArea"];
    NSArray *theAreas = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:request error:nil];
    
    return theAreas;
}

// MARK: Intention methods

-(NSArray*)fetchIntentions {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWIntention"];
    NSArray *theIntentions = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:request error:nil];
    
    return theIntentions;
}

-(NSArray*)fetchIntentionsWithCulture:(NSString *)theCulture {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"culture like[c] '%@'", theCulture]];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWIntention"];
    [request setPredicate:predicate];
    
    NSArray *theIntentions = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:request error:nil];
    
    return theIntentions;
}

-(NSArray*)fetchIntentionsWithArea:(NSString*)theArea withCulture:(NSString*)theCulture {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"culture like[c] '%@' AND areaName like[c] '%@'", theCulture, theArea]];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWIntention"];
    [request setPredicate:predicate];
    
    NSArray *intentions = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:request error:nil];
    
    return intentions;
}

-(NSArray *)fetchIntentionsWithCulture:(NSString *)theCulture withId:(NSString *)theId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"culture like[c] '%@' AND intentionId like[c] '%@'", theCulture, theId]];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWIntention"];
    [request setPredicate:predicate];
    
    NSArray *theIntentions = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:request error:nil];
    
    return theIntentions;
}

// MARK: Text methods

-(NSInteger)fetchNumTexts {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWText"];
    [request setIncludesSubentities:NO];
    
    NSInteger count = [[[GWCoreDataManager sharedInstance] mainObjectContext] countForFetchRequest:request error:nil];
        
    return count;
}

// MARK: Tag methods

-(NSArray*)fetchTags {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWTag"];
    
    NSArray *theTags = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:request error:nil];
    
    return theTags;
}

-(GWTag*)fetchTagWaithName:(NSString *)tagName {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWTag"];
    [request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"tagId like[c] '%@'", tagName]]];
    
    NSArray *theTexts = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:request error:nil];
    
    if (theTexts.count > 0) {
        return [theTexts firstObject];
    }
    
    return nil;
}

-(NSArray*)fetchTagsOnBackgroundThread {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWTag"];
    
    NSArray *theTags = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:request error:nil];
    
    return theTags;
}

-(GWTag*)fetchTagWithNameOnBackgroundThread:(NSString *)tagName {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWTag"];
    [request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"tagId like[c] '%@'", tagName]]];
    
    NSArray *theTexts = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:request error:nil];
    
    if (theTexts.count > 0) {
        return [theTexts firstObject];
    }
    
    return nil;
    
}

// MARK: Image methods

-(NSArray*)randomIndexesFromArray:(NSArray*)theArray withNumRandomIndexes:(NSInteger)numRandomIndexes {
    
    if (numRandomIndexes >= theArray.count) {
        return theArray;
    }
    
    NSMutableArray *allRandomImages = [NSMutableArray arrayWithArray:theArray];
    NSMutableArray *randomImages = [NSMutableArray array];
    
    while (randomImages.count != numRandomIndexes && allRandomImages.count != 0) {
        int position = arc4random_uniform((int)allRandomImages.count);
        [randomImages addObject:[allRandomImages objectAtIndex:position]];
        [allRandomImages removeObjectAtIndex:position];
    }
    
    return randomImages;
}

-(NSInteger)fetchNumImages {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWImage"];
    [request setIncludesSubentities:NO];
    
    NSInteger count = [[[GWCoreDataManager sharedInstance] mainObjectContext] countForFetchRequest:request error:nil];
    
    return count;
}

-(NSArray*)fetchRandomImagesWithNum:(int)numImages {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWImage"];
    
    NSMutableArray *theImagesToReturn = [NSMutableArray array];
    
    NSArray *theImages = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:request error:nil];
    NSMutableArray *allMutableImages = [NSMutableArray arrayWithArray:theImages];
    
    int imagesFound = 0;
    
    while (imagesFound != numImages && allMutableImages.count > 0) {
        int randPos = arc4random_uniform((int)allMutableImages.count);
        [theImagesToReturn addObject:[allMutableImages objectAtIndex:randPos]];
        [allMutableImages removeObjectAtIndex:randPos];
        imagesFound++;
    }
    
    return theImagesToReturn;
}

-(NSArray*)fetchRandomImagesWithPredicate:(NSPredicate *)thePredicate withNum:(int)numImages {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWImage"];
    [request setPredicate:thePredicate];
    
    NSMutableArray *theImagesToReturn = [NSMutableArray array];
    
    NSArray *theImages = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:request error:nil];
    NSMutableArray *allMutableImages = [NSMutableArray arrayWithArray:theImages];
    
    int imagesFound = 0;
    
    while (imagesFound < numImages && allMutableImages.count > 0) {
        int randPos = arc4random_uniform((int)allMutableImages.count);
        [theImagesToReturn addObject:[allMutableImages objectAtIndex:randPos]];
        [allMutableImages removeObjectAtIndex:randPos];
        imagesFound++;
    }
    
    
    return theImagesToReturn;
}

-(NSMutableArray*)images:(NSArray *)theImages removeImages:(NSArray *)theImagesToRemove {
    
    NSMutableArray *imagesToReturn = [NSMutableArray arrayWithArray:theImages];
    
    for (NSString *imageIdToRemove in theImagesToRemove) {
        for (GWImage *currentImage in theImages) {
            if ([currentImage.imageId isEqualToString:imageIdToRemove]) {
                [imagesToReturn removeObject:currentImage];
            }
        }
    }
    
    return imagesToReturn;
    
}

-(NSArray*)fetchRandomImagesWithNum:(int)numImages ignoringImages:(NSArray*)theImageIdsIgnore numberOfImagesInDatabase:(int)numDBImages {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWImage"];
    
    NSMutableArray *theImagesToReturn = [NSMutableArray array];
    
    NSArray *theImages = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:request error:nil];
    
    NSMutableArray *allMutableImages;
    
    if (theImages.count > numDBImages && theImageIdsIgnore != nil) {
        allMutableImages = [self images:theImages removeImages:theImageIdsIgnore];
    }
    else {
        allMutableImages = [NSMutableArray arrayWithArray:theImages];
    }
    
    int imagesFound = 0;
    
    while (imagesFound != numImages && allMutableImages.count > 0) {
        int randPos = arc4random_uniform((int)allMutableImages.count);
        [theImagesToReturn addObject:[allMutableImages objectAtIndex:randPos]];
        [allMutableImages removeObjectAtIndex:randPos];
        imagesFound = imagesFound + 1;
    }
    
    return theImagesToReturn;
}

-(NSSet *)fetchImageSetWithImagePaths:(NSArray *)theImagePaths {
    
    NSArray *theImages = nil;
    
    if (theImagePaths != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId IN %@", theImagePaths];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GWImage"];
        [fetchRequest setPredicate:predicate];
        
        theImages = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:fetchRequest error:nil];
    }
    
    return [NSSet setWithArray:theImages];
    
}

-(NSArray*)fetchImages {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWImage"];
    
    NSArray *theImages = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:request error:nil];
    
    return theImages;
    
}

-(NSArray*)fetchImagesWithImagePaths:(NSArray *)theImagePaths {
    
    NSArray *theImages = nil;
    
    NSMutableArray *theAlteredImagePaths = [NSMutableArray array];
    for (NSString *imagePath in theImagePaths) {
        
        NSMutableString *mutableImageId = [NSMutableString stringWithString:imagePath];
        if ([imagePath hasPrefix:@"http://gw-static.azurewebsites.net"] == YES) {
            [mutableImageId deleteCharactersInRange:NSMakeRange(0, [NSString stringWithFormat:@"http://gw-static.azurewebsites.net"].length)];
        }
        else if([imagePath hasPrefix:@"http://az767698.vo.msecnd.net"] == YES) {
            [mutableImageId deleteCharactersInRange:NSMakeRange(0, [NSString stringWithFormat:@"http://az767698.vo.msecnd.net"].length)];
        }
        
        [theAlteredImagePaths addObject:mutableImageId];
    }
    
    if (theImagePaths != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId IN %@", theAlteredImagePaths];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GWImage"];
        [fetchRequest setPredicate:predicate];
        
        theImages = [[[GWCoreDataManager sharedInstance] mainObjectContext] executeFetchRequest:fetchRequest error:nil];
    }
    
    return theImages;
}

-(NSArray*)fetchRandomImagesOnBackgroundThreadWithNum:(int)numImages {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWImage"];
    
    NSMutableArray *theImagesToReturn = [NSMutableArray array];
    
    NSArray *theImages = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:request error:nil];
    NSMutableArray *allMutableImages = [NSMutableArray arrayWithArray:theImages];
    
    int imagesFound = 0;
    
    while (imagesFound != numImages && allMutableImages.count > 0) {
        int randPos = arc4random_uniform((int)allMutableImages.count);
        [theImagesToReturn addObject:[allMutableImages objectAtIndex:randPos]];
        [allMutableImages removeObjectAtIndex:randPos];
        imagesFound = imagesFound + 1;
    }
    
    return allMutableImages;
}

-(NSArray*)fetchImagesOnBackgroundThread {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GWImage"];
    
    NSArray *theImages = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:request error:nil];
    
    return theImages;
}

-(NSArray*)fetchImagesWithImagePathsOnBackgroundThread:(NSArray *)theImagePaths {
    
    NSArray *theImages = nil;
    
    if (theImagePaths != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId IN %@", theImagePaths];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GWImage"];
        [fetchRequest setPredicate:predicate];
        
        theImages = [[[GWCoreDataManager sharedInstance] childContext] executeFetchRequest:fetchRequest error:nil];
    }
    
    return theImages;
}


#pragma mark - Local Data Store Helper Methods

// MARK: Search methods

-(GWText*)textWithId:(NSString *)theTextId inArray:(NSArray *)theArray {
    for (GWText *theText in theArray) {

        if ([theText.textId isEqualToString:theTextId]) {

            return theText;
        }
    }
    
    return nil;
}

-(GWTag*)tagWithId:(NSString *)theTagId inArray:(NSArray *)theArray {
    
    for (GWTag *theTag in theArray) {
        if ([theTag.tagId isEqualToString:theTagId]) {
            return theTag;
        }
    }
    
    return nil;
}

-(GWIntention*)intentionWithId:(NSString *)theIntentionId inArray:(NSArray *)theArray {
    
    for (GWIntention *theIntention in theArray) {
        if ([theIntention.intentionId isEqualToString:theIntentionId]) {
            return theIntention;
        }
    }
    
    return nil;
}

/* New functions so that we don't overwrit the same intentions with different areas. **/
-(GWIntention*)intentionWithId:(NSString *)theIntentionId andAreaName:(NSString*)theAreaName andCulture:(NSString *)theCulture inArray:(NSArray *)theArray {
    for (GWIntention *theIntention in theArray) {
        if ([theIntention.intentionId isEqualToString:theIntentionId] && [theIntention.areaName isEqualToString:theAreaName] && [theIntention.culture isEqualToString:theCulture]) {
            return theIntention;
        }
    }
    
    return nil;
}

-(GWArea*)areaWithId:(NSString *)theAreaId inArray:(NSArray *)theArray {
    
    for (GWArea *theArea in theArray) {
        if ([theArea.areaId isEqualToString:theAreaId]) {
            return theArea;
        }
    }
    
    return nil;
}

-(GWImage*)imageWithId:(NSString *)theImageId inArray:(NSArray *)theArray {
    
    for (GWImage *theImage in theArray) {
        if ([theImage.imageId isEqualToString:theImageId]) {
            return theImage;
        }
    }
    
    return nil;
}

// MARK: data manipulation methods

-(NSArray*)removeImagePathsInArray:(NSArray*)theImagePaths withImagePathsToRemove:(NSArray*)theImagePathsToRemove {
    
    NSMutableArray *imagePathsToReturn = [NSMutableArray arrayWithArray:theImagePaths];
    
    for (NSString *imagePathToRemove in theImagePathsToRemove) {
        
        for (int i = 0; i < imagePathsToReturn.count; i++) {
            
            NSString *theImagePath = [imagePathsToReturn objectAtIndex:i];
            
            if ([imagePathToRemove isEqualToString:theImagePath]) {
                [imagePathsToReturn removeObject:theImagePath];
                --i;
            }
        }
        
    }
    
    return imagePathsToReturn;
}

-(NSArray *)removeImagePathsInArray:(NSArray*)theImagePaths withImagesToRemove:(NSArray*)theImagesToRemove {
    
    NSMutableArray *imagePathsToReturn = [NSMutableArray arrayWithArray:theImagePaths];
    
    for (GWImage *theImage in theImagesToRemove) {
        
        for (int i = 0; i < imagePathsToReturn.count; i++) {
            
            NSString *theImagePath = [imagePathsToReturn objectAtIndex:i];
            
            if ([theImage.imageId isEqualToString:theImagePath]) {
                [imagePathsToReturn removeObject:theImagePath];
                --i;
            }
        }
        
    }
    
    return imagePathsToReturn;
    
}

// MARK: persist and update methods

-(NSArray *)updatedTextsWithArea:(NSString *)theArea intentionId:(NSString *)theIntentionId culture:(NSString *)theCulture texts:(NSArray *)theTexts {
    
    NSMutableArray *textToReturn = [NSMutableArray array];
    NSManagedObjectContext *childContext = [[GWCoreDataManager sharedInstance] childContext];
    GWDataManager *dataMan = [[GWDataManager alloc] init];
    NSArray *textsForIntention = [dataMan fetchTextsWithIntentionIds:@[theIntentionId] withTag:nil withCulture:theCulture];
    
    for (NSDictionary *textJson in theTexts) {
        
        GWText *text = [dataMan persistTextOrUpdateWithJson:textJson withArray:textsForIntention withContext:childContext];
        [textToReturn addObject:text.textId];
        
    }
    
    [childContext save:nil];
    
    return textToReturn;
}

-(GWText*)persistTextOrUpdateWithJson:(NSDictionary*)textJson withArray:(NSArray*)theArray withContext:(NSManagedObjectContext*)theContext {
    
    NSString *textId = [textJson objectForKey:@"TextId"];
    
    GWText *theText = [self textWithId:textId inArray:theArray];
    
    if (theText == nil) {
        theText = [GWText createGWTextWithDict:textJson withContext:theContext];
    }
    else {
        [theText updateTextWithDict:textJson withContext:theContext];
    }
    
    return theText;
}

-(GWIntention*)persistIntentionOrUpdateWithAreaName:(NSString*)theAreaName withCulture:(NSString*)theCulture withJson:(NSDictionary*)intentionJson withArray:(NSArray*)theArray withContext:(NSManagedObjectContext*)theContext {
    
    NSString *intentionId = [intentionJson objectForKey:@"IntentionId"];
    
    GWIntention *theIntention = [self intentionWithId:intentionId andAreaName:theAreaName andCulture:theCulture inArray:theArray];
    
    if (theIntention == nil) {
        theIntention = [GWIntention createGWIntentionWithAreaName:theAreaName withDict:intentionJson withContext:theContext];
    }
    else {
        [theIntention updateIntentionWithAreaName:theAreaName withDict:intentionJson withContext:theContext];
    }
    
    return theIntention;
}

-(GWArea*)persistAreaOrUpdateWithJson:(NSDictionary *)areaJson withArray:(NSArray *)theArray withContext:(NSManagedObjectContext *)theContext {
    
    NSString *areaId = [areaJson objectForKey:@"AreaId"];
    
    GWArea *theArea = [self areaWithId:areaId inArray:theArray];
    
    
    return theArea;
}

-(GWImage*)persistImageIfNotExistWithImageId:(NSString*)theImageId withImageData:(NSData*)theImageData withImageIds:(NSArray*)theImageIds withContext:(NSManagedObjectContext*)theContext {
    
    GWImage *theImage = [self imageWithId:theImageId inArray:theImageIds];
    
    if (theImage == nil) {
        theImage = [GWImage createGWImageWithImagePath:theImageId withImageData:theImageData withManagedContext:theContext];
    }
    
    return theImage;
    
}

#pragma mark - Server Comm

#pragma mark - Download Personality Questions

-(void)downloadPersonalityQuestionsWithPath:(NSString *)thePath completion:(void (^)(NSArray<GWPersonalityQuestion *> * _Nullable, NSError * _Nullable))completion {
    
    [ServerCommunication downloadPersonalityQuestionsWithPath: thePath completion:^(NSArray <NSDictionary *> *questions, NSError *error) {
        
        if (error == nil && questions != nil) {
            
            NSMutableArray *questionsToReturn = [NSMutableArray array];
            for (NSDictionary *questionDict in questions) {
                
                NSString *questionId = [questionDict objectForKey:@"Id"];
                
                GWPersonalityQuestion *personalityQuestion = [self fetchPersonalityQuestionWithId: questionId];
                if (personalityQuestion == nil) {
                    personalityQuestion = [GWPersonalityQuestion createGWPersonalityQuestion];
                    [personalityQuestion updateWithJsonDict: questionDict];
                }
                else {
                    [personalityQuestion updateWithJsonDict: questionDict];
                }
                
                [questionsToReturn addObject: personalityQuestion];
                
            }
            
            [[[GWCoreDataManager sharedInstance] childContext] save:nil];
            
            completion(questionsToReturn, nil);
            
        }
        else {
            completion(nil, error);
        }
        
    }];
    
}

#pragma mark - Download Recipients

-(void)downloadRecipientsWithArea:(NSString *)theArea completion:(void (^)(NSArray <GWRecipient *> *, NSError *))completion {
    [completion copy];
    
    NSString *path = [NSString stringWithFormat:@"http://api.cvd.io/%@/recipienttypes", theArea];
    
    [ServerCommunication downloadRecipientsWithPath:path completion:^(NSArray *recipients, NSError *error) {
       
        if (error == nil && recipients != nil) {
            
            NSMutableArray *recipientsToReturn = [NSMutableArray array];
            for (NSDictionary *recipientDict in recipients) {
                
                NSString *recipientId = [recipientDict objectForKey:@"Id"];
                
                GWRecipient *recipient = [self fetchRecipientWithId:recipientId];
                if (recipient == nil) {
                    recipient = [GWRecipient createGWRecipientWithAreaName:theArea jsonDict:recipientDict context:nil];
                }
                else {
                    [recipient updateGWRecipientWithAreaName:theArea jsonDict:recipientDict context:nil];
                }
                
                [recipientsToReturn addObject:recipient];
            }
            
            [[[GWCoreDataManager sharedInstance] childContext] save:nil];
            
            completion(recipientsToReturn, nil);
        }
        else {
            completion (nil, error);
        }
        
    }];
    
}

# pragma mark - Download Images

-(void)downloadImageThemesWithPath:(NSString *)thePath withCompletion:(void (^)(NSDictionary *theImageThemes, NSError *error))block {
    [block copy];
    
    [ServerCommunication downloadImageThemesWithPath:thePath withCompletion:block];
    /*
    [ServerCommunication downloadImageThemesWithCompletion:^(NSDictionary *theImageThemes, NSError *error) {
        block(theImageThemes, error);
    }];
    */
}

-(void)downloadImagesAndPersistIfNotExistWithUrls:(NSArray<NSString *> *)theUrls withCompletion:(void (^)(NSArray * _Nullable, NSError * _Nullable))completion {
    [completion copy];
    
    NSMutableArray *urlsWithoutApiPath = [NSMutableArray array];
    for(NSString *url in theUrls) {
        [urlsWithoutApiPath addObject:[url c_stringByRemovingApiUrls]];
    }
    
    NSArray *existingImages = [self fetchImagesWithImagePaths:urlsWithoutApiPath];
    
    // if we have all the iamges send the ids via the block and stop the function
    if (existingImages.count == theUrls.count) {
        NSMutableArray *imageIds = [NSMutableArray array];
        for (GWImage *image in existingImages) {
            [imageIds addObject:image.imageId];
        }
        
        completion(existingImages, nil);
        return ;
    }
    
    NSMutableArray *imagesLeftToDownload = [NSMutableArray array];
    for (NSString *url in theUrls) {
        
        for (GWImage *image in existingImages) {
            if ([url containsString:image.imageId] == YES) {
                break ;
            }
        }
        
        [imagesLeftToDownload addObject:url];
    }
    
    [self downloadImagesAndPersistWithUrls:imagesLeftToDownload withCompletion:^(NSArray *theImageIds, NSError *error) {
       
        NSMutableArray *imageIdsToReturn = [NSMutableArray array];
        
        for (GWImage *image in existingImages) {
            [imageIdsToReturn addObject:image.imageId];
        }
        
        for (NSString *imageId in theImageIds) {
            [imageIdsToReturn addObject:[imageId c_stringByRemovingApiUrls]];
        }
        
        completion(imageIdsToReturn, error);
    }];
    
}

-(void)downloadImagesAndPersistWithUrls:(NSArray <NSString *> *)theUrls withCompletion:(void (^)(NSArray * _Nullable, NSError * _Nullable))block {
    [block copy];
    
    [self downloadImagesWithUrls:theUrls isRelativeURL:NO withCompletion:^(NSArray *imageIds, NSError *error) {
        
        block(imageIds, error);
    }];
    
}

-(void)downloadImagesAndPersistWithRelativePath:(NSString*)theRelativePath withNumImagesToDownload:(NSInteger)theNumImages withCompletion:(void(^)(NSArray *theImageIds, NSError *error))block {
    [block copy];
    
    NSLog(@"Relative path is: %@", theRelativePath);
    
    [ServerCommunication downloadImageIdsForRelativePath:theRelativePath withCompletion:^(NSArray *theImagePaths, NSError *error) {
       
        GWDataManager *newDataMan = [[GWDataManager alloc] init];
                
        // fetch all the images in the datastore
        NSArray *allImages = [newDataMan fetchImagesOnBackgroundThread];
        NSLog(@"all images to persist are: %d", (int)allImages.count);
        // remove the images that we have in the datastore from the paths sent from the array
        NSArray *imagePathsLeft = [newDataMan removeImagePathsInArray:theImagePaths withImagesToRemove:allImages];
        NSLog(@"the image paths left: %d", (int)imagePathsLeft.count);
        
        if (imagePathsLeft.count == 0) {
            block([NSArray array], nil);
            return ;
        }
        
        // get random image paths from those left based on the num images to download
        NSArray *randomImagePaths = [newDataMan randomIndexesFromArray:imagePathsLeft withNumRandomIndexes:theNumImages];
        NSLog(@"num random images: %d", (int)randomImagePaths.count);
        
        [newDataMan downloadImagesWithUrls:randomImagePaths isRelativeURL:YES withCompletion:^(NSArray *theImagePaths, NSError *error) {
            
            block(theImagePaths, error);
            
        }];

        
    }];
    
}

-(void)downloadImagesAndPersistWithIntentionSlug:(NSString *)theIntentionSlug withNumImagesToDownload:(NSInteger)theNumImages withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    [ServerCommunication downloadImageIdsForIntentionSlug:theIntentionSlug withCompletion:^(NSArray *theImageIds, NSError *error) {
       
        GWDataManager *newDataMan = [[GWDataManager alloc] init];
        
        //NSLog(@"all image paths downloaded: %d", (int)theImageIds.count);
        
        // fetch all the images in the datastore
        NSArray *allImages = [newDataMan fetchImagesOnBackgroundThread];
        NSLog(@"all images to persist are: %d", (int)allImages.count);
        // remove the images that we have in the datastore from the paths sent from the array
        NSArray *imagePathsLeft = [newDataMan removeImagePathsInArray:theImageIds withImagesToRemove:allImages];
        NSLog(@"the image paths left: %d", (int)imagePathsLeft.count);
        
        if (imagePathsLeft.count == 0) {
            block([NSArray array], nil);
            return ;
        }
        
        // get random image paths from those left based on the num images to download
        NSArray *randomImagePaths = [newDataMan randomIndexesFromArray:imagePathsLeft withNumRandomIndexes:theNumImages];
        NSLog(@"num random images: %d", (int)randomImagePaths.count);
        
        [newDataMan downloadImagesWithUrls:randomImagePaths isRelativeURL:YES withCompletion:^(NSArray *theImagePaths, NSError *error) {
            
            block(theImagePaths, error);
            
        }];
        
    }];
    
}

-(void)downloadImagesAndPersistWithRecipientId:(NSString *)theRecipientId withNumImagesToDownload:(NSInteger)theNumImages withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    [ServerCommunication downloadImageIdsForRecipientId:theRecipientId withCompletion:^(NSArray *theImageIds, NSError *error) {
       
        GWDataManager *newDataMan = [[GWDataManager alloc] init];
        
        // fetch all the image in the datastore
        NSArray *allImages = [newDataMan fetchImagesOnBackgroundThread];
        // remove the images that we have in the datastore from the paths sent form the array
        NSArray *imagePathsLeft = [newDataMan removeImagePathsInArray:theImageIds withImagesToRemove:allImages];
        
        if (imagePathsLeft.count == 0) {
            block([NSArray array], nil);
            return ;
        }
        
        // get random image paths from those left based on the num images to download
        NSArray *randomImagePaths = [newDataMan randomIndexesFromArray:imagePathsLeft withNumRandomIndexes:theNumImages];
        
        [newDataMan downloadImagesWithUrls:randomImagePaths isRelativeURL:YES withCompletion:^(NSArray *theImagePaths, NSError *error) {
           
            block(theImagePaths, error);
            
        }];
        
    }];
}

-(void)downloadImagePathsWithRelativePath:(NSString*)theRelativePath withCompletion:(void (^)(NSArray *theImagePaths, NSError *error))block {
    [block copy];
    
    [ServerCommunication downloadImageIdsForRelativePath:theRelativePath withCompletion:block];
}

-(void)downloadImagePathsWithIntentionSlug:(NSString *)theIntentionSlug withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    [ServerCommunication downloadImageIdsForIntentionSlug:theIntentionSlug withCompletion:^(NSArray *theIntentionSlugs, NSError *error) {
       
        block(theIntentionSlugs, error);
    }];
}

-(void)downloadImagePathsWithRecipientId:(NSString *)theRecipientId withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    [ServerCommunication downloadImageIdsForRecipientId:theRecipientId withCompletion:^(NSArray *theImagePaths, NSError *error) {
       
        block(theImagePaths, error);
        
    }];
}

-(void)downloadImagesWithUrls:(NSArray *)theImageUrls isRelativeURL:(BOOL)isRelative withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    NSMutableArray *theImages = [NSMutableArray array];
    int allImagesCount = (int)theImageUrls.count;
    __block int numImages = 0;
    
    for (NSString *theImagePath in theImageUrls) {
        
        if (isRelative) {
            [self downloadImageWithRelativeUrl:[NSString stringWithFormat:@"%@%@", @"http://gw-static.azurewebsites.net", theImagePath] withCompletion:^(NSString *theImageId, NSError *error) {
                NSLog(@"dowloaded image with url: %@", theImagePath);
                if (theImageId != nil) {
                    [theImages addObject:theImageId];
                }
                else {
                    NSLog(@"couldn't download image with url: %@", theImagePath);
                }
                
                numImages = numImages + 1;
                
                if (numImages == allImagesCount) {
                    NSLog(@"all images to download: %d, num images downloaded: %d", numImages, allImagesCount);
                    block(theImages, nil);
                }
                
            }];
        }
        else {
            [self downloadImageWithRelativeUrl:theImagePath withCompletion:^(NSString *theImageId, NSError *error) {
                NSLog(@"dowloaded image with url: %@", theImagePath);
                if (theImageId != nil) {
                    [theImages addObject:theImageId];
                }
                else {
                    NSLog(@"couldn't download image with url: %@", theImagePath);
                }
                
                numImages = numImages + 1;
                
                if (numImages == allImagesCount) {
                    NSLog(@"all images to download: %d, num images downloaded: %d", numImages, allImagesCount);
                    block(theImages, nil);
                }
                
            }];
        }
        
    }
    
}

-(void)downloadImageWithRelativeUrl:(NSString*)theImageUrl withCompletion:(void (^)(NSString *imageId, NSError *error))block {
    [block copy];
    
    NSManagedObjectContext *childContext = [[GWCoreDataManager sharedInstance] childContext];
    
    NSData *theData = [ServerCommunication downloadImageWithImageURL:theImageUrl];
    
    NSMutableString *mutableImageId = [NSMutableString stringWithString:theImageUrl];
    if ([theImageUrl hasPrefix:@"http://gw-static.azurewebsites.net"] == YES) {
        [mutableImageId deleteCharactersInRange:NSMakeRange(0, [NSString stringWithFormat:@"http://gw-static.azurewebsites.net"].length)];
    }
    else if([theImageUrl hasPrefix:@"http://az767698.vo.msecnd.net"] == YES) {
        [mutableImageId deleteCharactersInRange:NSMakeRange(0, [NSString stringWithFormat:@"http://az767698.vo.msecnd.net"].length)];
    }
    
    if (theData == nil) {
        block(nil, [NSError errorWithDomain:@"api.cvd.io" code:1000 userInfo:@{NSLocalizedDescriptionKey : @"No image found"}]);
    }
    else {
        GWImage *theImage = [GWImage createGWImageWithImagePath:mutableImageId withImageData:theData withManagedContext:childContext];
        
        [childContext save:nil];
        
        //[[GWCoreDataManager sharedInstance] saveContext];
        
        block(theImage.imageId, nil);
    }
  
}

#pragma mark - Text downloads



// MARK: Download for all texts using operations, queues and blocks

-(void)downloadAllTextsWithBlockForArea:(NSString *)theArea withCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block {
    
    GWDataManager *theDataMan = [[GWDataManager alloc] init];
    
    [theDataMan downloadIntentionsWithArea:theArea withCulture:theCulture withCompletion:^(NSArray *intentionIds, NSError *error) {
        
        NSLog(@"downlaod intention response");
        
        GWDataManager *newDataMan = [[GWDataManager alloc] init];
        
        NSArray *allIntentions = [newDataMan fetchIntentionsWithAreaName:nil withIntentionsIds:nil];
        NSArray *intentionsFromArray = [allIntentions valueForKey:@"intentionId"];
        NSMutableSet *set = [[NSMutableSet alloc] initWithArray:intentionsFromArray];
        intentionsFromArray = [set allObjects];
        
        if (error) {
            block(nil, error);
            return ;
        }

     
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        GWDataManager *secondDataMan = [[GWDataManager alloc] init];
        
        [secondDataMan downloadTextsWithBlockForArea:theArea queue:operationQueue dataMan:secondDataMan withIntentionIds:intentionsFromArray withCulture:theCulture withCompletion:block];
     
    }];
    
    
}


-(void)downloadTextsWithBlockForArea:(NSString *)theArea queue:(NSOperationQueue*)theQueue dataMan:(GWDataManager*)theDataMan withIntentionIds:(NSArray *)theIntentionsIds withCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    
    __block int numIntentionsDown = 0;
    
    for (NSString *intentionId in theIntentionsIds) {
        
        [theQueue addOperationWithBlock:^{
            [theDataMan downloadTextsWithArea:theArea withIntentionId:intentionId withCulture:theCulture withCompletion:^(NSArray *textIds, NSError *error) {
                
                numIntentionsDown++;
                if (numIntentionsDown == theIntentionsIds.count) {
                    block(nil, error);
                }
                
            }];
        }];
    
    }
    
}


// MARK: Download for all texts

-(void)downloadAllTextsForArea:(NSString *)theArea withCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       
        GWDataManager *theDataMan = [[GWDataManager alloc] init];
        
        [theDataMan downloadIntentionsWithArea:theArea withCulture:theCulture withCompletion:^(NSArray *intentionIds, NSError *error) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                GWDataManager *newDataMan = [[GWDataManager alloc] init];
                
                NSArray *allIntentions = [newDataMan fetchIntentionsWithAreaName:theArea withIntentionsIds:nil];
                NSArray *intentionsFromArray = [allIntentions valueForKey:@"intentionId"];
                NSMutableSet *set = [[NSMutableSet alloc] initWithArray:intentionsFromArray];
                intentionsFromArray = [set allObjects];
                
                if (error) {
                    block(nil, error);
                    return ;
                }
                
                GWDataManager *anotherDataMan = [[GWDataManager alloc] init];
                [anotherDataMan downloadTextsWithArea:theArea withIntentionIds:intentionsFromArray withCulture:theCulture withCompletion:^(NSArray *textIds, NSError *error) {
                    block(textIds, error);
                }];
            });
            
        }];

        
    });
    
}

-(void)downloadTextsWithArea:(NSString *)theArea withIntentionIds:(NSArray *)theIntentionsIds withCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
    
    __block NSMutableArray *textsIdsToReturn = [NSMutableArray array];
    __block NSError *theError = nil;
    __block int numTextDownloads = 0;
    int numTextDownloadsToComplete = (int)theIntentionsIds.count;
    
    for (NSString *theIntentionId in theIntentionsIds) {
        
        [self downloadTextsWithArea:theArea withIntentionId:theIntentionId withCulture:theCulture withCompletion:^(NSArray *theTextIds, NSError *error) {
            
            if (error != nil) {
                theError = error;
            }
            
            numTextDownloads = numTextDownloads + 1;
            [textsIdsToReturn addObjectsFromArray:theTextIds];
            
            if (numTextDownloadsToComplete == numTextDownloads) {
                NSLog(@"Completed download: %d of %d", numTextDownloads, numTextDownloadsToComplete);
                block(textsIdsToReturn, theError);
            }
            else {
                NSLog(@"Completed download: %d of %d", numTextDownloads, numTextDownloadsToComplete);
            }
            
        }];
        
    }
    
}

-(void)downloadTextsWithArea:(NSString *)theArea withIntentionId:(NSString *)intentionId withCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block {
    [block copy];
        
    [ServerCommunication downloadTextsWithAreaName:theArea withIntentionId:intentionId withCulture:theCulture withCompletion:^(NSArray *theTexts, NSError *error) {
        
        NSMutableArray *textToReturn = [NSMutableArray array];
        NSManagedObjectContext *childContext = [[GWCoreDataManager sharedInstance] childContext];
        GWDataManager *dataMan = [[GWDataManager alloc] init];
        NSArray *textsForIntention = [dataMan fetchTextsWithIntentionIds:@[intentionId] withTag:nil withCulture:theCulture];
        
        for (NSDictionary *textJson in theTexts) {
            
            GWText *text = [dataMan persistTextOrUpdateWithJson:textJson withArray:textsForIntention withContext:childContext];
            [textToReturn addObject:text.textId];
            
        }
        
        [childContext save:nil];
        
        
        block(textToReturn, error);
        
    }];
}


#pragma mark - Intention Download


-(NSURLSessionDataTask *)downloadIntentionsWithArea:(NSString *)theArea withCulture:(NSString*)theCulture withCompletion:(void (^)(NSArray *theIntentionIds, NSError *error))block {
    [block copy];
    
    
    NSURLSessionDataTask *dataTask = [ServerCommunication downloadIntentionsWithArea:theArea withCulture:theCulture withCompletion:^(NSArray *intentions, NSError *error) {

        NSMutableArray *intentionsToReturn = [NSMutableArray array];
        NSManagedObjectContext *childContext = [[GWCoreDataManager sharedInstance] childContext];
        GWDataManager *dataMan = [[GWDataManager alloc] init];
        NSArray *intentionsForCulture = [dataMan fetchIntentionsWithAreaName:theArea withIntentionsIds:nil];
        
        for (NSDictionary *jsonDict in intentions) {
            GWIntention *intention = [dataMan persistIntentionOrUpdateWithAreaName:theArea withCulture:theCulture withJson:jsonDict withArray:intentionsForCulture withContext:childContext];
            [intentionsToReturn addObject:intention.intentionId];
        }
        
        [childContext save:nil];
        
        block(intentionsToReturn, error);
        
    }];
    
    return dataTask;
}


#pragma mark - Area Download


-(void)downloadAllAreasWithCulture:(NSString *)theCulture withCompletion:(void (^)(NSArray *, NSError *))block{
    [block copy];
    
    
    [ServerCommunication downloadAllAreasWithCulture:theCulture withCompletion:^(NSArray *theAreas, NSError *error) {

        NSMutableArray *areasToReturn = [NSMutableArray array];
        NSManagedObjectContext *childContext = [[GWCoreDataManager sharedInstance] childContext];
        GWDataManager *dataMan = [[GWDataManager alloc] init];
        NSArray *localAreas = [dataMan fetchAreas];
        
        for (NSDictionary *jsonDict in theAreas) {
            GWArea *area = [dataMan persistAreaOrUpdateWithJson:jsonDict withArray:localAreas withContext:childContext];
            [areasToReturn addObject:area.areaId];
        }
        
        [childContext save:nil];
        
        block(areasToReturn, error);
        
    }];
}

-(void)downloadArea:(NSString *)theAreaName withCulture:(NSString *)theCulture withCompletion:(void (^)(NSString *, NSError *))block {
    [block copy];
    
    NSLog(@"downloading area with name: %@", theAreaName);
    
    [ServerCommunication downloadArea:theAreaName withCulture:theCulture withCompletion:^(NSArray *theArea, NSError *error) {
        NSLog(@"Finished download area with name: %@", theAreaName);
    }];
}

@end
