//
//  SWODTableViewController.h
//  Biathlon
//
//  Created by Philip Henson on 6/15/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "SWODDatabase.h"
#import "SWOD.h"
#import "SWODDetailViewController.h"

@interface SWODTableViewController : UITableViewController

@property (nonatomic, strong) SWODDatabase *database;
@property (nonatomic, strong) NSArray *workouts;

@end
