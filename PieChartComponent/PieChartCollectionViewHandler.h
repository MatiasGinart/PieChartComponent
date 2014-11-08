//
//  PieChartCollectionViewHandler.h
//  PieChartComponent
//
//  Created by Matías Ginart on 11/7/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartConfiguration.h"

#define kPieChartComponentView @"kPieChartComponentView"

@interface PieChartCollectionViewHandler : UICollectionViewFlowLayout <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PieChartConfiguration* pieChartConfiguration;

@end
