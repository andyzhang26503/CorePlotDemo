//
//  CPDSecondViewController.h
//  CorePlotDemo
//
//  Created by andyzhang on 13-7-30.
//  Copyright (c) 2013年 andyzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPDBarGraphViewController : UIViewController<CPTBarPlotDataSource,CPTBarPlotDelegate>
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *hostView;

@property (nonatomic,strong)CPTBarPlot *aaplPlot;
@property (nonatomic,strong)CPTBarPlot *googPlot;
@property (nonatomic,strong)CPTBarPlot *msftPlot;
@property (nonatomic,strong)CPTPlotSpaceAnnotation *priceAnnotation;

- (IBAction)aaplSwitched:(id)sender;
- (IBAction)googSwitched:(id)sender;
- (IBAction)msftSwitched:(id)sender;

- (void)initPlot;
- (void)configureGraph;
- (void)configurePlots;
- (void)configureAxes;
- (void)hideAnnotation:(CPTGraph *)graph;
@end
