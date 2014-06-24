//
//  ALAssetsLibrary+CustomPhotoAlbum.m
//  LKTQ
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 sony. All rights reserved.
//


#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <objc/runtime.h>
static NSString * path;

@implementation ALAssetsLibrary(CustomPhotoAlbum)

//@dynamic indieBandName;
//
//- (NSString *)indieBandName {
//    return objc_getAssociatedObject(self, IndieBandNameKey);
//}
//
//- (void)setIndieBandName:(NSString *)indieBandName
//{
//    objc_setAssociatedObject(self, IndieBandNameKey, indieBandName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
//    DDD = @"DDD";
    [self writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
     
                       completionBlock:^(NSURL* assetURL, NSError* error)
    {
                           if (error!=nil)
                           {
                               completionBlock(error);
                               return;
                               
                           }
                           [self addAssetURL: assetURL
                                     toAlbum:albumName
                         withCompletionBlock:completionBlock];
        path = [assetURL absoluteString];
//        NSLog(@"%@",assetURL);
    }];
}

-(NSString *)getPath
{
    return path;
}


-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock{
    
    __block BOOL albumWasFound = NO;
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum
     
                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                            if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                                albumWasFound = YES;
                                [self assetForURL: assetURL
                                      resultBlock:^(ALAsset *asset) {
                                          [group addAsset: asset];
                                          completionBlock(nil);
                                      } failureBlock: completionBlock];
                                return;
                            }
                            if (group==nil && albumWasFound==NO) {
                                __weak ALAssetsLibrary* weakSelf = self;
                                [self addAssetsGroupAlbumWithName:albumName
                                                      resultBlock:^(ALAssetsGroup *group) {
                                                          [weakSelf assetForURL: assetURL
                                                                    resultBlock:^(ALAsset *asset) {
                                                                        [group addAsset: asset];
                                                                        completionBlock(nil);
                                                                    } failureBlock: completionBlock];
                                                      } failureBlock: completionBlock];
                                return;
                            }
                        } failureBlock: completionBlock];
}
@end