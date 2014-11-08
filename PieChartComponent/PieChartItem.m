//
//  PieChartInformation.m
//  PieChartComponent
//
//  Created by Matías Ginart on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "PieChartItem.h"

@implementation PieChartItem

+ (NSArray*)mock {
    return @[
             [self itemWithTitle:@"Technology" stocks:@[@"MSFT", @"GOOG", @"FB", @"TW", @"AMZN", @"EBAY", @"WING", @"ALIN", @"ALE", @"RAUL"] percentage:0.25],
             [self itemWithTitle:@"Health" stocks:@[@"MSFT", @"GOOG", @"FB", @"TW", @"AMZN", @"EBAY", @"WING", @"ALIN", @"ALE", @"RAUL"] percentage:0.25],
             [self itemWithTitle:@"Industry" stocks:@[@"MSFT", @"GOOG", @"FB", @"TW", @"AMZN", @"EBAY", @"WING", @"ALIN", @"ALE", @"RAUL"] percentage:0.25],
             [self itemWithTitle:@"Mongo" stocks:@[@"MSFT", @"GOOG", @"FB", @"TW", @"AMZN", @"EBAY", @"WING", @"ALIN", @"ALE", @"RAUL"] percentage:0.25]
             ];
}

+ (instancetype)itemWithTitle:(NSString*)title stocks:(NSArray*)stocks percentage:(CGFloat)percentage {
    PieChartItem* item = [[PieChartItem alloc] init];
    item.itemTitle = title;
    item.stocks = stocks;
    item.percentage = percentage;
    return item;
}

@end
