//
//  SBDoodleViewController.h
//  StoryBox
//
//  Created by spacewander on 14-6-20.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBPen;
@class SBDoodleView;

/**
 *  定制的scrollView，支持涂鸦
 */
@interface SBScrollView : UIScrollView

- (void) startToDraw:(SBPen *)pen;
- (void) startToErase:(SBPen *)pen;
- (void) waitForNext;
- (void) makeDoodlePossible;
- (void) updatePenWeight:(unsigned int)weight;
- (void) moveDoodleViewAbove;
- (SBDoodleView *) saveDoodleView;
- (void) recordDoodleView;
- (void) addSubview:(UIView *)view;
- (void) setDoodle:(BOOL)isDoodling;

@property (nonatomic, assign) NSUInteger doodleViewNum; /// 视图个数 + 涂鸦视图，记得从0开始
@property (nonatomic, assign) BOOL isDoodling; /// 表示是否处于涂鸦中，在涂鸦中屏蔽特定的触屏事件

@end
