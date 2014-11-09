//
//  PieChartView.m
//  PieChartComponent
//
//  Created by Matías Ginart on 11/5/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "PieChartView.h"

typedef enum {
    AnimationStateDeselecting = 0,
    AnimationStateRotating,
    AnimationStateSelecting,
    AnimationStateNoAnimaton,
} AnimationState;

@interface PieChartView()
@property(nonatomic,weak)PieChartItem *lastSelectedItem;
@property(nonatomic,assign)CGFloat animationFrequency;
@property(nonatomic,assign)CGFloat selectedItemSize;
@property(nonatomic,assign)AnimationState animationState;

//Animation
@property(nonatomic,assign) CGFloat animationPercentage;
@property(nonatomic,assign) CGFloat animationDecreasing;


@end


@implementation PieChartView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.animationFrequency = 1./20.0;
        self.selectedItemSize = .15;
    }
    return self;
}
- (void)selectionWasChanged {
//    [self prepareForDeselectAnimation];
//    self.animationState = AnimationStateDeselecting;

    [self prepareForSelectAnimation];
    self.animationState = AnimationStateSelecting;
    [self setNeedsDisplay];
    self.lastSelectedItem = self.configuration.selectedItem;
}
- (void)setConfiguration:(PieChartConfiguration *)configuration {
    if (configuration != _configuration) {
        _configuration = configuration;
    }
    self.lastSelectedItem = configuration.selectedItem;
    [self reloadData];
}

- (void)reloadData {
    self.animationState = AnimationStateNoAnimaton;
    [self setNeedsDisplay];
}

- (void)animationDeselection{
    [self drawItemsWithSelectedPercentageSize:self.animationPercentage > 0?self.animationPercentage:0];
    NSLog(@"Percentage:%.4f",self.animationPercentage);
    if (self.animationPercentage>0) {
        self.animationPercentage -= self.animationDecreasing;
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:self.animationFrequency];
    }
}

- (void)prepareForDeselectAnimation{
    self.animationDecreasing = self.selectedItemSize * self.animationFrequency / (self.configuration.animationDuration/4);
    self.animationPercentage = self.selectedItemSize;
}

- (void)rotate{

}

- (void)animationSelection{
    [self drawItemsWithSelectedPercentageSize:self.animationPercentage < self.selectedItemSize
     ?self.animationPercentage:self.selectedItemSize];
    NSLog(@"Percentage:%.4f",self.animationPercentage);
    if (self.animationPercentage<self.selectedItemSize) {
        self.animationPercentage += self.animationDecreasing;
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:self.animationFrequency];
    }
}

- (void)prepareForSelectAnimation{
    self.animationDecreasing = self.selectedItemSize * self.animationFrequency / (self.configuration.animationDuration/4);
    self.animationPercentage = 0;
}

- (void)drawItemsWithSelectedPercentageSize:(CGFloat)selectedPercentage{
    //Big circle
    NSUInteger selectedItemIndex = [self.configuration.items indexOfObject:self.lastSelectedItem];
    NSArray *sortedArray = [self.configuration.items subarrayWithRange:NSMakeRange(selectedItemIndex, self.configuration.items.count-selectedItemIndex)];
    sortedArray = [sortedArray arrayByAddingObjectsFromArray:[self.configuration.items subarrayWithRange:NSMakeRange(0, selectedItemIndex)]];
    
    CGFloat lastAngle = -M_PI/2 - self.configuration.selectedItem.percentage*M_PI;
    for (NSUInteger index = 0; index < sortedArray.count; index++) {
        PieChartItem* item = sortedArray[index];
        
        //Colors settings
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context,0);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetFillColorWithColor(context,[[self.configuration colorForItem:item] CGColor]);
        
        //Begin Context
        CGContextBeginPath(context);
        
        //Angle settings
        CGFloat radious = self.frame.size.width*.725/2;
        if ([[self.configuration selectedItem]isEqual:item]) {
            radious += radious * selectedPercentage;
        }
        
        CGFloat toAngle = lastAngle + item.percentage*2*M_PI;
        
        CGContextAddArc(context, self.frame.size.width/2,self.frame.size.height/2,radious,lastAngle,toAngle,NO);
        CGContextAddLineToPoint(context, self.frame.size.width/2,self.frame.size.height/2);
        CGContextClosePath(context);
        CGContextDrawPath(context,kCGPathFillStroke);
        lastAngle = toAngle;
    }
    
    //Small circle
    for (NSUInteger index = 0; index < sortedArray.count; index++) {
        PieChartItem* item = sortedArray[index];
        
        //Colors settings
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context,0);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetFillColorWithColor(context,[[UIColor colorWithWhite:0 alpha:.2] CGColor]);
        
        //Begin Context
        CGContextBeginPath(context);
        
        //Angle settings
        CGFloat radious = self.frame.size.width*.45/2;
        if ([[self.configuration selectedItem]isEqual:item]) {
            radious += radious * selectedPercentage/2;
        }
        
        
        CGFloat toAngle = lastAngle + item.percentage*2*M_PI;
        
        CGContextAddArc(context, self.frame.size.width/2,self.frame.size.height/2,radious,lastAngle,toAngle,NO);
        CGContextAddLineToPoint(context, self.frame.size.width/2,self.frame.size.height/2);
        CGContextClosePath(context);
        CGContextDrawPath(context,kCGPathFillStroke);
        lastAngle = toAngle;
    }
    
    //White small circle
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,0);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetFillColorWithColor(context,[self.backgroundColor CGColor]);
    
    CGFloat radious = self.frame.size.width/2;
    radious = radious * 0.4;
    CGContextAddArc(context, self.frame.size.width/2,self.frame.size.height/2,radious,0,2*M_PI,NO);
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFillStroke);
}

- (void)drawRect:(CGRect)rect {
    switch (self.animationState) {
        case AnimationStateNoAnimaton:{
            [self drawItemsWithSelectedPercentageSize:self.selectedItemSize];
        }
            break;
        case  AnimationStateDeselecting:{
            [self animationDeselection];
        }
        case  AnimationStateSelecting:{
            [self animationSelection];
        }
        default:
            break;
    }
}

@end
