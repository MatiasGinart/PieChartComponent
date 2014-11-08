//
//  AllStocksView.h
//  PieChartComponent
//
//  Created by Matías Ginart on 11/8/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartConfiguration.h"

@interface AllStocksView : UIView

@property (nonatomic, strong) NSArray* allStocks;
@property (nonatomic, strong) PieChartConfiguration* configuration;

@end
