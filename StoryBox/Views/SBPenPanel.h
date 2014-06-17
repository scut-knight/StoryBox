//
//  SBPenPanel.h
//  StoryBox
//
//  Created by spacewander on 14-6-16.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBPen;

@interface SBPenPanel : UIView

@property (nonatomic) UIView * penRadiusView; /// 画笔半径单选框
@property (nonatomic) UIView * penStatusView; /// 画笔状态，包括是否要变成橡皮擦

-(id) initWithFrame:(CGRect)frame WithBackground:(UIImageView *)view;
-(void) updateStatus:(NSString *)status;
-(void) showPanel:(BOOL)ok;
-(void) setPenDelegate:(SBPen *)pen;

@end
