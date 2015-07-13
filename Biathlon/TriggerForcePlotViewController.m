//
//  TriggerForcePlotViewController.m
//  Biathlon
//
//  Created by Philip Henson on 7/26/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

//
//  CPDScatterPlotViewController.m
//  CorePlotDemo
//
//  Created by Fahim Farook on 19/5/12.
//  Copyright 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import "TriggerForcePlotViewController.h"

@interface TriggerForcePlotViewController ()

@end

@implementation TriggerForcePlotViewController

@synthesize d;
@synthesize loadSensor;
@synthesize sensorsEnabled;
@synthesize hostView = hostView_;
@synthesize rawData, plotData;

static const NSUInteger kMaxDataPoints = 100;
static const double kFrameRate = 5.0;
NSUInteger currentIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.loadSensor = [[sensorMCP3422 alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Initializations
    
    self.sensorsEnabled = [[NSMutableArray alloc] init];
    self.rawData = [[NSMutableArray alloc] init];
    self.plotData = [[NSMutableArray alloc] initWithCapacity:kMaxDataPoints];
    [self initPlot];
    
    if (self.d.p.state == CBPeripheralStateDisconnected) {
        self.d.manager.delegate = self;
        [self.d.manager connectPeripheral:self.d.p options:nil];
    }
    else {
        self.d.p.delegate = self;
        [self configureSensorTag];
    }
    
    
    // Set up NSTimer to govern data plotting frequency
    if (animated){
        [NSTimer scheduledTimerWithTimeInterval:(1/kFrameRate)
                                         target:self
                                       selector:@selector(refreshPlot:)
                                       userInfo:nil
                                        repeats:YES];
    }
    
    
}

-(void) refreshPlot:(NSTimer *)timer {
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTPlot *plot   = [graph plotWithIdentifier:@"Force Plot"];
    
    if ( plot ) {
        // Cull old data to make room for new
        if ( self.plotData.count >= kMaxDataPoints ) {
            [self.plotData removeObjectAtIndex:0];
            [plot deleteDataInIndexRange:NSMakeRange(0, 1)];
        }
        
        // Set up plot space
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
        NSUInteger location       = (currentIndex >= kMaxDataPoints ? currentIndex - kMaxDataPoints + 2 : 0);
        CPTPlotRange *newRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(location)
                                                              length:CPTDecimalFromUnsignedInteger(kMaxDataPoints + (kMaxDataPoints/2))];
        
        
        [CPTAnimation animate:plotSpace
                     property:@"xRange"
                fromPlotRange:plotSpace.xRange
                  toPlotRange:newRange
                     duration:CPTFloat(1/kFrameRate)];
        
        
        currentIndex++;
        

        

            // Plot data in real time
        
        
        
        /*
        // High Pass Filter
        double dt = 1.0 / 100;
        double RC = 1.0 / kFrameRate;
        double HP_filter = RC/(dt+RC);
        double lastPlotValue;
        if(([self.rawData lastObject] != nil) && count>1){
            
            // Initialize fist element of plotData
            if (self.plotData.count ==0)
                lastPlotValue = HP_filter * [[self.rawData lastObject] doubleValue];
            else
                lastPlotValue = [[self.plotData lastObject] doubleValue];
            
            // Apply Filter
            double newData = (HP_filter * lastPlotValue) + (HP_filter * ([self.rawData[count-1] doubleValue] - [self.rawData[count-2] doubleValue]));
            
            //[self.plotData addObject:[self.rawData lastObject]];
            [self.plotData addObject:[NSNumber numberWithDouble:newData]];
         
         */
        
         //DATA POINT AVERAGING
        
        
        int count = (int)[self.rawData count];

                if (count >=30 ){
                    float avgVal = 0.0;
                    for (int i=0; i<30; i++){
                        avgVal = avgVal + [self.rawData[count-1-i] floatValue];
                    }
                    avgVal = avgVal/30;
        
                    [self.plotData addObject:[NSNumber numberWithFloat:avgVal]];
                    
                    
                    //NSLog(@"loadVal: %f",avgVal);
        
        
        [plot insertDataAtIndex:self.plotData.count - 1 numberOfRecords:1];
        
                }

        
    }
        
    
    
}

