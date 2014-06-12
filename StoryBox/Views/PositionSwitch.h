//
//  PositionSwitch.h
//  故事盒子
//
//  Created by mac on 14-1-10.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionSwitch : NSObject
{
    NSString * typeDevice;
}
-(int)indexDevice;
-(CGRect)switchRect:(CGRect)rect;
-(CGPoint)switchPoint:(CGPoint)point;
-(CGRect)switchBound:(CGRect)point;
@end
