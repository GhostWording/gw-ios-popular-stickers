//
//  GWCoreDataManager.m
//  GWFramework
//
//  Created by Mathieu Skulason on 21/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "GWCoreDataManager.h"

@implementation GWCoreDataManager

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize mainObjectContext = _mainObjectContext;
@synthesize childManagedObjectContext = _childManagedObjectContext;
@synthesize dateFormatter;

+(instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if (self = [super init]) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return self;
}

-(NSManagedObjectContext*)childContext {
    
    if ([NSThread isMainThread]) {
        return self.mainObjectContext;
    }
    
    if ([[[NSThread currentThread] threadDictionary] valueForKey:@"objectContext"] == nil) {
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        context.parentContext = self.mainObjectContext;
        //context.persistentStoreCoordinator = self.persistentStoreCoordinator;
        context.mergePolicy = [[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType];
        
        [[[NSThread currentThread] threadDictionary] setValue:context forKey:@"objectContext"];
        
    }
    
    return [[[NSThread currentThread] threadDictionary] valueForKey:@"objectContext"];
    
}

-(NSDate*)dateFromJsonString:(NSString *)dateString {
    
    [dateFormatter setDateFormat:@"yyyy'-'mm'-'dd'T'HH:mm:ss.SSS"];
    
    if (![dateFormatter dateFromString:dateString]) {
        
        [dateFormatter setDateFormat:@"yyyy'-'mm'-'dd'T'HH:mm:ss"];
        
        if (![dateFormatter dateFromString:dateString]) {
            return [NSDate date];
        }
        else {
            return [dateFormatter dateFromString:dateString];
        }
    }
    else {
        return [dateFormatter dateFromString:dateString];
    }

    
}


#pragma mark - Model, Persistent Store and Context

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GWFramework1" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        @synchronized(_persistentStoreCoordinator) {
            return _persistentStoreCoordinator;
        }
    }
        
    // Add this block of code.  Basically, it forces all threads that reach this
    // code to be processed in an ordered manner on the main thread.  The first
    // one will initialize the data, and the rest will just return with that
    // data.  However, it ensures the creation is not attempted multiple times.
    /*
    if (![NSThread currentThread].isMainThread) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            (void)[self persistentStoreCoordinator];
        });
        return _persistentStoreCoordinator;
    }*/
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GWFramework1.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [storeURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)mainObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_mainObjectContext != nil) {
        return _mainObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    
    _mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_mainObjectContext setPersistentStoreCoordinator:coordinator];
    return _mainObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSManagedObjectContext *managedObjectContext = self.mainObjectContext;
        if (managedObjectContext != nil) {
            NSError *error = nil;
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                //abort();
            }
        }
    });
}


#pragma mark - Helper functions

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.konta.GWFramework" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
