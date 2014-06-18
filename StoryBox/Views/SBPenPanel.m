//
//  SBPenPanel.m
//  StoryBox
//
//  Created by spacewander on 14-6-16.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//
#import <math.h>

#import "SBPenPanel.h"
#import "SBPen.h"

/**
 *  画笔面板的状态。1. 涂鸦中 2. 选择画笔 3. 选择橡皮擦
 */
typedef enum : NSUInteger {
    DOODLING,
    PEN,
    ERASER,
} PEN_PANEL_STATE;

@interface SBPenPanel ()

-(void) paintBackGroundViewForView:(UIView *)view;
-(void) initStatusLabel;
-(void) initRadiusSlider;
-(void) initOkBtnForDoodle;
-(void) initLeaveBtn;

@property (nonatomic) CGFloat panelWidth; /// 面板的最大宽度
@property (nonatomic) CGFloat panelHeight; /// 单个面板的高度
@property (nonatomic) UISlider *radiusSlider;
@property (nonatomic) UILabel *statusLabel;
@property (nonatomic) UIButton *okBtn;
@property (nonatomic) UIButton *leaveBtn;
@property (nonatomic) SBPen *delegate;
@property (nonatomic) PEN_PANEL_STATE state;

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
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.panelWidth = frame.size.width;
        self.panelHeight = 50.0;
        
        self.penColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.panelWidth, self.panelHeight)];
        
        // penColorView在penRadiusView下方
        self.penRadiusView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.panelWidth, self.panelHeight)];
        
        [self initRadiusSlider];
        [self.penRadiusView addSubview:self.radiusSlider];
        
        // penRadiusView在penStatusView下方
        self.penStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.panelWidth, self.panelHeight)];
        
        [self initStatusLabel];
        [self initOkBtnForDoodle];
        [self initLeaveBtn];
        
        [self.penStatusView addSubview:self.statusLabel];
        [self.penStatusView addSubview:self.okBtn];
        [self.penStatusView addSubview:self.leaveBtn];

        [self showPanel:NO];

        [self paintBackGroundViewForView:self.penColorView];
        [self paintBackGroundViewForView:self.penRadiusView];
        [self paintBackGroundViewForView:self.penStatusView];
        
        [self addSubview:self.penColorView];
        [self addSubview:self.penRadiusView];
        [self addSubview:self.penStatusView];
        
        self.state = PEN; // 初始状态是准备选择画笔
    }
    return self;
}

#pragma mark - about the panel view

/**
 *  初始化状态标签
 */
-(void) initStatusLabel
{
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, self.panelWidth / 2, self.panelHeight)];
}

/**
 *  初始化半径滑动条
 */
-(void) initRadiusSlider
{
    self.radiusSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 10, self.panelWidth - 20, 30)];
    self.radiusSlider.minimumValue = 1.0;
    self.radiusSlider.maximumValue = 50.0;
    [self.radiusSlider setValue:10.0 animated:NO];
    [self.radiusSlider addTarget:self
                          action:@selector(sliderValueChanged:)
                          forControlEvents:UIControlEventValueChanged];
}

-(void) initOkBtnForDoodle
{
    self.okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.okBtn setFrame:CGRectMake(self.panelWidth - 110, 10, 40, 30)];
    [self.okBtn setTitle:@"涂鸦" forState:UIControlStateNormal];
    [self.okBtn addTarget:self action:@selector(prepareForDoodle)
         forControlEvents:UIControlEventTouchUpInside];
}

-(void) initLeaveBtn
{
    self.leaveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.leaveBtn setFrame:CGRectMake(self.panelWidth - 50, 10, 40, 30)];
    [self.leaveBtn setTitle:@"暂停" forState:UIControlStateNormal];
}

/**
 *  初始化画笔颜色面板的内容
 */
-(void) fillPenColorPanel
{
    for (UIView *view in self.penColorView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    //初始化颜色按钮
    for (int i=0; i<5; ++i)
    {
        UIButton * modelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [modelBtn setTag:i];
        [modelBtn setFrame:CGRectMake(28+i*58,26, 33, 33)];//60 //36
        [modelBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%dcolor.png",i]] forState:UIControlStateNormal];
         // 涂鸦
        [modelBtn addTarget:self action:@selector(clickColorForPen:) forControlEvents:UIControlEventTouchUpInside];
        [self.penColorView addSubview:modelBtn];
    }
}

/**
 *  使用一个背景视图作为涂鸦面板的背景
 */
-(void) paintBackGroundViewForView:(UIView *)view
{
    UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,320,self.panelHeight)];
    [view1 setImage:[UIImage imageNamed:@"colorbg1.png"]];
    [view addSubview:view1];
}

/**
 *  更新状态说明文字
 *
 *  @param status 新的状态说明文字
 */
-(void) updateStatus:(NSString *)status
{
    self.statusLabel.text = status;
    // 根据图片的颜色来设置说明文字的颜色
    self.statusLabel.textColor = [UIColor colorWithPatternImage:
                                    [UIImage imageNamed:
                                     [NSString stringWithFormat:@"%dcolor.png", self.delegate.color]]];
    NSLog(@"%@", [self.statusLabel.textColor description]);
}

/**
 *  是否显示面板
 *
 *  @param ok 当ok为YES时，显示；否则不显示
 */
-(void) showPanel:(BOOL)ok
{
    // 注意hidden属性的设置不是双向的。如果设置超类的hidden为NO，子类不一定显示；
    // 如果设置超类的hidden为YES，子类就一定会被隐藏。
    if (ok) {
        self.hidden = NO;
        for (UIView *view in self.subviews) {
            view.hidden = NO;
        }
    } else {
        self.hidden = YES;
    }
}

#pragma mark - about control the pen

-(void) setPenDelegate:(SBPen *)pen
{
    if (pen == nil) {
        NSLog(@"画笔不能为空");
    }
    self.delegate = pen;
}

/**
 *  设置画笔的颜色。在penColorView中的按钮被点击后触发
 *
 *  @param sender 触发事件的按钮
 */
-(void)clickColorForPen:(id)sender
{
    int color = [sender tag];
    if (color > 4 || color < 0) {
        NSLog(@"画笔颜色面板中的触发按钮标签有误，不应该是%d", color);
    }
    else {
        self.delegate.color = color;
        [self updateStatus:[self.delegate description]];
    }
}

/**
 *  设置画笔的半径。
 *
 *  @param sender 由半径滑动条触发
 */
- (void) sliderValueChanged:(id)sender
{
    UISlider * control = (UISlider *)sender;
    unsigned int before = self.delegate.radius;
    if(control == self.radiusSlider) {
        self.delegate.radius = (unsigned int)(control.value);
    }
    if (abs(before - self.delegate.radius) >= 1) {
        [self updateStatus:[self.delegate description]];
    }
}

#pragma mark - about switch from status

/**
 *  切换到准备选择画笔的状态
 */
-(void)prepareForSelectPen
{
    [self showPanel:YES];
}

/**
 *  切换到正在涂鸦的状态
 */
-(void)prepareForDoodle
{
    // 首先，是面板的形态要发生改变
    
    [self.penStatusView removeFromSuperview];
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
    
    // 只填充状态框
    self.penStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.panelWidth, self.panelHeight)];
    [self addSubview:self.penStatusView];
    
    self.state = DOODLING;
}
@end
