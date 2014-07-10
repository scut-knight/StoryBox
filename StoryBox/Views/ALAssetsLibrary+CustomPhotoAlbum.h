//
//  ALAssetsLibrary+CustomPhotoAlbum.h
//  LKTQ
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol PassValueDelegate
@optional
-(void)willFinishPass:(NSString*)strVal;
@end

typedef void(^SaveImageCompletion)(NSError* error);

/**
 *  自定义的保存图片的方式
 */
@interface ALAssetsLibrary(CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

-(NSString *)getPath;

@end