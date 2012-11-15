//
//  KVDDictionary.h
//  KeyValueData
//
//  Created by Rui Zhao on 2012-11-14.
//  Copyright (c) 2012 Rui Zhao. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface KVDDictionary : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// Return the Object For Key That Exactly Equals To The Key
// If the key is Unique, only return one Object
// If the key is not Unique, will return an NSArray contains all objects
// Case Sensitive Search
- (id)objectForKey:(NSString *)key;

// Search All Key that Contains the value "key" in the string
// Return An Key Value Pair Dictionary with:
// key = key in KVD,
// value = value in KVD
// Case Insensitive Search
- (NSDictionary *)objectForKeyContains:(NSString *)key;


// Save the Object With the Key into KVD
- (void)setObject:(id)object forKey:(NSString *)key;

@end
