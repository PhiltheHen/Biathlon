//
//  TriggerForcePlotViewController.h
//  Biathlon
//
//  Created by Philip Henson on 7/26/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

//
//  CPDScatterPlotViewController.h
//  CorePlotDemo
//
//  Created by Fahim Farook on 19/5/12.
//  Copyright 2012 RookSoft Pte. Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BLEDevice.h"
#import "BLEUtility.h"
#import "LoadSensor.h"

@interface TriggerForcePlotViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, CPTPlotDataSource>


@property (strong,nonatomic) BLEDevice *d;
@property (strong, nonatomic) sensorMCP3422 *loadSensor;
@property NSMutableArray *sensorsEnabled;

@property NSMutableArray *rawData;
@property NSMutableArray *plotData;

@property (nonatomic, strong) CPTGraphHostingView *hostView;

-(void) configureSensorTag;
-(void) deconfigureSensorTag;

@end
