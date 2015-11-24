//
//  LoadSensor.m
//  Biathlon
//
//  Created by Philip Henson on 7/25/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

#import "LoadSensor.h"

@implementation sensorMCP3422

-(id) init{
    return self;
}

// Class methods for handling streaming load cell data

+(float) calcLoad:(NSData *)data {
    char tempVal[data.length];
    [data getBytes:&tempVal length:data.length];
    UInt16 load;
    //load = (tempVal[0] & 0xff) | ((tempVal[1] << 8) & 0xff00);
    load = tempVal[1] & 0xff;
    load = load;
    return (float)load;
}


// Testing other calculations for load
+(float) calcLoad2:(NSData *)data {
    char tempVal[data.length];
    [data getBytes:&tempVal length:data.length];
    UInt16 load;
    load = tempVal[1] << 2;
    load = load;
    return (float)load;
}

+(float) calcLoad3:(NSData *)data {
    char tempVal[data.length];
    [data getBytes:&tempVal length:data.length];
    UInt16 load;
    load = tempVal[1] >> 1;
    load = load;
    return (float)load;
}

@end

