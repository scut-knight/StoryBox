    //
//  ExtraLayerView.m
//  LKTQ
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import "ExtraLayerView.h"
#import "UITextLable.h"
#import "ClipViewController.h"
#import "PositionSwitch.h"
#import "ModifyImageView.h"
#import "CustomAnimation.h"
#import "SelectTitleView.h"
#import "UIImage.h"

#import<CoreText/CoreText.h>
@implementation ExtraLayerView
@synthesize gemomtryView,textEditView, scrollView;
@synthesize imageViewArray,textEditViewArray;
@synthesize positionSwich;
#define _width 320
#define _height 480
#define width_gemotry 320//标签容器宽度
#define height_gemotry 85//标签容器高度

#define Start_x_gemotry 0//标签容器


#define MAX_IMAGEPIX 640.0          // max pix 640.0px
int Start_y_gemotry;//标签容器

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define gap_btn_bar 80


#define x_imgView 0
#define y_imgView 80//100
- (id)initWithFrame:(CGRect)frame withImageArray:(NSMutableArray*)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         self.frame=frame;
         positionSwich=[[PositionSwitch alloc] init];
         LableArray=[[NSMutableArray alloc] init];
        
        if(IS_IPHONE_5)
        {
            Start_y_gemotry=568;//431
        }
        else
        {
            Start_y_gemotry=480;//343
            
        }
 
        history=CGPointMake(0, 0);//用于长按下的坐标记录
        [self setBackgroundColor:[UIColor blackColor]];
        scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 320, Start_y_gemotry-45)];//568
        
//      scrollView=[[UIScrollView alloc] initWithFrame:[positionSwich switchBound:CGRectMake(0, 45, 320,480-45)]];//568
        scrollView.userInteractionEnabled = YES;
        [scrollView setContentSize:CGSizeMake(320, 960)];
        scrollView.pagingEnabled=NO;
        [scrollView setBackgroundColor:[UIColor blackColor]];
        
        [self addSubview:scrollView];
        imageViewArray=[[NSMutableArray alloc] init];
        textEditViewArray=[[NSMutableArray alloc] init];//标签数组        
        
        [self initImageArray:arr];
        [self initTextEditView];
        [self initGeometryModelBtn];
      
        UITapGestureRecognizer * tapG=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
         tapG.numberOfTapsRequired=1;
        [scrollView addGestureRecognizer:tapG];
        [tapG release];
 
        UILongPressGestureRecognizer * tapG2=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPress:)];
        tapG2.minimumPressDuration=0.7;
        
        [self addGestureRecognizer:tapG2];
        [tapG2 release];
        
        current_index=-1;
        _scale=0.7;
        stateEdit=NO;
        actionTitleView=nil;
       
        
    }
    return self;
}
-(void)LongPress:(UILongPressGestureRecognizer *)longG
{
    printf("long");
    CGPoint point=[longG locationInView:self];
    float _x=history.x;
    float _y=history.y;
    float dis_x=0;
    float dis_y=0;
    
    if (_x==0&&_y==0) {
        history=CGPointMake(point.x, point.y);
    }
    else
    {
        dis_x=point.x-history.x;
        dis_y=point.y-history.y;
        history=point;
    }
    
    if (longG.state==UIGestureRecognizerStateBegan) {
        printf("beg");
        
        dis_pan=scrollView.frame.size.height*(1-_scale)/2;
        CGPoint point_s=[longG locationInView:scrollView];
        for (int i=0; i<imageViewArray.count; ++i) {
            UIImageView * img=[imageViewArray objectAtIndex: i];
            float t=img.frame.origin.y+img.frame.size.height;
            float p=img.frame.origin.y;
            if (point_s.y<=t&&point_s.y>=p) {
                current_index=i;//找到点击对应的视图序号
                printf("d=%d",current_index);
                break;
            }
        }
 
        [self scaleToSmall:dis_pan ];
 
    }
    else if (longG.state==UIGestureRecognizerStateChanged)
    {
        [self adjustALLwith_x:dis_x  with_y:dis_y];
    }
    else
    {
         printf("end");
         overBound=NO;
        [self scaleToOrdinal:dis_pan];
    
    }

}

