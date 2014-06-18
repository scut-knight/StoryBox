//
//  ExtraLayerView.h
//  LKTQ
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextLable.h"

#import "ClipViewController.h"
#import "PositionSwitch.h"
#import "UITitleLabel.h"
#import "WeatherLabel.h"


@protocol HiddenTopViewDelegate <NSObject>

-(void)hiddenTopView:(BOOL)flag;
-(void)accessPhotoAblum;
-(void)clear;
@end

@interface ExtraLayerView : UIView<UpdateCurrentImageDelegate,UITextFieldDelegate ,GetParentChild,SetParentTitle>
{
    //模板选择栏
    UIView * gemomtryView;
    UIView * subGemomtryView;
    UIImageView * subGemomtryViewBg;
    UIView*  simlarGemomtryView;//同类标签容器
    
    //文字层
    UIView * textEditView;//每一张图片对应一个View
    UITextLable * textLable;
    UITitleLabel * actionTitleView;

    
    UIScrollView * scrollView;//显示currentImageView
    UIScrollView * scviewButton;//显示currentImageView
    
    int flag_model;//默认0模型
    int fla_model_color;//默认0模型模型颜色
    int flag_mid;
    
    int current_index;//当前图片的序号从0开始
    BOOL dire_up;//记录拖动方向
    BOOL overBound;//越界标志
    int empyt_index;//记录空的位置
    PositionSwitch *positionSwich;
    CGPoint  history;           //用于长按下的坐标记录
    float _scale;
    float dis_pan;//sc平移量
    
    NSMutableArray *LableArray;
    NSMutableArray *textEditViewArray;//用于放标签的view数组，一个相片对应一个view，所有该相片上的标签都放在这个view
    NSMutableArray * imageViewArray;//保存ImageView数组
    NSMutableArray * imageArray;//图片数组
    
    
    BOOL stateEdit;//记录标签的编辑状态
    
}
@property(retain,nonatomic) UIView * gemomtryView;
@property(retain,nonatomic) UIView * textEditView;
@property(retain,nonatomic) NSMutableArray *textEditViewArray;;
@property(retain,nonatomic) NSMutableArray * imageViewArray;
@property(retain,nonatomic) UIScrollView * scrollView;      //放置相片的view
@property(retain,nonatomic) id<HiddenTopViewDelegate>delegate;
@property(retain,nonatomic) PositionSwitch *positionSwich;

-(id)initWithFrame:(CGRect)frame withImageArray:(NSMutableArray*)arr;
-(void)initTextEditView;//更新文字编辑图层
 
-(void)tapHandle:(UIGestureRecognizer *)tapD;
-(void)initImageArray:(NSMutableArray*)arr;//初始化图片数组
-(float)getScrollviewOffset;
-(void)setCurrentTitleView:(UITitleLabel *)titleView;
-(void)clearView;

//取消所有titleview的选中状态
-(BOOL)resetTitleviewState;
//拼图分享后返回把标题移动到scrollview层
-(void)moveTitleViewToScrollView;
 
@end
