//
//  SBDoodleViewController.m
//  StoryBox
//
//  Created by spacewander on 14-6-20.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import "SBScrollView.h"
#import "SBDoodleView.h"
#import "SBPen.h"

@interface SBScrollView ()

@property (nonatomic, strong) SBDoodleView * doodleView;
@property (nonatomic, strong) UIImage * doodleResult;
@property (nonatomic, assign) CGRect doodleFrame;

@end

@implementation SBScrollView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self makeDoodlePossible]; 需要等到填充图片之后才能启动涂鸦功能
    }
    return self;
}

/**
 *  初始化涂鸦视图，并添加到scrollView中
 */
- (void) makeDoodlePossible
{
    self.doodleView = [[SBDoodleView alloc] init];
    [self addSubview:self.doodleView];
    [self.doodleView setFrame:CGRectMake(0, 0,
                                self.contentSize.width, self.contentSize.height)];
    NSLog(@"wid %f, hei %f", self.contentSize.width, self.contentSize.height);
    self.doodleViewNum = 0;// 等待其父类进一步地修改
    self.doodleView.userInteractionEnabled = NO;
    self.isDoodling = NO;
    self.doodleView.image = [[UIImage alloc] init];
}

/**
 *  将涂鸦视图重新加入到顶部
 */
- (void) moveDoodleViewAbove
{
    [self.doodleView removeFromSuperview];
    NSLog(@"move view wid %f, hei %f", self.contentSize.width, self.contentSize.height);
    NSLog(@"doodle view x %f, y %f, wid %f, hei %f", self.doodleView.frame.origin.x, self.doodleView.frame.origin.y,self.doodleView.frame.size.width, self.doodleView.frame.size.height);

    [self addSubview:self.doodleView];
    if (self.doodleResult != nil) {
        self.doodleView.image = self.doodleResult;
        [self.doodleView setFrame:self.doodleFrame];// 防止古怪的大小变换
    }
}

#pragma mark - draw, erase, and wait

/**
 *  切换到接受用户手指触摸即进行涂鸦的状态
 *
 *  @param pen 画笔，用来设置各项绘画参数
 */
- (void)startToDraw:(SBPen *)pen
{
    self.doodleView.drawMode = DOODLING;
    if (pen.color < 0 || pen.color > 4) {
        NSLog(@"在准备往画板上涂鸦时遇到错误的颜色范围。选中错误颜色: %d", pen.color);
        return;
    }
    // 注意这一部分要参照那些%dcolor.png图片的颜色，
    // 比如color=0时，颜色需要是0color.png表示的绿色.
    // 之所以不直接从图片中获取颜色，是因为图片的颜色不纯
    switch (pen.color) {
        case 0:
            self.doodleView.selectedColor = [UIColor greenColor];
            break;
        case 1:
            self.doodleView.selectedColor = [UIColor whiteColor];
            break;
        case 2:
            self.doodleView.selectedColor = [UIColor blueColor];
            break;
        case 3:
            self.doodleView.selectedColor = [UIColor redColor];
            break;
        case 4:
            self.doodleView.selectedColor = [UIColor blackColor];
            break;
        default:
            break;
    }
    
    self.doodleView.weight = pen.radius;
    self.doodleView.userInteractionEnabled = YES;
    self.isDoodling = YES;
    self.scrollEnabled = NO;
    NSLog(@"P");
}

/**
 *  切换到接受用户手指触摸即进行擦除的状态
 *
 *  @param pen 橡皮，用来设置擦除范围的大小
 */
- (void)startToErase:(SBPen *)pen
{
    self.doodleView.drawMode = ERASER;
    self.doodleView.weight = pen.radius;
    self.doodleView.userInteractionEnabled = YES;
    self.isDoodling = YES;
    self.scrollEnabled = NO;
        NSLog(@"E");
}

/**
 *  切换到什么都不干的状态。此时用户手势输入交由底下一个视图进行处理。
 */
- (void)waitForNext
{
    self.doodleView.drawMode = PEN;
//    self.doodleView.userInteractionEnabled = NO;
    self.isDoodling = NO;
    self.scrollEnabled = YES;
        NSLog(@"W");
}

/**
 *  更新画笔或橡皮的大小
 *
 *  @param weight 新的大小
 */
- (void)updatePenWeight:(unsigned int)weight
{
    self.doodleView.weight = weight;
}

/**
 *  返回涂鸦的结果
 *
 *  @return 当前涂鸦的内容，UIImage类型
 */
- (SBDoodleView *)saveDoodleView
{
    if (self.doodleView.image == nil) {
        self.doodleView.image = [[UIImage alloc] init];
    }
    return self.doodleView;
}

/**
 *  记录变形之前的涂鸦视图
 */
- (void) recordDoodleView
{
    self.doodleResult = [UIImage imageWithCGImage:self.doodleView.image.CGImage];
    self.doodleFrame = self.doodleView.frame;
}
@end
