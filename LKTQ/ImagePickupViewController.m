//
//  ImagePickupViewController.m
//  LKTQ
//
//  Created by mac on 13-12-2.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import "ImagePickupViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <ShareSDK/ShareSDK.h>
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
    if (self) {
        // Custom initialization
        current_index=0;//默认从0开始
        pS=[[PositionSwitch alloc] init];
        addIS=NO;
    }
    return self;
}

//返回相册添加
-(void)clickBack:(id)sender
{
    printf("addpic");
    addIS=YES;
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提醒" message:@"该操作将会删除当前标签，你确认这样做吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            [self.delegate clickPhotoPickup:imageArray];
            [self.view retain];
            [self.view removeFromSuperview];
             break;
        }
        default:
            break;
    }
}
//拼图前把标题移动到相应的文字视图层
-(void)moveTitleViewFromScrollViewToTextView
{
    printf("拼接前开始移动");
    for (int i=extLayerView.scrollView.subviews.count-1;i>=0; --i) {
        UITitleLabel *titleTemp=[extLayerView.scrollView.subviews objectAtIndex:i];
        if ([titleTemp isKindOfClass:[UITitleLabel class]] ) {
            [titleTemp hiddenBorder];
            [titleTemp endPanHandle];//移动到title
        }
    }
    printf("结束");
}


-(void)clickSave:(id)sender//分享保存跳转下一界面
{
    CGRect rect=[pS switchBound:CGRectMake(0, 0, 320, 480)];
    
    [self moveTitleViewFromScrollViewToTextView];//add
    shareView=[[ShareView alloc] initWithFrame:rect withImageVA:extLayerView.imageViewArray withTextEditVA:extLayerView.textEditViewArray];
    shareView.delegate=self;
    [self.view addSubview:shareView];
    [shareView release];
}
-(void)updateImageArray:(NSArray *)arry
{
    imageArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[arry count]; i++) {
//          UIImage * img=[[arry objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage * img=[arry objectAtIndex:i];//new
        
        [imageArray addObject:[img compressedImage]];
    }
    NSLog(@"updete,image=%d",imageArray.count);
 
    
}
-(void)addUpdateImageArray:(NSArray *)arry_old
{
    imageArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[arry_old count]; i++) {
        UIImage * img=[arry_old objectAtIndex:i];
        [imageArray addObject:img];
    }
    NSLog(@"updete,image=%d",imageArray.count);
    
}

-(NSArray*)addImageToImageArray:(NSArray*)arry
{
    for (int i=0; i<[arry count]; i++) {
//        UIImage * img=[[arry objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage * img=[arry objectAtIndex:i];//new
        
        [imageArray addObject:img];
    }
    NSLog(@"updete,image=%d",imageArray.count);
    
    return  imageArray;
    
}
-(NSMutableArray * )getImageArray
{
    return self.imageArray;
}

-(void)hiddenTopView:(BOOL)flag
{
    printf("隐藏标题栏");
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
    
    extLayerView=[[ExtraLayerView alloc] initWithFrame:[pS switchBound:CGRectMake(0, 0, 320, 480)] withImageArray:imageArray ];
    extLayerView.delegate=self;
    [self.view addSubview:extLayerView];//附加层
    [extLayerView release];
    
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    [self.view addSubview:topView];
    [topView release];
    
    imgVBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height)];
    [imgVBg setImage:[UIImage imageNamed:@"topBg_ImagePick.png"]];
    [topView addSubview: imgVBg];
    [imgVBg release];
    
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
    [imageArray release];
    
    [topView removeFromSuperview];
    [imgVBg removeFromSuperview];
    
    [pS release];
    [self.view removeFromSuperview];
    
}
-(void)dealloc
{
    printf("pickupC dealloc");
    [super dealloc];
}
@end
