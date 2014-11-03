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
#import "SBViewerView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize imgViewC;
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
 *  点击我的故事按钮触发
 点击浏览现有故事
 *
 */
//- (IBAction)clickViewPhotoAlbum:(id)sender {
//    NSLog(@"wind call");
//    UIButton* btn1 = (UIButton*)sender;
//    if ([btn1 isKindOfClass:[UIButton class]])
//    {
//        picker_library_ = [[UIImagePickerController alloc] init];
//        picker_library_.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        picker_library_.allowsEditing = NO;
//        picker_library_.delegate = self;
//        
//        [self jumpToImageViewC];
//    }
//}

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

-(void)jumpToImageViewC
{
    NSLog(@"跳转页面浏览故事");
    //    self.imgViewC = [[SBViewController alloc] initWithNibName:@"SBViewController" bundle:nil];
    //      [self presentModalViewController:imgViewC animated:YES];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
    //    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    //    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    imagePicker.showsCameraControls = NO;
    
    //    SBViewerView *view = [[SBViewerView alloc] init];
    //    [self.view addSubview:view];
    //    [self.view bringSubviewToFront:view];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"PICK");
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSLog(@"bin:%@",imageURL);
    
    SBViewerView *view = [[SBViewerView alloc] initWithImage:image withImageURL:imageURL];
    [self.view addSubview:view];
    
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
