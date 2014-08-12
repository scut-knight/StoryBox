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

@interface SBPenPanel ()

-(void) paintBackGroundViewForView:(UIView *)view;
-(void) initStatusLabel;
-(void) initRadiusSlider;
-(void) initOkBtnForDoodle;
-(void) initOkBtnForErase;
-(void) initLeaveBtn;
-(void) initReselectBtn;
-(void) tranformMode:(PEN_STATE)mode;

@property (nonatomic) CGFloat panelWidth; /// 面板的最大宽度
@property (nonatomic) CGFloat panelHeight; /// 单个面板的高度
@property (nonatomic) UISlider *radiusSlider;
@property (nonatomic) UILabel *statusLabel;
@property (nonatomic) UIButton *okBtn; /// 涂鸦或橡皮
@property (nonatomic) UIButton *leaveBtn; /// 离开画笔面板
@property (nonatomic) UIButton *reselectBtn; /// 重新选择画笔
@property (nonatomic) SBPen *delegate;
@property (nonatomic) PEN_STATE state;

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

        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,320, 85)];
        [view setImage:[UIImage imageNamed:@"colorbg1.png"]];
        [view setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        
        [self.penColorView addSubview:view]; // 注意penColorView的高度与其他面板不一样
        
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
    if (self.delegate != nil) {
        [self updateStatus:[self.delegate description]];
    }
}

/**
 *  初始化半径滑动条
 */
-(void) initRadiusSlider
{
    self.radiusSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 10, self.panelWidth - 20, 30)];
    self.radiusSlider.minimumValue = 1.0;
    self.radiusSlider.maximumValue = 50.0;
    if (self.delegate != nil) {
        self.radiusSlider.value = (float)self.delegate.radius;
    } else {
        self.radiusSlider.value = 10.0;
    }
    [self.radiusSlider addTarget:self
                          action:@selector(sliderValueChanged:)
                          forControlEvents:UIControlEventValueChanged];
}

-(void) initOkBtnForDoodle
{
    self.okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.okBtn setFrame:CGRectMake(self.panelWidth - 110, 10, 40, 30)];
    [self.okBtn setTitle:@"涂鸦" forState:UIControlStateNormal];
    [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okBtn addTarget:self action:@selector(prepareForDoodle)
         forControlEvents:UIControlEventTouchUpInside];
}

-(void) initOkBtnForErase
{
    self.okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.okBtn setFrame:CGRectMake(self.panelWidth - 110, 10, 40, 30)];
    [self.okBtn setTitle:@"橡皮" forState:UIControlStateNormal];
    [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okBtn addTarget:self action:@selector(prepareForErase)
         forControlEvents:UIControlEventTouchUpInside];
}

-(void) initLeaveBtn
{
    self.leaveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.leaveBtn setFrame:CGRectMake(self.panelWidth - 50, 10, 40, 30)];
    [self.leaveBtn setTitle:@"离开" forState:UIControlStateNormal];
    [self.leaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leaveBtn addTarget:self action:@selector(prepareForLeave)
            forControlEvents:UIControlEventTouchUpInside];
}

-(void) initReselectBtn
{
    self.reselectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.reselectBtn setFrame:CGRectMake(self.panelWidth - 170, 10, 40, 30)];
    [self.reselectBtn setTitle:@"选笔" forState:UIControlStateNormal];
    [self.reselectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.reselectBtn addTarget:self action:@selector(prepareForSelectPen)
               forControlEvents:UIControlEventTouchUpInside];
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
        [modelBtn addTarget:self
                     action:@selector(clickColorForPen:)
                     forControlEvents:UIControlEventTouchUpInside];
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
    [view setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
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
    // 如果是橡皮，设置成白色
    if (self.delegate.color == -1) {
        self.statusLabel.textColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
        return;
    }
    // 根据图片的颜色来设置说明文字的颜色
    if (self.delegate.color == 4) {
        self.statusLabel.textColor = [UIColor blackColor];
    }
    else {
        self.statusLabel.textColor = [UIColor colorWithPatternImage:
                                    [UIImage imageNamed:
                                     [NSString stringWithFormat:@"%dcolor.png", self.delegate.color]]];
    }
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
        [self.delegate updateRadiusWithSliderValue:(unsigned int)(control.value)];
    }
    if (abs(before - self.delegate.radius) >= 1) {
        [self updateStatus:[self.delegate description]];
    }
}

- (void) tranformMode:(PEN_STATE)mode
{
    self.state = mode;
    switch (mode) {
        case DOODLING:
            [self.delegate transformToPen];
            break;
        case ERASER:
            [self.delegate transformToEraser];
            break;
        case PEN:
            [self.delegate waitForNextState];
            break;
        default:
            break;
    }
    [self updateStatus:[self.delegate description]];
}

