//
//  SBPenPanel.m
//  StoryBox
//
//  Created by spacewander on 14-6-16.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import "SBPenPanel.h"
#import "SBPen.h"

@interface SBPenPanel ()

-(void) setBackGroundView:(UIImageView *)view;

@property (nonatomic) UILabel *statusLabel;
//@property (nonatomic) UIButton *okBtn;
//@property (nonatomic) UIButton *leaveBtn;
@property (nonatomic) SBPen *delegate;
@end

@implementation SBPenPanel

/**
 *  使用Frame和一个作为背景的UIView来初始化
 *
 *  @param frame 视图大小
 *  @param view  视图背景
 *
 *  @return self对象
 */
- (id)initWithFrame:(CGRect)frame WithBackground:(UIImageView *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width_gemotry = frame.size.width;
        
        self.penRadiusView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, width_gemotry, 50)];
        
        // penRadiusView在penStatusView下方
        self.penStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width_gemotry, 50)];

        [self setBackGroundView:view];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width_gemotry * 2 / 3, 50)];
        self.statusLabel.text = @"aa";
        
        [self.penStatusView addSubview:self.statusLabel];

        [self showPanel:NO];

        [self addSubview:self.penRadiusView];
        [self addSubview:self.penStatusView];
    }
    return self;
}

#pragma mark - about the panel view

/**
 *  使用一个背景视图作为涂鸦面板的背景
 *
 *  @param view 背景视图，是一张纯色图片
 */
-(void) setBackGroundView:(UIImageView *)view
{
    [self addSubview:view];
}

/**
 *  更新状态说明文字
 *
 *  @param status 新的状态说明文字
 */
-(void) updateStatus:(NSString *)status
{
    self.statusLabel.text = status;
}

/**
 *  是否显示面板
 *
 *  @param ok 当ok为YES时，显示；否则不显示
 */
-(void) showPanel:(BOOL)ok
{
    if (ok) {
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

#pragma mark - about control the pen

-(void) setPenDelegate:(SBPen *)pen
{
    self.delegate = pen;
}
@end
