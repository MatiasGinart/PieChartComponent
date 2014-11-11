//
//  PieChartView.m
//  PieChartComponent
//
//  Created by Exequiel Banga on 11/5/14.
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
@property(nonatomic,assign) CGFloat animationSizePercentage;
@property(nonatomic,assign) CGFloat animationResizing;
@property(nonatomic,assign) CGFloat animationAngleOffset;
@property(nonatomic,assign) CGFloat animationChangeAngle;
@property(nonatomic,assign) CGFloat animationSumAngle;

@end


@implementation PieChartView

#pragma mark - init
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.animationFrequency = 1./40.0;
        self.selectedItemSize = .15;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (CGFloat)radiansFromPoint:(CGPoint)point{
    CGFloat radian;
    if (point.y >= 0) {
        radian = atan2f(point.y, point.x);
    }else{
        radian =  atan2f(point.y, point.x)+2*M_PI;
    }
    
    //Clockwise change
    radian = 2*M_PI-radian;
    return radian;
}

-(void)viewTapped:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self];
    point = CGPointMake(point.x-self.frame.size.width/2, (self.frame.size.height/2)-point.y);
    CGFloat angle = [self radiansFromPoint:point];
    PieChartItem *item = [self itemForAngleInRadians:angle];
    
    NSLog(@"%@",item.itemTitle);
}


#pragma mark - Angles calcs
- (CGFloat)percentToRadians:(CGFloat)percent{
    return percent*2*M_PI;
}
- (CGFloat)percentToDegrees:(CGFloat)percent{
    return percent*360;
}
- (CGFloat)radiansToDegrees:(CGFloat)radians{
    return radians*180/M_PI;
}

- (CGFloat)degreesToRadians:(CGFloat)degrees{
    return degrees*M_PI/180;
}

- (CGFloat)totalAngleOffset{
    //Chequear lasitem vs configuration.item
    NSUInteger selectedItemIndex = [self.configuration.items indexOfObject:self.lastSelectedItem];
    NSArray *sortedArray = [self.configuration.items subarrayWithRange:NSMakeRange(selectedItemIndex, self.configuration.items.count-selectedItemIndex)];
    sortedArray = [sortedArray arrayByAddingObjectsFromArray:[self.configuration.items subarrayWithRange:NSMakeRange(0, selectedItemIndex)]];
    
    CGFloat totalAngle = 0;
    for (NSUInteger index = 0; index < sortedArray.count; index++) {
        PieChartItem* item = sortedArray[index];
        if ([item isEqual:self.lastSelectedItem] || [item isEqual:self.configuration.selectedItem]) {
            totalAngle += [self percentToDegrees:item.percentage/2];
            if ([item isEqual:self.configuration.selectedItem]) {
                break;
            }
        }else{
            totalAngle += [self percentToDegrees:item.percentage];
        }
    }
    if (totalAngle > 180) {
        totalAngle -= 360;
    }
    return -[self degreesToRadians:totalAngle];
}

//Parameters must be in radians
- (BOOL)angle:(CGFloat )angle isInRangeFrom:(CGFloat)from to:(CGFloat)to{
    CGFloat angleNormalized = angle > 0 ? angle: angle + 2*M_PI;
    CGFloat fromNormalized = from > 0 ? from: from + 2*M_PI;
    CGFloat toNormalized = to > 0 ? to: to + 2*M_PI;
    //One cycle completed
    if(fromNormalized > toNormalized){
        fromNormalized -= 2*M_PI;
    }
    NSLog(@"Buscando:%.2f, from:%.2f, to:%.2f",angleNormalized,fromNormalized,toNormalized);
    return fromNormalized <= angleNormalized && toNormalized >= angleNormalized;
}

- (PieChartItem *)itemForAngleInRadians:(CGFloat)radians{
    CGFloat radiansWithOffset = radians;// - (M_PI + [self percentToRadians:self.lastSelectedItem.percentage])/2;
    
    NSUInteger selectedItemIndex = [self.configuration.items indexOfObject:self.lastSelectedItem];
    NSArray *sortedArray = [self.configuration.items subarrayWithRange:NSMakeRange(selectedItemIndex, self.configuration.items.count-selectedItemIndex)];
    sortedArray = [sortedArray arrayByAddingObjectsFromArray:[self.configuration.items subarrayWithRange:NSMakeRange(0, selectedItemIndex)]];
    
    CGFloat fromAngle = - (M_PI + [self percentToRadians:self.lastSelectedItem.percentage])/2;;
    for (NSUInteger index = 0; index < sortedArray.count; index++) {
        PieChartItem* item = sortedArray[index];
        CGFloat toAngle = fromAngle + [self percentToRadians:item.percentage];
        
        if ([self angle:radiansWithOffset isInRangeFrom:fromAngle to:toAngle]) {
            return item;
        }
        fromAngle = toAngle;
    }
    return nil;
}

