//
//  SWODDatabase.m
//  Biathlon
//
//  Created by Philip Henson on 6/15/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

#import "SWODDatabase.h"

@implementation SWODDatabase

static SWODDatabase *_database;

+ (SWODDatabase*)database {
    if (_database == nil) {
        _database = [[SWODDatabase alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [self databasePath];
        
        /* Manually remove database from documents folder */
        
//        NSError *error;
//        if ([fileManager fileExistsAtPath:filePath] == YES) {
//            [fileManager removeItemAtPath:filePath error:&error];
//        }
        
        if (![fileManager fileExistsAtPath:filePath]) {
            NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"biathlon"
                                                                 ofType:@"sqlite"];
            [fileManager copyItemAtPath:sqLiteDb
                                 toPath:filePath
                                  error:NULL];
        }
        
    }
    return self;
}

- (NSString *)databasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    return [documentsDirectory stringByAppendingPathComponent:@"biathlon.sqlite"];
}

- (NSArray *)getAllSWODs
{
    
    NSMutableArray *workouts = [NSMutableArray array];
    FMDatabase *database = [FMDatabase databaseWithPath:[self databasePath]];
    [database open];

    FMResultSet *resultSet = [database executeQuery:@"SELECT * from swodTable"];
    
    while ([resultSet next]) {
        
        SWOD *workout = [[SWOD alloc]init];
        
        workout.name     = [resultSet stringForColumn:@"name"];
        workout.description     = [resultSet stringForColumn:@"description"];
                
        [workouts addObject:workout];
        
        
    }
    
    [database close];
    
    return workouts;
}

@end
