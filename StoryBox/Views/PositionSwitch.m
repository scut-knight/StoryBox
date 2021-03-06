//
//  PositionSwitch.m
//  故事盒子
//
//  Created by mac on 14-1-10.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import "PositionSwitch.h"
#import "TypeDevice.h"
@implementation PositionSwitch
-(id)init
{
    if (self=[super init])
    {
        typeDevice = [NSString stringWithString:[TypeDevice returnTypeName]];
        NSLog(@"type=%@\n",typeDevice);
    }
    return self;

}

/**
 *  根据typeDevice返回设备代号
 *
 *  @return 设备代号
 */
-(int)indexDevice
{
    if ([typeDevice isEqualToString:@"ipad"])
    {
        return 1;
    }
    else if([typeDevice isEqualToString:@"Type5"])
    {
        return 2;
    }
    else
    {//Type4
        return 3;
    }
}

/**
 *  view的y坐标转换
 *
 *  @param rect
 *
 *  @return 适应设备的rect
 */
-(CGRect)switchRect:(CGRect)rect
{
    printf("变化");
    float _x=rect.origin.x;
    float _y=rect.origin.y;
    float _w=rect.size.width;
    float _h=rect.size.height;
    if ([typeDevice isEqualToString:@"Type5"])
    {
        rect=CGRectMake(_x, _y+88,_w, _h);//88
        
    }
    else if([typeDevice isEqualToString:@"ipad"])
    {
       rect=CGRectMake(_x, _y-20,_w, _h);//53
    }
    return rect;
}

/**
 *  point的坐标转换
 *
 *  @param point 坐标
 *
 *  @return 适应设备的point
 */
-(CGPoint)switchPoint:(CGPoint)point
{
    float _x=point.x;
    float _y=point.y;
    
    if ([typeDevice isEqualToString:@"Type5"])
    {
        point=CGPointMake(_x,_y+88);
    }
    else if([typeDevice isEqualToString:@"ipad"])
    {
        point=CGPointMake(_x,_y+88);
    }
    return point;
}

//view的边界Height调整
/**
 *  view的边界Height调整
 *
 *  @param rect
 *
 *  @return 变换后的rect
 */
-(CGRect)switchBound:(CGRect)rect
{
    printf("变化");
    float _x=rect.origin.x;
    float _y=rect.origin.y;
    float _w=rect.size.width;
    float _h=rect.size.height;
    if ([typeDevice isEqualToString:@"Type5"])
    {
        rect=CGRectMake(_x, _y,_w, _h+88);//88
    }
//    else if([typeDevice isEqualToString:@"ipad"])
//    {
//        rect=CGRectMake(_x, _y, _w, _h+88);
//    }
    return rect;
}

@end
