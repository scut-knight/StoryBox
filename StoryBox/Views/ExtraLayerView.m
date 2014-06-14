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
#import "WeatherLabel.h"

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
    if (self)
    {
        // Initialization code
        self.frame = frame;
        positionSwich = [[PositionSwitch alloc] init];
        
        //初始化label数组
         LableArray = [[NSMutableArray alloc] init];
        
        if(IS_IPHONE_5)
        {
            Start_y_gemotry = 568;//431
        }
        else
        {
            Start_y_gemotry = 480;//343
            
        }
 
        history = CGPointMake(0, 0);
        [self setBackgroundColor:[UIColor blackColor]];
        
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 320, Start_y_gemotry-45)];//568
        
//      scrollView=[[UIScrollView alloc] initWithFrame:[positionSwich switchBound:CGRectMake(0, 45, 320,480-45)]];//568
        scrollView.userInteractionEnabled = YES;
        [scrollView setContentSize:CGSizeMake(320, 960)];
        scrollView.pagingEnabled = NO;
        [scrollView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:scrollView];
        
        //初始化图片view和标注编辑view数组
        imageViewArray = [[NSMutableArray alloc] init];
        textEditViewArray = [[NSMutableArray alloc] init];//标签数组
        
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
        
        current_index = -1;
        _scale = 0.7;
        stateEdit = NO;
        actionTitleView = nil;
        
    }
    return self;
}

/**
 *  初始化图片数组imageArray
 *
 *  @param arr
 */
-(void)initImageArray:(NSMutableArray*)arr
{
    imageArray = arr;
    NSLog(@"ImageArray大小:%d",[imageArray count]);
    [self initImageViewFromArray:imageArray];
}

/**
 *  初始化imageViewArray和textEditViewArray
 *  @param arr 图片数组
 */
-(void)initImageViewFromArray:(NSMutableArray *)arr//图片和文字
{
 
    int num = [arr count];
    int s = 0;
    if ([imageViewArray count] > 0)
    {
        s = [imageViewArray count];
    }
    
    int  _y=0;//two图片Y坐标
    for (int i=s;i<num;i++)
    {
        UIImage *img = [imageArray objectAtIndex:i];
        NSLog(@"img size%f,%f",img.size.width,img.size.height);
        float img_w=img.size.width;
        float img_h=img.size.height;
        img_h = img_h*_width/img_w;//转换

        //新建用于显示图片的UIImageView
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0,_y,_width, img_h)];//_width, _height  0  0
//        [imgV setImage:[img compressedImage]];
        [imgV setImage:img];
        //设立tag标识
        [imgV setTag:i];
        [imageViewArray addObject:imgV];
        [imgV release];
        
        //新建用于标注编辑的textEditView
        textEditView = [[UIView alloc] initWithFrame:CGRectMake(0,_y, imgV.frame.size.width,imgV.frame.size.height)];
        [textEditView setTag:i];
        [textEditView setCenter:imgV.center];
        [textEditViewArray addObject:textEditView];
        [textEditView release];
        
        _y = _y+imgV.frame.size.height+8;

    }

}

/**
 *  目测是对图片进行压缩?已在UIImage中实现，该处已没有使用
 */
//-(UIImage*)imageCom:(UIImage*)_img
//{
//    CGSize imageSize = _img.size;
//    CGFloat width = imageSize.width;
//    CGFloat height = imageSize.height;
//    
//    if (width <= MAX_IMAGEPIX)
//    {
//        return 0;
//    }
//    
//    UIImage *newImage = nil;
//    CGFloat widthFactor = MAX_IMAGEPIX / width;
////    CGFloat heightFactor = MAX_IMAGEPIX / height;
//    CGFloat scaleFactor = 0.0;
//    
//    scaleFactor = widthFactor;//width
//    CGFloat scaledWidth  = width * scaleFactor;
//    CGFloat scaledHeight = height * scaleFactor;
//    
//    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
//    UIGraphicsBeginImageContext(targetSize); // this will crop
//    
//    CGRect thumbnailRect = CGRectZero;
//    thumbnailRect.size.width  = scaledWidth;
//    thumbnailRect.size.height = scaledHeight;
//    printf("w=%f,h=%f",scaledWidth,scaledHeight);
//    
//    [_img drawInRect:thumbnailRect];
//    
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    //pop the context to get back to the default
//    UIGraphicsEndImageContext();
//    return newImage;
//}

