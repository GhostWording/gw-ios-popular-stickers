//
//  UserDefaults.m
//  PopularStickers
//
//  Created by Mathieu Skulason on 06/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "UserDefaults.h"
#import "Constants.h"
#import "NSString+MAXHeightExtension.h"

@implementation UserDefaults


+(BOOL)isFirstLaunch {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLaunch"] == nil) {
        [UserDefaults setIsFirstLaunch:YES];
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"];
}

+(void)setIsFirstLaunch:(BOOL)isFirstLaunch {
    [[NSUserDefaults standardUserDefaults] setBool:isFirstLaunch forKey:@"isFirstLaunch"];
}

+(BOOL)isCoreDataSetup {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isCoreDataSetup"] == nil) {
        [UserDefaults setIsCoreDataSetup:NO];
    }
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"isCoreDataSetup"] boolValue];
}

+(void)setIsCoreDataSetup:(BOOL)isSetup {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isSetup] forKey:@"isCoreDataSetup"];
    
}

+(BOOL)isNotificationRegistered {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isNotificationRegistered"] == nil) {
        [UserDefaults setIsNotificationRegistered:NO];
    }
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"isNotificationRegistered"] boolValue];
}

+(void)setIsNotificationRegistered:(BOOL)isNotificationRegistered {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isNotificationRegistered] forKey:@"isNotificationRegistered"];
    
}

+(BOOL)hasSentImageOrText {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hasSentImageOrText"] == nil ) {
        [self setHasSentImageOrText: NO];
    }
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasSentImageOrText"] boolValue];
}

+(void)setHasSentImageOrText:(BOOL)hasSent {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool: hasSent] forKey:@"hasSentImageOrText"];
    
}

+(MessageSendMethod)sendMethodForMessage {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sendMethodForMessage"] == nil) {
        [self setSendMethodForMessage: MessageSendMethodNoMethod];
    }
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey: @"sendMethodForMessage"] integerValue];
}

+(void)setSendMethodForMessage:(MessageSendMethod)sendMethod {
    
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInteger: sendMethod] forKey:@"sendMethodForMessage"];
    
}

+(int)numAppLaunches {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"numAppLaunches"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"numAppLaunches"];
    }
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"numAppLaunches"] intValue];
}

+(void)incrementAppNumLaunches {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt: 1 + [UserDefaults numAppLaunches] ] forKey:@"numAppLaunches"];
    
}

+(int)numBackToMainMenu {
    
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"numBackToMainMenu"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"numBackToMainMenu"];
    }
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"numBackToMainMenu"] intValue];
}

+(void)incrementNumBackToMainMenu {
    
    int numBackToMainMenu = [self numBackToMainMenu];
    
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt: numBackToMainMenu + 1] forKey:@"numBackToMainMenu"];
    
}


+(BOOL)isFirstMoodItemPressed {
    
    if ( [[NSUserDefaults standardUserDefaults] objectForKey: @"isFirstMoodItemPressed"] == nil ) {
        
        return NO;
        
    }
    
    return [(NSNumber *) [[NSUserDefaults standardUserDefaults] objectForKey: @"isFirstMoodItemPressed"] boolValue];
}

+(void)setIsFirstMoodItemPressed:(BOOL)isFirstMoodItemPressed {
    
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithBool:isFirstMoodItemPressed] forKey: @"isFirstMoodItemPressed"];
    
}

+(void)setIsMainScreenReached:(BOOL)isReached {
    
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithBool: isReached] forKey: @"isMainScreenReached"];
    
}

+(BOOL)isMainScreenReached {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey: @"isMainScreenReached"] == nil) {
        
        return NO;
    }
    
    return [(NSNumber *) [[NSUserDefaults standardUserDefaults] objectForKey: @"isMainScreenReached"] boolValue];
    
}

+(NSDate*)dateInstalled {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"dateInstalled"];
    
}

