//
//  PieChartCollectionViewCell.m
//  PieChartComponent
//
//  Created by Matías Ginart on 11/7/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "PieChartCollectionViewCell.h"

@implementation PieChartCollectionViewCell

+ (instancetype)view {
    PieChartCollectionViewCell* objectToReturn = [[NSBundle mainBundle] loadNibNamed:@"PieChartCollectionViewCell" owner:nil options:nil][0];
    return objectToReturn;
}

@end
