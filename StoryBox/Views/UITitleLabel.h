//
//  UITextField.h
//  LKTQ
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  UITitleLabel;

@protocol SetParentTitle <NSObject>
-(void)setCurrentTitleView:(UITitleLabel *)titleView;
-(void)deleteCurrentTitleView:(UITitleLabel*)titleView;
@end

/**
 *  大标签类
 */
@interface UITitleLabel: UIView<UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    UIImageView * imageViewBg;
 
    UIView * maskTouch;
    BOOL used;
    
    int index_colorLable;
    
    NSMutableArray * textVArray;
    UIScrollView * scView;//父视图
    
    UIButton * contorlBtn;
    UIButton * deleteBTn;
    CGPoint tempPoint;
}

@property(retain,nonatomic) UIView * maskTouch;
@property(retain,nonatomic) UIImageView * imageViewBg;
@property(retain,nonatomic) UITextView * _textView;
@property(retain,nonatomic)id<SetParentTitle>delegate;
@property(retain,nonatomic)  UIButton * contorlBtn;
-(id)initWithFrame:(CGRect)frame  initImage:(int)tag withFlagModel:(int)index withTextVArr:(NSMutableArray *)textVA withView:(UIScrollView *)sc;

-(void)startPanHandle;//父视图转换
-(void)endPanHandle;//父视图转换
-(void)showBorder;
-(void)hiddenBorder;
@end
