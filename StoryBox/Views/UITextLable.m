
//  UITextField.m
//  LKTQ
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import "UITextLable.h"

@implementation UITextLable
@synthesize _textView,imageViewBg;
@synthesize used;
@synthesize maskTouch;
@synthesize delegate;
#define Max_width 200//宽度上限
#define height_textView 30//文本框初始化高度25

#define MAEGIN_HEIGHT 0//文本框和背景图的高度差距7
#define MAEGIN_WIDTH  10//文本框和背景图的宽度差距10

#define min_width 10//初始化最小宽度30


-(id)initWithFrame:(CGRect)frame  initImage:(int)tag withFlagModel:(int)index withTextVArr:(NSMutableArray *)textVA withView:(UIScrollView *)sc
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        rows_Char = 1;//默认字符行数为1
        currentMax = min_width;
        
        index_colorLable = index;//记录不同标签序号0~7

        //文字视图数组
        textVArray = textVA;
        scView = sc;
 
        //新建textView用于放置文字
        _textView=[[UITextView alloc] initWithFrame:CGRectMake(7, 0, min_width, height_textView)];
        [_textView setBackgroundColor:[UIColor clearColor]];
        _textView.delegate = self;
        _textView.text = @"";
        
        UIColor *color;
        UIColor * colorTint;
        colorTint = [UIColor whiteColor];
        NSLog(@"===%d,%d",index,tag);
        
        //如果.....否则字体为白色
        if ((index_colorLable == 1 && tag == 1) || index_colorLable == 21)
        {//白色
            color = [UIColor blackColor];
            colorTint = [UIColor blackColor];
        }
        else
        {
            color = [UIColor whiteColor];
        }
        
        _textView.textColor = color;
        _textView.font = [UIFont systemFontOfSize:12.0];
        [_textView  setTintColor:colorTint];
        _textView.scrollEnabled = NO;
        
        
        //添加背景，背景比文本框高5个像素
        imageViewBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,_textView.frame.size.width+MAEGIN_WIDTH,height_textView+MAEGIN_HEIGHT)];
        //加载标签图片
        [self initImage:tag withflag:index];
        
        //让文字置于背景上方
        [self addSubview:imageViewBg];
        [self addSubview: _textView];

        //触摸屏蔽层
        maskTouch = [[UIView alloc] initWithFrame:CGRectMake(0,0,imageViewBg.frame.size.width,imageViewBg.frame.size.height)];
        [maskTouch setBackgroundColor:[UIColor clearColor]];
        [self addSubview:maskTouch];
        
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y,imageViewBg.frame.size.width,imageViewBg.frame.size.height)];
        
        UITapGestureRecognizer * tapG=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapHandle:)];
        [maskTouch addGestureRecognizer:tapG];
        
        UIPanGestureRecognizer * panG=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
        [self addGestureRecognizer:panG];
       
        used = YES;
    }
    return self;
}

/**
 *  初始化标签数组
 *
 *  @param arrLable
 */
-(void)initWithLableArray:(NSMutableArray *)arrLable
{
    lableArr = arrLable;
}

/**
 *  初始化标签
 *
 *  @param tag   图片tag
 *  @param index 标签序号
 */
-(void)initImage:(int)tag withflag:(int)index
{
    float top = 22;//25
    float left = 28;
    float bottom = 25;
    float right = 28;
    NSString* strImg=[NSString stringWithFormat:@"%d%d.png",index,tag];

    UIImage *image = [[UIImage imageNamed:strImg]
                                      resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)];//13 13 13 13
    [imageViewBg setImage:image];
}

/**
 *  滑动手势捕捉,用于标签的移动
 *
 *  @param panG
 */
-(void)panHandle:(UIPanGestureRecognizer * )panG
{
    
    if (panG.state==UIGestureRecognizerStateBegan)
    {
//        printf("kaishi");
        [self startPanHandle];
    }
    CGPoint center = self.center;
    CGPoint point = [panG translationInView:self];
    CGPoint newCenter = CGPointMake(center.x+point.x, center.y+point.y);
    
    //对新的中点位置进行检测
    [self setCenter:[self judgeTextlableBound:newCenter]];
   
//    NSLog(@"x=%f,y=%f",self.center.x,self.center.y);
   [panG setTranslation:CGPointZero inView:self];

    if (panG.state == UIGestureRecognizerStateEnded)
    {
        [self endPanHandle];
    }
    
}

/**
 *  检测标签是否在scrollview中
 *  bin?:怎么算是不在scrollview中？试了一下好像做不到
 */