#pragma mark - about switch from status
/**
 *  状态变迁的说明： 选择画笔是每次打开画笔面板都切换到的状态。从选择画笔可以到离开状态和涂鸦状态。
 *  从涂鸦状态可以到选择画笔（选笔）、擦除状态（橡皮）、离开状态（离开）。
 *  从擦除状态可以到选择画笔和涂鸦状态、离开状态。
 *  离开状态下，隐藏画笔面板，重置状态到选择画笔。
 */

/**
 *  切换到准备选择画笔的状态
 */
-(void)prepareForSelectPen
{
    [self showPanel:YES];
    if (self.delegate.color == -1) {
        [self.delegate transformToPen];
    }
    
    // 前一个状态是怎么样的
    switch (self.state) {
        case DOODLING:
            [self.penStatusView removeFromSuperview];
            
            self.penStatusView = [[UIView alloc]
                                  initWithFrame:CGRectMake(0, 0, self.panelWidth, self.panelHeight)];
            
            [self initStatusLabel];
            [self initOkBtnForDoodle];
            [self initLeaveBtn];
            
            [self.penStatusView addSubview:self.statusLabel];
            [self.penStatusView addSubview:self.okBtn];
            [self.penStatusView addSubview:self.leaveBtn];
            [self paintBackGroundViewForView:self.penStatusView];
            [self addSubview:self.penStatusView];
            
            self.penRadiusView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.panelWidth, self.panelHeight)];
            
            [self initRadiusSlider];
            [self.penRadiusView addSubview:self.radiusSlider];
            [self paintBackGroundViewForView:self.penRadiusView];
            [self addSubview:self.penRadiusView];
            break;
            
        case ERASER:
            [self.penRadiusView removeFromSuperview];
            [self.penStatusView removeFromSuperview];
            self.penColorView.hidden = NO;
            
            self.penRadiusView = [[UIView alloc]
                                  initWithFrame:CGRectMake(0, 50, self.panelWidth, self.panelHeight)];
            
            [self initRadiusSlider];
            [self.penRadiusView addSubview:self.radiusSlider];
            
            self.penStatusView = [[UIView alloc]
                                  initWithFrame:CGRectMake(0, 0, self.panelWidth, self.panelHeight)];
            
            [self initStatusLabel];
            [self initOkBtnForDoodle];
            [self initLeaveBtn];
            
            [self.penStatusView addSubview:self.statusLabel];
            [self.penStatusView addSubview:self.okBtn];
            [self.penStatusView addSubview:self.leaveBtn];
            
            [self paintBackGroundViewForView:self.penRadiusView];
            [self paintBackGroundViewForView:self.penStatusView];
            
            [self addSubview:self.penRadiusView];
            [self addSubview:self.penStatusView];
            break;
            
        default:
            break;
    }
    
    self.state = PEN;
    // 更新画笔状态
    [self.delegate waitForNextState];
}

/**
 *  由离开按钮触发的离开动作
 */
-(void) prepareForLeave
{
    // 先恢复到准备选择画笔的状态
    [self prepareForSelectPen];
    // 然后离开
    [self showPanel:NO];
}

/**
 *  切换到正在涂鸦的状态
 */
-(void)prepareForDoodle
{
    // 面板的形态要发生改变
    [self.penStatusView removeFromSuperview];
    [self.penRadiusView removeFromSuperview];
    self.penColorView.hidden = YES;
    
    // 只填充状态面板
    // 总高度 185 状态面板高度 50 面板宽度 320
    self.penStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, self.panelWidth, self.panelHeight)];
    
    self.statusLabel = [[UILabel alloc]
                        initWithFrame:CGRectMake(10, 0, self.panelWidth / 3 + 20, self.panelHeight)];
    if (self.delegate != nil) {
        [self tranformMode:DOODLING];
    }
    
    [self initOkBtnForErase];
    [self initLeaveBtn];
    [self initReselectBtn];
    [self.penStatusView addSubview:self.statusLabel];
    [self.penStatusView addSubview:self.okBtn];
    [self.penStatusView addSubview:self.leaveBtn];
    [self.penStatusView addSubview:self.reselectBtn];
    [self paintBackGroundViewForView:self.penStatusView];
    [self addSubview:self.penStatusView];
}

/**
 *  切换到擦除状态
 */
-(void) prepareForErase
{
    [self.okBtn removeFromSuperview];
    [self initOkBtnForDoodle];
    [self.penStatusView addSubview:self.okBtn];
    
    self.penRadiusView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, self.panelWidth, self.panelHeight)];
    
    [self tranformMode:ERASER];
    
    [self initRadiusSlider];
    [self.penRadiusView addSubview:self.radiusSlider];
    [self paintBackGroundViewForView:self.penRadiusView];
    [self addSubview:self.penRadiusView];
}
@end
