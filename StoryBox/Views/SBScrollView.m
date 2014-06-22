//
//  SBDoodleViewController.m
//  StoryBox
//
//  Created by spacewander on 14-6-20.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import "SBScrollView.h"
#import "SBPen.h"

@interface SBScrollView ()

-(void) initialize;
-(void) drawLineNew;
-(void) eraseLine;
-(void) handleTouches;

@property (nonatomic, assign) CGPoint previousPoint;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) PEN_STATE drawMode;
@property (nonatomic, strong) UIImage * viewImage;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, assign) unsigned int weight;
@end

@implementation SBScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)drawRect:(CGRect)rect
{
    [self.viewImage drawInRect:self.bounds];
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

#pragma mark - draw, erase, and wait

/**
 *  切换到接受用户手指触摸即进行涂鸦的状态
 *
 *  @param pen 画笔，用来设置各项绘画参数
 */
- (void)startToDraw:(SBPen *)pen
{
    self.drawMode = DOODLING;
    if (pen.color < 0 || pen.color > 4) {
        NSLog(@"在准备往画板上涂鸦时遇到错误的颜色范围。选中错误颜色: %d", pen.color);
        return;
    }
    // 注意这一部分要参照那些%dcolor.png图片的颜色，
    // 比如color=0时，颜色需要是0color.png表示的绿色.
    // 之所以不直接从图片中获取颜色，是因为图片的颜色不纯
    switch (pen.color) {
        case 0:
            self.selectedColor = [UIColor greenColor];
            break;
        case 1:
            self.selectedColor = [UIColor whiteColor];
            break;
        case 2:
            self.selectedColor = [UIColor blueColor];
            break;
        case 3:
            self.selectedColor = [UIColor redColor];
            break;
        case 4:
            self.selectedColor = [UIColor blackColor];
            break;
        default:
            break;
    }
    
    self.weight = pen.radius;
    NSLog(@"P");
}

/**
 *  切换到接受用户手指触摸即进行擦除的状态
 *
 *  @param pen 橡皮，用来设置擦除范围的大小
 */
- (void)startToErase:(SBPen *)pen
{
    self.drawMode = ERASER;
    NSLog(@"%d", pen.radius);
    self.weight = pen.radius;
        NSLog(@"E");
}

/**
 *  切换到什么都不干的状态。此时用户手势输入交由底下一个视图进行处理。
 */
- (void)waitForNext
{
    self.drawMode = PEN;
        NSLog(@"W");
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

/**
 *  更新画笔或橡皮的大小
 *
 *  @param weight 新的大小
 */
- (void)updatePenWeight:(unsigned int)weight
{
    self.weight = weight;
}

#pragma mark - 具体的画图和擦除的实现

- (void)eraseLine
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.weight);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.previousPoint.x, self.previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.currentPoint.x, self.currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.previousPoint = self.currentPoint;
    
    [self setNeedsDisplay];
}


- (void)drawLineNew
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.weight);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.previousPoint.x, self.previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.currentPoint.x, self.currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.previousPoint = self.currentPoint;
    
    [self setNeedsDisplay];
}

#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    self.previousPoint = p;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = [[touches anyObject] locationInView:self];
    
    [self handleTouches];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = [[touches anyObject] locationInView:self];
    
    [self handleTouches];
}

@end
