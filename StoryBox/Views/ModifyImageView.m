//
//  ModifyImageView.m
//  故事盒子
//
//  Created by mac on 14-3-3.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import "ModifyImageView.h"
#import "ClipViewController.h"
#import "CameraCustom.h"
#import "SBDoodleView.h"

//界面布局
int Start_y_ColorPanel;//410功能容器

#define _width 320
#define width_btn_bar 160
#define Height_btn_bar 44
#define gap_btn_bar 160
#define width_More_btn_bar 67
#define height_More_btn_bar 16
#define height_textEditView 640//文字层高度
#define Height_ColorPanel 50//功能容器高度
#define Height_subPanel 45  //子功能列表高度
#define width_subbtn_bar 26 //子功能列表按钮
#define Height_subbtn_bar 26
#define x_imgView 0
#define y_imgView 80//100

@implementation ModifyImageView

@synthesize delegate;

-(id)initWithImageView:(UIImageView*)imgV withTextView:(UIView*)textV
             withIndex:(int)index   withScrollView:(SBScrollView *)sc
         withTextArray:(NSMutableArray*)textArray withImageArray:(NSMutableArray*)imageArray
{
    self = [super init];
    if (self)
    {
        if(IS_IPHONE_5)
        {
            Start_y_ColorPanel=524;
            [self setFrame:CGRectMake(0, 0, 320, 568)];
        }
        else
        {
            Start_y_ColorPanel=436;
            [self setFrame:CGRectMake(0, 0, 320, 480)];
        }
        [self isExclusiveTouch];
        [self  setBackgroundColor:[UIColor blackColor]];
        state_V = NO;
        state_H = NO;
        
        [imgV setFrame:CGRectMake(0,45, imgV.frame.size.width, imgV.frame.size.height)];
        [textV setFrame:imgV.frame];
        
        [self addSubview:imgV];
        [self addSubview:textV];
        
        currentImageView = imgV;
        //textV为当前图片上的已有标签视图
         _textV = textV;
        //隐藏标签
        _textV.hidden = YES;
        _sc = sc;
        imageCG = CGImageCreateCopy(currentImageView.image.CGImage) ;
 
        
        imageIndex = index;
        imageViewArr = imageArray;
        textViewArr = textArray;
        
        imageTrangsform = currentImageView.transform;
        
        [self initColorPanel];
        [self initSubFunction];
        [self initNavigationBar];
        [self bringSubviewToFront:NavigationView];
        [self bringSubviewToFront:imageBarView];
        [self bringSubviewToFront:subFunctionView];
        [self bringSubviewToFront:subFunctionViewofFilter];
    }
    return self;
}

/**
 *  导航条布局，添加完成和返回按钮
 */