-(void)startPanHandle
{
    //不在scrollview中 需要把其移入scrollview
    if (![self.superview isKindOfClass:[UIScrollView class]])
    {
        float _y=self.superview.frame.origin.y+self.frame.origin.y;//计算坐标Y
        [self setFrame:CGRectMake(self.frame.origin.x, _y, self.frame.size.width, self.frame.size.height)];
        [scView addSubview:self];
    }
    else
    {
//        printf("在sc 中");
    }
    
}

/**
 *  把标签从scrollView移除，放入对应的textView
 *  bin?:意义不明。
 */
-(void)endPanHandle
{
//    printf("end-------");
    float _x=self.frame.origin.x;
    float _y=self.frame.origin.y;
    float _w=self.frame.size.width;
    float _h=self.frame.size.height;
//    int d=-1;
    int num=textVArray.count;
    int sum=0;
    UIView * _textV;
    for (int i=0; i<num; ++i)
    {
        _textV=[textVArray objectAtIndex: i];
        float max=_textV.frame.origin.y+_textV.frame.size.height-self.frame.size.height;//
        float min=_textV.frame.origin.y;
        float _bound=_textV.frame.origin.y+_textV.frame.size.height+4-self.frame.size.height/2;//边界
        float _bound2=_textV.frame.origin.y+_textV.frame.size.height+8;
        sum=min;//min
        if (_y<=max&&_y>=min)
        {
//            d=i;//找到点击对应的视图序号
            _y=_y-sum;
            [self setFrame:CGRectMake( _x,_y,_w,_h)];
            [_textV addSubview:self];
            [_textV bringSubviewToFront:self];
            printf("退出");
            return;
        }
        else if(_y>max&&_y<=_bound)//中间区域偏上
        {
//            printf("偏上");
            _y=_textV.frame.size.height-self.frame.size.height;
            [self setFrame:CGRectMake(_x,_y, _w,_h)];
            [_textV addSubview:self];
            [_textV bringSubviewToFront:self];
            return;
        }
        else if(_y>_bound &&_y<_bound2)//中间区域偏下
        {
//            printf("循环下");
            float _y_new=_textV.frame.origin.y+_textV.frame.size.height+8;
            [self setFrame:CGRectMake(_x,_y_new, _w,_h)];
            _y = self.frame.origin.y;
        }
        else
            printf("无");
        
    }
//    printf("sum=%d,d=%d,",sum,d);
   
 
}

/**
 *  对中心点的坐标进行规范化
 *  定义点的范围用四个点构成一个闭合的区域（可见区  x<320 Y<420）
 *  左上开始顺时针
 *  标签运动感区域默认 宽 高区域320 420,当图片高度小于420时，已实际高度作为运动区域
 *  @param center 中心点坐标
 *
 *  @return 规范化后的中心坐标
 */
-(CGPoint)judgeTextlableBound:(CGPoint)center
{
    UIScrollView * sc = (UIScrollView*) self.superview;
    float _h = sc.contentSize.height - 60;//区域高度
    float _margin = 10;
    if (self.superview.frame.size.height<_h)
    {
        _margin = 0;
    }
    
    CGPoint point1 = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+_margin);//10 不想拖动顶部栏的下面
    CGPoint point2 = CGPointMake(320-self.frame.size.width/2, self.frame.size.height/2+_margin);
//    CGPoint point3 = CGPointMake(self.frame.size.width/2, 410-self.frame.size.height/2);
    CGPoint point4 = CGPointMake(320-self.frame.size.width/2, _h-self.frame.size.height/2);//左下
    
    float x = 0;
    float y = 0;
 
    if (center.x < point1.x)
    {
        x = point1.x;
    }
    if (center.x > point2.x)
    {
        x = point2.x;
    }
    
    if (center.y < point1.y)
    {
        y = point1.y;
    }
    if (center.y>point4.y)
    {
        y = point4.y;
    }
    //如果移动会产生越界,返回规范化未越界坐标,否则直接返回
    if (x||y)
    {
        if (x&&y)
        {
            return CGPointMake(x, y);
        }
        else if (x)
        {
            return CGPointMake(x, center.y);
        }
        else
        {
            return CGPointMake(center.x,y);
        
        }
    }
    else
    {
        return  center;
    }
}

/**
 *  单击手势捕捉
 *
 *  @param tapG
 */
