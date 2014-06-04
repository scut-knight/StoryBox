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

@class ExtraLayerView;
//@protocol ParentExtralayer <NSObject>
//
//-(void)enableGesture:(BOOL)b;
//@end



@interface ModifyImageView : UIView<UpdateCurrentImageDelegate,UITextFieldDelegate,HiddenTopViewDelegate >
{
    UIImageView * currentImageView;
    UIView * _textV;
    UIScrollView *_sc;
    NSMutableArray * imageViewArr;
    NSMutableArray* textViewArr;
    UIView * imageBarView;
    PositionSwitch *positionSwich;
    CGAffineTransform imageTrangsform;
    
    UIView * moreFunction;
    UIView *NavigationView;
    UIView * subFunctionView;
    UITextLable * textEditView;
    BOOL state_V;//记录镜像垂直状态
    BOOL state_H;//记录镜像水平状态
    int imageIndex;
    CGImageRef imageCG;
    
}

@property(retain,nonatomic) id<HiddenTopViewDelegate>delegate;

-(id)initWithImageView:(UIImageView*)imgV withTextView:(UIView*)textV withIndex:(int)index   withScrollView:(UIScrollView *)sc withTextArray:(NSMutableArray*)textArray withImageArray:(NSMutableArray*)imageArray;
@end