-(void) initPlot{
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost {
    
    // Set up host view for plot as a subview
    
	self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
	self.hostView.allowPinchScaling = YES;
	[self.view addSubview:self.hostView];
    [self.plotData removeAllObjects];
    currentIndex = 0;
    self.hostView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

-(void)configureGraph {
    // Create graph
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
	[graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
	self.hostView.hostedGraph = graph;
    
	// Title
	NSString *title = @"Trigger Pull";
	graph.title = title;
	CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
	titleStyle.color = [CPTColor whiteColor];
	titleStyle.fontName = @"Helvetica-Bold";
	titleStyle.fontSize = 16.0f;
	graph.titleTextStyle = titleStyle;
	graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    
	// Padding
	[graph.plotAreaFrame setPaddingLeft:30.0f];
	[graph.plotAreaFrame setPaddingBottom:30.0f];
    [graph.plotAreaFrame setPaddingTop:10.0f];
    [graph.plotAreaFrame setPaddingRight:10.0f];
    graph.plotAreaFrame.masksToBorder = NO;
    
	// Enable user interactions for plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {
	// Get graph and plot space
	CPTGraph *graph = self.hostView.hostedGraph;
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
	// Create plot
	CPTScatterPlot *forcePlot = [[CPTScatterPlot alloc] init];
	forcePlot.dataSource = self;
    forcePlot.identifier = @"Force Plot";
    forcePlot.cachePrecision = CPTPlotCachePrecisionDouble;
	CPTColor *forceColor = [CPTColor redColor];
	[graph addPlot:forcePlot toPlotSpace:plotSpace];
    
    // Set up plot space
	[plotSpace scaleToFitPlots:[NSArray arrayWithObjects:forcePlot, nil]];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(kMaxDataPoints - 2)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(200)];
    
	// Create styles
	CPTMutableLineStyle *forceLineStyle = [forcePlot.dataLineStyle mutableCopy];
	forceLineStyle.lineWidth = 2.5;
	forceLineStyle.lineColor = forceColor;
	forcePlot.dataLineStyle = forceLineStyle;
	}

-(void)configureAxes {
	// Create styles
	CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
	axisTitleStyle.color = [CPTColor whiteColor];
	axisTitleStyle.fontName = @"Helvetica-Bold";
	axisTitleStyle.fontSize = 12.0f;
	CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
	axisLineStyle.lineWidth = 2.0f;
	axisLineStyle.lineColor = [CPTColor whiteColor];
	CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
	axisTextStyle.color = [CPTColor whiteColor];
	axisTextStyle.fontName = @"Helvetica-Bold";
	axisTextStyle.fontSize = 11.0f;
	CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor whiteColor];
	tickLineStyle.lineWidth = 2.0f;
	CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor blackColor];
	tickLineStyle.lineWidth = 1.0f;
    
	// Configure Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
	CPTAxis *x = axisSet.xAxis;
	x.title = @"Time (s)";
	x.titleTextStyle = axisTitleStyle;
	x.titleOffset = 15.0f;
	x.axisLineStyle = axisLineStyle;
	x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
	x.labelTextStyle = axisTextStyle;
	x.majorTickLineStyle = axisLineStyle;
	x.majorTickLength = 4.0f;
	x.tickDirection = CPTSignNegative;

	CPTAxis *y = axisSet.yAxis;
	y.title = @"Trigger Pull (arb units)";
	y.titleTextStyle = axisTitleStyle;
	y.titleOffset = -40.0f;
	y.axisLineStyle = axisLineStyle;
	y.majorGridLineStyle = gridLineStyle;
	y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
	y.labelTextStyle = axisTextStyle;
	y.labelOffset = 16.0f;
	y.majorTickLineStyle = axisLineStyle;
	y.majorTickLength = 4.0f;
	y.minorTickLength = 2.0f;
	y.tickDirection = CPTSignPositive;
    axisSet.yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
	return [self.plotData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
	
    NSNumber *num = nil;
    
	switch (fieldEnum) {
		case CPTScatterPlotFieldX:
			num = [NSNumber numberWithUnsignedInteger:index + currentIndex - self.plotData.count];
			break;
            
        case CPTScatterPlotFieldY:
            num = [self.plotData objectAtIndex:index];

			break;
            
            default:
            break;
	}
	return num;
}


-(void)viewWillDisappear:(BOOL)animated {
    [self deconfigureSensorTag];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    self.sensorsEnabled = nil;
    self.d.manager.delegate = nil;
    self.loadSensor = nil;
    self.rawData = nil;
    self.plotData = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) configureSensorTag{
    if ([self sensorEnabled:@"Trigger Force active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Trigger Force service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Trigger Force config UUID"]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Trigger Force data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Trigger Force"];
    }
}

-(void) deconfigureSensorTag{
    if ([self sensorEnabled:@"Trigger Force active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Trigger Force service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Trigger Force config UUID"]];
        //Disable sensor
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Trigger Force data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
        
    }
}

-(bool)sensorEnabled:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    if (val) {
        if ([val isEqualToString:@"1"]) return TRUE;
    }
    return FALSE;
}

#pragma mark - CBCentralManager delegate function

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}


#pragma mark - CBperipheral delegate functions

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"..");
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Trigger Force service UUID"]]]) {
        [self configureSensorTag];
    }
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@".");
    for (CBService *s in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@, error = %@",characteristic.UUID, error);
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Trigger Force data UUID"]]]) {
        
        
        // Continuously store data as it comes in to be plot in real time
        
        float loadVal = [sensorMCP3422 calcLoad:characteristic.value];
        float loadVal2 = [sensorMCP3422 calcLoad2:characteristic.value];
        float loadVal3 = [sensorMCP3422 calcLoad3:characteristic.value];
        
        [self.rawData addObject:[NSNumber numberWithFloat:loadVal]];

        
        NSLog(@"loadVal: %f",loadVal);
    }
    
    
    
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic.UUID,error);

    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
