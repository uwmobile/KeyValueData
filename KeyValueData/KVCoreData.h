//
//  KVCoreData.h
//  KeyValueData
//
//  Created by Rui Zhao on 2012-11-14.
//  Copyright (c) 2012 Rui Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KVCoreData : NSManagedObject

@property (nonatomic, retain) NSNumber * timeStamp;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSData * encodedValue;

@end
