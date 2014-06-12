//
//  ImagePickupViewController.h
//  LKTQ
//
//  Created by mac on 13-12-2.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtraLayerView.h"
#import "QBAssetCollectionViewController.h"
#import "ShareView.h"

/**
 *  故事盒子编辑界面（长图）控制器
 *  实现 AccessHomeDelegate协议(在shareview.h中),用于shareview通过调用对本界面进行操作
 */
@interface ImagePickupViewController :UIViewController<UIGestureRecognizerDelegate,HiddenTopViewDelegate,QBAssetCollectionViewControllerDelegate,AccessHomeDelegate,UIAlertViewDelegate>
{
    UIImage * image;
    ExtraLayerView * extLayerView;          //编辑页
    
    NSMutableArray* imageArray;             //图片数组
    int current_index;                      //当前图片的序号从0开始
    UIView * topView;                       //顶部栏
    UIImageView *imgVBg;
    PositionSwitch *pS;
    ShareView *shareView;
    BOOL addIS;
}

@property(strong,nonatomic) ExtraLayerView * extLayerView;
@property(strong,nonatomic) NSMutableArray* imageArray;
@property(strong,nonatomic) UIImageView *imageView;
@property(strong,nonatomic) id<AccessHomeDelegate>delegate;
@property(assign,nonatomic) BOOL addIS;


-(void)updateImageArray:(NSArray *)arry;
-(void)clickBack:(id)sender;
-(void)clickSave:(id)sender;

-(NSArray*)addImageToImageArray:(NSArray*)arry;
-(void)addUpdateImageArray:(NSArray *)arry_old;
-(NSMutableArray * )getImageArray;
@end
