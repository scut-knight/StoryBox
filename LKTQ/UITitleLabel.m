//
//  UITextField.m
//  LKTQ
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 sony. All rights reserved.
//
#include <math.h>
#import <QuartzCore/QuartzCore.h>

#import "UITitleLabel.h"

@implementation UITitleLabel
@synthesize _textView,imageViewBg;
@synthesize maskTouch;
@synthesize contorlBtn;
#define image_width 60
#define image_height 60



-(id)initWithFrame:(CGRect)frame initImage:(int)tag withFlagModel:(int)index withTextVArr:(NSMutableArray *)textVA withView:(UIScrollView *)sc
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        //记录不同标签序号0~7
        //bin:?目测大标签序号为3
        index_colorLable = index;
        textVArray = textVA;//文字视图 数组
        scView = sc;
        
        imageViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,image_width,image_height)];
        //加载标签图片
        [self initImage:tag withflag:index];
      
        [self addSubview:imageViewBg];
        [imageViewBg release];
        
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y,imageViewBg.frame.size.width+40, imageViewBg.frame.size.height+40)];//重新设置
        
        maskTouch=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height)];
        [maskTouch setBackgroundColor:[UIColor clearColor]];
        [self addSubview:maskTouch];
        [maskTouch release];
        
        //手势捕捉
        UITapGestureRecognizer * tapG=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapHandle:)];
        [maskTouch addGestureRecognizer:tapG];
        [tapG release];
        UIPanGestureRecognizer * panG=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
        [self addGestureRecognizer:panG];
        [panG release];
        
        //拉伸按钮，点击时反色
        contorlBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [contorlBtn setImage:[UIImage imageNamed:@"scale.png"] forState:UIControlStateNormal];
        [contorlBtn setImage:[UIImage imageNamed:@"scaled.png"] forState:UIControlStateSelected];
        [contorlBtn setFrame:CGRectMake(self.frame.size.width-40, self.frame.size.height-40, 40, 40)];
        contorlBtn.hidden=YES;
        [contorlBtn addTarget:self action:@selector(clickControlBtn:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:contorlBtn];
        
        //移除按钮
        deleteBTn=[UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBTn setImage:[UIImage imageNamed:@"deleteTitle.png"] forState:UIControlStateNormal];
        [deleteBTn setFrame:CGRectMake(0,0, 40, 40)];
        deleteBTn.hidden=YES;
        [deleteBTn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBTn];
        
        
        UILongPressGestureRecognizer * tapL=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPress:)];
        tapL.minimumPressDuration=0.0;//0.7
        [contorlBtn addGestureRecognizer:tapL];
        [tapL release];
        
        tempPoint = CGPointMake(0, 0);
 
    }
    return self;
}

/**
 *  加载大标签图片
 *
 *  @param tag   图片tag
 *  @param index 标签序号
 */
-(void)initImage:(int)tag withflag:(int)index
{
    NSLog(@"index:%d,tag:%d",tag,index);
    NSString* strImg = [NSString stringWithFormat:@"%d%d.png",index,tag];
    UIImage *image = [UIImage imageNamed:strImg];//13 13 13 13
    [imageViewBg setFrame:CGRectMake(20,20,image.size.width/3,image.size.height/3)];
    [imageViewBg setImage:image];
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"触摸");
////    CGPoint point= [[touches anyObject] locationInView:self.superview];
////    
////    printf("=%f",point.x);
////    printf("=%f",point.y);
//}
//
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"移动了");
//    
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//
//}

/**
 *  长时间点击手势捕捉
 *
 *  @param LG
 */
-(void)LongPress:(UILongPressGestureRecognizer * )LG
{
    NSLog(@"LongPress");
    CGPoint point = [LG locationInView:self.superview];
    //刚点击时，记录坐标
    if (LG.state == UIGestureRecognizerStateBegan)
    {
//        printf("beg");
        tempPoint = CGPointMake(point.x, point.y);
        [contorlBtn setImage:[UIImage imageNamed:@"scaled.png"] forState:UIControlStateNormal];
    }
    //调整大标签的大小
    [self adjust:point];
    //点击结束时，还原图标，隐藏操作栏
    if (LG.state == UIGestureRecognizerStateEnded)
    {
//        printf("end");
        [contorlBtn setImage:[UIImage imageNamed:@"scale.png"] forState:UIControlStateNormal];
        [self hiddenBorder];
    }
}


/**
 *  调整大标签的大小
 *
 *  @param point
 */
