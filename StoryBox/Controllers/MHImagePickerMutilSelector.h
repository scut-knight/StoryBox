//
//  MHMutilImagePickerViewController.h
//  doujiazi
//
//  Created by Shine.Yuan on 12-8-7.
//  Copyright (c) 2012年 mooho.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  协议，用于获取多选图片的数组
 */
@protocol MHImagePickerMutilSelectorDelegate <NSObject>

-(void)imagePickerMutilSelectorDidGetImages:(NSArray*)imageArray;

@end

/**
 *  从相册中选取多张图片.
 *
 *  实现成一个singleton
 */
@interface MHImagePickerMutilSelector : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView * selectedPan;
    UILabel * textlabel;
    UIImagePickerController * imagePicker;
    NSMutableArray * pics;
    UITableView * tbv;
    id<MHImagePickerMutilSelectorDelegate>  delegate;
    
    UIButton * btn_done;//add
}

@property (nonatomic,retain)UIImagePickerController * imagePicker;
@property(nonatomic,retain)id<MHImagePickerMutilSelectorDelegate> delegate;
@property(nonatomic,retain)UIView * selectedPan;

+(void)showInViewController:(UIViewController<UIImagePickerControllerDelegate,MHImagePickerMutilSelectorDelegate> *)vc  withArr:(NSArray*)arry;

@end
