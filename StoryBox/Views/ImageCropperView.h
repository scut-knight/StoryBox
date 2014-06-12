
//
// refer to http://www.cnblogs.com/xiaobaizhu/archive/2013/07/03/3170101.html
// xiaobaizhu
// 13-07-03
//

#import <UIKit/UIKit.h>

@protocol ImageCropperDelegate;
/**
 *  实现对图片的缩放，拖动，裁剪功能
 *  继承UIScrollView
 */
@interface ImageCropperView : UIScrollView
{
	UIImageView *imageView;

}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImage *croppedImage;

- (void)setup;
- (void)finishCropping;
- (void)reset;
- (void)setWidthAndHeight:(NSInteger)width withHeight:(NSInteger)height;

@end
