//
//  PieChartItemView.h
//  PieChartComponent
//
//  Created by Exequiel Banga on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartItem.h"
#import "PieChartConfiguration.h"

@interface PieChartItemView : UIView

@property (nonatomic, strong) PieChartItem* item;

+ (instancetype)view;

- (void)updateWithConfiguration:(PieChartConfiguration*)configuration item:(PieChartItem*)item;

- (void)setTextColor:(UIColor*)textColor;

@end
