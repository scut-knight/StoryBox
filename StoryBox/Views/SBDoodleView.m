//
//  SBDoodleView.m
//  StoryBox
//
//  Created by spacewander on 14-6-22.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import "SBDoodleView.h"
#import "SBScrollView.h"

@implementation SBDoodleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

/**
 *  @overwrite
 */
- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:self.bounds];
}

- (void) setParentView:(SBScrollView *)parentView
{
    delegate = parentView;
}

/**
 *  调用该私有方法完成初始化的重任
 */
- (void)initialize
{
    //    self.opaque = NO;
    self.currentPoint = CGPointMake(0, 0);
    self.previousPoint = self.currentPoint;
    
    self.drawMode = PEN;
    self.selectedColor = [UIColor blackColor];
}

/**
 *  根据当前状态的不同，来处理触摸事件对视图的影响
 */
- (void)handleTouches
{
    switch (self.drawMode) {
        case PEN:
            // do nothing
            break;
        case DOODLING:
            [self drawLineNew];
            break;
        case ERASER:
            [self eraseLine];
        default:
            break;
    }
}

#pragma mark - 具体的画图和擦除的实现

- (void)eraseLine
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:self.bounds];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.weight);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.previousPoint.x, self.previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.currentPoint.x, self.currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.previousPoint = self.currentPoint;
    
    
    [self setNeedsDisplay];
}

- (void)drawLineNew
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:self.bounds];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.weight);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.previousPoint.x, self.previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.currentPoint.x, self.currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.previousPoint = self.currentPoint;
    
    [self setNeedsDisplay];
}

#pragma mark - Touches methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    self.previousPoint = p;
    
    // 使用contentSize来划定涂鸦的边界，而不是原始的frame大小
    x0 = self.superview.frame.origin.x;
    x1 = self.superview.frame.origin.x + self->delegate.contentSize.width;
    y0 = self.superview.frame.origin.y;
    y1 = self.superview.frame.origin.y + self->delegate.contentSize.height;
    NSLog(@"左上角 (%f, %f) 右下角 (%f, %f)", x0, y0, x1, y1);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = [[touches anyObject] locationInView:self];
    
//    if (self.currentPoint.x > x0 && self.currentPoint.x < x1 &&
//        self.currentPoint.y > y0 && self.currentPoint.y < y1) {
        [self handleTouches];
//    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = [[touches anyObject] locationInView:self];
    NSLog(@"当前点 %f, %f", self.currentPoint.x, self.currentPoint.y);
    
//    if (self.currentPoint.x > x0 && self.currentPoint.x < x1 &&
//        self.currentPoint.y > y0 && self.currentPoint.y < y1) {
        [self handleTouches];
//    }
}

@end
