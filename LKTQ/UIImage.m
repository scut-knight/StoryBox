//
//  UIImage.m
//  故事盒子
//
//  Created by mac on 14-3-24.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import "UIImage.h"
#define MAX_IMAGEPIX 600.0          // max pix 640.0px

@implementation UIImage(Compess)

/**
 *  图片尺寸规范化，使图片的宽度调整为规定大小
 *  bin?:采用这种图片缩放方法速度较慢
 */
- (UIImage *)compressedImage
{
    
//        [imgV setImage:[UIImage imageWithData:UIImageJPEGRepresentation(img,640/img_w)]];
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    
    if (width <= MAX_IMAGEPIX)
    {
        // no need to compress.
        return self;
    }

    UIImage *newImage = nil;
    CGFloat widthFactor = MAX_IMAGEPIX / width;
//    CGFloat heightFactor = MAX_IMAGEPIX / height;
    
    //缩放因子
    CGFloat scaleFactor = 0.0;
    //暂时选定宽度为缩放因子
    scaleFactor = widthFactor; // scale to fit width
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    
    //创建大小为targetSize的基于位图的上下文
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    //在新的大小框内重绘
    [self drawInRect:thumbnailRect];
    
    //从当前上下文中生成UIImage
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
//    printf("imgnew==%f,=%f,",newImage.size.width,newImage.size.height);
    return newImage;
    
}

@end
