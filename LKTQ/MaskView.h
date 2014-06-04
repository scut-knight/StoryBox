//
//  maskView.h
//  故事盒子
//
//  Created by caijunbin on 14-1-8.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskView : UIView
{
    float width,height,orgin_x,orgin_y;
}
-(void)setDrawFrame:(CGRect)drawFrame;
@end
