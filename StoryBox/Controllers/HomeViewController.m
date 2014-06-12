//
//  HomeViewController.m
//  LKTQ
//
//  Created by mac on 13-12-2.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import "HomeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "MHImagePickerMutilSelector.h"
#import <SinaWeiboConnection/SinaWeiboConnection.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize picker;
@synthesize imagePkViewC;
@synthesize startBtn,homeBgV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        show = NO;
        isadd = NO;
        [self barControl];          //第一次运行，隐藏状态栏
    }
    return self;
}


-(void)barControl
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        // iOS 7
        [self prefersStatusBarHidden];
        //刷新状态栏样式
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

/**
 *  重载prefersStatusBarHidden
 */
- (BOOL)prefersStatusBarHidden
{
//    printf("父控制执行");
//    if (!show)
//    {
////        printf("1");
//        NSLog(@"隐藏状态栏\n");
//
//        show = YES;
//    }
//    else
//    {
////        printf("2");
//        NSLog(@"显示状态栏\n");
//        show = NO;
//    }
//    return show;
    return YES;                 //隐藏为YES，显示为NO
}

/**
 *  点击开始制作按钮触发
    调用MHImagePickerMutilSelector来选取多张图片，并保存到
 *
 */
-(IBAction)clickPhotoPickup:(id)sender//相册
{
//    //方法一
//    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//
//    imagePickerController.limitsMaximumNumberOfSelection=YES;
//    imagePickerController.maximumNumberOfSelection= 12;  //设置限制的张数
//
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
//    [self presentViewController:navigationController animated:YES completion:NULL];
//    [imagePickerController release];
//    [navigationController release];
    
    //方法二
    UIButton* btn = (UIButton*)sender;
    if ([btn isKindOfClass:[UIButton class]])
    {
        NSArray* arr = nil;
        [MHImagePickerMutilSelector showInViewController:self withArr:arr];
    }
    else
    {
        NSArray* arr = (NSArray*)sender;
        [MHImagePickerMutilSelector showInViewController:self withArr:arr];
    }
    
}

/**
 *  委托。图片选取完毕后执行，用于获取多选图片的数组
 *  @param imageArray MHImagePickerMutilSelector传来的图片数组
 */
-(void)imagePickerMutilSelectorDidGetImages:(NSArray*)imageArray
{
//    printf("do");
    imageA = imageArray;                //将imageA指向返回的数组
    [self jumpToImagePkVC:imageA];      //执行页面跳转

}

/**
 *  跳转到ImagePickupView（长图编辑）页面
 *
 *  @param array 用户选取的图片数组指针
 */
-(void)jumpToImagePkVC:(NSArray*)array
{
    NSLog(@"跳转页面");
    NSArray * array_temp;
    array_temp = array;
    NSLog(@"选中图片数目:%d",array_temp.count);
    
    self.imagePkViewC = [[ImagePickupViewController alloc] initWithNibName:@"ImagePickupView" bundle:nil];    //实例化ImagePickupViewController
    [imagePkViewC updateImageArray:array_temp];
    //设置代理
    imagePkViewC.delegate = self;
    [self.view addSubview:imagePkViewC.view];   //把imagePkViewC作为当前视图的子视图（遮盖）
    
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    if (!IS_IPHONE_5) {
//          PositionSwitch * positon= [[PositionSwitch  alloc] init];
////            if ([positon indexDevice]==3) {//iphone4
//                [homeBgV setImage:[UIImage imageNamed:@"homeBg1.png"]];
//                [startBtn setFrame:CGRectMake(startBtn.frame.origin.x,393, startBtn.frame.size.width, startBtn.frame.size.height)];
// 
////            }
//    
//    }
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
