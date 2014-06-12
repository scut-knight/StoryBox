//
//  ShareView.h
//  LKTQ
//
//  Created by mac on 13-12-27.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ShareSDK/ShareSDK.h>

#import "PositionSwitch.h"

@protocol AccessHomeDelegate <NSObject>
-(void)clickPhotoPickup:(id)sender;
-(void)accessPhotoAblum;            //相册
-(void)resetTitleView;              //移动标题到scrollview
-(void)reloadimageView;
-(void)clear;
@end

/**
 *  分享界面
 */
@interface ShareView : UIView
{
    UIImageView *topView;           
    UIButton * outputBtn;
    
    UIButton * outputAllBtn;
    
    NSMutableArray * imageVArr;
    NSMutableArray * textEditVArr;
    ShareType shareTypeSocial;
    
    UIImageView * bg;
    UIImageView * label;
    
}

@property(nonatomic,strong) id<AccessHomeDelegate> delegate;
@property(nonatomic,strong) NSString * pathImageM;              //合成图路径
@property(nonatomic,strong) UIImage * img_Merged;                //社会化分享容器
@property(nonatomic,strong) UIView  * pannerShareView;           //社会化分享容器
- (id)initWithFrame:(CGRect)frame  withImageVA:(NSMutableArray*)imageVA withTextEditVA:(NSMutableArray *)textEVA;

 
-(void)clickBack:(id)sender;
-(void)clickHome:(id)sender;
@end
