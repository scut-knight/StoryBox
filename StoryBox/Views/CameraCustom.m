//
//  CameraCustom.m
//  LKTQ
//
//  Created by mac on 13-12-26.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import "CameraCustom.h"
#import "UITextLable.h"
#import "UIImage.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "WeatherLabel.h"
#import "UITitleLabel.h"

@implementation CameraCustom

/*拼接图片并自动保存到沙盒指定目录*/
+(UIImage*)photoMerge:(NSMutableArray *)imageViewArr textViewArray:(NSMutableArray*)textViewArr
{
    int num=[imageViewArr count];
    printf("自动保存沙盒%d",num);
    UIImageView *testImageV;
    UIView * testTextEditV;
    UIView *panner = [[UIView alloc] init];
    UIView * textPanner = [[UIView alloc] init];
    float  _height=0;
    float  _width=640;
    float _height_textv=0;
    float _width_textv=640;
   
//    NSMutableArray* _centerA=[self saveCenterArray:imageViewArr];//保存原始中点
    NSMutableArray *_centerA=[[NSMutableArray alloc]init];
    
    int margin = 8;//图片间隔
    for (int i=0; i< num; ++i)
    {
        testImageV = [imageViewArr objectAtIndex:i];
        testTextEditV = [textViewArr objectAtIndex:i];
        
        //保存位置，大小
        [self saveCenterArray:_centerA withView:testImageV];
        
        //重新设置图片view 和文字view的y坐标，然后添加到容器panner View中
        [testImageV setFrame:CGRectMake(0, _height,testImageV.frame.size.width*2,testImageV.frame.size.height*2)];//图片放大二倍
 
        [testTextEditV setFrame:CGRectMake(0,_height_textv, testImageV.frame.size.width, testImageV.frame.size.height)];//文本view自动适应图片的大小
        
        [self adjustTextLableTolarge:testTextEditV];//调整文字层标签，字号和文字背景图片
        
        _height=_height + testImageV.frame.size.height+margin;//累加总高度
        _height_textv=_height_textv +testTextEditV.frame.size.height+margin;
        //排列依次添加
        [panner addSubview: testImageV];//图片
        [textPanner addSubview:testTextEditV];//文字拼接
    }
    [panner setFrame:CGRectMake(0, 0, _width, _height)];
     /*文字层拼接后，以文字图片的形式和图片层叠加*/
 
    [textPanner setFrame:CGRectMake(0, 0,_width_textv, _height_textv)];//变大 test
    [panner addSubview:textPanner];

    UIImage * img=[self SaveToBox:panner withPath:[self pathOfImageOfBox]];//默认自动保存到沙盒
    [self adjustIamgeViewAndTextView:imageViewArr textView:textViewArr WithCenterOrdinal:_centerA];//还原图片大小
    [self adjustTextLableTosmall:textPanner];//还原文字view
    
    
    [_centerA removeAllObjects];//add

    return  img;
}

//new 保存拼接前的位置和大小
+(NSMutableArray*)saveCenterArray:(NSMutableArray *)centerArray  withView:(UIView*)imageV
{
 
    NSMutableDictionary *centerTemp=[[NSMutableDictionary alloc]init];
    [centerTemp setObject:[NSNumber numberWithFloat:imageV.frame.origin.x] forKey:@"x"];
    [centerTemp setObject:[NSNumber numberWithFloat:imageV.frame.origin.y] forKey:@"y"];
    [centerTemp setObject:[NSNumber numberWithFloat:imageV.frame.size.width] forKey:@"w"];
    [centerTemp setObject:[NSNumber numberWithFloat:imageV.frame.size.height] forKey:@"h"];
    [centerArray addObject:centerTemp];
    
    return centerArray;
}

