//
//  Animation.h
//  故事盒子
//
//  Created by mac on 14-3-4.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ExtraLayerView.h"
 
/**
 *  实现缩略动画和次序调整。拓展了ExtraLayerView类
 */
@interface ExtraLayerView (CustomAnimation)

-(void)scaleToSmall:(float )dis;

-(void)adjustALLwith_x:(float)d_x with_y:(float)d_y;

-(void)scaleToOrdinal:(float)dis;


@end
