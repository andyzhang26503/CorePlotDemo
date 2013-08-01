//
//  CPDScatterPlotViewController.m
//  CorePlotDemo
//
//  Created by andyzhang on 13-7-30.
//  Copyright (c) 2013年 andyzhang. All rights reserved.
//

#import "CPDScatterPlotViewController.h"

@interface CPDScatterPlotViewController ()

@end

@implementation CPDScatterPlotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initPlot];
}

- (void)initPlot
{
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

- (void)configureHost
{
    
}

- (void)configureGraph
{
    
}

- (void)configurePlots
{
    
}

- (void)configureAxes
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
    return 0;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    return [NSDecimalNumber zero];
}
@end
