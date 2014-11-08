//
//  PieChartComponentView.m
//  PieChartComponent
//
//  Created by Matías Ginart on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "PieChartComponentView.h"
#import "PieChartCollectionViewHandler.h"

@interface PieChartComponentView()

@property (nonatomic, weak) IBOutlet PieChartItemsInformationScrollView* componentsScrollView;
@property (nonatomic, weak) IBOutlet UIView* topView;
@property (nonatomic, weak) IBOutlet UILabel* pieChartComponentTitleLabel;
@property (nonatomic, weak) IBOutlet PieChartView* pieChartView;
@property (nonatomic, weak) IBOutlet UILabel* itemTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel* itemPercentageLabel;
@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) PieChartCollectionViewHandler* collectionViewHandler;

@end

@implementation PieChartComponentView

+ (instancetype)view {
    PieChartComponentView* objectToReturn = [[NSBundle mainBundle] loadNibNamed:@"PieChartComponentView" owner:nil options:nil][0];
    return objectToReturn;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.collectionViewHandler = [[PieChartCollectionViewHandler alloc] init];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PieChartCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kPieChartComponentView];
    self.collectionView.delegate = self.collectionViewHandler;
    self.collectionView.dataSource = self.collectionViewHandler;
    self.collectionView.collectionViewLayout = self.collectionViewHandler;

    if (self.pieChartConfiguration) {
        [self configureWithPieChartConfiguration];
    }
}

- (void)setPieChartConfiguration:(PieChartConfiguration *)pieChartConfiguration {
    if (_pieChartConfiguration != pieChartConfiguration) {
        [_pieChartConfiguration setSelectionCallback:NULL];
        _pieChartConfiguration = pieChartConfiguration;

        __weak PieChartComponentView* weakSelf = self;
        [_pieChartConfiguration setSelectionCallback:^(PieChartConfiguration* configuration) {
            PieChartComponentView* strongSelf = weakSelf;
            [strongSelf updateItemSelection];
        }];

        [self configureWithPieChartConfiguration];
    }
}

- (void)configureWithPieChartConfiguration {
    self.collectionViewHandler.pieChartConfiguration = self.pieChartConfiguration;
    self.componentsScrollView.configuration = self.pieChartConfiguration;

    self.topView.backgroundColor = self.pieChartConfiguration.topViewColor;
    self.pieChartComponentTitleLabel.textColor = self.pieChartConfiguration.topTextColor;
    self.pieChartComponentTitleLabel.font = self.pieChartConfiguration.topTextFont;

    self.itemTitleLabel.text = self.pieChartConfiguration.selectedItem.itemTitle;
    self.itemTitleLabel.textColor = self.pieChartConfiguration.selectedItemTitleColor;
    self.itemTitleLabel.font = self.pieChartConfiguration.itemTitleFont;

    self.itemPercentageLabel.text = [NSString stringWithFormat:@"%.2f%@", self.pieChartConfiguration.selectedItem.percentage, @"%"];
    self.itemPercentageLabel.textColor = self.pieChartConfiguration.itemPercentageColor;
    self.itemPercentageLabel.font = self.pieChartConfiguration.itemPercentageFont;
}

- (void)updateItemSelection {
    self.itemTitleLabel.text = self.pieChartConfiguration.selectedItem.itemTitle;
    self.itemPercentageLabel.text = [NSString stringWithFormat:@"%.2f%@", self.pieChartConfiguration.selectedItem.percentage, @"%"];
    [self.componentsScrollView selectionWasChanged];
}

@end
