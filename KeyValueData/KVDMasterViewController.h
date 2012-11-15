//
//  KVDMasterViewController.h
//  KeyValueData
//
//  Created by Rui Zhao on 2012-11-14.
//  Copyright (c) 2012 Rui Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface KVDMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
