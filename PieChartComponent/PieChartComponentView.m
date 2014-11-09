//
//  PieChartComponentView.m
//  PieChartComponent
//
//  Created by Matías Ginart on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "PieChartComponentView.h"
#import "AllStocksView.h"

@interface PieChartComponentView()

@property (nonatomic, weak) IBOutlet PieChartItemsInformationScrollView* componentsScrollView;
@property (nonatomic, weak) IBOutlet UIView* topView;
@property (nonatomic, weak) IBOutlet UILabel* pieChartComponentTitleLabel;
@property (nonatomic, weak) IBOutlet PieChartView* pieChartView;
@property (nonatomic, weak) IBOutlet UILabel* itemTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel* itemPercentageLabel;
@property (nonatomic, weak) IBOutlet AllStocksView* allStocksView;

@end

@implementation PieChartComponentView

+ (instancetype)view {
    PieChartComponentView* objectToReturn = [[NSBundle mainBundle] loadNibNamed:@"PieChartComponentView" owner:nil options:nil][0];
    return objectToReturn;
}

- (void)awakeFromNib {
    [super awakeFromNib];

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
    self.componentsScrollView.configuration = self.pieChartConfiguration;
    self.allStocksView.configuration = self.pieChartConfiguration;
    self.pieChartView.configuration = self.pieChartConfiguration;

    self.topView.backgroundColor = self.pieChartConfiguration.topViewColor;
    self.pieChartComponentTitleLabel.textColor = self.pieChartConfiguration.topTextColor;
    self.pieChartComponentTitleLabel.font = self.pieChartConfiguration.topTextFont;

    self.itemTitleLabel.text = self.pieChartConfiguration.selectedItem.itemTitle;
    self.itemTitleLabel.textColor = self.pieChartConfiguration.selectedItemTitleColor;
    self.itemTitleLabel.font = self.pieChartConfiguration.itemTitleFont;

    self.itemPercentageLabel.textColor = self.pieChartConfiguration.itemPercentageColor;
    self.itemPercentageLabel.font = self.pieChartConfiguration.itemPercentageFont;

    [self updateItemSelection];
}

- (void)updateItemSelection {
    self.itemTitleLabel.text = self.pieChartConfiguration.selectedItem.itemTitle;
    self.itemPercentageLabel.text = [NSString stringWithFormat:@"%.2f%@", self.pieChartConfiguration.selectedItem.percentage*100, @"%"];
    [self.componentsScrollView selectionWasChanged];
    self.allStocksView.allStocks = self.pieChartConfiguration.selectedItem.stocks;
}

@end