-(void)initNavigationBar
{
    NavigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    UIImageView *NavigationViewBg= [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 45) ] initWithImage:[UIImage imageNamed:@"editTopView.png"]];
    [NavigationView addSubview:NavigationViewBg];
    [self addSubview:NavigationView];
    
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(10, 15, 88,16)];
    [back setImage:[UIImage imageNamed:@"editBackBtn.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backEdit:) forControlEvents:UIControlEventTouchUpInside];
    [NavigationView addSubview:back];
    
    UIButton* finish=[UIButton buttonWithType:UIButtonTypeCustom];
    [finish setFrame:CGRectMake(262, 15, 48,15)];
    [finish setImage:[UIImage imageNamed:@"editFinishBtn.png"] forState:UIControlStateNormal];
    [finish addTarget:self action:@selector(finishEdit:) forControlEvents:UIControlEventTouchUpInside];
    [NavigationView addSubview:finish];
}

/**
 *  返回按钮触发
 *
 *  @param sender
 */
-(void)backEdit:(id)sender
{
    // 当前图片
    currentImageView.transform = imageTrangsform;
    [currentImageView setImage:[UIImage imageWithCGImage:imageCG]];

    [_sc addSubview:currentImageView];
    [_sc addSubview:_textV];
    //显示标签层
    _textV.hidden = NO;
    [self reloadScrollview];
    [self.delegate hiddenTopView:NO];
    [self removeFromSuperview];
    
}

/**
 *  结束按钮触发
 *
 *  @param sender
 */
-(void)finishEdit:(id)sender
{
    [self reSetImgView];
    [_sc addSubview:currentImageView];
    [_sc addSubview:_textV];
    //显示标签层
     _textV.hidden = NO;
     [self reloadScrollview];
    
    [self.delegate hiddenTopView:NO];
    [self removeFromSuperview];
}

/**
 *  更新图片和文字层
 */
-(void)reSetImgView
{
    UIView * temp_textView=[textViewArr objectAtIndex:imageIndex];
    for (int i=0; i<temp_textView.subviews.count; ++i) {
        UIView * temp=[temp_textView.subviews objectAtIndex:i];
        [temp removeFromSuperview];
    }
    NSString * _path=[CameraCustom pathOfTempImage];
    
    [CameraCustom SaveToBoxForTempImage:[CameraCustom singleImage:currentImageView withTextView:temp_textView] withPath: _path];

    float _x=currentImageView.frame.origin.x;
    float _y=currentImageView.frame.origin.y;
    float _w=currentImageView.frame.size.width;
    float _h=currentImageView.frame.size.height;
    currentImageView.transform=CGAffineTransformIdentity;
    
    NSLog(@"%@",currentImageView);
    [currentImageView setImage:[UIImage imageWithContentsOfFile:_path]];
    [currentImageView setFrame: CGRectMake(_x, _y, _w, _h)];
    
    [self anjustTextLableOFView:_textV];
    [_textV setFrame:currentImageView.frame];
    
    [_textV removeFromSuperview];
    [currentImageView removeFromSuperview];
}

-(void)anjustTextLableOFView:(UIView*)_v
{
    UIView *_temp=nil;
    float  dis=0;
    for (int i=0; i<_v.subviews.count; ++i)
    {
        _temp=[_v.subviews objectAtIndex:i];
        dis=dis + _temp.frame.size.height;
        [_temp setFrame:CGRectMake(40,30+dis, _temp.frame.size.width, _temp.frame.size.height)];
    }
}

-(void)reloadScrollview
{
    int height=0;
    int  _y=0;//two图片Y坐标
    int margin = 8; // 图片间隔
    for (int i=0; i<imageViewArr.count; ++i)
    {
        UIImageView * imgv;
        UIView *textv;
        if(i==imageIndex)
        {
            imgv=currentImageView;
            textv=_textV;
        }
        else{
            imgv=[imageViewArr objectAtIndex:i];
            textv=[textViewArr objectAtIndex:i];
            
        }
        
        if ([imgv isKindOfClass:[SBDoodleView class]]) { // 跳过涂鸦视图，避免奇怪的偏移
            continue;
        }
        
        [imgv setFrame:CGRectMake(0,_y,imgv.frame.size.width, imgv.frame.size.height)];
        [textv setFrame:imgv.frame];
        height=height+imgv.frame.size.height;
        NSLog(@"%d", height); // sptest
        _y += imgv.frame.size.height + margin;
        
    }
    
    [_sc moveDoodleViewAbove];
    [_sc setContentSize:CGSizeMake(320,height+60)];//更新滚动视图的内容大小
    //重新设置坐标
    
    [self reLoadTitleView];
}

/**
 *  重新设置titleView的层次级别
 */
-(void)reLoadTitleView
{
    for (int i=0; i<_sc.subviews.count; ++i) {
        UITitleLabel * titleLabelTemp=[_sc.subviews objectAtIndex:i];
        if ([titleLabelTemp isKindOfClass:[UITitleLabel class]])
        {
            [_sc bringSubviewToFront:titleLabelTemp];
        }
    }

}

/**
 *  功能栏布局（裁剪，变换）
 */
-(void)initColorPanel
{
//    NSLog(@"%d is the width,%d is the ColorPanel.\n",_width,Start_y_ColorPanel);
    imageBarView=[[UIView alloc] initWithFrame:CGRectMake(0,Start_y_ColorPanel, _width, 44)];//功能面板背景
    [imageBarView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:imageBarView];

    
    
    UIImageView *imgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, 44)];
    [imgV setImage:[UIImage imageNamed:@"functionBg.png"]];
    [imageBarView addSubview:imgV];
    
    
    UIImageView *imgV1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, 44)];
    [imgV1 setImage:[UIImage imageNamed:@"functionBg1.png"]];
    [imageBarView addSubview:imgV1];
    
    
    
    UIButton* btnRotateLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRotateLeft setFrame:CGRectMake(9+gap_btn_bar, 0, width_btn_bar,Height_btn_bar)];
    //    [btnRotateLeft setTitle:@"左旋" forState:UIControlStateNormal];
    [btnRotateLeft setImage:[UIImage imageNamed:@"rotateBtn.png"] forState:UIControlStateNormal];
    [btnRotateLeft addTarget:self action:@selector(clickRotate:) forControlEvents:UIControlEventTouchUpInside];
    [imageBarView addSubview:btnRotateLeft];
    
    
    UIButton*  btnCutting=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCutting setFrame:CGRectMake(0, 0, width_btn_bar,Height_btn_bar)];
    //    [btnCutting setTitle:@"裁剪" forState:UIControlStateNormal];
    [btnCutting setImage:[UIImage imageNamed:@"clipBtn.png"] forState:UIControlStateNormal];
    [btnCutting addTarget:self action:@selector(clickCutting:) forControlEvents:UIControlEventTouchUpInside];
    [imageBarView addSubview:btnCutting];
 
    
    
    
    UIButton* btnFilter=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnFilter setFrame:CGRectMake(gap_btn_bar/2+18, 0, width_btn_bar,Height_btn_bar)];
    //    [btnFilter setTitle:@"滤镜" forState:UIControlStateNormal];
    [btnFilter setImage:[UIImage imageNamed:@"滤镜.png"] forState:UIControlStateNormal];
    [btnFilter addTarget:self action:@selector(clickFilter:) forControlEvents:UIControlEventTouchUpInside];
    [imageBarView addSubview:btnFilter];
    
    
    
    //    UIButton* btnRotateRight=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnRotateRight setFrame:CGRectMake(gap_btn_bar*2+20, 4, width_btn_bar,Height_btn_bar)];
    ////    [btnRotateRight setTitle:@"滤镜" forState:UIControlStateNormal];
    //     [btnRotateRight setImage:[UIImage imageNamed:@"filterBtn.png"] forState:UIControlStateNormal];
    //    [btnRotateRight addTarget:self action:@selector(clickFilter:) forControlEvents:UIControlEventTouchUpInside];
    //    [imageBarView addSubview:btnRotateRight];
    
