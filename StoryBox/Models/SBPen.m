//
//  SBPen.m
//  StoryBox
//
//  Created by spacewander on 14-6-16.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import "SBPen.h"

@implementation SBPen

-(id) init
{
    self = [super init];
    if (self) {
        self.color = 1;
        self.radius = 10;
    }
    return self;
}

-(NSString *) description
{
    NSString *colorDescription = @"";
    // 绿白蓝红黑
    switch (self.color) {
        case -1:
            colorDescription = @"橡皮";
            break;
        case 0:
            colorDescription = @"绿色";
            break;
        case 1:
            colorDescription = @"白色";
            break;
        case 2:
            colorDescription = @"蓝色";
            break;
        case 3:
            colorDescription = @"红色";
            break;
        case 4:
            colorDescription = @"黑色";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@       半径:%u", colorDescription, self.radius];
}
@end