/**
 *  初始化scrollView
 */
-(void)initTextEditView
{
    [self loadAllImageAddTextView];
}

/**
 *  把imageView和textEditView排版加入到scrollView中
 */
-(void)loadAllImageAddTextView
{
    int height=0;
    for (int i=0; i<imageViewArray.count; ++i)
    {
        UIImageView * imgv = [imageViewArray objectAtIndex:i];
        UIView * textv = [textEditViewArray objectAtIndex:i];
      
        height = height+imgv.frame.size.height;
        [scrollView addSubview:imgv];
        [scrollView addSubview:textv];
    }
//    printf("计算==%d",height);
    
    [scrollView setContentSize:CGSizeMake(320,height+60)];//更新滚动视图的内容大小
    [self reLoadTitleView];
}

/**
 *  把所有标签层置于图片层上方显示
 */
-(void)reLoadTitleView
{
    for (int i=0; i<scrollView.subviews.count; ++i)
    {
        UIView * titleV=[scrollView.subviews objectAtIndex:i];
        if ([titleV isKindOfClass:[UITitleLabel class]])
        {
            [scrollView bringSubviewToFront:titleV];
        }
    }
}

/**
 *  初始化底部功能按钮层gemomtryView及相应的面板
 */
-(void)initGeometryModelBtn
{//添加五个标签tag  0~4
   

    float _y = scrollView.frame.origin.y+scrollView.frame.size.height-49;
    
    gemomtryView = [[UIView alloc] initWithFrame:CGRectMake(0, _y, 320, 49)];
    [self addSubview:gemomtryView];
    [gemomtryView release];
    
    UIImageView* imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,gemomtryView.frame.size.width,gemomtryView.frame.size.height)];
    [imgBg setImage:[UIImage imageNamed:@"colorbg.png"]];
    [gemomtryView addSubview:imgBg];
    [imgBg release];
    
    scviewButton = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,320, gemomtryView.frame.size.height)];
    [scviewButton setContentSize:CGSizeMake(gemomtryView.frame.size.width, gemomtryView.frame.size.height)];
    [gemomtryView addSubview:scviewButton];
    [scviewButton release];
    
    
    //大标签功能按钮
    UIButton * modelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modelBtn setFrame:CGRectMake(0,0, 80, 49)];
    //tag设置为3
    [modelBtn setTag:3];
    [modelBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",3]] forState:UIControlStateNormal];
    [modelBtn addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    [scviewButton addSubview:modelBtn];
    
    //标签按钮，tag0,1,2分别对应字幕，瓷片，气泡
    for (int i=0; i<3; i++)
    {
        UIButton * modelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [modelBtn setTag:i];
        [modelBtn setSelected:NO];
        [modelBtn setFrame:CGRectMake(0+gap_btn_bar*(i+1),0, 80, 49)];
        [modelBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]] forState:UIControlStateNormal];
        [modelBtn addTarget:self action:@selector(clickModel:) forControlEvents:UIControlEventTouchUpInside];
        [scviewButton addSubview:modelBtn];
    }
    
    //bin test
    UIButton * weatherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [weatherBtn setFrame:CGRectMake(20,300, 90, 35)];

    [weatherBtn setTitle:@"weather" forState:UIControlStateNormal];
    
    [weatherBtn setTag:10];
    [weatherBtn setSelected:NO];
    [weatherBtn addTarget:self action:@selector(clickWeatherButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:weatherBtn];
    
    //子模板view颜色面板
     _y = gemomtryView.frame.origin.y - height_gemotry;
    subGemomtryView = [[UIView alloc] initWithFrame:CGRectMake(0, _y, width_gemotry, height_gemotry)];
    subGemomtryView.hidden = YES;
    [self addSubview:subGemomtryView];
    [subGemomtryView release];

    subGemomtryViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,85)];
    [subGemomtryView addSubview:subGemomtryViewBg];
    [subGemomtryViewBg release];
   
    //同类标签面板
    
    _y = subGemomtryView.frame.origin.y-50;
    simlarGemomtryView = [[UIView alloc] initWithFrame:CGRectMake(0, _y, width_gemotry, 50)];
    [self addSubview:simlarGemomtryView];
    [simlarGemomtryView release];
    
    UIImageView * similarGVBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,320,50)];
    [similarGVBg setImage:[UIImage imageNamed:@"colorbg1.png"]];
    simlarGemomtryView.hidden = YES;
    [simlarGemomtryView addSubview:similarGVBg];//和颜色面板相同背景视图
    [similarGVBg release];
}


