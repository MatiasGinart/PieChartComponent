//
//  PieChartComponentView.h
//  PieChartComponent
//
//  Created by Exequiel Banga on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartView.h"
#import "PieChartItemsInformationScrollView.h"
#import "PieChartConfiguration.h"

@interface PieChartComponentView : UIView

@property (nonatomic, strong) PieChartConfiguration* pieChartConfiguration;

+ (instancetype)view;

@end
