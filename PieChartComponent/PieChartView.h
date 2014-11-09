//
//  PieChartView.h
//  PieChartComponent
//
//  Created by Matías Ginart on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartConfiguration.h"

@interface PieChartView : UIView

@property (nonatomic, strong) PieChartConfiguration* configuration;

- (void)selectionWasChanged;

@end
