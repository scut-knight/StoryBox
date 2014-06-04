#import <UIKit/UIKit.h>

@protocol ImageCropperDelegate;

@interface ImageCropperView : UIScrollView {
	UIImageView *imageView;

}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImage *croppedImage;

- (void)setup;
- (void)finishCropping;
- (void)reset;
- (void)setWidthAndHeight:(NSInteger)width withHeight:(NSInteger)height;

@end
