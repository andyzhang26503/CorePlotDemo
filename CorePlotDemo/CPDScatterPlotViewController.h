//
//  CPDScatterPlotViewController.h
//  CorePlotDemo
//
//  Created by andyzhang on 13-7-30.
//  Copyright (c) 2013年 andyzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPDScatterPlotViewController : UIViewController<CPTPlotDataSource>

@property (nonatomic,strong) CPTGraphHostingView *hostView;
@end