-(void)initImageViewFromArray:(NSMutableArray *)arr//图片和文字
{
 
    int num=[arr count];
    int s=0;
    if ([imageViewArray count]>0) {
        s=[imageViewArray count];
        
    }
    int  _y=0;//two图片Y坐标
    printf("test");
    for (int i=s;i<num;i++) {
        UIImage *img=[imageArray objectAtIndex:i];
        printf("img==%f,%f",img.size.width,img.size.height);
        float img_w=img.size.width;
        float img_h=img.size.height;
        img_h=img_h*_width/img_w;//转换
 
        UIImageView * imgV=[[UIImageView alloc] initWithFrame:CGRectMake(0,_y,_width, img_h)];//_width, _height  0  0
//        [imgV setImage:[img compressedImage]];
        
        [imgV setImage:img];
        [imgV setTag:i];//0
        [imageViewArray  addObject:imgV];
        [imgV release];
        
        textEditView=[[UIView alloc] initWithFrame:CGRectMake(0,_y, imgV.frame.size.width,imgV.frame.size.height)];
        [textEditView setTag:i];
        [textEditView setCenter:imgV.center];
        [textEditViewArray addObject:textEditView];
        [textEditView release];
        
        _y=_y+imgV.frame.size.height+8;
    
        
    }

}
-(UIImage*)imageCom:(UIImage*)_img
{
    CGSize imageSize = _img.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= MAX_IMAGEPIX) {
        
        return 0;
    }
    
    UIImage *newImage = nil;
    CGFloat widthFactor = MAX_IMAGEPIX / width;
//    CGFloat heightFactor = MAX_IMAGEPIX / height;
    CGFloat scaleFactor = 0.0;
    
    scaleFactor = widthFactor;//width
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    printf("w=%f,h=%f",scaledWidth,scaledHeight);
    
    [_img drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;

}
-(void)initTextEditView//首次显示图片view和图片编辑view
{
    [self loadAllImageAddTextView];
}

