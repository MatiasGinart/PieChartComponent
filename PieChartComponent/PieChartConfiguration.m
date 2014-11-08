//
//  PieChartConfiguration.m
//  PieChartComponent
//
//  Created by Matías Ginart on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "PieChartConfiguration.h"

@implementation PieChartConfiguration

+ (instancetype)defaultPieChartConfiguration {
    static dispatch_once_t once;
    static PieChartConfiguration* sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.topViewColor = [UIColor colorWithRed:211.f/255.f green:220.f/255.f blue:238.f/255.f alpha:1];
        sharedInstance.topTextColor = [UIColor colorWithRed:103.f/255.f green:119.f/255.f blue:138.f/255.f alpha:1];
        sharedInstance.topTextFont = [UIFont systemFontOfSize:17.f];
        sharedInstance.componentColors = @[
                                           [UIColor redColor],
                                           [UIColor yellowColor],
                                           [UIColor brownColor],
                                           [UIColor magentaColor]
                                           ];
        sharedInstance.itemTitleColor = [UIColor grayColor];
        sharedInstance.selectedItemTitleColor = [UIColor colorWithRed:46.f/255.f green:77.f/255.f blue:105.f/255.f alpha:1];
        sharedInstance.itemTitleFont = [UIFont systemFontOfSize:17.f];
        sharedInstance.itemPercentageColor = [UIColor grayColor];
        sharedInstance.itemPercentageFont = [UIFont systemFontOfSize:17.f];
        sharedInstance.itemSectorsColor = [UIColor yellowColor];
        sharedInstance.itemMoreSectorsColor = [UIColor brownColor];
        sharedInstance.itemSectorsTextColor = [UIColor lightGrayColor];
        sharedInstance.itemSectorsTextFont = [UIFont systemFontOfSize:17.f];
    });
    return sharedInstance;
}

- (UIColor*)colorForItem:(PieChartItem*)pieChartItem {
    NSInteger indexOfItem = [self.items indexOfObject:pieChartItem];
    NSInteger indexOfColor = indexOfItem % self.componentColors.count;
    return self.componentColors[indexOfColor];
}

- (void)setSelectedItem:(PieChartItem *)selectedItem {
    if (selectedItem != _selectedItem) {
        _selectedItem = selectedItem;
        if (self.selectionCallback) {
            self.selectionCallback(self);
        }
    }
}

@end
