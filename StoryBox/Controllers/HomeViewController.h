//
//  HomeViewController.h
//  LKTQ
//
//  Created by mac on 13-12-2.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePickupViewController.h"

#import "QBAssetCollectionViewController.h"
#import "MHImagePickerMutilSelector.h"

/**
 *  初始界面控制器，点击开始制作按钮
 *  在这一页面，要求隐藏状态栏（电池栏）
 *  实现MHImagePickerMutilSelectorDelegate协议
 */
@interface HomeViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,QBImagePickerControllerDelegate,AccessHomeDelegate,MHImagePickerMutilSelectorDelegate>
{
    ImagePickupViewController * imagePkViewC;
    ImagePickupViewController *imgViewC;
    UIActionSheet *sheet;
//    NSMutableArray * imageA;//图片数组
    NSArray * imageA;//图片数组
    UIImagePickerController* picker_library_;
    
    BOOL show;
    BOOL isadd;

}

@property(retain,nonatomic)IBOutlet UIImageView *homeBgV;
@property(retain,nonatomic)IBOutlet UIButton *startBtn;
@property(retain,nonatomic)ImagePickupViewController * imagePkViewC;
@property(retain,nonatomic) ImagePickupViewController *imgViewC;

-(IBAction)clickPhotoPickup:(id)sender;//相册
-(IBAction)clickset:(id)sender;
-(void)imagePickerMutilSelectorDidGetImages:(NSArray*)imageArray;
- (IBAction)clickViewPhotoAlbum:(id)sender;
@end
