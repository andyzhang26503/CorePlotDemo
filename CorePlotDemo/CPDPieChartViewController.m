//
//  CPDFirstViewController.m
//  CorePlotDemo
//
//  Created by andyzhang on 13-7-30.
//  Copyright (c) 2013年 andyzhang. All rights reserved.
//

#import "CPDPieChartViewController.h"

@interface CPDPieChartViewController ()

@end

@implementation CPDPieChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initPlot];
}

- (IBAction)themeTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Apply a Theme" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:CPDThemeNameDarkGradient,CPDThemeNamePlainBlack,CPDThemeNamePlainWhite,CPDThemeNameSlate,CPDThemeNameStocks, nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void) initPlot
{
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

- (void)configureHost
{
    CGRect parentRect = self.view.bounds;
    CGSize toolbarSize = self.toolbar.bounds.size;
    parentRect = CGRectMake(parentRect.origin.x, parentRect.origin.y+toolbarSize.height, parentRect.size.width, (parentRect.size.height - toolbarSize.height));
    
    self.hostView = [[CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = NO;
    [self.view addSubview:self.hostView];
}
- (void)configureGraph
{
    //表头
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;
    
    NSString *title = @"Portfolio Prices:May 1,2012";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor  = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
    
    self.selectedTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:self.selectedTheme];

}
- (void)configureChart
{
    CPTGraph *graph = self.hostView.hostedGraph;
    //create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = self.hostView.bounds.size.height *0.7/2;
    pieChart.identifier = graph.title;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    //create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.8];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    
    //add chart to graph
    [graph addPlot:pieChart];

}
- (void)configureLegend
{
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorRight;
    CGFloat legendPadding = -(self.view.bounds.size.width/8);
    graph.legendDisplacement = CGPointMake(legendPadding, 0.0);

}
#pragma mark - CPTPlotDataSource methods
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [[[CPDStockPriceStore sharedInstance] tickerSymbols] count];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    if (CPTPieChartFieldSliceWidth == fieldEnum) {
        return [[[CPDStockPriceStore sharedInstance] dailyPortfolioPrices] objectAtIndex:idx];
    }
    return [NSDecimalNumber zero];
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText) {
        labelText = [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    
    NSDecimalNumber *portfolioSum = [NSDecimalNumber zero];
    for (NSDecimalNumber *price in [[CPDStockPriceStore sharedInstance] dailyPortfolioPrices]) {
        portfolioSum = [portfolioSum decimalNumberByAdding:price];
    }
    
    NSDecimalNumber *price = [[[CPDStockPriceStore sharedInstance] dailyPortfolioPrices] objectAtIndex:idx];
    NSDecimalNumber *percent = [price decimalNumberByDividingBy:portfolioSum];
    
    NSString *labelValue = [NSString stringWithFormat:@"$%0.2f USD (%0.1f %%)",[price floatValue],([percent floatValue]*100.0f)];
    
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}

- (NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    if (idx < [[[CPDStockPriceStore sharedInstance] tickerSymbols] count]) {
        return [[[CPDStockPriceStore sharedInstance] tickerSymbols] objectAtIndex:idx];
    }
    return @"N/A";
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSString *themeName = kCPTPlainWhiteTheme;
    if ([title isEqualToString:CPDThemeNameDarkGradient]) {
        themeName = kCPTDarkGradientTheme;
    }else if([title isEqualToString:CPDThemeNamePlainBlack]){
        themeName = kCPTPlainBlackTheme;
    }else if([title isEqualToString:CPDThemeNamePlainWhite]){
        themeName = kCPTPlainWhiteTheme;
    }else if([title isEqualToString:CPDThemeNameSlate]){
        themeName = kCPTSlateTheme;
    }else if([title isEqualToString:CPDThemeNameStocks]){
        themeName = kCPTStocksTheme;
    }
    
    [self.hostView.hostedGraph applyTheme:[CPTTheme themeNamed:themeName]];
}
@end
