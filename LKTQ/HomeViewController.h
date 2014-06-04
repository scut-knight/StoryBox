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

@interface HomeViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,QBImagePickerControllerDelegate,AccessHomeDelegate,MHImagePickerMutilSelectorDelegate>
{
    ImagePickupViewController * imagePkViewC;
    UIActionSheet *sheet;
//    NSMutableArray * imageA;//图片数组
     NSArray * imageA;//图片数组
    
    BOOL show;
    BOOL isadd;

}

@property(retain,nonatomic)IBOutlet UIImageView *homeBgV;
@property(retain,nonatomic)IBOutlet UIButton *startBtn;
@property(retain,nonatomic)ImagePickupViewController * imagePkViewC;
@property(retain,nonatomic) UIImagePickerController *picker;
-(IBAction)clickPhotoPickup:(id)sender;//相册
-(IBAction)clickset:(id)sender;
-(void)imagePickerMutilSelectorDidGetImages:(NSArray*)imageArray;

@end
