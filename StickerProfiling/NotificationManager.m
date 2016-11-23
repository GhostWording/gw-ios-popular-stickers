//
//  NotificationManager.m
//  PopularStickers
//
//  Created by Mathieu Skulason on 13/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "NotificationManager.h"
#import "UserDefaults.h"
#import "Constants.h"
#import "GWLocalizedBundle.h"
#import <UIKit/UIKit.h>

static NSURLSession *session = nil;
static NSCalendar *calendar = nil;

@implementation NotificationManager

+(NSURLSession *)p_getSession {
    
    if (session == nil) {
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    return session;
}

+(NSCalendar *)p_getCalendar {
    
    if (calendar == nil) {
        calendar = [NSCalendar currentCalendar];
    }
    
    return calendar;
}

-(void)downloadNotificationTextsWithPath:(NSString *)thePath completion:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))completion {
    [completion copy];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:thePath]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [[[self class] p_getSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            completion(dict, error);
        }
        else {
            completion(nil, error);
        }
        
    }];
    
    [task resume];
}

-(void)downloadAndSaveNotificationTextsWithCompletion:(void (^)(NSError * _Nullable))completion {
    
    [self downloadNotificationTextsWithPath:@"http://gw-static-apis.azurewebsites.net/data/stickers/notificationtexts.json" completion:^(NSDictionary *dictionaryTexts, NSError *error) {
       
        for (NSString *cultureKey in dictionaryTexts.allKeys) {
            NSArray <NSString *> *cultureArray = [dictionaryTexts objectForKey: cultureKey];
            [UserDefaults setNotifiactionsTexts: cultureArray culture:cultureKey];
        }
        
        completion(error);
        
    }];
    
}

-(void)scheduleRandomNotifications {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if ([UserDefaults isNotificationRegistered] == YES && [UserDefaults wantsNotification] == YES) {
        
        if ([[UserDefaults userNotificationFrequency] intValue] == OneMessageADay) {
            [self scheduleDailyNotifications];
        }
        else if ([[UserDefaults userNotificationFrequency] intValue] == OneMessageEveryOtherDay) {
            [self scheduleEveryOtherDayNotifications];
        }
        else if ([[UserDefaults userNotificationFrequency] intValue] == OneMessageAWeek) {
            [self scheduleWeeklyNotification];
        }
        
    }
    
}

-(void)scheduleDailyNotifications {
    
    NSArray *randomTexts = [UserDefaults notificationTextsForCulture:[GWLocalizedBundle currentLocaleAPIString]];
    
    for (int i = 0; i < 7 && randomTexts != nil && randomTexts.count != 0; i++) {
        
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.alertBody = [self randomTextFromArray:randomTexts];
        NSDate *fireDate = [self getFireDateWithDay:i andHour:[self p_randomHour] andMinute:[self p_randomMinute] calender: [[self class] p_getCalendar]];
        localNotif.fireDate = fireDate;
        
    }
    
}

-(void)scheduleEveryOtherDayNotifications {
    
    NSArray *randomTexts = [UserDefaults notificationTextsForCulture:[GWLocalizedBundle currentLocaleAPIString]];
    
    for (int i = 0; i < 7 && randomTexts != nil && randomTexts.count != 0; i++) {
        
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.alertBody = [self randomTextFromArray:randomTexts];
        NSDate *fireDate = [self getFireDateWithDay: 2 * i andHour:[self p_randomHour] andMinute:[self p_randomMinute] calender: [[self class] p_getCalendar]];
        localNotif.fireDate = fireDate;
        
    }
    
}

-(void)scheduleWeeklyNotification {
    
    NSArray *randomTexts = [UserDefaults notificationTextsForCulture: [GWLocalizedBundle currentLocaleAPIString]];
    
    for (int i = 0; i < 7 && randomTexts != nil && randomTexts.count != 0; i++) {
        
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        NSString *alertBody = [self randomTextFromArray:randomTexts];
        localNotif.alertBody = alertBody;
        NSDate *fireDate = [self getFireDateWithDay: 7 * i andHour:[self p_randomHour] andMinute:[self p_randomMinute] calender: [[self class] p_getCalendar]];
        localNotif.fireDate = fireDate;
        
    }
    
}



-(NSDate *)getFireDateWithDay:(NSInteger)theDayNumber andHour:(NSInteger)theHour andMinute:(NSInteger)theMinute calender:(NSCalendar *)theCalendar {
    
    NSDate *date = [NSDate date];
    
    NSDateComponents *dateComposition = [theCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    
    if (dateComposition.hour > theHour) {
        [dateComposition setDay:dateComposition.day +1 + theDayNumber];
        [dateComposition setHour:theHour];
        [dateComposition setMinute:theMinute];
    }
    else if(dateComposition.hour == theHour && dateComposition.minute > theMinute) {
        [dateComposition setDay:dateComposition.day + 1 + theDayNumber];
        [dateComposition setHour:theHour];
        [dateComposition setMinute:theMinute];
    }
    else {
        [dateComposition setDay:dateComposition.day + theDayNumber];
        [dateComposition setHour:theHour];
        [dateComposition setMinute:theMinute];
    }
    
    return [theCalendar dateFromComponents:dateComposition];
}

-(NSString *)randomTextFromArray:(NSArray <NSString *> *)theArray {
    
    int randPos = arc4random_uniform((u_int32_t)theArray.count);
    
    NSString *randText = [theArray objectAtIndex:randPos];
    
    return randText;
}

-(int)p_randomHour {
    return arc4random_uniform(9) + 9;
}

-(int)p_randomMinute {
    return arc4random_uniform(59);
}

@end
