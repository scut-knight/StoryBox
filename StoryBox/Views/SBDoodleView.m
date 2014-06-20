//
//  SBDoodleViewController.m
//  StoryBox
//
//  Created by spacewander on 14-6-20.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import "SBDoodleView.h"
#import "SBPen.h"

@interface SBDoodleView ()

-(void) initialize;

@property (nonatomic, assign) CGPoint previousPoint;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) PEN_STATE drawMode;
@property (nonatomic, strong) UIImage * viewImage;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, assign) unsigned int weight;
@end

@implementation SBDoodleView

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
    // 设置面板为透明
    self.opaque = NO;
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
    self.selectedColor = [UIColor colorWithPatternImage:
                          [UIImage imageNamed:
                           [NSString stringWithFormat:@"%dcolor.png", pen.color]]];
    self.weight = pen.radius;
    NSLog(@"P");
    self.hidden = NO;
}

/**
 *  切换到接受用户手指触摸即进行擦除的状态
 *
 *  @param pen 橡皮，用来设置擦除范围的大小
 */
- (void)startToErase:(SBPen *)pen
{
    self.drawMode = ERASER;
    self.weight = pen.radius;
        NSLog(@"E");
    self.hidden = NO;
}

/**
 *  切换到什么都不干的状态。此时用户手势输入交由底下一个视图进行处理。
 */
- (void)waitForNext
{
    self.drawMode = PEN;
        NSLog(@"W");
    self.hidden = YES;
}
@end
