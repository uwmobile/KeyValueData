//
//  KVDDictionary.m
//  KeyValueData
//
//  Created by Rui Zhao on 2012-11-14.
//  Copyright (c) 2012 Rui Zhao. All rights reserved.
//

#import "KVDDictionary.h"
#import "KVCoreData.h"

//Hash For convertObjectToNSData
#define NSARCHIVER_ENCODED_KEY @"7c3e8251bab916121fe2cad541683b774c853056"

@implementation KVDDictionary

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KeyValueData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KeyValueData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data Dictionary API

- (void)setObject:(id)object forKey:(NSString *)key
{
    // Changing Object to Data
    NSMutableData *objectArchiverRaw = [NSMutableData data];
    NSKeyedArchiver *objectArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:objectArchiverRaw];
    [objectArchiver encodeObject:object forKey:NSARCHIVER_ENCODED_KEY];
    [objectArchiver finishEncoding];
    
    KVCoreData *coreData = [NSEntityDescription insertNewObjectForEntityForName:@"KVCoreData" inManagedObjectContext:self.managedObjectContext];
    coreData.key = key;
    coreData.encodedValue = [objectArchiverRaw copy];
    coreData.timeStamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    // Save to Data Persistence
    
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        [self saveContext];
        NSLog(@"Could Not Save %@", [error localizedDescription]);
    }
    
}

- (NSDictionary *)objectForKeyContains:(NSString *)key
{
    NSFetchRequest *objectRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KVCoreData" inManagedObjectContext:self.managedObjectContext];
    [objectRequest setEntity:entity];
    objectRequest.predicate = [NSPredicate predicateWithFormat:@"key contains[cd] %@", key];
    NSError *error;
    NSArray *searchResult = [self.managedObjectContext executeFetchRequest:objectRequest error:&error];
    if (searchResult.count == 0) {
        return nil;
    }
    NSMutableDictionary *dataManager = [[NSMutableDictionary alloc] init];
    for (KVCoreData *dataModel in searchResult) {
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataModel.encodedValue];
        id object = [unArchiver decodeObjectForKey:NSARCHIVER_ENCODED_KEY];
        [dataManager setObject:object forKey:dataModel.key];
    }
    return [dataManager copy];
}

- (id)objectForKey:(NSString *)key
{
    NSFetchRequest *objectRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KVCoreData" inManagedObjectContext:self.managedObjectContext];
    [objectRequest setEntity:entity];
    objectRequest.predicate = [NSPredicate predicateWithFormat:@"key = %@", key];
    NSError *error;
    NSArray *searchResult = [self.managedObjectContext executeFetchRequest:objectRequest error:&error];
    if (searchResult.count > 1) {
        NSMutableArray *arrayOfObject = [[NSMutableArray alloc] initWithCapacity:searchResult.count];
        for (KVCoreData *dataModel in searchResult) {
            NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataModel.encodedValue];
            id object = [unArchiver decodeObjectForKey:NSARCHIVER_ENCODED_KEY];
            [arrayOfObject addObject:object];
        }
        return [arrayOfObject copy];
    }else if(searchResult.count == 1){
        KVCoreData *dataModel = [searchResult objectAtIndex:0];
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataModel.encodedValue];
        id object = [unArchiver decodeObjectForKey:NSARCHIVER_ENCODED_KEY];
        return object;
    }else{
        return nil;
    }
}

@end