//    UIButton* btnRotateRight=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnRotateRight setFrame:CGRectMake(gap_btn_bar*2+20, 4, width_btn_bar,Height_btn_bar)];
//    //    [btnRotateRight setTitle:@"滤镜" forState:UIControlStateNormal];
//    [btnRotateRight setImage:[UIImage imageNamed:@"filterBtn.png"] forState:UIControlStateNormal];
////    [btnRotateRight addTarget:self action:@selector(clickAddImage:) forControlEvents:UIControlEventTouchUpInside];
//    [imageBarView addSubview:btnRotateRight];
    
    
//    UIButton* btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnDelete setFrame:CGRectMake(gap_btn_bar*3+20,4, width_btn_bar,Height_btn_bar)];
//    //    [btnDelete setTitle:@"删除" forState:UIControlStateNormal];
//    [btnDelete setImage:[UIImage imageNamed:@"deleteBtn.png"] forState:UIControlStateNormal];
////    [btnDelete addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
//    [imageBarView addSubview:btnDelete];

}

/**
 *  变换子功能栏布局
 */
-(void)initSubFunction
{
    
    subFunctionView=[[UIView alloc]initWithFrame:CGRectMake(0,Start_y_ColorPanel-Height_subPanel, _width, Height_ColorPanel)];
    subFunctionView.hidden=YES;
    [self addSubview:subFunctionView];
    
    
    subFunctionViewofFilter=[[UIView alloc]initWithFrame:CGRectMake(0,Start_y_ColorPanel-Height_subPanel, _width, Height_ColorPanel)];
    subFunctionViewofFilter.hidden=YES;
    [self addSubview:subFunctionViewofFilter]; //wind:滤镜部分的子菜单图片加载
    
    UIImageView *imgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, Height_subPanel)];
     UIImageView *imgV1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, Height_subPanel)];
    [imgV setImage:[UIImage imageNamed:@"subFunctionBg.png"]];
    [imgV1 setImage:[UIImage imageNamed:@"subFunctionBg1.png"]];
    [subFunctionView addSubview:imgV];
    [subFunctionViewofFilter addSubview:imgV1];
    
    UIButton* btnRotateLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRotateLeft setFrame:CGRectMake(45, 6, width_subbtn_bar,Height_subbtn_bar)];
    //    [btnRotateLeft setTitle:@"左旋" forState:UIControlStateNormal];
    [btnRotateLeft setImage:[UIImage imageNamed:@"leftRotaeBtn.png"] forState:UIControlStateNormal];
    [btnRotateLeft addTarget:self action:@selector(clickRotateLeft:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionView addSubview:btnRotateLeft];
    
    UIButton* btnRotateRight=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRotateRight setFrame:CGRectMake(113, 6, width_subbtn_bar,Height_subbtn_bar)];
    //    [btnRotateRight setTitle:@"右旋" forState:UIControlStateNormal];
    [btnRotateRight setImage:[UIImage imageNamed:@"rightRotaeBtn.png"] forState:UIControlStateNormal];
    [btnRotateRight addTarget:self action:@selector(clickRotateRight:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionView addSubview:btnRotateRight];
    
    UIButton* btnTurnToL=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnTurnToL setFrame:CGRectMake(181, 6, width_subbtn_bar,Height_subbtn_bar)];
    //    [btnTurnToL setTitle:@"垂直" forState:UIControlStateNormal];
    [btnTurnToL setImage:[UIImage imageNamed:@"verticalMirror.png"] forState:UIControlStateNormal];
    [btnTurnToL addTarget:self action:@selector(clickTurnToL:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionView addSubview:btnTurnToL];
    
    UIButton*  btnTurnToR=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnTurnToR setFrame:CGRectMake(249, 6, width_subbtn_bar,Height_subbtn_bar)];
    //    [btnTurnToR setTitle:@"水平" forState:UIControlStateNormal];
    [btnTurnToR setImage:[UIImage imageNamed:@"levelMirror.png"] forState:UIControlStateNormal];
    [btnTurnToR addTarget:self action:@selector(clickTurnToR:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionView addSubview:btnTurnToR];
    
    
    //wind:---------------------------在子菜单加入滤镜部分按钮-----------------------
    UIButton* Filter1=[UIButton buttonWithType:UIButtonTypeCustom];
    [Filter1 setFrame:CGRectMake(16, 6, width_subbtn_bar,Height_subbtn_bar)];
    // [Filter1 setTitle:@"LOMO" forState:UIControlStateNormal];
    [Filter1 setImage:[UIImage imageNamed:@"FilterofLOMO2.png"] forState:UIControlStateNormal];
    [Filter1 addTarget:self action:@selector(clickFilter1:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionViewofFilter addSubview:Filter1];
    
    UIButton* Filter2=[UIButton buttonWithType:UIButtonTypeCustom];
    [Filter2 setFrame:CGRectMake(60, 6, width_subbtn_bar,Height_subbtn_bar)];
    //[Filter2 setTitle:@"黑白" forState:UIControlStateNormal];
    [Filter2 setImage:[UIImage imageNamed:@"Filterofheibai.png"] forState:UIControlStateNormal];
    [Filter2 addTarget:self action:@selector(clickFilter2:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionViewofFilter addSubview:Filter2];
    
    UIButton* Filter3=[UIButton buttonWithType:UIButtonTypeCustom];
    [Filter3 setFrame:CGRectMake(104, 6, width_subbtn_bar,Height_subbtn_bar)];
    //[Filter3 setTitle:@"怀旧" forState:UIControlStateNormal];
    [Filter3 setImage:[UIImage imageNamed:@"Filterofhuaijiu.png"] forState:UIControlStateNormal];
    [Filter3 addTarget:self action:@selector(clickFilter3:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionViewofFilter addSubview:Filter3];
    
    UIButton*  Filter4=[UIButton buttonWithType:UIButtonTypeCustom];
    [Filter4 setFrame:CGRectMake(148, 6, width_subbtn_bar,Height_subbtn_bar)];
    //[Filter4 setTitle:@"淡雅" forState:UIControlStateNormal];
    [Filter4 setImage:[UIImage imageNamed:@"Filterofdanya.png"] forState:UIControlStateNormal];
    [Filter4 addTarget:self action:@selector(clickFilter4:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionViewofFilter addSubview:Filter4];
    
    UIButton*  Filter5=[UIButton buttonWithType:UIButtonTypeCustom];
    [Filter5 setFrame:CGRectMake(192, 6, width_subbtn_bar,Height_subbtn_bar)];
    //[Filter5 setTitle:@"锐色" forState:UIControlStateNormal];
    [Filter5 setImage:[UIImage imageNamed:@"Filterofruise.png"] forState:UIControlStateNormal];
    [Filter5 addTarget:self action:@selector(clickFilter5:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionViewofFilter addSubview:Filter5];
    
    UIButton*  Filter6=[UIButton buttonWithType:UIButtonTypeCustom];
    [Filter6 setFrame:CGRectMake(236, 6, width_subbtn_bar,Height_subbtn_bar)];
    //[Filter6 setTitle:@"哥特" forState:UIControlStateNormal];
    [Filter6 setImage:[UIImage imageNamed:@"Filterofgete.png"] forState:UIControlStateNormal];
    [Filter6 addTarget:self action:@selector(clickFilter6:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionViewofFilter addSubview:Filter6];
    
    UIButton*  Filter7=[UIButton buttonWithType:UIButtonTypeCustom];
    [Filter7 setFrame:CGRectMake(280, 6, width_subbtn_bar,Height_subbtn_bar)];
    //[Filter7 setTitle:@"夜色" forState:UIControlStateNormal];
    [Filter7 setImage:[UIImage imageNamed:@"Filterofyese.png"] forState:UIControlStateNormal];
    [Filter7 addTarget:self action:@selector(clickFilter7:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionViewofFilter addSubview:Filter7];
    //wind:---------------------------在子菜单加入滤镜部分按钮-----------------------
}

/**
 *  裁剪按钮触发
 *
 *  @param sender
 */
-(void)clickCutting:(id)sender
{
    NSLog(@"裁剪");
    [[ClipViewController sharedInstance] initWith:currentImageView.image with:self withDelegate:self];
    //进入裁剪界面
    [self.superview addSubview:[ClipViewController sharedInstance].view];
    
    [self removeFromSuperview];

    moreFunction.hidden = YES;
}

/**
 *  变换按钮事件
 *
 *  @param sender
 */
-(void)clickRotate:(id)sender
{
    subFunctionViewofFilter.hidden=YES;
//    printf("子功能");
    if (subFunctionView.hidden)
    {
//        printf("hidd");
        NSLog(@"显示变换菜单");
        subFunctionView.hidden=NO;
    }
    else
    {
//        printf("yes dis");
        NSLog(@"隐藏变换菜单");
        subFunctionView.hidden=YES;
    }
    
    moreFunction.hidden=YES;
    
}

#pragma mark - 滤镜
//----------------------------------滤镜添加----------------------------------------
/**
 *  滤镜按钮触发
 *
 *  @param sender
 */
-(void)clickFilter:(id)sender
{
    subFunctionView.hidden=YES;  //如是打开滤镜的界面，则关闭旋转的界面
    originalImage = [UIImage imageWithCGImage:currentImageView.image.CGImage];
    printf("滤镜");
    if (subFunctionViewofFilter.hidden)
    {
        //        printf("hidd");
        NSLog(@"显示变换菜单");
        subFunctionViewofFilter.hidden=NO;
    }
    else
    {
        //        printf("yes dis");
        NSLog(@"隐藏变换菜单");
        subFunctionViewofFilter.hidden=YES;
    }
    moreFunction.hidden=YES;
}

// 1返回一个使用RGBA通道的位图上下文
static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow = (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
    colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
    //分配足够容纳图片字节数的内存空间
    bitmapData = malloc( bitmapByteCount );
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    CGColorSpaceRelease( colorSpace );
    return context;
}
// 2返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
static unsigned char *RequestImagePixelData(UIImage *inImage)
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    //使用上面的函数创建上下文
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    CGRect rect = {{0,0},{size.width, size.height}};
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    CGContextDrawImage(cgctx, rect, img);
    unsigned char *data = CGBitmapContextGetData (cgctx);
    //释放上面的函数创建的上下文
    CGContextRelease(cgctx);
    return data;
}

//3修改RGB的值
static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f){
    int redV=*red;
    int greenV=*green;
    int blueV=*blue;
    int alphaV=*alpha;
    *red=f[0]*redV+f[1]*greenV+f[2]*blueV+f[3]*alphaV+f[4];
    *green=f[0+5]*redV+f[1+5]*greenV+f[2+5]*blueV+f[3+5]*alphaV+f[4+5];
    *blue=f[0+5*2]*redV+f[1+5*2]*greenV+f[2+5*2]*blueV+f[3+5*2]*alphaV+f[4+5*2];
    *alpha=f[0+5*3]*redV+f[1+5*3]*greenV+f[2+5*3]*blueV+f[3+5*3]*alphaV+f[4+5*3];
    if (*red>255) {
        *red=255;
    }
    if(*red<0){
        *red=0;
    }
    if (*green>255) {
        *green=255;
    }
    if (*green<0) {
        *green=0;
    }
    if (*blue>255) {
        *blue=255;
    }
    if (*blue<0) {
        *blue=0;
    }
    if (*alpha>255) {
        *alpha=255;
    }
    if (*alpha<0) {
        *alpha=0;
    }
}

+ (UIImage*)processImage:(UIImage*)inImage withColorMatrix:(const float*) f
{
    unsigned char *imgPixel = RequestImagePixelData(inImage);
    CGImageRef inImageRef = [inImage CGImage];
    GLuint w = CGImageGetWidth(inImageRef);
    GLuint h = CGImageGetHeight(inImageRef);
    int wOff = 0;
    int pixOff = 0;
    //双层循环按照长宽的像素个数迭代每个像素点
    for(GLuint y = 0;y< h;y++)
    {
        pixOff = wOff;
        
        for (GLuint x = 0; x<w; x++)
        {
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            int alpha=(unsigned char)imgPixel[pixOff+3];
            
            changeRGBA(&red, &green, &blue, &alpha, f);
            //回写数据
            imgPixel[pixOff] = red;
            imgPixel[pixOff+1] = green;
            imgPixel[pixOff+2] = blue;
            imgPixel[pixOff+3] = alpha;
            
            //将数组的索引指向下四个元素
            pixOff += 4;
        }
        wOff += w * 4;
    }
    
    NSInteger dataLength = w*h* 4;
    //下面的代码创建要输出的图像的相关参数
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    //创建要输出的图像
    CGImageRef imageRef = CGImageCreate(w, h,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider,
                                        NULL, NO, renderingIntent);
    
    UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return my_Image;
}
//-----------颜色处理-----
//lomo
const float colormatrix_lomo[] = {
    1.7f,  0.1f, 0.1f, 0, -73.1f,
    0,  1.7f, 0.1f, 0, -73.1f,
    0,  0.1f, 1.6f, 0, -73.1f,
    0,  0, 0, 1.0f, 0 };

//黑白
const float colormatrix_heibai[] = {
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0,  0, 0, 1.0f, 0 };
//旧化
const float colormatrix_huajiu[] = {
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0.2f, 0.5f, 0.1f, 0, 40.8f,
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0, 0, 0, 1, 0 };

//哥特
const float colormatrix_gete[] = {
    1.9f,-0.3f, -0.2f, 0,-87.0f,
    -0.2f, 1.7f, -0.1f, 0, -87.0f,
    -0.1f,-0.6f, 2.0f, 0, -87.0f,
    0, 0, 0, 1.0f, 0 };

//锐色
const float colormatrix_ruise[] = {
    4.8f,-1.0f, -0.1f, 0,-388.4f,
    -0.5f,4.4f, -0.1f, 0,-388.4f,
    -0.5f,-1.0f, 5.2f, 0,-388.4f,
    0, 0, 0, 1.0f, 0 };


//淡雅
const float colormatrix_danya[] = {
    0.6f,0.3f, 0.1f, 0,73.3f,
    0.2f,0.7f, 0.1f, 0,73.3f,
    0.2f,0.3f, 0.4f, 0,73.3f,
    0, 0, 0, 1.0f, 0 };

//酒红
const float colormatrix_jiuhong[] = {
    1.2f,0.0f, 0.0f, 0.0f,0.0f,
    0.0f,0.9f, 0.0f, 0.0f,0.0f,
    0.0f,0.0f, 0.8f, 0.0f,0.0f,
    0, 0, 0, 1.0f, 0 };

//清宁
const float colormatrix_qingning[] = {
    0.9f, 0, 0, 0, 0,
    0, 1.1f,0, 0, 0,
    0, 0, 0.9f, 0, 0,
    0, 0, 0, 1.0f, 0 };

//浪漫
const float colormatrix_langman[] = {
    0.9f, 0, 0, 0, 63.0f,
    0, 0.9f,0, 0, 63.0f,
    0, 0, 0.9f, 0, 63.0f,
    0, 0, 0, 1.0f, 0 };

//光晕
const float colormatrix_guangyun[] = {
    0.9f, 0, 0,  0, 64.9f,
    0, 0.9f,0,  0, 64.9f,
    0, 0, 0.9f,  0, 64.9f,
    0, 0, 0, 1.0f, 0 };

//蓝调
const float colormatrix_landiao[] = {
    2.1f, -1.4f, 0.6f, 0.0f, -31.0f,
    -0.3f, 2.0f, -0.3f, 0.0f, -31.0f,
    -1.1f, -0.2f, 2.6f, 0.0f, -31.0f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

//梦幻
const float colormatrix_menghuan[] = {
    0.8f, 0.3f, 0.1f, 0.0f, 46.5f,
    0.1f, 0.9f, 0.0f, 0.0f, 46.5f,
    0.1f, 0.3f, 0.7f, 0.0f, 46.5f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

//夜色
const float colormatrix_yese[] = {
    1.0f, 0.0f, 0.0f, 0.0f, -66.6f,
    0.0f, 1.1f, 0.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 1.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

-(void)clickFilter1:(id)sender
{
//    NSLog(@"滤镜LOMO");
//    {
//        MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
//        indicatorView.numberOfCircles = 7;
//        indicatorView.radius = 6;
//        indicatorView.internalSpacing = 3;
//        indicatorView.duration = 0.5;
//        indicatorView.delay = 0.5;
//        indicatorView.center = self.center;
//        // [self activityIndicatorView:indicatorView
//        //circleBackgroundColorAtIndex:2];
//        [indicatorView startAnimating];
//        [self addSubview:indicatorView];
//        [NSTimer scheduledTimerWithTimeInterval:5 target:indicatorView selector:@selector(stopAnimating) userInfo:nil repeats:NO];
//    }//转针启动5秒
    
//    UIImage * img = [UIImage imageWithCGImage:currentImageView.image.CGImage];
//    [currentImageView setImage:img];
    UIImage *img = [ModifyImageView processImage:originalImage withColorMatrix:colormatrix_lomo];
//    NSLog(@"%@",img);
    currentImageView.image = img;
    [currentImageView startAnimating];
}
-(void)clickFilter2:(id)sender
{
//    NSLog(@"滤镜黑白");
//    {
//        MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
//        indicatorView.numberOfCircles = 7;
//        indicatorView.radius = 6;
//        indicatorView.internalSpacing = 3;
//        indicatorView.duration = 0.5;
//        indicatorView.delay = 0.5;
//        indicatorView.center = self.center;
//        // [self activityIndicatorView:indicatorView
//        //circleBackgroundColorAtIndex:2];
//        [indicatorView startAnimating];
//        [self addSubview:indicatorView];
//        [NSTimer scheduledTimerWithTimeInterval:5 target:indicatorView selector:@selector(stopAnimating) userInfo:nil repeats:NO];
//    }//转针启动5秒
//    UIImage * img = [UIImage imageWithCGImage:currentImageView.image.CGImage];
//    [currentImageView setImage:img];
    UIImage *img=[ModifyImageView processImage:originalImage withColorMatrix:colormatrix_heibai];
    NSLog(@"%@",img);
    currentImageView.image = img;
    [currentImageView startAnimating];
    
    
}
-(void)clickFilter3:(id)sender
{
//    NSLog(@"滤镜怀旧");
//    {
//        MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
//        indicatorView.numberOfCircles = 7;
//        indicatorView.radius = 6;
//        indicatorView.internalSpacing = 3;
//        indicatorView.duration = 0.5;
//        indicatorView.delay = 0.5;
//        indicatorView.center = self.center;
//        // [self activityIndicatorView:indicatorView
//        // circleBackgroundColorAtIndex:2];
//        [indicatorView startAnimating];
//        [self addSubview:indicatorView];
//        [NSTimer scheduledTimerWithTimeInterval:5 target:indicatorView selector:@selector(stopAnimating) userInfo:nil repeats:NO];
//    }//转针启动5秒
//    UIImage * img = [UIImage imageWithCGImage:currentImageView.image.CGImage];
//    [currentImageView setImage:img];
    UIImage *img=[ModifyImageView processImage:originalImage withColorMatrix:colormatrix_huajiu];
    NSLog(@"%@",img);
    currentImageView.image = img;
    [currentImageView startAnimating];
}
-(void)clickFilter4:(id)sender
{
    
//    NSLog(@"滤镜淡雅");
//    {
//        MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
//        indicatorView.numberOfCircles = 7;
//        indicatorView.radius = 6;
//        indicatorView.internalSpacing = 3;
//        indicatorView.duration = 0.5;
//        indicatorView.delay = 0.5;
//        indicatorView.center = self.center;
//        //   [self activityIndicatorView:indicatorView circleBackgroundColorAtIndex:7];
//        // - (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
//        //circleBackgroundColorAtIndex:(NSUInteger)index
//        [indicatorView startAnimating];
//        [self addSubview:indicatorView];
//        [NSTimer scheduledTimerWithTimeInterval:5 target:indicatorView selector:@selector(stopAnimating) userInfo:nil repeats:NO];
//    }//转针启动5秒
//    
//    UIImage * img = [UIImage imageWithCGImage:currentImageView.image.CGImage];
//    [currentImageView setImage:img];
    UIImage *img=[ModifyImageView processImage:originalImage withColorMatrix:colormatrix_danya];
    NSLog(@"%@",img);
    currentImageView.image = img;
    [currentImageView startAnimating];
}

-(void)clickFilter5:(id)sender
{
    
//    NSLog(@"滤镜锐色");
//    {
//        MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
//        indicatorView.numberOfCircles = 7;
//        indicatorView.radius = 6;
//        indicatorView.internalSpacing = 3;
//        indicatorView.duration = 0.5;
//        indicatorView.delay = 0.5;
//        indicatorView.center = self.center;
//        //  [self activityIndicatorView:indicatorView
//        //  circleBackgroundColorAtIndex:2];
//        [indicatorView startAnimating];
//        [self addSubview:indicatorView];
//        [NSTimer scheduledTimerWithTimeInterval:5 target:indicatorView selector:@selector(stopAnimating) userInfo:nil repeats:NO];
//    }//转针启动5秒
//    
//    UIImage * img = [UIImage imageWithCGImage:currentImageView.image.CGImage];
//    [currentImageView setImage:img];
    UIImage *img=[ModifyImageView processImage:originalImage withColorMatrix:colormatrix_ruise];
    NSLog(@"%@",img);
    currentImageView.image = img;
    [currentImageView startAnimating];
}


-(void)clickFilter6:(id)sender
{
    
//    NSLog(@"滤镜哥特");
//    {
//        MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
//        indicatorView.numberOfCircles = 7;
//        indicatorView.radius = 6;
//        indicatorView.internalSpacing = 3;
//        indicatorView.duration = 0.5;
//        indicatorView.delay = 0.5;
//        indicatorView.center = self.center;
//        //    [self activityIndicatorView:indicatorView
//        //  circleBackgroundColorAtIndex:2];
//        [indicatorView startAnimating];
//        [self addSubview:indicatorView];
//        [NSTimer scheduledTimerWithTimeInterval:5 target:indicatorView selector:@selector(stopAnimating) userInfo:nil repeats:NO];
//    }//转针启动5秒
//    
//    UIImage * img = [UIImage imageWithCGImage:currentImageView.image.CGImage];
//    [currentImageView setImage:img];
    UIImage *img=[ModifyImageView processImage:originalImage withColorMatrix:colormatrix_gete];
    NSLog(@"%@",img);
    currentImageView.image = img;
    [currentImageView startAnimating];
}


-(void)clickFilter7:(id)sender
{
//    NSLog(@"滤镜哥特");
//    {
//        MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
//        indicatorView.numberOfCircles = 7;
//        indicatorView.radius = 6;
//        indicatorView.internalSpacing = 3;
//        indicatorView.duration = 0.5;
//        indicatorView.delay = 0.5;
//        indicatorView.center = self.center;
//        //  [self activityIndicatorView:indicatorView
//        // circleBackgroundColorAtIndex:2];
//        [indicatorView startAnimating];
//        [self addSubview:indicatorView];
//        [NSTimer scheduledTimerWithTimeInterval:5 target:indicatorView selector:@selector(stopAnimating) userInfo:nil repeats:NO];
//    }//转针启动5秒
//    
//    UIImage * img = [UIImage imageWithCGImage:currentImageView.image.CGImage];
//    [currentImageView setImage:img];
    UIImage *img=[ModifyImageView processImage:originalImage withColorMatrix:colormatrix_yese];
    NSLog(@"%@",img);
    currentImageView.image = img;
    [currentImageView startAnimating];
}
//wind:----------------------------------滤镜添加----------------------------------------2014.6.20 end




/**
 *  左旋按钮触发，向左选择90度
 *
 *  @param sender
 */
-(void)clickRotateLeft:(id)sender
{
    NSLog(@"左旋");
    
    float h_img = currentImageView.frame.size.height;
    CGPoint  center = currentImageView.center;
    CGAffineTransform newTrangsform;
    switch (currentImageView.tag)
    {
        case 0:
            newTrangsform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*1.5),320/h_img, 320/h_img);
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:3];
            break;
        case 3:
            newTrangsform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*1), 1, 1);
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:2];
            break;
        case 2:
            newTrangsform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*0.5), 320/h_img, 320/h_img);
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:1];
            break;
        case 1:
            newTrangsform = CGAffineTransformIdentity;
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:0];
            break;
        default:
            break;
    }
    
    
    [textEditView setFrame:CGRectMake(currentImageView.frame.origin.x, currentImageView.frame.origin.y, currentImageView.frame.size.width, currentImageView.frame.size.height)];
    
    textEditView.center=center;
    currentImageView.center=center;
}

