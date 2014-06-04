//
//  CameraCustom.h
//  LKTQ
//
//  Created by mac on 13-12-26.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface CameraCustom : NSObject
+(UIImage*)photoMerge:(NSMutableArray *)imageViewArr textViewArray:(NSMutableArray*)textViewArr;//返回拼接图片

+(void)saveImage_merged:(UIImage *)img;//保存拼接图到本地LKTQ目录
+(void)saveAllImageOneByOne:(NSMutableArray *)imageViewArr textViewArray:(NSMutableArray*)textViewArr;//循环保存每个图片
+(NSString*)returnPathImage;//返回合成图片路径


+(UIImage*)singleImage:(UIView*)testImageV  withTextView:(UIView*)testTextEditV;
+(UIImage *)SaveToBox:(UIView *)_view withPath:(NSString*)_pathF;
+(UIImage *)SaveToBoxForTempImage:(UIImage *)viewImg withPath:(NSString*)_pathF;
+(NSString*)pathOfTempImage;
+(NSString*)pathOfImageOfBox;

@end
