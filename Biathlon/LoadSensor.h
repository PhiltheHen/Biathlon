//
//  LoadSensor.h
//  Biathlon
//
//  Created by Philip Henson on 7/25/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

#import <Foundation/Foundation.h>


//HAL Load Cell connected to TI SensorTag ADC via I2C

@interface sensorMCP3422 : NSObject

-(id) init;
+(float) calcLoad:(NSData *)data;
+(float) calcLoad2:(NSData *)data;
+(float) calcLoad3:(NSData *)data;



@end