/**
 *  右旋按钮触发，向右选择90度
 *
 *  @param sender
 */
-(void)clickRotateRight:(id)sender
{
    NSLog(@"右旋");

    CGPoint  center = currentImageView.center;
    CGAffineTransform newTrangsform;
    float h_img=currentImageView.frame.size.height;
    
    switch (currentImageView.tag)
    {
        case 0:
            newTrangsform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*0.5), 320/h_img, 320/h_img);//高，宽
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:1];
            break;
        case 1:
            newTrangsform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*1), 1, 1);
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:2];
            break;
        case 2:
            newTrangsform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*1.5), 320/h_img,320/h_img);
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:3];
            break;
        case 3:
            newTrangsform = CGAffineTransformIdentity;
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:0];
            break;
        default:
            break;
    }
    
    [textEditView setFrame:CGRectMake(currentImageView.frame.origin.x, currentImageView.frame.origin.y, currentImageView.frame.size.width, currentImageView.frame.size.height)];
    textEditView.center=center;
    currentImageView.center=center;
}

/**
 *  垂直翻转按钮触发，上下翻转
 *
 *  @param sender
 */
-(void)clickTurnToL:(id)sender
{
    NSLog(@"垂直翻转");
    CGPoint  center = currentImageView.center;
    int flag = currentImageView.tag;
    UIImageOrientation  imageOrientation = UIImageOrientationDownMirrored;
    switch (flag)
    {
        case 0://竖着
        case 2:
            imageOrientation=UIImageOrientationDownMirrored;
            break;
        case 1:
        case 3://横着
            imageOrientation=UIImageOrientationUpMirrored;
            
            break;
        default:
            break;
    }
    if (!state_V)
    {
        UIImage * img = [UIImage imageWithCGImage:currentImageView.image.CGImage scale:1 orientation:imageOrientation];
        [currentImageView setImage:img];
   
        
        state_V=YES;
    }
    else
    {
        UIImage * img = [UIImage imageWithCGImage:currentImageView.image.CGImage scale:1 orientation:UIImageOrientationUp];
        [currentImageView setImage:img];
        state_V=NO;
        
    }
    
    currentImageView.center=center;
}