+(void)setDateInstalled:(NSDate *)theDate {
    
    [[NSUserDefaults standardUserDefaults] setObject:theDate forKey:@"dateInstalled"];
    
}

+(BOOL)wantsNotification {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"wantsNotification"] == nil) {
        [UserDefaults setWantsNotification:NO];
    }
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"wantsNotification"] boolValue];
}

+(void)setWantsNotification:(BOOL)wantsNotification {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:wantsNotification] forKey:@"wantsNotification"];
    
}

+(NSArray <NSString *> * _Nullable)notificationTextsForCulture:(NSString *)theCulture {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"NotificationTexts%@", theCulture]] == nil) {
        
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"NotificationTexts%@", theCulture]];
}

+(void)setNotifiactionsTexts:(NSArray <NSString *> *)theNotifTexts culture:(NSString*)theCulture {
    
    [[NSUserDefaults standardUserDefaults] setObject:theNotifTexts forKey:[NSString stringWithFormat:@"NotificationTexts%@", theCulture]];
    
}


+(NSString*)userUniqueId {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueId"] == nil) {
        
        NSLog(@"user unique id");
        [[NSUserDefaults standardUserDefaults] setValue:[NSString c_generateRandStringWithLength:8] forKey:@"uniqueId"];
    }
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueId"];
}

+(NSString *)facebookId {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"facebookId"];
    
}

+(void)setFacebookId:(NSString *)theFacebookId {
    
    [[NSUserDefaults standardUserDefaults] setObject:theFacebookId forKey:@"facebookId"];
    
}

+(BOOL)developerModeEnabled {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey: @"developerMode"] == nil) {
        [UserDefaults setDeveloperMode: NO];
    }
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey: @"developerMode"] boolValue];
}

+(void)setDeveloperMode:(BOOL)developerMode {
    
    [[NSUserDefaults standardUserDefaults] setObject:@( developerMode ) forKey: @"developerMode"];
    
}

// MARK: User settings

+(NSString *)userGender {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userGender"];
}

+(void)setUserGender:(NSString *)theGender {
    [[NSUserDefaults standardUserDefaults] setObject:theGender forKey:@"userGender"];
}

+(NSNumber * _Nullable)userLivingSituation {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userLivingSituation"];
}

+(void)setUserLivingSituation:(NSNumber *)theLivingSituation {
    [[NSUserDefaults standardUserDefaults] setObject:theLivingSituation forKey:@"userLivingSituation"];
}

+(NSNumber * _Nullable)userAge {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userAge"];
}

+(void)setUserAge:(NSNumber *)theUserAge {
    [[NSUserDefaults standardUserDefaults] setObject:theUserAge forKey:@"userAge"];
}

+(NSNumber * _Nullable)userNotificationFrequency {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userNotificationFrequency"] == nil) {
        [UserDefaults setUserNotificationFrequency:[NSNumber numberWithInt: OneMessageADay]];
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userNotificationFrequency"];
}

+(void)setUserNotificationFrequency:(NSNumber *)theUserNotificationFrequency {
    [[NSUserDefaults standardUserDefaults] setObject:theUserNotificationFrequency forKey:@"userNotificationFrequency"];
}


+(NSDate *)lastDateAdWasShown {
    
    
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"dateAdWasShown"];
}

+(void)setLastDateAdWasShown:(NSDate *)date {
    
    [[NSUserDefaults standardUserDefaults] setObject: date forKey: @"dateAdWasShown"];
    
}


#pragma mark

+(NSArray <NSString *> *)viewedIntentionsAndThemes {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"viewedIntentionsAndThemes"] == nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject: @[] forKey:@"viewedIntentionsAndThemes"];
        
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"viewedIntentionsAndThemes"];
    
}

+(void)setViewedIntentionOrTheme:(NSString *)theIntentionOrTheme {
    
    NSMutableArray *array = [NSMutableArray arrayWithArray: [self viewedIntentionsAndThemes]];
    
    if ([self viewIntentionsContainsThemeOrIntentionId: theIntentionOrTheme] == NO) {
        [array addObject:theIntentionOrTheme];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"viewedIntentionsAndThemes"];
    
}

