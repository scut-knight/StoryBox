//
//  SelectTitleView.h
//  故事盒子
//
//  Created by caijunbin on 14-3-17.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextLable.h"
#import "ImagePickupViewController.h"
@interface SelectTitleView : UIView<HiddenTopViewDelegate>
{
    UIScrollView *selectView;
    UIScrollView *_sc;
    UIView *NavigationView;
    UIView * imageBarView;
    PositionSwitch *positionSwich;
    NSMutableArray *textEditViewArray;//保存标注编辑层view数组
    UIImageView *selectedSignal;  //选择叠加层

}
@property(retain,nonatomic) UIScrollView * selectView;
@property(retain,nonatomic) id<HiddenTopViewDelegate>delegate;
@property(retain,nonatomic) PositionSwitch *positionSwich;

-(id)initWithScrollView:(UIScrollView *) scrollView withTextArr:(NSMutableArray *)arr;
@end