/**
 *  水平翻转按钮触发，左右翻转
 *
 *  @param sender
 */
-(void)clickTurnToR:(id)sender
{
    NSLog(@"水平翻转");
    CGPoint center = currentImageView.center;
    int flag = currentImageView.tag;
    UIImageOrientation  imageOrientation = UIImageOrientationUpMirrored;
    switch (flag)
    {
        case 0://竖着
        case 2:
            imageOrientation = UIImageOrientationUpMirrored;
            break;
        case 1:
        case 3://横着
            imageOrientation = UIImageOrientationDownMirrored;
            break;
        default:
            break;
    }
    
    if (!state_H)
    {
        UIImage * img = [UIImage imageWithCGImage:currentImageView.image.CGImage scale:1 orientation:imageOrientation];//UIImageOrientationUpMirrored
        [currentImageView setImage:img];
        state_H = YES;
    }
    else
    {
        UIImage * img = [UIImage imageWithCGImage:currentImageView.image.CGImage scale:1 orientation:UIImageOrientationUp];//UIImageOrientationUp
        [currentImageView setImage:img];
        state_H = NO;
        
    }
    
    currentImageView.center=center;
//    printf("水平");
}

/**
 *  更新当前的图片
 *
 *  @param img
 */
-(void)UpdateCurrentImage:(UIImage*)img
{
    float img_w = img.size.width;
    float img_h = img.size.height;
    img_h = img_h*_width/img_w;//转换
    NSLog(@"高度:%f,宽度;%d",img_h,_width);
    if (_width>img_h)
    {
         [currentImageView setFrame:CGRectMake(0, y_imgView, _width, img_h)];
    }
    else
    {
         [currentImageView setFrame:CGRectMake(0, 0, _width, img_h)];

    }
    if(IS_IPHONE_5)
    {
        [currentImageView setCenter:CGPointMake(160, 284)];
    }
    else
    {
        [currentImageView setCenter:CGPointMake(160, 240)];
    }
    [currentImageView setImage:img];

}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return  NO;
}

@end