-(void)tapHandle:(UITapGestureRecognizer * )tapG
{
    printf("tap");
    [self.delegate resetTitleviewState];
    [self.superview bringSubviewToFront:self];
    if ([self._textView.text isEqualToString:@"@"]||[self._textView.text isEqualToString:@""])
    {
        [self._textView becomeFirstResponder];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",@"编辑",nil];
        alert.alertViewStyle=UIAlertViewStyleDefault;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        //确定删除
        case 1:
        {
            [self clearFromArrayLable];
            [self removeFromSuperview];
            
            break;
        }
        case 2:
        {
            [self bringSubviewToFront:_textView];
            [_textView becomeFirstResponder];
            //bin?:不明作用
//            [self adjustTextLableCenter];
            [self.delegate modifyStateEdit];
            break;
        
        }
        default:
            break;
    }
}

/**
 *  将当前选中标签从移除
 */
-(void)clearFromArrayLable
{
//    printf("清除从数组");
    for (int i=0; i<lableArr.count; ++i)
    {
        UITextLable * la = [lableArr objectAtIndex:i];
        if ([la._textView.text isEqualToString:self._textView.text])
        {
            [lableArr removeObjectAtIndex:i];
        }
    }
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.superview bringSubviewToFront:self];
    return YES;
}

/**
 *  处理textView中文字变化
 *
 *  @param textView 当前编辑的textView
 */
-(void)textViewDidChange:(UITextView *)textView
{
//    NSLog(@"began=%@",textView.text);
    NSString* str;
    CGSize s;
    int rows=0;
    int coutCharWidth=0;
    int maxHistorylength=0;
    int height_text=0;//
    for (int i=0; i<textView.text.length; ++i)
    {
        str=[NSString stringWithFormat:@"%C",[textView.text characterAtIndex:i]];
        s=[str sizeWithAttributes:
           @{NSFontAttributeName:[textView font]}];
        
        height_text=height_text>s.height?height_text:s.height;
        if ([str isEqualToString:@"\n"])
        {
            printf("换行了");
            coutCharWidth=0;
            ++rows;
        }
        else if (coutCharWidth+s.width>Max_width)//超出，不加coutCharWidth
        {
            printf("最大了");
            ++rows;
            maxHistorylength=Max_width;
            coutCharWidth=0;
//            NSLog(@"r=%d",rows);
 
        }
        else
        {
//            printf("继续");
            coutCharWidth=coutCharWidth+s.width;
            if (coutCharWidth>maxHistorylength)
            {
                maxHistorylength=coutCharWidth;//记录行宽
            }
            
        }
    }
    maxHistorylength = coutCharWidth>maxHistorylength?coutCharWidth:maxHistorylength;
 
//    NSLog(@"max=%d",maxHistorylength);
    if (maxHistorylength==Max_width)
    {//达到最宽
//         printf("测试0");
         [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, Max_width,height_textView+rows*height_text)];//5  MAEGIN_HEIGHT
    }
    else
    {
//        printf("测试1=%d",height_text);
         [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, maxHistorylength+s.height,height_textView+rows*height_text)];
    }
 
    [self updateFrame];//更新背景大小
}


/**
 *  更新边框
 */
-(void)updateFrame
{
    if (index_colorLable>=20)
    {
//        printf("测试");//气泡
        
    }
    float w_new = _textView.frame.size.width + MAEGIN_WIDTH;
    float h_new = _textView.frame.size.height + MAEGIN_HEIGHT;
    
    [imageViewBg setFrame:CGRectMake(0, 0,w_new,h_new)];
    [maskTouch setFrame:CGRectMake(0, 0,w_new,h_new)];
    
    [self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y,w_new,h_new)];
}

/**
 *  停止编辑textView触发,交出控制权并置顶屏蔽层
 *
 *  @param textView 当前编辑的textView
 *
 *  @return YES
 */
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.transform = CGAffineTransformIdentity;
    [textView resignFirstResponder];
    [self bringSubviewToFront:maskTouch];
    
//    printf("失效");
    return YES;
}


-(void)adjustTextLableCenter
{
//    printf("上拉");
    float offset=[self.delegate getScrollviewOffset];
    int bottom_y_relative=self.superview.frame.origin.y+self.frame.origin.y-offset;

    if (bottom_y_relative>250)
    {
        self.transform=CGAffineTransformMakeTranslation(0, -(bottom_y_relative-250));
    }
    
}
-(void)clearView
{
    for (int i=0; i<self.subviews.count; ++i)
    {
        UIView *_v=[self.subviews objectAtIndex:i];
        [_v removeFromSuperview];
    }
}

-(void)dealloc
{
//    printf("lable release");
    [self clearView];
}
@end