//bin test
-(void)clickWeatherButton:(id)sender
{
    WeatherLabel * t = [[WeatherLabel alloc] init];
    [t getWeather];
}
/**
 *  处理单击手势，实现到编辑单张图片的跳转
 *
 *  @param tapD
 */
-(void)tapHandle:(UIGestureRecognizer *)tapD
{
//    printf("tap\n\n\n\n");
    BOOL isExisted = [self resetTitleviewState];
    //如果没有处于编辑状态的标签，则询问是否编辑当前图片
    if (stateEdit == NO)
    {
        //第二次检查
        if (!isExisted)
        {
            CGPoint point = [tapD locationInView:scrollView];
            //记录触摸的图片序号
            int d_index=-1;
            for (int i=0; i<imageViewArray.count; ++i)
            {
                UIImageView * img = [imageViewArray objectAtIndex: i];
                float t = img.frame.origin.y+img.frame.size.height;
                float p = img.frame.origin.y;
                if (point.y<=t&&point.y>=p)
                {
                    //找到点击对应的视图序号
                    d_index = i;
                    printf("edit:%d",d_index);
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
        //如果是在编辑状态，则单击后变为非编辑状态
        stateEdit = NO;
        [self resignTextLable];
        [self reStatusModel];//回复按钮
        subGemomtryView.hidden = YES;
        simlarGemomtryView.hidden = YES;
    }
}

/**
 *  处理长点击手势，进入图片略缩图，可改变图片顺序
 *
 *  @param longG
 */
-(void)LongPress:(UILongPressGestureRecognizer *)longG
{
    CGPoint point = [longG locationInView:self];
    float _x = history.x;
    float _y = history.y;
    float dis_x=0;
    float dis_y=0;
    
    if (_x==0&&_y==0)
    {
        history=CGPointMake(point.x, point.y);
    }
    else
    {
        dis_x=point.x-history.x;
        dis_y=point.y-history.y;
        history=point;
    }
    
    if (longG.state==UIGestureRecognizerStateBegan)
    {
        printf("beg");
        
        dis_pan=scrollView.frame.size.height*(1 - _scale)/2;
        CGPoint point_s=[longG locationInView:scrollView];
        for (int i=0; i<imageViewArray.count; ++i)
        {
            UIImageView * img=[imageViewArray objectAtIndex: i];
            float t=img.frame.origin.y+img.frame.size.height;
            float p=img.frame.origin.y;
            if (point_s.y<=t&&point_s.y>=p)
            {
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
        overBound = NO;
        [self scaleToOrdinal:dis_pan];
    }
    
}

/**
 *  实现alertView委托。进入单图编辑界面
 *
 *  @param alertView
 *  @param buttonIndex
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {//确定编辑
        case 1:
        {
            ModifyImageView * modifyV = [[ModifyImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            modifyV.delegate = self.delegate;
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

/**
 *  bin?:已停用？
 */
-(void)hiddleTitleVieWBorder
{
    for (int i=0; i<scrollView.subviews.count; ++i)
    {
        UITitleLabel * view=[scrollView.subviews objectAtIndex:i];
        if([view isKindOfClass:[UITitleLabel class]])
        {
            [view showBorder];
        }
    }
}

/**
 *  大标签按钮触发，切换到大标签选择界面
 *
 *  @param sender
 */
-(void)clickTitle:(id)sender
{
    SelectTitleView *selectTitle = [[SelectTitleView alloc] initWithScrollView:self.scrollView withTextArr:self.textEditViewArray];
    selectTitle.delegate=self.delegate;
    [self addSubview:selectTitle];
    [selectTitle release];
    [self.delegate hiddenTopView:YES];
    [self setCurrentTitleView:nil];
   
    [self  resetButtonImage:nil];
    subGemomtryView.hidden = YES;
    simlarGemomtryView.hidden = YES;
}

/**
 *  其他标签按钮触发
 *
 *  @param sender
 */
-(void)clickModel:(id)sender
{
//    printf("选择模型");
    [self resetTitleviewState];
    int fla_o = flag_model;
    
    flag_model = [sender tag];
    [self resetButtonImage:sender];
    
    //如果是字幕,切换到字幕编辑状态
    if(flag_model == 0)
    {
        stateEdit = YES;
        [self clickGemotryModel:sender];
        return;
    }
    
    //如果子按钮栏为隐藏，显示子按钮栏，否则隐藏
    if (subGemomtryView.hidden)
    {
        subGemomtryView.hidden = NO;
        //如果是气泡，显示气泡选择栏，否则隐藏
        if (flag_model == 2)
        {
            simlarGemomtryView.hidden = NO;
        }
        else
        {
            simlarGemomtryView.hidden = YES;
        }
      
    }
    else
    {
        subGemomtryView.hidden=YES;
        simlarGemomtryView.hidden=YES;
    }
    
    //初始化颜色按钮
    for (int i=0; i<5; ++i)
    {
        UIButton * modelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [modelBtn setTag:i];
        [modelBtn setFrame:CGRectMake(28+i*58,26, 33, 33)];//60 //36
        [modelBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%dcolor.png",i]] forState:UIControlStateNormal];
        //为颜色按钮是属于瓷片和气泡两种情况设立不同的触发
        if (flag_model == 2)
        {
            [modelBtn addTarget:self action:@selector(clickColorInitGemo:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [modelBtn addTarget:self action:@selector(clickGemotryModel:) forControlEvents:UIControlEventTouchUpInside];
        }
        [subGemomtryView addSubview:modelBtn];
    }
 
    //从按钮到按钮的选中切换
    if (fla_o != flag_model)
    {
        [self clickColorInitGemo:(id)0];
        subGemomtryView.hidden = NO;
        if (flag_model!=1)
        {
             simlarGemomtryView.hidden = NO;
        }
        
    }
    
    if (subGemomtryView.hidden == YES)
    {
        [(UIButton* )sender setSelected:NO];
        [self resetButtonImage:Nil];
    }
    
    //设定子按钮栏背景
    [subGemomtryViewBg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"colorbg1.png"]]];
}

/**
 *  按钮图片切换，只置换flag_model为1和2的按钮
 *  因为0对应的标题按钮会切换到另一个view，对应的字幕按钮会被键盘挡住,所以没必要切换
 *
 *  @param sender
 */
-(void)resetButtonImage:(id)sender
{
    NSLog(@"当前选中按钮:%d",flag_model);
    [self reStatusModel];
    if (flag_model==1 || flag_model==2)
    {
        UIButton * btn = (UIButton *)sender;
        if ([btn isSelected] == NO)
        {
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

/**
 *  恢复按钮状态  隐藏模板选择子视图?
 */
-(void)reStatusModel
{
    UIButton * modelBtn;
    for (int j=0; j<scviewButton.subviews.count; ++j)
    {
//        NSLog(@"bin:bin%d",scviewButton.subviews.count);
        modelBtn = [scviewButton.subviews objectAtIndex:j];
        if ([modelBtn isKindOfClass:[UIButton class]])
        {
            int f = [modelBtn tag];
            [modelBtn setSelected:NO];
            [modelBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",f]] forState:UIControlStateNormal];
        }
    }
}

/**
 *  bin:?已停用
 *
 *  @param sender
 */
//-(void)clickColorSure:(id)sender
//{
//    subGemomtryView.hidden = YES;
//    simlarGemomtryView.hidden = YES;
//    [textLable._textView becomeFirstResponder];
//   
//}

-(void)clickColorInitGemo:(id)sender
{
//    printf("initG=%d",flag_model);
    int temp = [sender tag];
    int num = 0;//个数
    int start_point;
    int label_height;
    int label_width;
    int label_gar;
    
    //如果是气泡
    if (flag_model==2)
    {
        num = 4;
        start_point = 20;
        label_height = 34;
        label_width = 55;
        label_gar = 75;
    }
 
    //移除气泡按钮栏的所有按钮
    for (UIButton * btn in simlarGemomtryView.subviews)
    {
        printf("clear");
        if ([btn isKindOfClass:[UIButton class]])
        {
            [btn removeFromSuperview];
        }
    }
    
    flag_mid = flag_model*10 + temp;
    //重新建立气泡按钮栏的所有按钮
    for (int i=0; i<num; ++i)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(start_point+i*label_gar,13, label_width, label_height)];
        [btn setTag:i];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%d.png",flag_mid,i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickGemotryModel:) forControlEvents:UIControlEventTouchUpInside];
        [simlarGemomtryView addSubview:btn];
    }
    
   
}

/**
 *  清除所有没有文字的标签
 */
-(void)clearNullLable
{
    for (int i=0;i<LableArray.count ; ++i)
    {
        UITextLable * _lable=[LableArray objectAtIndex:i];
        if ([_lable._textView.text isEqualToString:@""]||[_lable._textView.text isEqualToString:@"@"])
        {
            [LableArray removeObjectAtIndex:i];
            [_lable removeFromSuperview];
        }
    }
}

/**
 *  添加标签到view
 *
 *  @param sender
 */
-(void)clickGemotryModel:(id)sender
{
    NSLog(@"添加标签");
    stateEdit=YES;
    
    int flag_color=[sender tag];
    //清除空标签
    [self clearNullLable];
 
    float offset=scrollView.contentOffset.y;
    
    printf("test==%d,",flag_model);
    if (flag_model==2)
    {
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


/**
 *  已停用
 *
 *  @param sender
 */
-(void)showBorder:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    for (UIButton *b in btn.superview.subviews)
    {
        [b.layer setBorderWidth:0];
    }
    if (btn.layer.borderWidth == 0)
    {
        btn.layer.borderWidth = 1;
    }
    else
    {
        btn.layer.borderWidth = 0;
    }
    
}


/**
 *  取消所有标签的焦点
 */
 -(void)resignTextLable
{
    for (int j=0; j<textEditViewArray.count;++j)
    {
        UIView * v = [self.textEditViewArray objectAtIndex:j];
        int num = [v.subviews count];
        printf("标签失去焦点all=%d",num);
        UITextLable * lab;
        for(int i=0; i<num; ++i)
        {
            lab=[v.subviews objectAtIndex:i];
            //取消编辑焦点
            [lab._textView resignFirstResponder];
        }
    }
}

/**
 *  委托方法。获取Scrollview y方向上的偏移量
 *
 *  @return 偏移量
 */
-(float)getScrollviewOffset
{
    return scrollView.contentOffset.y;

}

/**
 *  设定为编辑状态
 */
-(void)modifyStateEdit
{
    stateEdit = YES;
}


/**
 *  委托方法。设置大标签视图为当前激活状态，并显示操作栏
 *
 *  @param titleView 大标签
 */
-(void)setCurrentTitleView:(UITitleLabel *)titleView
{
    //修改后父视图为scrollview
    //如果传入titleView为空，则从已有大标签中选取第一个
    if ((titleView == nil) || ((actionTitleView!=nil) && (![actionTitleView isEqual:titleView])))
    {
        for (int i=0; i<scrollView.subviews.count; ++i)
        {
            UITitleLabel * _view = [scrollView.subviews objectAtIndex:i];
            if ([_view isKindOfClass:[UITitleLabel class]])
            {
//                printf("找到");
                [_view hiddenBorder];
            }
        }
    }
    
    //如果没有大标签，则返回
    if (titleView == nil)
    {
        return;
    }
    
    //显示选中大标签的操作栏,并设为当前活动状态
    [titleView showBorder];
    actionTitleView = titleView;
}

/**
 *  委托方法。设定当前活动的大标签
 *
 *  @param titleView 大标签
 */
-(void)deleteCurrentTitleView:(UITitleLabel*)titleView
{
    actionTitleView = titleView;
}

/**
 *  取消所有大标签的选中状态
 *
 *  @return 是否执行了取消选中
 */
-(BOOL)resetTitleviewState
{
    for (int i=0; i<scrollView.subviews.count; ++i)
    {
        UITitleLabel * view = [scrollView.subviews objectAtIndex:i];
        if ([view isKindOfClass:[UITitleLabel class]])
        {
            if (view.contorlBtn.hidden == NO)
            {
                [view hiddenBorder];
                return YES;
            }
            
        }
    }
    return NO;
}


/**
 *  拼图分享后返回把大标签移动到scrollview层
 */
-(void)moveTitleViewToScrollView
{
    printf("拼接后移动=%d",scrollView.subviews.count);
    for (int i=scrollView.subviews.count-1;i>=0; --i)
    {
        UIView *textView=[scrollView.subviews objectAtIndex:i];
        if ([textView isKindOfClass:[UIView class]])
        {
            for (int j=textView.subviews.count-1; j>=0; --j)
            {
                UITitleLabel * titleView=[textView.subviews objectAtIndex:j];
                if ([titleView isKindOfClass:[UITitleLabel class]] )
                {
                    [titleView hiddenBorder];
 
                    float _y=titleView.superview.frame.origin.y+titleView.center.y;//计算坐标Y
                    [titleView setCenter:CGPointMake(self.center.x, _y)];
                    
                    [scrollView  addSubview:titleView];
                    [scrollView bringSubviewToFront:titleView];
                   
                }
                
            }

        }
    }
//    printf("结束");
}

/**
 *  清除长图编辑界面的所有元素(包括相片素材,标签,视图)。一般拼接完成后继续制作时调用
 */
-(void)clearView
{
    NSLog(@"清除了");
    int num=imageViewArray.count;
    for (int i=0; i<num; ++i)
    {
        UIView *test1 = [imageViewArray objectAtIndex:i];
        UIView *test2 = [textEditViewArray objectAtIndex:i];
        for (int j=0; j<test2.subviews.count; ++j)
        {
            UIView * test3 = [test2.subviews objectAtIndex:j];
            [test3 removeFromSuperview];
        }
        
        [test1 removeFromSuperview];
        [test2 removeFromSuperview];
        
    }
    [imageViewArray removeAllObjects];
    [textEditViewArray removeAllObjects];
    [LableArray removeAllObjects ];
    
    [scrollView removeFromSuperview];
    
    for (int j=0; j<self.subviews.count;++j)
    {
        UIView * _v=[self.subviews objectAtIndex:j];
        for (int i=0; i<_v.subviews.count; ++i)
        {
            UIView * t=[_v.subviews objectAtIndex:i];
            [t removeFromSuperview];
        }
        [_v removeFromSuperview];
        
    }
}

-(void)dealloc
{
//    printf("extralar dealloc");
    [self clearView];
    [LableArray release];
    [imageViewArray release];
    [textEditViewArray release];
    [super dealloc];
    
}
@end
