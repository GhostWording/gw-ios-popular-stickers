//
//  GoogleAnalyticsConstants.h
//  PopularStickers
//
//  Created by Mathieu Skulason on 20/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#ifndef GoogleAnalyticsConstants_h
#define GoogleAnalyticsConstants_h
#import <Foundation/Foundation.h>

// MARK: Event Target Types
static const NSString *kGATargetTypeText = @"Text";
static const NSString *kGATargetTypeImage = @"Image";
static const NSString *kGATargetTypeIntention = @"Intention";
static const NSString *kGATargetTypeTheme = @"Theme";
static const NSString *kGATargetTypeApp = @"App";

// MARK: Icons
static const NSString *kGAMainScreen = @"MainScreen";
static const NSString *kGALoginScreen = @"LoginScreen";
static const NSString *kGAPersonalityScreen = @"PersonalityScreen";
static const NSString *kGADailyIdeasScreen = @"DailyIdeasScreen";
static const NSString *kGAUserProfileScreen = @"UserProfileScreen";
static const NSString *kGACategoryListScreen = @"CategoryListScreen";
static const NSString *kGAItemDetailScreen = @"ItemDetailScreen";
static const NSString *kGARecipientPickerScreen = @"RecipientPickerScreen";
static const NSString *kGAIntentionPickerScreen = @"IntentionPickerScreen";

// MARK: Strings
static const NSString *kGACountry = @"Country";
static const NSString *kGASkipPersonalityIntro = @"SkipPersonalityQuestions";
static const NSString *kGACategories = @"Categories";
static const NSString *kGAStickerCategory = @"StickerCategory";
static const NSString *kGADailyIdeas = @"DailySuggestion";
static const NSString *kGASelectTab = @"SelectTab";
static const NSString *kGAImageSelected = @"ImageSelected";
static const NSString *kGABackFromThemes = @"BackFromThemes";
static const NSString *kGABackFromImage = @"BackFromImage";
static const NSString *kGAAppLaunch = @"AppLaunch";
static const NSString *kGAMoodIntention = @"MoodIntention";
static const NSString *kGASendMenuOpened = @"SendMenuOpened";
static const NSString *kGAMoodTheme = @"MoodTheme";
static const NSString *kGAGender = @"Gender";
static const NSString *kGAShareWhatsApp = @"ShareWhatsApp";
static const NSString *kGASendMessenger = @"SendMessenger";
static const NSString *kGALanguage = @"Language";
static const NSString *kGALoginWithoutFacebook = @"LoginWithoutFacebook";
static const NSString *kGAFirstMoodItemPressed = @"FirstMoodItemPressed";
static const NSString *kGAMoodItemPressed = @"MoodItemPressed";
static const NSString *kGAFirstLaunch = @"FirstAppLaunch";
static const NSString *kGANotificationReceived = @"NotificationReceived";
static const NSString *kGAShareViaIntent = @"ShareViaIntent";
static const NSString *kGASendWith = @"SendWith";
static const NSString *kGAShareOnFbWall = @"ShareOnFbWall";
static const NSString *kGALinkEvents = @"LinkEvents";
static const NSString *kGAOptionMenu = @"OptionMenu";
static const NSString *kGASetLanguage = @"ppLanguage";
static const NSString *kGAShareViber = @"ShareViber";
static const NSString *kGAConjugalSituation = @"ConjugalSituation";
static const NSString *kGAOpenMBTI = @"OpenMBTI";
static const NSString *kGAShareSMS = @"ShareSMS";
static const NSString *kGAAcceptNotifications = @"NotificationAccept";
static const NSString *kGACancelNotifications = @"NotificationCancel";
static const NSString *kGAPromoteAppClicked = @"PromoteAppClicked";
static const NSString *kGAMBTISelected = @"MBTISelected";
static const NSString *kGANotificationFrequency = @"NotificationFrequency";
static const NSString *kGALoginWithFacebook = @"LoginWithFacebook";
static const NSString *kGASetFacebookId = @"SetFacebookId";
static const NSString *kGALogoutWithFacebook = @"LogoutWithFacebook";
static const NSString *kGAContactFacebbokId = @"ContactFacebookId";
static const NSString *kGAMainScreenReached = @"MainScreenReached";
static const NSString *kGAUserEmail = @"UserEmail";
static const NSString *kGAReadVariation = @"ReadVariation";

static const NSString *kGAAdRequested = @"AdRequested";
static const NSString *kGAAdDisplayed = @"AdDisplayed";

static const NSString *kGAReplyFromMessenger = @"ReplyFromMessenger";
static const NSString *kGAReplyingToFacebookContact = @"ReplyingToFacebookContact";
static const NSString *kGAReplyingRecipientType = @"ReplyingRecipientType";
static const NSString *kGAReplyingIntention = @"ReplyingIntention";
static const NSString *kGAReplyingTextPrototypeId = @"ReplyingTextPrototypeId";
static const NSString *kGAReplyingImageName = @"ReplyingImageName";

#endif /* GoogleAnalyticsConstants_h */
