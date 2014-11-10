//
//  PieChartInformation.h
//  PieChartComponent
//
//  Created by Exequiel Banga on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartItem : NSObject

@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, strong) NSArray *stocks;
@property (nonatomic) CGFloat percentage;

+ (NSArray*)mock;

+ (instancetype)itemWithTitle:(NSString*)title stocks:(NSArray*)stocks percentage:(CGFloat)percentage;

@end
