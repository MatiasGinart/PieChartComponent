//
//  PieChartView.m
//  PieChartComponent
//
//  Created by Matías Ginart on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "PieChartView.h"

@implementation PieChartView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setConfiguration:(PieChartConfiguration *)configuration {
    if (configuration != _configuration) {
        _configuration = configuration;
    }
    [self reloadData];
}

- (void)reloadData {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat lastAngle = 0;
    for (NSUInteger index = 0; index < self.configuration.items.count; index++) {
        PieChartItem* item = self.configuration.items[index];

        //Colors settings
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context,0);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetFillColorWithColor(context,[[self.configuration colorForItem:item] CGColor]);

        //Begin Context
        CGContextBeginPath(context);
        
        //Angle settings
        CGFloat radious = self.frame.size.width/2;
        radious = radious * .75;
        CGFloat toAngle = lastAngle + item.percentage*2*M_PI;
    
        CGContextAddArc(context, self.frame.size.width/2,self.frame.size.height/2,radious,lastAngle,toAngle,NO);
        CGContextAddLineToPoint(context, self.frame.size.width/2,self.frame.size.height/2);
        CGContextClosePath(context);
        CGContextDrawPath(context,kCGPathFillStroke);
        NSLog(@"From %.0f to %.0f",lastAngle,toAngle);
        lastAngle = toAngle;
    }
}

@end
