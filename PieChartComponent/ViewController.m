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
//    AllStocksView* view = [[AllStocksView alloc] initWithFrame:CGRectMake(30, 30, 250, 180)];
//    view.backgroundColor = [UIColor redColor];
//    [view setAllStocks:@[@"Primero", @"Segu", @"Ter", @"Primero", @"Segu", @"Ter", @"Primero", @"Segu", @"Ter", @"Primero", @"Segu", @"Ter", @"Primero", @"Segu", @"Ter", @"Primero", @"Segu", @"Ter", @"Primero", @"Segu", @"Ter", @"Primero", @"Segu", @"Ter"]];
//    [self.view addSubview:view];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        view.frame = CGRectMake(30, 30, 210, 130);
//    });

    PieChartConfiguration* configuration = [PieChartConfiguration defaultPieChartConfiguration];
    configuration.items = [PieChartItem mock];
    configuration.selectedItem = configuration.items[0];

    PieChartComponentView* view = [PieChartComponentView view];
    view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    view.pieChartConfiguration = configuration;
    [self.view addSubview:view];


}

@end
