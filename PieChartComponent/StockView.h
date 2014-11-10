//
//  PieChartCollectionViewCell.h
//  PieChartComponent
//
//  Created by Exequiel Banga on 11/7/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartConfiguration.h"

@interface StockView : UIView

+ (instancetype)view;

- (void)setText:(NSString *)text;

- (void)updateWithConfiguration:(PieChartConfiguration*)configuration;

- (void)updateMoreStocksWithConfiguration:(PieChartConfiguration*)configuration;

@end