////保存拼接前的位置和大小
//+(NSMutableArray*)saveCenterArray:(NSMutableArray *)imageViewArr
//{
//    UIImageView *imageV;
//    NSMutableArray *centerArray=[[NSMutableArray alloc]init];
//
//    for (int i=0; i<imageViewArr.count; ++i) {
//        NSMutableDictionary *centerTemp=[[NSMutableDictionary alloc]init];
//        imageV=[imageViewArr objectAtIndex:i];
//        [centerTemp setObject:[NSNumber numberWithFloat:imageV.frame.origin.x] forKey:@"x"];
//         [centerTemp setObject:[NSNumber numberWithFloat:imageV.frame.origin.y] forKey:@"y"];
//        [centerTemp setObject:[NSNumber numberWithFloat:imageV.frame.size.width] forKey:@"w"];
//         [centerTemp setObject:[NSNumber numberWithFloat:imageV.frame.size.height] forKey:@"h"];
//        [centerArray addObject:centerTemp];
//        [centerTemp release];
//        
//    }
//
//    return centerArray;
//
//}
/*生成图片同时会放进沙盒目录ImageMerged,默认名字Merged.png,用于后面分享获取*/
+(UIImage *)writeToImageFromView:(UIView *)pan//写成图片同时会放进沙盒目录ImageMerged,默认名字Merged.png,用于后面分享获取
{
    UIGraphicsBeginImageContextWithOptions(pan.bounds.size, NO, 1.0);
//    UIGraphicsBeginImageContext(pan.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [pan.layer renderInContext:UIGraphicsGetCurrentContext()];
    //renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    
//    UIImage *img=[UIImage imageWithCGImage:viewImage.CGImage scale:0.5 orientation:UIImageOrientationUp];
    return viewImage;

}
/* 保存合成后图片到本地LKTQ目录*/
+(void)saveImage_merged:(UIImage *)img
{
    ALAssetsLibrary * library=[[ALAssetsLibrary alloc] init] ;
    [library saveImage:img toAlbum:@"故事盒子" withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"Big error: %@", [error description]);
        }
    }];
}

/* 循环保存单独图片到本地LKTQ目录*/
+(void)saveAllImageOneByOne:(NSMutableArray *)imageViewArr textViewArray:(NSMutableArray*)textViewArr
{
    ALAssetsLibrary * library=[[ALAssetsLibrary alloc] init] ;
    UIImage * img=nil;
    int num=[imageViewArr count];
    UIImageView *testImageV;
    UIView * testTextEditV;
 
    for (int i=0; i< num; ++i) {
        testImageV=[imageViewArr objectAtIndex:i];
        testTextEditV=[textViewArr objectAtIndex:i];
        img=[self singleImage:testImageV withTextView:testTextEditV];
        
        [library saveImage:img toAlbum:@"故事盒子" withCompletionBlock:^(NSError *error) {
            if (error!=nil) {
                NSLog(@"Big error: %@", [error description]);
            }
        }];
        
    }
}

//单张图片生成uiimage
+(UIImage*)singleImage:(UIView*)testImageV  withTextView:(UIView*)testTextEditV
{
    UIImage * img=nil;
    UIView *panner=[[UIView alloc] init];
    float  _height=0;
    float  _width=0;
    
    float _x=testImageV.frame.origin.x;
    float _y=testImageV.frame.origin.y;
    
    _width=testImageV.frame.size.width*2;
    _height=testImageV.frame.size.height*2;//高度
    
    //添加到容器panner View中
    [testImageV setFrame:CGRectMake(0, 0,_width,_height)];
    [testTextEditV setFrame:CGRectMake(0, 0,_width,_height)];
    [self adjustTextLableTolarge:testTextEditV];
    //排列依次添加
    [panner addSubview: testImageV];
    [panner addSubview: testTextEditV];
    
    [panner setFrame:CGRectMake(0, 0, _width, _height)];
    img=[self writeToImageFromView:panner];
    
    
    //还原大小
    [testImageV setFrame:CGRectMake(_x, _y, _width/2, _height/2)];
    [testTextEditV setFrame:testImageV.frame];
    
    
    [self changeTextLableTosmall:testTextEditV];//还原标签
    [testImageV removeFromSuperview];
    [testTextEditV removeFromSuperview];
    
    return img;

}
/*生成沙盒目录ImageMerged,默认名字Merged.png,用于后面分享获取 */
+(UIImage *)SaveToBox:(UIView *)_view withPath:(NSString*)_pathF
{
//    UIImage * viewImg=[self writeToImageFromView:_view];
    UIImage * viewImg=[[self writeToImageFromView:_view]compressedImage];
    
    NSString * pathFull=_pathF;
    NSError *error=nil;
    NSData *mergedDate = UIImagePNGRepresentation(viewImg);
    [mergedDate writeToFile:pathFull options:NSAtomicWrite error:&error];
//    [mergedDate writeToFile:[self pathOfImageOfBox] options:NSAtomicWrite error:&error];

    return viewImg;//0
}
//保存临时文件到沙盒包括，滤镜处理后的图片
+(UIImage *)SaveToBoxForTempImage:(UIImage *)viewImg withPath:(NSString*)_pathF
{
    NSString * pathFull=_pathF;
    NSError *error=nil;
    NSData *mergedDate = UIImagePNGRepresentation(viewImg);
    [mergedDate writeToFile:pathFull options:NSAtomicWrite error:&error];
    //    [mergedDate writeToFile:[self pathOfImageOfBox] options:NSAtomicWrite error:&error];
    
    return viewImg;//0
}

