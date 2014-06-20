//
//  SBDoodleViewController.h
//  StoryBox
//
//  Created by spacewander on 14-6-20.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBPen;
/**
 *  Doodle时在这个上面作画
 */
@interface SBDoodleView : UIView

- (void) startToDraw:(SBPen *)pen;
- (void) startToErase:(SBPen *)pen;
- (void) waitForNext;
@end