-(void)adjust:(CGPoint)point
{
    CGPoint center1,center2;
    center1 = contorlBtn.center;
    center2 = deleteBTn.center;
    float _x=point.x-tempPoint.x;
    float _y=point.y-tempPoint.y;
   
    float _w=self.frame.size.width;
    float _h=self.frame.size.height;
   
    float _x_new=0;
    float _y_new=0;

    if ((_x*_x)>(_y*_y))
    {
        _x_new=_x;
        _y_new=_x*_h/_w;
    }
    else{
        _x_new=_y*_w/_h;
        _y_new=_y;
    
    }
    
//    float scale_x=(_x_new+self.frame.size.width)/self.frame.size.width;
//    float scale_y=(_y_new+self.frame.size.height)/self.frame.size.height;
//    float _scale=scale_x>scale_y?scale_x:scale_y;
//    float rotate1=atan2f(point.y, point.x);
//    float rotate2=atan2f(tempPoint.y, tempPoint.x);
//    float r=rotate1-rotate2;
    
    if (_x_new+_w<150)
    {
        return;
    }
    CGPoint old=CGPointMake(self.center.x, self.center.y);
    [self setFrame:CGRectMake(self.frame.origin.x
                              , self.frame.origin.y, _x_new+_w, _y_new+_h)];
    [self setCenter:old];
 
    [contorlBtn setFrame:CGRectMake(self.frame.size.width-40, self.frame.size.height-40, 40, 40)];
    [imageViewBg setFrame:CGRectMake(20,20,self.frame.size.width-40,self.frame.size.height-40)];
    [maskTouch setFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height)];
 
    tempPoint = CGPointMake(point.x, point.y);//add
    
//    NSLog(@"==%@",self.superview);
    
}


//- (void)drawRect:(CGRect)rect {
//    
//    printf("draw");
//    UIImage *img=imageViewBg.image;
////    CGRect img=self.frame;
//    CGImageRef image =imageViewBg.image.CGImage;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    
////    CGAffineTransform myAffine = CGAffineTransformMakeRotation(M_PI);
////    myAffine = CGAffineTransformTranslate(myAffine, -img.size.width/2, -img.size.height/2);
////    CGContextConcatCTM(context, myAffine);
//    
////    CGContextRotateCTM(context, 0);//M_PI
////    CGContextTranslateCTM(context, -img.size.width/2, -img.size.height/2);
//    
//    CGRect touchRect = CGRectMake(0, 0, img.size.width/2, img.size.height/2);
//    CGContextDrawImage(context, touchRect, image);
//    CGContextRestoreGState(context);
//}


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
//    NSLog(@"x=%f,y=%f",self.center.x,self.center.y);
   [panG setTranslation:CGPointZero inView:self];

//    if (panG.state == UIGestureRecognizerStateEnded)
//    {
//        [self endPanHandle];
//    }
}

/**
 *  检测大标签是否在scrollview中
 *  bin?:怎么算是不在scrollview中？试了一下好像做不到
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
        NSLog(@"在sc 中");
    }
}


/**
 *  把标签从scrollView移除，放入对应的textView
 *  bin?:意义不明。已停止使用?
 */
-(void)endPanHandle
{//把标签从scrollView移除，放入对应的textView
    printf("end-------");
    
//    [self showBorder];
    int d = -1;
    int num = textVArray.count;
    int sum = 0;
    float _x=self.center.x;
    float _y=self.center.y;
    UIView * _textV;
    for (int i=0; i<num; ++i)
    {
        _textV=[textVArray objectAtIndex: i];
          [self.superview bringSubviewToFront:_textV];
        float max=_textV.frame.origin.y+_textV.frame.size.height+8;//
        float min=_textV.frame.origin.y;
        sum=min;//min
        if (_y<=max&&_y>=min)
        {
            d=i;//找到点击对应的视图序号
            _y=_y-sum;
            [self setCenter:CGPointMake(_x, _y)];
            [_textV addSubview:self];
            [_textV bringSubviewToFront:self];
            printf("退出");
            return;
        }
        else
            printf("无");
        
    }
    printf("sum=%d,d=%d,",sum,d);
}


/**
 *  单击手势捕捉
 *
 *  @param tapG
 */
-(void)tapHandle:(UITapGestureRecognizer * )tapG
{
    NSLog(@"单击");
    [self.delegate setCurrentTitleView: self];
    
    [self.superview bringSubviewToFront:self];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
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
 *  拉伸按钮触发
 *
 *  @param sender
 */
-(void)clickControlBtn:(id)sender
{
//    printf("click");
    [self becomeFirstResponder];
}

-(void)clickDeleteBtn:(id)sender
{
    [self.delegate  deleteCurrentTitleView:nil];
    [self clear];
    
}

/**
 *  隐藏大标签的操作栏
 */
-(void)hiddenBorder
{
    imageViewBg.layer.borderWidth = 0;
    contorlBtn.hidden = YES;
    deleteBTn.hidden = YES;
}

/**
 *  显示大标签的操作栏
 *  bin?:这里作了一个判断,用于隐藏/显示操作栏，与hiddenBorder重复
 */
-(void)showBorder
{
    if (imageViewBg.layer.borderWidth == 0)
    {
        imageViewBg.layer.borderWidth = 1;
        contorlBtn.hidden = NO;
        deleteBTn.hidden = NO;
    }
    else
    {
        imageViewBg.layer.borderWidth = 0;
        contorlBtn.hidden = YES;
        deleteBTn.hidden = YES;
    }
}

-(void)clear
{
    for (int i=0; i<self.subviews.count; ++i)
    {
        UIView * _v=[self.subviews objectAtIndex:i];
        [_v removeFromSuperview];
    }
    [self removeFromSuperview];
    
}
-(void)dealloc
{
    printf("title dealloc");
    
    [super dealloc];
}
@end
