//
//  SWOD.h
//  Biathlon
//
//  Created by Philip Henson on 6/15/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

// Class for Shooting Workout of the Day (SWOD)

@interface SWOD : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;

@end