+(BOOL)viewIntentionsContainsThemeOrIntentionId:(NSString *)theThemeOrIntentionId {
    
    if (theThemeOrIntentionId == nil) {
        return NO;
    }
    
    NSArray <NSString *> *intentionsAndThemes = [self viewedIntentionsAndThemes];
    
    for (NSString *currentThemeOrIntention in intentionsAndThemes) {
        
        if ([currentThemeOrIntention isEqualToString:theThemeOrIntentionId] == YES) {
            return YES;
        }
        
    }
    
    return NO;
}

#pragma mark - 

+(BOOL)hasViewedImageWithId:(NSString *)theImageId {
    
    if (theImageId == nil) {
        return NO;
    }
    
    NSArray *imageIds = [self viewedImageIds];
    
    for (NSString *currentImageId in imageIds) {
        
        if ([theImageId isEqualToString:currentImageId] == YES) {
            return YES;
        }
        
    }
    
    return NO;
}

+(NSArray <NSString *> *)viewedImageIds {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"viewedImageIds"] == nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject: @[] forKey:@"viewedImageIds"];
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"viewedImageIds"];
}

+(void)setHasViewedImageWithId:(NSString *)theImageId {
    
    if (theImageId != nil && [self hasViewedImageWithId: theImageId] == NO) {
        
        NSMutableArray *imageIds = [NSMutableArray arrayWithArray: [self viewedImageIds] ];
        [imageIds addObject:theImageId];
        
        [[NSUserDefaults standardUserDefaults] setObject: imageIds forKey: @"viewedImageIds"];
        
    }
    
}

#pragma mark - Personality Questions

+(NSArray <NSString *> *)personalityAnswers {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey: @"personalityAnswers"] == nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject: @[] forKey: @"personalityAnswers"];
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"personalityAnswers"];
}

+(void)addPersonalityAnswer:(NSString *)answer {
    
    if ([self currentAnswerExistsWithAnswer: answer completion:nil] == YES) {
        
        return ;
    }
    else {
        
        NSMutableArray <NSString *> *personalityAnswers = [NSMutableArray arrayWithArray: [self personalityAnswers]];
        
        [personalityAnswers addObject: answer];
        NSLog(@"added personality answers: %@", personalityAnswers);
        [[NSUserDefaults standardUserDefaults] setObject: personalityAnswers forKey: @"personalityAnswers"];
    }
    
}

+(void)removePersonalityAnswer:(NSString *)answer {
    
    NSMutableArray <NSString *> *personalityAnswers = [NSMutableArray arrayWithArray: [self personalityAnswers]];
    
    for (int i = 0; i < personalityAnswers.count; i++) {
        
        NSString *currentAnswer = [personalityAnswers objectAtIndex: i];
        if ([currentAnswer isEqualToString: answer] == YES) {
            [personalityAnswers removeObjectAtIndex: i];
            break;
        }
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject: personalityAnswers forKey: @"personalityAnswers"];
}

+(BOOL)hasPersonalityAnswer:(NSString *)personalityAnswer {
    
    return [self currentAnswerExistsWithAnswer: personalityAnswer completion: nil];
}

+(BOOL)currentAnswerExistsWithAnswer:(NSString *)answer completion:(void (^)(BOOL found, NSUInteger index))completion {
    [completion copy];
    
    NSArray <NSString *> *personalityAnswers = [self personalityAnswers];
    
    NSUInteger index = 0;
    for (NSString *currentAswer in personalityAnswers) {
        
        if ([currentAswer isEqualToString: answer] == YES) {
            
            if (completion != nil) {
                completion(YES, index);
            }
            
            return YES;
        }
        
        index++;
        
    }
    
    if (completion != nil) {
        completion(NO, -1);
    }
    
    return NO;
}

@end
