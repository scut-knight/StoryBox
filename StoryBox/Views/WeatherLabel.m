//
//  WeatherLabel.m
//  故事盒子
//
//  Created by bin on 14-6-12.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import "WeatherLabel.h"
#define image_width 30
#define image_height 30
#define weatherLabel_width 90
#define weatherLabel_height 30


@implementation WeatherLabel
@synthesize _textView,imageViewBg,cityLabel,tempLabel;

- (id)initWithFrame:(CGRect)frame withView:(UIScrollView *)sc withTextVArr:textVA iconType:(int)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        scView = sc;
        textEditViewArray = textVA;
        
        UIPanGestureRecognizer * panG = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
        [self addGestureRecognizer:panG];
        
        //添加背景，用于放置所有元素
        imageViewBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,weatherLabel_width,weatherLabel_height)];
        imageViewBg.backgroundColor = [UIColor blackColor];
        [self addSubview:imageViewBg];
        
        iconType = type;
        
        UITapGestureRecognizer * tapG=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapHandle:)];
        [self addGestureRecognizer:tapG];

    }
    return self;
}

- (id)initPreview:(CGRect)frame iconType:(int)type
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        
        //添加背景，用于放置所有元素
        imageViewBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,weatherLabel_width,weatherLabel_height)];
        imageViewBg.backgroundColor = [UIColor blackColor];
        [self addSubview:imageViewBg];
        
        iconType = type;
        
        
    }
    return self;

}

- (void)initWeather:(NSString *)city withWeather:(NSString *)weather withTemp:(NSString *)temp;
{
    
//    int index = 0;
////    weatherImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,image_width,image_height)];
//    //加载标签图片
////    [self initImage:index];
//    //    [imageViewBg addSubview:weatherImageView];
//
//    NSString* strImg = [NSString stringWithFormat:@"weather-%d.png",index];
//    
//    UIImage *image = [UIImage imageNamed:strImg];
//    [imageViewBg setImage:image];
    [self setWeatherIcon:weather];
    
    
    cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(image_width + 15, 0, 100, weatherLabel_height - 10)];
    cityLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = city;
    
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(image_width + 5, 0, 100, weatherLabel_height + 15)];
    tempLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.text = temp;
    
    [imageViewBg addSubview:cityLabel];
    [imageViewBg addSubview:tempLabel];
    NSLog(@"OLD:%f",self.center.y);

}

- (void)setWeatherIcon:(NSString *)weather
{
    NSArray *WeatherName = [NSArray arrayWithObjects:@"晴",@"晴转多云",@"多云",@"雨",@"小雨",@"中雨",@"大雨",@"雷阵雨",@"雷阵雨转大雨",nil];

    int index = [WeatherName indexOfObject:weather];
    int realIndex = 0;
    switch(index)
    {
        case 0: realIndex = 0;break;
        case 1: realIndex = 1;break;
        case 2: realIndex = 2;break;
        case 3:
        case 4:
        case 5:
        case 6: realIndex = 3;break;
        case 7:
        case 8: realIndex = 4;break;
        default:realIndex = 0;break;
    }

    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"weather-%i-%i.png",iconType,realIndex]];
    [imageViewBg setImage:image];
}


/**
 *  单击手势捕捉
 *
 *  @param tapG
 */
-(void)tapHandle:(UITapGestureRecognizer * )tapG
{
    NSLog(@"单击");
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示"
                                                 message:@"要删除当前天气标签吗?"
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定",nil];
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {//确定删除
        case 1:
        {
            [self removeFromSuperview];
            break;
        }
        default:
            break;
    }
    
}

/**
 *  拖动手势捕捉
 *
 *  @param panG
 */
-(void)panHandle:(UIPanGestureRecognizer * )panG
{
    //如果是开始拖动,调用startPanHandle
    if (panG.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"开始拖动");
        [self startPanHandle];
    }
    CGPoint center = self.center;
    
    CGPoint point = [panG translationInView:self.superview];//sup
    CGPoint newCenter = CGPointMake(center.x+point.x, center.y+point.y);
    
    [self setCenter:newCenter];
    [panG setTranslation:CGPointZero inView:self];

}

/**
 *  检测标签是否在scrollview中
 */
-(void)startPanHandle
{
    if (![self.superview isKindOfClass:[UIScrollView class]])
    {//不在scrollview中 需要把其移入scrollview
        NSLog(@"不在sc");
        float _y = self.superview.frame.origin.y+self.center.y;//计算坐标Y
        [self setCenter:CGPointMake(self.center.x, _y)];
        [scView addSubview:self];
        [scView bringSubviewToFront:self];
    }
    else
    {

        NSLog(@"在sc 中:%f",self.center.y);
    }
}

/**
 *  把标签从scrollView移除，放入对应的textView
 *
 */
-(void)endPanHandle
{
    NSLog(@"TO call");
    //    [self showBorder];
    int d = -1;
    int num = textEditViewArray.count;
    int sum = 0;
    float _x=self.center.x;
    float _y=self.center.y;
    UIView * _textV;

    for (int i=0; i<num; ++i)
    {
        _textV = [textEditViewArray objectAtIndex:i];
        [self.superview bringSubviewToFront:_textV];
        float max=_textV.frame.origin.y+_textV.frame.size.height+8;
        float min=_textV.frame.origin.y;
        sum = min;//min
        NSLog(@"max:%f,min:%f,_y:%f",max,min,_y);

//        if (_y<=max&&_y>=min)
//        {
            _y=_y-sum;
            [self setCenter:CGPointMake(_x, _y)];
            [_textV addSubview:self];
            [_textV bringSubviewToFront:self];
            NSLog(@"退出");
            return;
//        }
//        else
//            NSLog(@"无");
    }
}


@end
