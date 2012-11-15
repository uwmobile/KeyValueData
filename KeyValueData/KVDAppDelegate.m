//
//  KVDAppDelegate.m
//  KeyValueData
//
//  Created by Rui Zhao on 2012-11-14.
//  Copyright (c) 2012 Rui Zhao. All rights reserved.
//

#import "KVDAppDelegate.h"
#import "KVDDictionary.h"

@implementation KVDAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    _dictionaryCoreData = [[KVDDictionary alloc] init];
    // Test For Simple String
   //[_dictionaryCoreData setObject:@"This is Test" forKey:@"Test"];
    
    // Test For Image
    //UIImage *testImage = [UIImage imageNamed:@"testPic.png"];
    //[_dictionaryCoreData setObject:testImage forKey:@"TestImageSave"];
    
    NSLog(@"test log: %@", [_dictionaryCoreData objectForKey:@"TestImageSave"]);
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    // [self saveContext];
    [_dictionaryCoreData saveContext];
}


@end
