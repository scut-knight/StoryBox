//
//  ImagePickupViewController.m
//  LKTQ
//
//  Created by mac on 13-12-2.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>

#import "ImagePickupViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "PositionSwitch.h"
#import "UIImage.h"

@implementation ImagePickupViewController

@synthesize imageView;
@synthesize imageArray;
@synthesize extLayerView;
@synthesize delegate;
@synthesize addIS;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        current_index = 0;//默认从0开始
        pS = [[PositionSwitch alloc] init];
        addIS = NO;
    }
    return self;
}

/**
 *  返回到相册选择界面，添加标签，之前选中的图片会初始时存在于选择列表中
 *  bin?: bug:显示当前选中为0张而不是初始张数
 *  @param sender
 */
-(void)clickBack:(id)sender
{
    NSLog(@"切换的选择图片界面");
    addIS=YES;
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提醒" message:@"该操作将会删除当前标签，你确认这样做吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

/**
 *  UIAlertView的委托
 *
 *  @param alertView
 *  @param buttonIndex 用户点击按钮序号
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 1:
        {
            //打开相片选中界面，传当前的imageArray来初始化
            [self.delegate clickPhotoPickup:imageArray];
            [self.view removeFromSuperview];
             break;
        }
        default:
            break;
    }
}

/**
 *  拼图前把标题移动到相应的文字视图层
 */
-(void)moveTitleViewFromScrollViewToTextView
{
//    printf("拼接前开始移动");
    NSLog(@"拼接前开始移动");
    for (int i=extLayerView.scrollView.subviews.count-1;i>=0; --i)
    {
        UITitleLabel *titleTemp=[extLayerView.scrollView.subviews objectAtIndex:i];
        if ([titleTemp isKindOfClass:[UITitleLabel class]] )
        {
            [titleTemp hiddenBorder];
            [titleTemp endPanHandle];//移动到title
        }
    }
    NSLog(@"移动结束");
}

/**
 *  编辑完成后点击保存，实现向分享界面的跳转
 *
 *  @param sender
 */
-(void)clickSave:(id)sender//分享保存跳转下一界面
{
    NSLog(@"binbincall");
    CGRect rect=[pS switchBound:CGRectMake(0, 0, 320, 480)];
    
    [self moveTitleViewFromScrollViewToTextView];//add
    shareView=[[ShareView alloc] initWithFrame:rect withImageVA:extLayerView.imageViewArray withTextEditVA:extLayerView.textEditViewArray];
    shareView.delegate=self;
    [self.view addSubview:shareView];
}


/**
 *  更新选择图片数组
 *
 *  @param arry 传来的新图片数组
 */
-(void)updateImageArray:(NSArray *)arry
{
    imageArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[arry count]; i++)
    {
//          UIImage * img=[[arry objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage * img = [arry objectAtIndex:i];//new
        
        [imageArray addObject:[img compressedImage]];
    }
    NSLog(@"updete,image=%d",imageArray.count);
}

/**
 *  bin?:跟updateImageArray一样？
 *
 *  @param arry_old 旧图片数组
 */
-(void)addUpdateImageArray:(NSArray *)arry_old
{
    imageArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[arry_old count]; i++)
    {
        UIImage * img = [arry_old objectAtIndex:i];
        [imageArray addObject:img];
    }
    NSLog(@"updete,image=%d",imageArray.count);
    
}

/**
 *  在旧图片数组上添加新图片
 *
 *  @param arry 新增图片数组
 *
 *  @return imageArray
 *  bin?:该函数是对属性imageArray进行修改，而imageArray有get函数，为什么要返回imageArray？
 */
-(NSArray*)addImageToImageArray:(NSArray*)arry
{
    for (int i=0; i<[arry count]; i++)
    {
//        UIImage * img=[[arry objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage * img = [arry objectAtIndex:i];//new
        
        [imageArray addObject:img];
    }
    NSLog(@"updete,image=%d",imageArray.count);
    
    return imageArray;
    
}

/**
 *  imageArray的get函数
 *
 *  @return imageArray
 */
-(NSMutableArray * )getImageArray
{
    return self.imageArray;
}

/**
 *  根据flag隐藏标题栏
 *
 *  @param flag
 */
-(void)hiddenTopView:(BOOL)flag
{
    NSLog(@"隐藏标题栏");
    topView.hidden=flag;
}

-(void)accessPhotoAblum
{
    [self.delegate clickPhotoPickup:nil];
    
}
-(void)reloadimageView
{
    [extLayerView initTextEditView];
}

-(void)resetTitleView
{
    [extLayerView moveTitleViewToScrollView];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.imageView setImage:image];
    
    //bin?:目测是标注层，还未细看
    extLayerView=[[ExtraLayerView alloc] initWithFrame:[pS switchBound:CGRectMake(0, 0, 320, 480)] withImageArray:imageArray ];
    extLayerView.delegate=self;
    [self.view addSubview:extLayerView];//附加层
    
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    [self.view addSubview:topView];
    
    imgVBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height)];
    [imgVBg setImage:[UIImage imageNamed:@"topBg_ImagePick.png"]];
    [topView addSubview: imgVBg];
    
    UIButton * backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"backBtn_ImagePick.png"] forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(10,15, 75, 15)];
    //    [backBtn setTitle:@"back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UIButton * nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(270,13, 37, 19)];
    //    [nextBtn setTitle:@"分享" forState:UIControlStateNormal];
    [nextBtn setImage:[UIImage imageNamed:@"shareBtn_ImagePick.png"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickSave:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:nextBtn];
    
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

-(void)clear
{
    [extLayerView removeFromSuperview];
    [shareView removeFromSuperview];
    
    [imageArray removeAllObjects];
    
    [topView removeFromSuperview];
    [imgVBg removeFromSuperview];
    
    [self.view removeFromSuperview];
    
}
-(void)dealloc
{
    NSLog(@"pickupC dealloc");
}
@end
