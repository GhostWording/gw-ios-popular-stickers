//
//  Constants.h
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 12/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef Constants_h
#define Constants_h

static NSString *frenchCultureString = @"fr-FR";
static NSString *englishCultureString = @"en-EN";
static NSString *spanishCultureString = @"es-ES";

static NSString *maleGender = @"H";
static NSString *femaleGender = @"F";

/*
typedef NS_ENUM(NSInteger, UserLanguage) {
    FrencLanguage = 0,
    EnglishLanguage = 1,
    SpanishLanguage = 2
};
*/
 
typedef NS_ENUM(NSInteger, UserLivingSituation) {
    LiveAlone = 0,
    LiveWithSomeone = 1
};

typedef NS_ENUM(NSInteger, UserAge) {
    LessThan17 = 0,
    Between18And39 = 1,
    Between40And64 = 2,
    Over65 = 3
};

typedef NS_ENUM(NSInteger, UserNotifications) {
    OneMessageADay = 0,
    OneMessageEveryOtherDay = 1,
    OneMessageAWeek = 2
};

#endif /* Constants_h */
