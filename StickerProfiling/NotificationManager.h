//
//  NotificationManager.h
//  PopularStickers
//
//  Created by Mathieu Skulason on 13/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

-(void)downloadNotificationTextsWithPath:(nonnull NSString *)thePath completion:(void (^ _Nonnull)(NSDictionary * _Nullable, NSError * _Nullable))completion;

-(void)downloadAndSaveNotificationTextsWithCompletion:(void (^ _Nullable)(NSError * _Nullable))completion;

-(void)scheduleRandomNotifications;

@end
