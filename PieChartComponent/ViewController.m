//
//  ViewController.m
//  PieChartComponent
//
//  Created by Exequiel Banga on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "ViewController.h"
#import "PieChartComponentView.h"


#import "PieChartItemsInformationScrollView.h"
#import "PieChartItem.h"
#import "PieChartConfiguration.h"
#import "AllStocksView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PieChartConfiguration* configuration = [PieChartConfiguration defaultPieChartConfiguration];
    configuration.items = [PieChartItem mock];
    configuration.selectedItem = configuration.items[0];

    PieChartComponentView* view = [PieChartComponentView view];
    view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    view.pieChartConfiguration = configuration;
    view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:view];
}


@end
