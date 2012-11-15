//
//  KVDDetailViewController.h
//  KeyValueData
//
//  Created by Rui Zhao on 2012-11-14.
//  Copyright (c) 2012 Rui Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KVDDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