-(void)loadAllImageAddTextView
{
    int height=0;
    for (int i=0; i<imageViewArray.count; ++i) {
        UIImageView * imgv=[imageViewArray objectAtIndex:i];
        UIView * textv=[textEditViewArray objectAtIndex:i];
      
        height=height+imgv.frame.size.height;
        [scrollView addSubview:imgv];
        [scrollView addSubview:textv];
        
    }
//    printf("计算==%d",height);
    
    [scrollView setContentSize:CGSizeMake(320,height+60)];//更新滚动视图的内容大小
    [self reLoadTitleView];
    
}
//标题视图刷新显示到图片视图上方
-(void)reLoadTitleView
{
    for (int i=0; i<scrollView.subviews.count; ++i) {
        UIView * titleV=[scrollView.subviews objectAtIndex:i];
        if ([titleV isKindOfClass:[UITitleLabel class]]) {
            [scrollView bringSubviewToFront:titleV];
        }
    }
    
}
-(void)initGeometryModelBtn
{//添加五个标签tag  0~4
   

    float _y=scrollView.frame.origin.y+scrollView.frame.size.height-49;
    
    gemomtryView=[[UIView alloc] initWithFrame:CGRectMake(0, _y, 320, 49)];
    [self addSubview:gemomtryView];
    [gemomtryView release];
    
    UIImageView* imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,gemomtryView.frame.size.width,gemomtryView.frame.size.height)];
    [imgBg setImage:[UIImage imageNamed:@"colorbg.png"]];
    [gemomtryView addSubview:imgBg];
    [imgBg release];
    
     scviewButton=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,320, gemomtryView.frame.size.height)];
    [scviewButton setContentSize:CGSizeMake(gemomtryView.frame.size.width, gemomtryView.frame.size.height)];
    [gemomtryView addSubview:scviewButton];
    [scviewButton release];
    
    
    //标题按钮
    UIButton * modelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [modelBtn setFrame:CGRectMake(0,0, 80, 49)];
    [modelBtn setTag:3];//标题按钮
    [modelBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",3]] forState:UIControlStateNormal];
    [modelBtn addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    [scviewButton addSubview:modelBtn];
    
    //标签按钮
    for (int i=0; i<3; i++) {
        UIButton * modelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [modelBtn setTag:i];
        [modelBtn setSelected:NO];
        [modelBtn setFrame:CGRectMake(0+gap_btn_bar*(i+1),0, 80, 49)];
        [modelBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]] forState:UIControlStateNormal];
        [modelBtn addTarget:self action:@selector(clickModel:) forControlEvents:UIControlEventTouchUpInside];
        [scviewButton addSubview:modelBtn];
    }
    
    //子模板view颜色面板
     _y=gemomtryView.frame.origin.y-height_gemotry;
    subGemomtryView=[[UIView alloc] initWithFrame:CGRectMake(0, _y, width_gemotry, height_gemotry)];
    subGemomtryView.hidden=YES;
    [self addSubview:subGemomtryView];
    [subGemomtryView release];

     subGemomtryViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,320,85)];
    [subGemomtryView addSubview:subGemomtryViewBg];
    [subGemomtryViewBg release];
   
    //同类标签面板
    
    _y=subGemomtryView.frame.origin.y-50;
    simlarGemomtryView=[[UIView alloc] initWithFrame:CGRectMake(0, _y, width_gemotry, 50)];
 
    [self addSubview:simlarGemomtryView];
    [simlarGemomtryView release];
    
    UIImageView * similarGVBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,320,50)];
    [similarGVBg setImage:[UIImage imageNamed:@"colorbg1.png"]];
    simlarGemomtryView.hidden=YES;
    [simlarGemomtryView addSubview:similarGVBg];//和颜色面板相同背景视图
    [similarGVBg release];

}

