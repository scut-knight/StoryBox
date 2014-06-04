//
//  maskView.m
//  故事盒子
//
//  Created by caijunbin on 14-1-8.
//  Copyright (c) 2014年 sony. All rights reserved.


#import "MaskView.h"

@implementation MaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        width=0;
        height=0;
        orgin_x=0;
        orgin_y=0;
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)setDrawFrame:(CGRect)drawFrame
{
    width=drawFrame.size.width;
    height=drawFrame.size.height;
    orgin_x=drawFrame.origin.x;
    orgin_y=drawFrame.origin.y;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rectt = CGRectMake(0 ,0, 320, orgin_y);//坐标
    CGRect rectb = CGRectMake(0, orgin_y+height, 320, 568-orgin_y-height);
    CGRect rectl = CGRectMake(0, orgin_y, (320-width)/2, height);
    CGRect rectr = CGRectMake(160+width/2, orgin_y, (320-width)/2, height);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.8);
    CGContextFillRect(context, rectt);
    CGContextFillRect(context, rectb);
    CGContextFillRect(context, rectl);
    CGContextFillRect(context, rectr);
}


@end
