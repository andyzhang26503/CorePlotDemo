//
//  CPDFirstViewController.h
//  CorePlotDemo
//
//  Created by andyzhang on 13-7-30.
//  Copyright (c) 2013年 andyzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPDPieChartViewController : UIViewController<UIActionSheetDelegate,CPTPieChartDataSource>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *themeButton;

@property (strong,nonatomic)CPTGraphHostingView *hostView;
@property (nonatomic,strong) CPTTheme *selectedTheme;

- (IBAction)themeTapped:(id)sender;

- (void)initPlot;
- (void)configureHost;
- (void)configureGraph;
- (void)configureChart;
- (void)configureLegend;


@end