-(void)tapHandle:(UIGestureRecognizer *)tapD
{
//    printf("tap\n\n\n\n");
   BOOL isExisted=[self resetTitleviewState];
    if (stateEdit==NO) {
        if (!isExisted) {
            CGPoint point=[tapD locationInView:scrollView];
            int d_index=-1;//记录触摸的图片序号
            for (int i=0; i<imageViewArray.count; ++i) {
                UIImageView * img=[imageViewArray objectAtIndex: i];
                float t=img.frame.origin.y+img.frame.size.height;
                float p=img.frame.origin.y;
                if (point.y<=t&&point.y>=p) {
                    d_index=i;//找到点击对应的视图序号
                    printf("d=%d",d_index);
                    break;
                }
            }
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"要编辑当前图片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert setTag:d_index];
            alert.alertViewStyle=UIAlertViewStyleDefault;
            [alert show];
            [alert release];
            
        }
      
    }
    else
    {
        stateEdit=NO;
        [self resignTextLable];
        [self reStatusModel];//回复按钮
        subGemomtryView.hidden=YES;
        simlarGemomtryView.hidden=YES;
    }
    
   
  
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {//确定编辑
        case 1:
        {
            ModifyImageView * modifyV=[[ModifyImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            modifyV.delegate=self.delegate;
            [modifyV  initWithImageView:[imageViewArray objectAtIndex:[alertView tag]] withTextView:[textEditViewArray objectAtIndex: [alertView tag]] withIndex:[alertView tag] withScrollView:scrollView withTextArray:imageViewArray withImageArray:textEditViewArray];
            [self addSubview:modifyV];
            //bin?:arc
            [modifyV release];
            [self.delegate hiddenTopView:YES];
            break;
        }
        default:
            break;
    }
    
}
-(void)hiddleTitleVieWBorder
{
    for (int i=0; i<scrollView.subviews.count; ++i) {
        UITitleLabel * view=[scrollView.subviews  objectAtIndex:i];
        if ([view isKindOfClass:[UITitleLabel class]]) {
            [view  showBorder ];
        }
    }
}
//显示主题页面
-(void)clickTitle:(id)sender
{
    SelectTitleView *selectTitle = [[SelectTitleView alloc] initWithScrollView:self.scrollView withTextArr:self.textEditViewArray];
    selectTitle.delegate=self.delegate;
    [self addSubview:selectTitle];
    [selectTitle release];
    [self.delegate hiddenTopView:YES];
    [self setCurrentTitleView:nil];
   
    [self  resetButtonImage:nil];
    subGemomtryView.hidden=YES;
    simlarGemomtryView.hidden=YES;
}

//标签形状选择 瓷片  气泡
-(void)clickModel:(id)sender
{
    printf("选择模型");
    [self resetTitleviewState];
    int fla_o=flag_model;
    
    flag_model=[sender tag];
    [self resetButtonImage:sender];

    if (flag_model==0) {//直接生产文字view
        stateEdit=YES;
        printf("You are the winner");
        [self clickGemotryModel:sender];
        return;
    }
    
    if (subGemomtryView.hidden) {
        subGemomtryView.hidden=NO;
        if (flag_model==2) {
              simlarGemomtryView.hidden=NO;
        }
        else
        {
             simlarGemomtryView.hidden=YES;
        }
      
    }
    else
    {
        subGemomtryView.hidden=YES;
        simlarGemomtryView.hidden=YES;
    }
    
//颜色按钮
    printf("flag=%d",flag_model);
    for (int i=0; i<5; ++i) {
        UIButton * modelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [modelBtn setTag:i];
        [modelBtn setFrame:CGRectMake(28+i*58,26, 33, 33)];//60 //36
        [modelBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%dcolor.png",i]] forState:UIControlStateNormal];
        if (flag_model==2) {
            printf("特殊了");
            [modelBtn addTarget:self action:@selector(clickColorInitGemo:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else
        {
             [modelBtn addTarget:self action:@selector(clickGemotryModel:) forControlEvents:UIControlEventTouchUpInside];
        
        }
        [subGemomtryView addSubview:modelBtn];
    }
    
 
    if (fla_o!=flag_model) {//切换按钮
        [self clickColorInitGemo:(id)0];
        subGemomtryView.hidden=NO;
        if (flag_model!=1) {
             simlarGemomtryView.hidden=NO;
        }
        
    }
    
    if (subGemomtryView.hidden==YES) {
        [(UIButton* )sender setSelected:NO];
        [self resetButtonImage:Nil];
    }
    
    [subGemomtryViewBg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"colorbg1.png"]]];
    
    
}
//模型按钮恢复状态  隐藏模板选择子视图
-(void)reStatusModel
{
    UIButton * modelBtn;
    for (int j=0; j<scviewButton.subviews.count; ++j) {
        modelBtn=[scviewButton.subviews objectAtIndex:j];
        if ([modelBtn isKindOfClass:[UIButton class]]) {
            int f=[modelBtn tag];
            [modelBtn setSelected:NO];
            [modelBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",f]] forState:UIControlStateNormal];
        }
    }
}
-(void)resetButtonImage:(id)sender
{
    printf("==%d",flag_model);
    [self reStatusModel];
    if (flag_model==1||flag_model==2) {
        UIButton * btn=(UIButton *)sender;
        if ([btn isSelected]==NO) {
            [btn setSelected:YES];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%dDowned.png",flag_model]] forState:UIControlStateNormal];
        }
        else
        {
            [btn setSelected:NO];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",flag_model]] forState:UIControlStateNormal];
        }
    }

}
-(void)clickColorSure:(id)sender
{
    subGemomtryView.hidden=YES;
    simlarGemomtryView.hidden=YES;
    [textLable._textView becomeFirstResponder];
   
}
-(void)clickColorInitGemo:(id)sender
{
    printf("initG=%d",flag_model);
    int temp=[sender tag];
    int num=0;//个数
    int start_point;
    int label_height;
    int label_width;
    int label_gar;
    if (flag_model==2) {//气泡
        num=4;
        start_point=20;
        label_height=34;
        label_width=55;
        label_gar=75;
    }
 
    for ( UIButton * btn  in simlarGemomtryView.subviews) {
        printf("clear");
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn removeFromSuperview];
        }
    }
    
    flag_mid=flag_model*10+temp;
    for (int i=0; i<num; ++i) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(start_point+i*label_gar,13, label_width, label_height)];
        [btn setTag:i];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%d.png",flag_mid,i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickGemotryModel:) forControlEvents:UIControlEventTouchUpInside];
        [simlarGemomtryView addSubview:btn];
    }
    
   
}

-(void)clearNullLable
{
    for (int i=0;i<LableArray.count ; ++i) {
        UITextLable * _lable=[LableArray objectAtIndex:i];
        if ([_lable._textView.text isEqualToString:@""]||[_lable._textView.text isEqualToString:@"@"]) {
            [LableArray removeObjectAtIndex:i];
            [_lable removeFromSuperview];
        }
    }
}

//添加标签到view
-(void)clickGemotryModel:(id)sender
{
    printf("添加标签");
    stateEdit=YES;
    
    int flag_color=[sender tag];
    [self clearNullLable];//清楚空标签
 
    float offset=scrollView.contentOffset.y;
    
    printf("test==%d,",flag_model);
    if (flag_model==2) {
        printf("新");
        textLable=[[UITextLable alloc]initWithFrame:CGRectMake(0, offset+80, 40, 25) initImage:flag_color withFlagModel:flag_mid withTextVArr:textEditViewArray withView:self.scrollView];//100
    }
    else
    {
      textLable=[[UITextLable alloc]initWithFrame:CGRectMake(0, offset+80, 40, 25) initImage:flag_color withFlagModel:flag_model withTextVArr:textEditViewArray withView:self.scrollView];
    }
     textLable.delegate=self;
    [textLable initWithLableArray:LableArray];
    [textLable._textView becomeFirstResponder];
    [scrollView addSubview:textLable];
    [LableArray addObject:textLable];//管理标签
    [textLable endPanHandle];
    [textLable release];
   
    if(flag_model==0)
    {
        NSShadow * shadow = [[NSShadow alloc] init];
        // 定义阴影的颜色
        shadow.shadowColor = [UIColor redColor];
        // 定义阴影的偏移位置
        shadow.shadowOffset = CGSizeMake(0,0);//0 0
        shadow.shadowBlurRadius=1;//3
        [textLable._textView becomeFirstResponder];
        [textLable._textView setFont:[UIFont systemFontOfSize:20.0]];
        
        NSDictionary *dict=@{
                            NSFontAttributeName:[UIFont systemFontOfSize:20.0],
                            NSForegroundColorAttributeName:[UIColor whiteColor],
                            NSStrokeWidthAttributeName:@3,
                            NSStrokeColorAttributeName:[UIColor blackColor],
//                            NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
//                            NSShadowAttributeName:shadow,
                            NSVerticalGlyphFormAttributeName:@(0)
                             };//@3
        
        textLable._textView.attributedText =[[NSAttributedString alloc]initWithString:@"" attributes:dict];
        
        [shadow release];
    }
   
}
-(void)showBorder:(id)sender
{
    UIButton * btn=(UIButton*)sender;
    for (UIButton *b  in btn.superview.subviews) {
        [b.layer setBorderWidth:0];
    }
    if (btn.layer.borderWidth==0) {
        btn.layer.borderWidth=1;
    }
    else
    {
        btn.layer.borderWidth=0;
    }
    
}
-(void)initImageArray:(NSMutableArray*)arr//初始化图片数组
{
    imageArray=arr;
    NSLog(@"arr=%d",[imageArray count]);
    [self initImageViewFromArray:imageArray];
}

//取消所有标签的焦点
 -(void)resignTextLable
{
    for (int j=0; j<textEditViewArray.count;++j) {
        UIView * v=[self.textEditViewArray objectAtIndex:j];
        int num= [v.subviews count];
        printf("标签失去焦点all=%d",num);
        UITextLable * lab;
        for (int i=0; i<num; ++i) {
            lab=[v.subviews objectAtIndex:i];
            [lab._textView resignFirstResponder];
        }
    }
   
}
-(float)getScrollviewOffset
{
    return scrollView.contentOffset.y;

}
-(void)modifyStateEdit
{
    stateEdit=YES;
}
//设置当前激活的标题视图
-(void)setCurrentTitleView:(UITitleLabel *)titleView
{
    //修改后父视图为scrollview
    if ((titleView==nil)||((actionTitleView!=nil)&&(![actionTitleView isEqual:titleView]))) {
        for (int i=0; i<scrollView.subviews.count; ++i) {//titleView
            UITitleLabel * _view=[scrollView.subviews objectAtIndex:i];
            if ([_view isKindOfClass:[UITitleLabel class]]) {
                printf("找到");
                [_view hiddenBorder];
            }
        }
    }
    if (titleView==nil) {
        return;
    }
    
    [titleView showBorder];
    actionTitleView=titleView;

}
-(void)deleteCurrentTitleView:(UITitleLabel*)titleView
{
    actionTitleView=titleView;
    
}
//取消所有titleview的选中状态
-(BOOL)resetTitleviewState
{
    for (int i=0; i<scrollView.subviews.count; ++i) {
        UITitleLabel * view=[scrollView.subviews  objectAtIndex:i];
        if ([view isKindOfClass:[UITitleLabel class]]) {
            if (view.contorlBtn.hidden==NO) {
                [view  hiddenBorder];
                return YES;
            }
            
        }
    }
    return NO;
}
//拼图分享后返回把标题移动到scrollview层
-(void)moveTitleViewToScrollView
{
    printf("拼接后移动=%d",scrollView.subviews.count);
    for (int i=scrollView.subviews.count-1;i>=0; --i) {
        UIView *textView=[scrollView.subviews objectAtIndex:i];
        if ([textView isKindOfClass:[UIView class]]) {
            for (int j=textView.subviews.count-1; j>=0; --j) {
                UITitleLabel * titleView=[textView.subviews objectAtIndex:j];
                if ([titleView isKindOfClass:[UITitleLabel class]] ) {
                    [titleView hiddenBorder];
 
                    float _y=titleView.superview.frame.origin.y+titleView.center.y;//计算坐标Y
                    [titleView setCenter:CGPointMake(self.center.x, _y)];
                    
                    [scrollView  addSubview:titleView];
                    [scrollView bringSubviewToFront:titleView];
                   
                }
                
            }

        }
        
    }
    printf("结束");
}
-(void)clearView
{
    printf("清除了");
    int num=imageViewArray.count;
    for (int i=0; i<num; ++i) {
        UIView *test1=[ imageViewArray objectAtIndex:i];
        UIView *test2=[ textEditViewArray objectAtIndex:i];
        for (int j=0; j<test2.subviews.count; ++j) {
            UIView * test3=[test2.subviews objectAtIndex:j];
            [test3 removeFromSuperview];
        }
        
        [test1 removeFromSuperview];
        [test2 removeFromSuperview];
        
    }
    [imageViewArray removeAllObjects];
    [textEditViewArray removeAllObjects];
    [LableArray removeAllObjects ];
    
    [scrollView removeFromSuperview];
    
    for (int j=0; j<self.subviews.count;++j) {
        UIView * _v=[self.subviews objectAtIndex:j];
        for (int i=0; i<_v.subviews.count; ++i) {
            UIView * t=[_v.subviews objectAtIndex:i];
            [t removeFromSuperview];
        }
        [_v removeFromSuperview];
        
    }
}
-(void)dealloc
{
    printf("extralar dealloc");
    [self clearView];
    [LableArray release];
    [imageViewArray release];
    [textEditViewArray release];
     printf(",ECC.");
    [super dealloc];
    
}
@end
