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

//压缩图片
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
    
//    if (width == 0 || height == 0) {
//        // void zero exception
//        return self;
//    }
//    
    UIImage *newImage = nil;
    CGFloat widthFactor = MAX_IMAGEPIX / width;
//    CGFloat heightFactor = MAX_IMAGEPIX / height;
    CGFloat scaleFactor = 0.0;
    
//    if (widthFactor > heightFactor)
//        scaleFactor = heightFactor; // scale to fit height
//    else
//        scaleFactor = widthFactor; // scale to fit width
    
    
    scaleFactor = widthFactor; // scale to fit width
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    printf("imgnew==%f,=%f,",newImage.size.width,newImage.size.height);

    return newImage;
    
}

@end
