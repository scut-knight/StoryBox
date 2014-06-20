//
//  SBPen.h
//  StoryBox
//
//  Created by spacewander on 14-6-16.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBDoodleView;

/**
 *  画笔面板的状态。1. 涂鸦中 2. 选择画笔 3. 选择橡皮擦
 */
typedef enum : NSUInteger {
    DOODLING,
    PEN,
    ERASER,
} PEN_STATE;

/**
 *  用于涂鸦的画笔
 */
@interface SBPen : NSObject

- (void) transformToEraser;
- (void) transformToPen;
- (void) waitForNextState;

@property (nonatomic) int color;
@property (nonatomic) unsigned int precolor;
@property (nonatomic) unsigned int radius;
@property (nonatomic) unsigned int preradius;
@property (nonatomic) SBDoodleView * board;
@end
