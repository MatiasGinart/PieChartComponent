//
//  PieChartCollectionViewHandler.m
//  PieChartComponent
//
//  Created by Matías Ginart on 11/7/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "PieChartCollectionViewHandler.h"
#import "PieChartCollectionViewCell.h"

#define kHeight 30


@implementation PieChartCollectionViewHandler

- (id)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = 10.f;
    }
    return self;
}

#pragma mark - Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pieChartConfiguration.selectedItem.stocks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PieChartCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPieChartComponentView forIndexPath:indexPath];
    cell.titleLabel.text = self.pieChartConfiguration.selectedItem.stocks[indexPath.row];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(120.f, 30.f);
}

@end