#pragma mark - Setup
- (void)selectionWasChanged {
    if (![self.lastSelectedItem isEqual:self.configuration.selectedItem]) {
        
        //Make Deselection
        NSTimeInterval delay = 0;
        [self performSelector:@selector(prepareForDeselectAnimation) withObject:nil afterDelay:delay];
        
        //Make Rotation
        delay = self.configuration.animationDuration/3.0;
        [self performSelector:@selector(prepareForRotationAnimation) withObject:nil afterDelay:delay];

    }
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

#pragma mark - Animation

- (void)animationDeselection{
    [self drawItemsWithSelectedPercentageSize:self.animationSizePercentage > 0?self.animationSizePercentage:0 angleOffset:0];
    if (self.animationSizePercentage>0) {
        self.animationSizePercentage -= self.animationResizing;
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:self.animationFrequency];
    }
}

- (void)prepareForDeselectAnimation{
    self.animationResizing = self.selectedItemSize * self.animationFrequency / (self.configuration.animationDuration/3);
    self.animationSizePercentage = self.selectedItemSize;
    self.animationState = AnimationStateDeselecting;
    [self setNeedsDisplay];
}

- (void)animationRotation{
    [self drawItemsWithSelectedPercentageSize:0 angleOffset:self.animationAngleOffset];
    self.animationSumAngle += self.animationChangeAngle;
    if (fabs(self.animationSumAngle) <= fabs([self totalAngleOffset])) {
        self.animationAngleOffset += self.animationChangeAngle;
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:self.animationFrequency];
    }else{
        //Update last selected item and make Selection
        [self performSelector:@selector(prepareForSelectAnimation) withObject:nil afterDelay:self.animationFrequency];
    }
}

-(void)prepareForRotationAnimation{
    self.animationState = AnimationStateRotating;
    self.animationSumAngle = 0;
    self.animationAngleOffset = 0;
    self.animationChangeAngle = [self totalAngleOffset] * self.animationFrequency / (self.configuration.animationDuration/3);
    self.animationState = AnimationStateRotating;
    [self setNeedsDisplay];
}

- (void)animationSelection{
    [self setLastSelectedItem: self.configuration.selectedItem];
    [self drawItemsWithSelectedPercentageSize:self.animationSizePercentage < self.selectedItemSize
     ?self.animationSizePercentage:self.selectedItemSize angleOffset:0];
    if (self.animationSizePercentage<self.selectedItemSize) {
        self.animationSizePercentage += self.animationResizing;
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:self.animationFrequency];
    }
}

- (void)prepareForSelectAnimation{
    self.animationResizing = self.selectedItemSize * self.animationFrequency / (self.configuration.animationDuration/3);
    self.animationSizePercentage = 0;
    self.animationState = AnimationStateSelecting;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawItemsWithSelectedPercentageSize:(CGFloat)selectedPercentage angleOffset:(CGFloat)angleOffset{
    //Big circle
    NSUInteger selectedItemIndex = [self.configuration.items indexOfObject:self.lastSelectedItem];
    NSArray *sortedArray = [self.configuration.items subarrayWithRange:NSMakeRange(selectedItemIndex, self.configuration.items.count-selectedItemIndex)];
    sortedArray = [sortedArray arrayByAddingObjectsFromArray:[self.configuration.items subarrayWithRange:NSMakeRange(0, selectedItemIndex)]];
    
    CGFloat lastAngle = angleOffset - (M_PI + [self percentToRadians:self.lastSelectedItem.percentage])/2;
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
        if ([self.lastSelectedItem isEqual:item]) {
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
        if ([self.lastSelectedItem isEqual:item]) {
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
    CGContextSetFillColorWithColor(context,[[UIColor whiteColor] CGColor]);
    
    CGFloat radious = self.frame.size.width/2;
    radious = radious * 0.4;
    CGContextAddArc(context, self.frame.size.width/2,self.frame.size.height/2,radious,0,2*M_PI,NO);
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFillStroke);
}

- (void)drawRect:(CGRect)rect {
    switch (self.animationState) {
        case AnimationStateNoAnimaton:{
            [self drawItemsWithSelectedPercentageSize:self.selectedItemSize angleOffset:0];
        }
            break;
        case  AnimationStateDeselecting:{
            [self animationDeselection];
        }
            break;
        case  AnimationStateSelecting:{
            [self animationSelection];
        }
            break;
        case  AnimationStateRotating:{
            [self animationRotation];
        }
            break;
        default:
            break;
    }
}

@end
