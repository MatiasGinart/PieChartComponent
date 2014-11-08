//
//  PieChartItemsInformationScrollView.m
//  PieChartComponent
//
//  Created by Matías Ginart on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "PieChartItemsInformationScrollView.h"
#import "PieChartItemView.h"

@interface PieChartItemsInformationScrollView()
@property (nonatomic, strong) NSMutableArray* itemsView;
@end

@implementation PieChartItemsInformationScrollView

- (NSMutableArray*)itemsView {
    if (!_itemsView) {
        _itemsView = [NSMutableArray array];
    }
    return _itemsView;
}

- (void)setConfiguration:(PieChartConfiguration *)configuration {
    if (configuration != _configuration) {
        _configuration = configuration;
    }
    [self reloadData];
}

- (void)reloadData {
    [self.itemsView makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemsView removeAllObjects];

    CGFloat xOrigin = 0;
    for (NSUInteger index = 0; index < self.configuration.items.count; index++) {
        PieChartItem* item = self.configuration.items[index];
        PieChartItemView* viewToAdd = [PieChartItemView view];

        [viewToAdd updateWithConfiguration:self.configuration item:item];
        CGSize size = [viewToAdd systemLayoutSizeFittingSize:CGSizeMake(7000.f, self.frame.size.height)];
        viewToAdd.frame = CGRectMake(xOrigin, 0, size.width, self.frame.size.height);

        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [viewToAdd addGestureRecognizer:tapRecognizer];
        [self addSubview:viewToAdd];
        [self.itemsView addObject:viewToAdd];
        xOrigin += viewToAdd.frame.size.width;
    }

    self.contentSize = CGSizeMake(xOrigin, self.frame.size.height);
}

- (void)selectionWasChanged {
    NSInteger indexOfViewToScrollTo = [self.configuration.items indexOfObject:self.configuration.selectedItem];

    for (NSUInteger index = 0; index < self.itemsView.count; index++) {
        PieChartItemView* itemView = self.itemsView[index];
        if (index != indexOfViewToScrollTo) {
            [itemView setTextColor:self.configuration.itemTitleColor];
        } else {
            [itemView setTextColor:self.configuration.selectedItemTitleColor];
        }
    }

    if (indexOfViewToScrollTo < self.itemsView.count) {
        CGFloat xOffset = [self.itemsView[indexOfViewToScrollTo] frame].origin.x;
        if (xOffset + self.frame.size.width > self.contentSize.width) {
            xOffset = self.contentSize.width - self.frame.size.width;
        }
        [self setContentOffset:CGPointMake(xOffset, 0) animated:YES];
    }
}

- (void)viewTapped:(UITapGestureRecognizer*)gestureRecognizer {
    PieChartItemView* itemView = (PieChartItemView*)gestureRecognizer.view;
    self.configuration.selectedItem = itemView.item;
}

@end
