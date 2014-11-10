//
//  PieChartCollectionViewCell.m
//  PieChartComponent
//
//  Created by Matías Ginart on 11/7/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "StockView.h"

@interface StockView ()
@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation StockView

+ (instancetype)view {
	StockView *objectToReturn = [[NSBundle mainBundle] loadNibNamed:@"StockView" owner:nil options:nil][0];
	return objectToReturn;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = self.frame.size.height/2.5;
}

- (void)setText:(NSString *)text {
	CGSize size = [text sizeWithAttributes:@{ NSFontAttributeName:self.titleLabel.font }];
	self.titleLabel.text = text;
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, size.width, size.height);
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width + 9, size.height + 10);
}

- (void)updateWithConfiguration:(PieChartConfiguration*)configuration {
    self.imageView.tintColor = configuration.itemSectorsColor;
    self.imageView.backgroundColor = configuration.itemSectorsColor;
    self.titleLabel.textColor = configuration.itemSectorsTextColor;
    self.titleLabel.font = configuration.itemSectorsTextFont;
}

- (void)updateMoreStocksWithConfiguration:(PieChartConfiguration*)configuration {
    self.imageView.tintColor = configuration.itemMoreSectorsColor;
    self.imageView.backgroundColor = configuration.itemMoreSectorsColor;
}

@end
