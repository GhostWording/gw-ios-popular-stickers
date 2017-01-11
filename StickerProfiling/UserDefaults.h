//
//  UserDefaults.h
//  PopularStickers
//
//  Created by Mathieu Skulason on 06/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MessageSendMethod) {
    MessageSendMethodNoMethod,
    MessageSendMethodMessenger,
    MessageSendMethodOS
};

@interface UserDefaults : NSObject

+(BOOL)isFirstLaunch;
+(void)setIsFirstLaunch:(BOOL)isFirstLaunch;

+(BOOL)isCoreDataSetup;
+(void)setIsCoreDataSetup:(BOOL)isSetup;

+(BOOL)isNotificationRegistered;
+(void)setIsNotificationRegistered:(BOOL)isNotificationRegistered;

+(BOOL)hasSentImageOrText;
+(void)setHasSentImageOrText:(BOOL)hasSent;

+(MessageSendMethod)sendMethodForMessage;
+(void)setSendMethodForMessage:(MessageSendMethod)sendMethod;

+(int)numAppLaunches;
+(void)incrementAppNumLaunches;

+(int)numBackToMainMenu;
+(void)incrementNumBackToMainMenu;

+(BOOL)isFirstMoodItemPressed;
+(void)setFirstMoodItemPressed:(BOOL)firstMoodItemPressed;

+(BOOL)isMainScreenReached;
+(void)setIsMainScreenReached:(BOOL)isReached;

+(NSDate * _Nullable)dateInstalled;
+(void)setDateInstalled:(NSDate *)theDate;

+(BOOL)wantsNotification;
+(void)setWantsNotification:(BOOL)wantsNotification;

+(NSArray <NSString *> * _Nullable)notificationTextsForCulture:(NSString *)theCulture;
+(void)setNotifiactionsTexts:(NSArray <NSString *> *)theNotifTexts culture:(NSString*)theCulture;

+(NSString *)userUniqueId;

+(NSString * _Nullable)facebookId;
+(void)setFacebookId:(NSString * _Nullable)theFacebookId;

+(BOOL)developerModeEnabled;
+(void)setDeveloperMode:(BOOL)developerMode;

+(NSNumber *)isNewInstall;
+(void)setIsNewInstall:(BOOL)isNewInstall;

+(BOOL)hasViewedDailyIdeas;
+(void)setHasViewedDailyIdeas:(BOOL)hasViewed;

// MARK: User Settings

+(NSString * _Nullable)userGender;
+(void)setUserGender:(NSString *)theGender;

+(NSNumber * _Nullable)userLivingSituation;
+(void)setUserLivingSituation:(NSNumber *)theLivingSituation;

+(NSNumber * _Nullable)userAge;
+(void)setUserAge:(NSNumber *)theUserAge;

+(NSNumber * _Nullable)userNotificationFrequency;
+(void)setUserNotificationFrequency:(NSNumber *)theUserNotificationFrequency;

+(NSDate * _Nullable)lastDateAdWasShown;
+(void)setLastDateAdWasShown:(NSDate *)date;

// MARK: Stored Information

+(NSArray <NSString *> *)viewedIntentionsAndThemes;
+(void)setViewedIntentionOrTheme:(nullable NSString *)theIntentionOrTheme;
+(BOOL)viewIntentionsContainsThemeOrIntentionId:(nullable NSString *)theThemeOrIntentionId;

// Personality Answer
+(NSArray <NSString *> *)personalityAnswers;
+(void)addPersonalityAnswer:(NSString *)personalityAnswer;
+(void)removePersonalityAnswer:(NSString *)personalityAnswer;
+(BOOL)hasPersonalityAnswer:(NSString *)personalityAnswer;

+(BOOL)hasViewedImageWithId:(NSString * _Nullable)theImageId;
+(void)setHasViewedImageWithId:(NSString * _Nullable)theImageId;


@end

NS_ASSUME_NONNULL_END
