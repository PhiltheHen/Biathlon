//
//  SWODDatabase.h
//  Biathlon
//
//  Created by Philip Henson on 6/15/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWOD.h"

// SQLite Database class

@class SWOD;
@interface SWODDatabase : NSObject

+ (SWODDatabase*)database;
- (NSArray *)getAllSWODs;

@end
