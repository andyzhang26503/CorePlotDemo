//
//  CPDSecondViewController.m
//  CorePlotDemo
//
//  Created by andyzhang on 13-7-30.
//  Copyright (c) 2013年 andyzhang. All rights reserved.
//

#import "CPDBarGraphViewController.h"

@interface CPDBarGraphViewController ()


@end

CGFloat const CPDBarWidth = 0.25f;
CGFloat const CPDBarInitialX = 0.25f;

@implementation CPDBarGraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initPlot];
}

- (void)initPlot{
    self.hostView.allowPinchScaling = NO;
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

- (void)configureGraph
{
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hostView.hostedGraph = graph;
    
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];
    graph.paddingBottom = 30.0f;
    graph.paddingLeft = 30.0f;
    graph.paddingTop = -1.0f;
    graph.paddingRight = -5.0f;
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    
    NSString *title = @"Portfolio Prices: April 23 - 27, 2012";
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -16.0f);
    
    CGFloat xMin = 0.0f;
    CGFloat xMax = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    CGFloat yMin = 0.0f;
    CGFloat yMax = 800.0f;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
}

- (void)configurePlots
{
    self.aaplPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
    self.aaplPlot.identifier = CPDTickerSymbolAAPL;
    
    self.googPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
    self.googPlot.identifier = CPDTickerSymbolGOOG;
    self.msftPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    self.msftPlot.identifier = CPDTickerSymbolMSFT;
    
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor lightGrayColor];
    barLineStyle.lineWidth = 0.5;
    
    CPTGraph *graph = self.hostView.hostedGraph;
    CGFloat barX = CPDBarInitialX;
    NSArray *plots = [NSArray arrayWithObjects:self.aaplPlot,self.googPlot,self.msftPlot, nil];
    for (CPTBarPlot *plot in plots) {
        plot.dataSource = self;
        plot.delegate = self;
        plot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
        plot.barOffset = CPTDecimalFromDouble(barX);
        plot.lineStyle = barLineStyle;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        barX += CPDBarWidth;
    }
    
    
}

- (void)configureAxes
{
//    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
//    axisTitleStyle.color = [CPTColor whiteColor];
//    axisTitleStyle.fontName = @"Helvetica-Bold";
//    axisTitleStyle.fontSize = 12.0f;
//    
//    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
//    axisLineStyle.lineWidth = 2.0f;
//    axisLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1];
//    
//    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.hostView.hostedGraph.axisSet;
//    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
//    axisSet.xAxis.title = @"Days of Week (Mon -Fri)";
//    axisSet.xAxis.titleTextStyle = axisTitleStyle;
//    axisSet.xAxis.titleOffset = 10.0f;
//    axisSet.xAxis.axisLineStyle = axisLineStyle;
//    
//    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
//    axisSet.yAxis.title = @"Price";
//    axisSet.yAxis.titleTextStyle = axisTitleStyle;
//    axisSet.yAxis.titleOffset = 5.0f;
//    axisSet.yAxis.axisLineStyle = axisLineStyle;
}

- (void)hideAnnotation:(CPTGraph *)graph
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CPTPlotDataSource methods
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    if ((fieldEnum ==CPTBarPlotFieldBarTip)&&(idx < [[[CPDStockPriceStore sharedInstance] datesInWeek] count])) {
        if ([plot.identifier isEqual:CPDTickerSymbolAAPL]) {
            return [[[CPDStockPriceStore sharedInstance] weeklyPrices:CPDTickerSymbolAAPL] objectAtIndex:idx];
        }else if([plot.identifier isEqual:CPDTickerSymbolGOOG]){
            return [[[CPDStockPriceStore sharedInstance] weeklyPrices:CPDTickerSymbolGOOG] objectAtIndex:idx];
        }else if([plot.identifier isEqual:CPDTickerSymbolMSFT]){
            return [[[CPDStockPriceStore sharedInstance] weeklyPrices:CPDTickerSymbolMSFT] objectAtIndex:idx];
        }
    }
    return [NSDecimalNumber numberWithUnsignedInteger:idx];
}

#pragma mark - CPTBarPlotDelegate methods
- (void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)idx
{
    
}


- (IBAction)aaplSwitched:(id)sender {
}

- (IBAction)googSwitched:(id)sender {
}

- (IBAction)msftSwitched:(id)sender {
}
@end
