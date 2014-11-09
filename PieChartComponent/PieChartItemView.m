//
//  PieChartItemView.m
//  PieChartComponent
//
//  Created by Matías Ginart on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "PieChartItemView.h"

@interface PieChartItemView()
@property (nonatomic, weak) IBOutlet UILabel* titleInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel* percentageLabel;
@property (nonatomic, weak) IBOutlet UIImageView* roundImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* textWidthConstraint;
@end

@implementation PieChartItemView

+ (instancetype)view {
    PieChartItemView* objectToReturn = [[NSBundle mainBundle] loadNibNamed:@"PieChartItemView" owner:nil options:nil][0];
    return objectToReturn;
}

- (void)setItem:(PieChartItem *)item {
    if (item != _item) {
        _item = item;

        CGFloat width = [item.itemTitle sizeWithAttributes:@{NSFontAttributeName:self.titleInfoLabel.font}].width;
        self.textWidthConstraint.constant = width + 1;
        self.titleInfoLabel.text = item.itemTitle;
        self.percentageLabel.text = [NSString stringWithFormat:@"%.2f%@", item.percentage*100, @"%"];
    }
}

- (void)updateWithConfiguration:(PieChartConfiguration*)configuration item:(PieChartItem*)item {
    if (configuration.selectedItem == item) {
        [self setTextColor:configuration.selectedItemTitleColor];
    } else {
        [self setTextColor:configuration.itemTitleColor];
    }
    self.titleInfoLabel.font = configuration.itemTitleFont;
    self.percentageLabel.textColor = configuration.itemPercentageColor;
    self.percentageLabel.font = configuration.itemPercentageFont;
    // ASADO: Cambiar por tintColor con imagen
    self.roundImageView.backgroundColor = [configuration colorForItem:item];

    self.item = item;
}

- (void)setTextColor:(UIColor*)textColor {
    self.titleInfoLabel.textColor = textColor;
}

@end
