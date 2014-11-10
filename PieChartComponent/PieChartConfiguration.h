//
//  PieChartConfiguration.h
//  PieChartComponent
//
//  Created by Exequiel Banga on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartItem.h"

@class PieChartConfiguration;

typedef void (^PieChartChangeSelectionCallback)(PieChartConfiguration* pieChartConfiguration);

@interface PieChartConfiguration : NSObject

@property (nonatomic, strong) UIColor* topViewColor;
@property (nonatomic, strong) UIColor* topTextColor;
@property (nonatomic, strong) UIFont* topTextFont;

@property (nonatomic, strong) NSArray* componentColors;
@property (nonatomic, strong) NSArray* items;

@property (nonatomic, strong) UIColor* itemTitleColor;
@property (nonatomic, strong) UIColor* selectedItemTitleColor;
@property (nonatomic, strong) UIFont* itemTitleFont;
@property (nonatomic, strong) UIColor* itemPercentageColor;
@property (nonatomic, strong) UIFont* itemPercentageFont;

@property (nonatomic, strong) UIColor* itemSectorsColor;
@property (nonatomic, strong) UIColor* itemMoreSectorsColor;
@property (nonatomic, strong) UIColor* itemSectorsTextColor;
@property (nonatomic, strong) UIFont* itemSectorsTextFont;

@property (nonatomic, assign) CGFloat animationDuration;


@property (nonatomic, weak) PieChartItem* selectedItem;
@property (nonatomic, copy) PieChartChangeSelectionCallback selectionCallback;

+ (instancetype)defaultPieChartConfiguration;

- (UIColor*)colorForItem:(PieChartItem*)pieChartItem;

@end
