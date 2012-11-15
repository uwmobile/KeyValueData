//
//  KVDAppDelegate.h
//  KeyValueData
//
//  Created by Rui Zhao on 2012-11-14.
//  Copyright (c) 2012 Rui Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KVDDictionary;

@interface KVDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KVDDictionary *dictionaryCoreData;



@end
