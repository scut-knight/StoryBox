//
//  SBDoodleView.h
//  StoryBox
//
//  Created by spacewander on 14-6-22.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPen.h"

/**
 *  Doodle时在这个上面作画
 */
@interface SBDoodleView : UIImageView
{
    // 父视图的四角
    CGFloat x0;
    CGFloat x1;
    CGFloat y0;
    CGFloat y1;
}

-(void) initialize;
-(void) drawLineNew;
-(void) eraseLine;
-(void) handleTouches;

@property (nonatomic, assign) CGPoint previousPoint;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) PEN_STATE drawMode;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, assign) unsigned int weight;

@end
