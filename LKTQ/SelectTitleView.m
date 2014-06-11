//
//  SelectTitleView.m
//  故事盒子
//
//  Created by caijunbin on 14-3-17.
//  Copyright (c) 2014年 sony. All rights reserved.
//
#import "UITitleLabel.h"
#import "SelectTitleView.h"
#define start_x 5
#define start_y 0//20
#define title_width 100
#define title_height 123
#define title_gar 103
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation SelectTitleView
@synthesize delegate;
@synthesize positionSwich;
@synthesize selectView;
@synthesize selectTag;
//int x;

-(id)initWithScrollView:(UIScrollView *)scrollView withTextArr:(NSMutableArray *)arr
{
    self = [super init];
    if (self)
    {
        positionSwich=[[PositionSwitch alloc] init];
        if(IS_IPHONE_5)
        {
            [self setFrame:CGRectMake(0, 0, 320, 568)];
            selectView=[[UIScrollView alloc] initWithFrame:[positionSwich switchBound:CGRectMake(0, 45, 320,568-45)]];
            [selectView setContentSize:CGSizeMake(320,568)];
        }
        else
        {
            [self setFrame:CGRectMake(0, 0, 320, 480)];
            selectView=[[UIScrollView alloc] initWithFrame:[positionSwich switchBound:CGRectMake(0, 45, 320,480-45)]];
            [selectView setContentSize:CGSizeMake(320,480)];

        }
    }
    selectTag = 0;
    _sc = scrollView;
    textEditViewArray = arr;
    [selectView setBackgroundColor:[UIColor colorWithRed:(38.0/255) green:(43.0/255) blue:49.0/255 alpha:0.9]];;
    [self addSubview:selectView];
    [selectView release];
    
    [self  setBackgroundColor:[UIColor blackColor]];
    [self initNavigationBar];
    [self initTitleWithNumber:24];
    [self bringSubviewToFront:NavigationView];
    return  self;
}

/**
 *  导航条布局
 */
-(void)initNavigationBar
{
    NavigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    [NavigationView setBackgroundColor:[UIColor colorWithRed:(28.0/255) green:(33.0/255) blue:39.0/255 alpha:0.95]];
    [self addSubview:NavigationView];
    [NavigationView release];
    
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(20, 15, 40,15)];
    [back setImage:[UIImage imageNamed:@"titleBackBtn.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backEdit:) forControlEvents:UIControlEventTouchUpInside];
    [NavigationView addSubview:back];

}

/**
 *  将所有大标签添加到选择层中
 *
 *  @param numberOfTitle 总大标签数
 */
-(void)initTitleWithNumber:(int)numberOfTitle
{
    selectedSignal = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
//    [selectView setContentSize:CGSizeMake(320,start_y+(numberOfTitle/2+numberOfTitle%2)*title_gar+title_height)];
    float h_selectView = 0;
    for(int i=0;i<numberOfTitle;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(start_x+i%3*title_gar,start_y+i/3*title_gar, title_width, title_height)];
        //设置标签用于识别
        [btn setTag:i];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"button%d.png",i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickAddTitle:) forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:btn];
        
        h_selectView = btn.frame.origin.y+btn.frame.size.height;
    }
    
    [selectView setContentSize:CGSizeMake(320, h_selectView+60)];
}

/**
 *  所有大标签皆可触发，通过获取tag判断是哪个大标签后添加到编辑界面
 *
 *  @param sender
 */
-(void)clickAddTitle:(id)sender
{
//    printf("添加标题");
    selectTag = [sender tag];
    NSLog(@"添加%d号大标签",selectTag);
//    printf("==%d",x);
    
    //把选中的大标签作为UITitleLabel添加到长图编辑界面中
    UITitleLabel *label = [[UITitleLabel alloc]initWithFrame:CGRectMake(100, _sc.contentOffset.y+100, 400, 200) initImage:selectTag withFlagModel:3 withTextVArr:textEditViewArray withView:_sc];//200 ,100

    label.delegate = self.superview;
    [_sc addSubview:label];
  
    [self.delegate hiddenTopView:NO];
    //bin?:arc
    [label release];
    //移除本视图
    [self removeFromSuperview];
}

/**
 *  返回按钮触发
 *
 *  @param sender
 */
-(void)backEdit:(id)sender
{
    [self.delegate hiddenTopView:NO];
    [self removeFromSuperview];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return  NO;
}

-(void)clear
{
    for (int i=0; i<self.subviews.count; ++i)
    {
        UIView * _v = [self.subviews objectAtIndex:i];
        [_v removeFromSuperview];
    }
    
}
-(void)dealloc
{
//    printf("titled dealloc");
    [self clear];
    [positionSwich release];
    
    [super dealloc];
}
@end