+(NSString*)returnPathImage//返回合成图片沙盒路径
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * dirFull=[documentsDirectory stringByAppendingPathComponent:@"ImageMerged"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error=nil;
    if (![fileManager fileExistsAtPath:dirFull]) {
        [fileManager createDirectoryAtPath:dirFull withIntermediateDirectories:YES attributes:nil error:&error];
    }
    //创建目录完成
     return dirFull;
   
}
+(NSString*)pathOfImageOfBox
{
    NSString * path=[self  returnPathImage];
    NSString * pathImage=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"Merged.png"]];
    return  pathImage;//返回合成图片路径

}
+(NSString*)pathOfTempImage
{
    NSString * path=[self  returnPathImage];
    NSString * pathImage=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"Temp_LKTQ.png"]];
    return  pathImage;//返回临时图片路径
    
}

//还原大小图片view和文字层的view大小和位置
+(void)adjustIamgeViewAndTextView:(NSMutableArray *)imageViewArr textView:(NSMutableArray *)textViewArr WithCenterOrdinal:(NSMutableArray *)rectA
{
    int num=[imageViewArr count];
    UIImageView *testImageV;
    UIView * testTextEditV;
    for (int i=0; i< num; ++i)
    {
        testImageV=[imageViewArr objectAtIndex:i];
        testTextEditV=[textViewArr objectAtIndex:i];
     
        NSMutableDictionary * _rect=[rectA objectAtIndex:i];//addcenter
        NSNumber * x=[_rect objectForKey:@"x"];
        NSNumber * y=[_rect objectForKey:@"y"];
        NSNumber * w=[_rect objectForKey:@"w"];
        NSNumber * h=[_rect objectForKey:@"h"];
        float _x=[x floatValue];
        float _y=[y floatValue];
        float _w=[w floatValue];
        float _h=[h floatValue];
       [testImageV setFrame:CGRectMake(_x,_y,_w,_h)];
        
        [testTextEditV setFrame:testImageV.frame];
        
    }

}
+(void)adjustTextLableTolarge:(UIView *)textview//textview 表示文字层
{
    //放大标签尺寸
    int num = textview.subviews.count;
    printf("调整=:%d",num);
  
    //bin?:需要进一步抽象！！！
    UITextLable * temp;
    for (int i=0; i<num; ++i)
    {
        temp = [textview.subviews objectAtIndex:i];

//        float x = temp.frame.origin.x * 2;
//        float y = temp.frame.origin.y * 2;
        
//        [temp setFrame:CGRectMake(temp.frame.origin.x * 2, temp.frame.origin.y * 2, temp.frame.size.width*2, temp.frame.size.height*2)];
      
//        temp._textView.font=[UIFont fontWithName:@"Arial" size:24.0];//12;
//        [temp._textView setFrame:CGRectMake(temp._textView.frame.origin.x, temp._textView.frame.origin.y, temp._textView.frame.size.width*2, temp._textView.frame.size.height*2)];
//        [temp.imageViewBg setFrame:CGRectMake(temp.imageViewBg.frame.origin.x, temp.imageViewBg.frame.origin.y, temp.imageViewBg.frame.size.width*2-20, temp.imageViewBg.frame.size.height*2-20)];
        
        if([temp isKindOfClass:[WeatherLabel class]])
        {
            [temp setFrame:CGRectMake(temp.frame.origin.x * 2, temp.frame.origin.y * 2, temp.frame.size.width*2, temp.frame.size.height*2)];

            WeatherLabel * temp = [textview.subviews objectAtIndex:i];
            temp.cityLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
            temp.tempLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
            [temp.cityLabel setFrame:CGRectMake(temp.cityLabel.frame.origin.x + 45, temp.cityLabel.frame.origin.y, temp.cityLabel.frame.size.width*2, temp.cityLabel.frame.size.height*2)];
            [temp.tempLabel setFrame:CGRectMake(temp.tempLabel.frame.origin.x + 35, temp.tempLabel.frame.origin.y, temp.tempLabel.frame.size.width*2, temp.tempLabel.frame.size.height*2)];

            [temp.imageViewBg setFrame:CGRectMake(temp.imageViewBg.frame.origin.x, temp.imageViewBg.frame.origin.y, temp.imageViewBg.frame.size.width*2, temp.imageViewBg.frame.size.height*2)];

        }
        else
        {
            [temp setFrame:CGRectMake(temp.frame.origin.x*2,temp.frame.origin.y*2, temp.frame.size.width*2, temp.frame.size.height*2)];
            
            
            temp._textView.font=[UIFont fontWithName:@"Arial" size:24.0];//12;
            [temp._textView setFrame:CGRectMake(temp._textView.frame.origin.x, temp._textView.frame.origin.y, temp._textView.frame.size.width*2, temp._textView.frame.size.height*2)];
            
            [temp.imageViewBg setFrame:CGRectMake(temp.imageViewBg.frame.origin.x, temp.imageViewBg.frame.origin.y, temp.imageViewBg.frame.size.width*2-20, temp.imageViewBg.frame.size.height*2-20)];
            
        }
        
    }
    
}
/*用于对整个拼接后的文字层调整还原*/
+(void)adjustTextLableTosmall:(UIView *)textview
{
    //还原标签尺寸
    int num = textview.subviews.count;
    printf("调整=:%d",num);
    UIView * tempV;
    for (int i=0; i<num; ++i)
    {
        printf("还原=%d,",i);
        tempV = [textview.subviews objectAtIndex:i];
        UITextLable *temp;
        for (int j=0; j<tempV.subviews.count; ++j)
        {
            temp = [tempV.subviews objectAtIndex:j];
//            [temp setFrame:CGRectMake(temp.frame.origin.x/2, temp.frame.origin.y/2, temp.frame.size.width/2, temp.frame.size.height/2)];
//            temp._textView.font=[UIFont fontWithName:@"Arial" size:12.0];//12;
//            [temp._textView setFrame:CGRectMake(temp._textView.frame.origin.x, temp._textView.frame.origin.y, temp._textView.frame.size.width/2, temp._textView.frame.size.height/2)];
//            
//            [temp.imageViewBg setFrame:CGRectMake(temp.imageViewBg.frame.origin.x, temp.imageViewBg.frame.origin.y, (temp.imageViewBg.frame.size.width+20)/2, (temp.imageViewBg.frame.size.height+20)/2)];
            
            if([temp isKindOfClass:[WeatherLabel class]])
            {
                WeatherLabel * temp = [tempV.subviews objectAtIndex:j];
                [temp setFrame:CGRectMake(temp.frame.origin.x/2, temp.frame.origin.y/2, temp.frame.size.width/2, temp.frame.size.height/2)];
                temp.cityLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
                temp.tempLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
                [temp.cityLabel setFrame:CGRectMake(temp.cityLabel.frame.origin.x - 45, temp.cityLabel.frame.origin.y, temp.cityLabel.frame.size.width/2, temp.cityLabel.frame.size.height/2)];
                [temp.tempLabel setFrame:CGRectMake(temp.tempLabel.frame.origin.x - 35, temp.tempLabel.frame.origin.y, temp.tempLabel.frame.size.width/2, temp.tempLabel.frame.size.height/2)];

                [temp.imageViewBg setFrame:CGRectMake(temp.imageViewBg.frame.origin.x, temp.imageViewBg.frame.origin.y, temp.imageViewBg.frame.size.width/2, temp.imageViewBg.frame.size.height/2)];
            }
            else
            {
                [temp setFrame:CGRectMake(temp.frame.origin.x/2, temp.frame.origin.y/2, temp.frame.size.width/2, temp.frame.size.height/2)];
                
                temp._textView.font=[UIFont fontWithName:@"Arial" size:12.0];
                [temp._textView setFrame:CGRectMake(temp._textView.frame.origin.x, temp._textView.frame.origin.y, temp._textView.frame.size.width/2, temp._textView.frame.size.height/2)];
                [temp.imageViewBg setFrame:CGRectMake(temp.imageViewBg.frame.origin.x, temp.imageViewBg.frame.origin.y, (temp.imageViewBg.frame.size.width+20)/2, (temp.imageViewBg.frame.size.height+20)/2)];

            }

        }
        
        
    }
    
}
/*用于单张文字层调整标签还原*/
+(void)changeTextLableTosmall:(UIView *)textview
{
    //还原标签尺寸
    int num=textview.subviews.count;
    printf("调整=:%d",num);
    UITextLable * temp;
    for (int i=0; i<num; ++i)
    {
        printf("还原=%d,",i);
        temp=[textview.subviews objectAtIndex:i];
        float x=temp.frame.origin.x/2;
        float y=temp.frame.origin.y/2;
        [temp setFrame:CGRectMake(x, y, temp.frame.size.width/2, temp.frame.size.height/2)];
        
        temp._textView.font=[UIFont fontWithName:@"Arial" size:12.0];//12;
        [temp._textView setFrame:CGRectMake(temp._textView.frame.origin.x, temp._textView.frame.origin.y, temp._textView.frame.size.width/2, temp._textView.frame.size.height/2)];
        
        [temp.imageViewBg setFrame:CGRectMake(temp.imageViewBg.frame.origin.x, temp.imageViewBg.frame.origin.y, (temp.imageViewBg.frame.size.width+20)/2, (temp.imageViewBg.frame.size.height+20)/2)];//
    }
}
@end
