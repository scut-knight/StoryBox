//
//  ModifyImageView.h
//  故事盒子
//
//  Created by mac on 14-3-3.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionSwitch.h"
#import "UITextLable.h"
#import "ImagePickupViewController.h"
#import "MONActivityIndicatorView.h"

@class ExtraLayerView;
@class SBScrollView;
//@protocol ParentExtralayer <NSObject>
//
//-(void)enableGesture:(BOOL)b;
//@end


/**
 *  编辑单张图片的主界面
 *
 *  实现成一个singleton
 */
@interface ModifyImageView : UIView<UpdateCurrentImageDelegate,UITextFieldDelegate,HiddenTopViewDelegate >
{
    UIImageView * currentImageView;
    UIView * _textV;
    SBScrollView * _sc;
    NSMutableArray * imageViewArr;
    NSMutableArray * textViewArr;
    UIView * imageBarView;
    PositionSwitch * positionSwich;
    CGAffineTransform imageTrangsform;
    
    UIView * moreFunction;
    UIView * NavigationView;
    UIView * subFunctionView;
    UIView * subFunctionViewofFilter;   //加入滤镜的选择子功能视图
    UITextLable * textEditView;
    BOOL state_V;           /// 记录镜像垂直状态
    BOOL state_H;           /// 记录镜像水平状态
    int imageIndex;
    CGImageRef imageCG;
    UIImage *originalImage;
    
}

@property(retain,nonatomic) id<HiddenTopViewDelegate>delegate;

-(id)initWithImageView:(UIImageView*)imgV withTextView:(UIView*)textV withIndex:(int)index   withScrollView:(SBScrollView *)sc withTextArray:(NSMutableArray*)textArray withImageArray:(NSMutableArray*)imageArray;

@end
