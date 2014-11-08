//
//  PieChartCollectionViewCell.h
//  PieChartComponent
//
//  Created by Matías Ginart on 11/7/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

+ (instancetype)view;

@end
