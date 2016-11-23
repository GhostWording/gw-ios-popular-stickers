//
//  GWCoreDataManager.h
//  GWFramework
//
//  Created by Mathieu Skulason on 21/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface GWCoreDataManager : NSObject

@property (readwrite, strong, nonatomic) NSManagedObjectContext *mainObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *childManagedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

+(instancetype)sharedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSDate*)dateFromJsonString:(NSString*)dateString;
- (NSManagedObjectContext*)childContext;

@end
