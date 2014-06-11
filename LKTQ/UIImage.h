//
//  UIImage.h
//  故事盒子
//
//  Created by mac on 14-3-24.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  扩充UIImage类，实现图片尺寸规范化功能
 */
@interface UIImage (Compess)
- (UIImage *)compressedImage;
@end
