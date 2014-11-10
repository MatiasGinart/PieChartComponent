//
//  AllStocksView.m
//  PieChartComponent
//
//  Created by Exequiel Banga on 11/8/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "AllStocksView.h"
#import "StockView.h"

#define kHorizontalSpace 3
#define kVerticalSpace 2

@interface AllStocksView ()
@property (nonatomic, strong) NSMutableArray *allViews;
@end

@implementation AllStocksView

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.allViews = [NSMutableArray array];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.allViews = [NSMutableArray array];
	}
	return self;
}

- (void)setAllStocks:(NSArray *)allStocks {
	if (_allStocks != allStocks) {
		_allStocks = allStocks;
		[self.allViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[self.allViews removeAllObjects];
		[self reloadData];
	}
}

- (void)setBounds:(CGRect)bounds {
	[super setBounds:bounds];
	[self reloadData];
}

- (void)setFrame:(CGRect)frame {
	if (self.frame.size.width != frame.size.width || self.frame.size.height != frame.size.height) {
		[super setFrame:frame];
		[self reloadData];
	}
	else {
		[super setFrame:frame];
	}
}

- (void)reloadData {
	CGFloat xOrigin = 0;
	CGFloat yOrigin = 0;

	NSUInteger index;
	for (index = 0; index < self.allStocks.count; index++) {
		StockView *view;
		CGFloat width;

		if (index < self.allViews.count) {
			view = self.allViews[index];
            [view updateWithConfiguration:self.configuration];
			width = view.frame.size.width;
		}
		else {
			view = [StockView view];
            [view updateWithConfiguration:self.configuration];
			[self.allViews addObject:view];
			[view setText:self.allStocks[index]];

			width = view.frame.size.width;
		}

		if (xOrigin + width + kHorizontalSpace > self.frame.size.width) {
			xOrigin = 0;
			yOrigin += view.frame.size.height + kVerticalSpace;

			if (yOrigin + view.frame.size.height > self.frame.size.height) {
				if (index == 0) {
					break;
				}
				view = self.allViews[index - 1];
                [view updateMoreStocksWithConfiguration:self.configuration];
				[view setText:[NSString stringWithFormat:@"+%lu", self.allStocks.count - (index - 1)]];
				break;
			}
		}

		[self addSubview:view];
		view.frame = CGRectMake(xOrigin, yOrigin, width, view.frame.size.height);
		xOrigin += width + kHorizontalSpace;
	}

	for (NSUInteger indexOfViewsToRemove = index; indexOfViewsToRemove < self.allViews.count; indexOfViewsToRemove++) {
		StockView *view = self.allViews[indexOfViewsToRemove];
		[view removeFromSuperview];
	}
}

@end
