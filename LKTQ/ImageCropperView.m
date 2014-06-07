#import "ImageCropperView.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface ImageCropperView()
{
    @private
    CGSize _originalImageViewSize;
}

@property (nonatomic, retain) UIImageView *imageView;
@end

@implementation ImageCropperView

@synthesize imageView, image = _image, croppedImage;

- (void)setup
{
    //不裁剪超出父视图的子视图部分
    self.clipsToBounds = NO;
    //不显示滚动条
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor blackColor];
    //图片显示区域初始化，bin?: arc中无autorelease
    self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)] autorelease];
    imageView.userInteractionEnabled = YES;
    
    [self addSubview:imageView];
 
    //注册缩放手势
    UIPinchGestureRecognizer *scaleGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    [imageView addGestureRecognizer:scaleGes];
    //bin?: arc
    [scaleGes release];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
    {
		self.frame = frame;
        [self setup];
        
	}
	return self;
}

/**
 *  设置ScrollView的大小和位置
 *
 *  @param width  宽度
 *  @param height 高度
 */
-(void)setWidthAndHeight:(NSInteger)width withHeight:(NSInteger)height
{
    NSLog(@"%f,%f,is the w/h\n",self.contentSize.width,self.contentSize.height);
    if(self.contentSize.width/self.contentSize.height >= 1)
    {
        if(self.contentSize.width/self.contentSize.height > width*1.0/height)
            [self setFrame:CGRectMake(0, 0, self.contentSize.height*width/height, self.contentSize.height)];
        else
            [self setFrame:CGRectMake(0, 0,self.contentSize.width,self.contentSize.width*height/width)];
    }
    else
    {
        [self setFrame:CGRectMake(0, 0,self.contentSize.width,self.contentSize.width*height/width)];
    }
    [self reset];
    if(IS_IPHONE_5)
    {
        self.center = CGPointMake(160, 254);//设置视口居中//284
    }
    else
    {
        self.center = CGPointMake(160, 210);//设置视口居中//284
    }
    
    //设置显示区域顶点相对于frame顶点的偏移量
    [self setContentOffset:CGPointMake((self.contentSize.width-self.frame.size.width)/2,(self.contentSize.height-self.frame.size.height)/2) animated:false];
}

float _lastScale = 1.0;
/**
 *  缩放图片
 *
 *  @param sender
 */
- (void)scaleImage:(UIPinchGestureRecognizer *)sender
{
    if([sender state] == UIGestureRecognizerStateBegan)
    {
        _lastScale = 1.0;
        return;
    }
    
    CGFloat scale = [sender scale]/_lastScale;
    
    //获取转换矩阵
    CGAffineTransform currentTransform = imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    //如果产生缩放（a >= 1),按转换矩阵执行变换
    if(newTransform.a >= 1)
    {
        [imageView setTransform:newTransform];

    }
    self.contentSize=CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    imageView.center = CGPointMake(self.contentSize.width/2.0, self.contentSize.height/2.0);
    _lastScale = [sender scale];
}

/**
 *  设置显示图片
 *
 *  @param image
 */
- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        //bin?:arc
        _image = [image retain];
    }
    
    //图片适应屏幕的放缩比
    float  _imageScale = 320 / image.size.width;
    self.imageView.frame = CGRectMake(0, 0, image.size.width*_imageScale, image.size.height*_imageScale);
    _originalImageViewSize = CGSizeMake(image.size.width*_imageScale, image.size.height*_imageScale);
    
    //设置scrollView的contentSize值
    self.contentSize = CGSizeMake(_image.size.width*_imageScale, _image.size.height*_imageScale);
     [self setContentOffset:CGPointMake((self.contentSize.width-self.frame.size.width)/2,(self.contentSize.height-self.frame.size.height)/2) animated:false];
    
    //设置位置
    self.center = CGPointMake(160, 250);//设置视口居中//284
    imageView.image = image;
    //将图片居中
    imageView.center = CGPointMake(self.contentSize.width/2.0, self.contentSize.height/2.0);
}

/**
 *  执行图片变换（裁剪）
 */
- (void)finishCropping
{
    //图片由于手势放大倍数
    float zoomScale = [[self.imageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    //图片本身由于适应屏幕的放大倍数
    float _imageScale = _image.size.width/_originalImageViewSize.width;

    //裁剪大小以及起始点
    CGSize cropSize = CGSizeMake(self.frame.size.width/zoomScale, self.frame.size.height/zoomScale);
    CGPoint cropperViewOrigin = CGPointMake((self.contentOffset.x)/zoomScale,
                                            (self.contentOffset.y)/zoomScale);

    if((NSInteger)cropSize.width % 2 == 1)
    {
        //向上取整
        cropSize.width = ceil(cropSize.width);
    }
    if((NSInteger)cropSize.height % 2 == 1)
    {
        cropSize.height = ceil(cropSize.height);
    }
    
    CGRect CropRectinImage = CGRectMake((NSInteger)(cropperViewOrigin.x*_imageScale) ,(NSInteger)( cropperViewOrigin.y*_imageScale), (NSInteger)(cropSize.width*_imageScale),(NSInteger)(cropSize.height*_imageScale));

    CGImageRef tmp = CGImageCreateWithImageInRect([self.image CGImage], CropRectinImage);
    self.croppedImage = [UIImage imageWithCGImage:tmp scale:self.image.scale orientation:self.image.imageOrientation];
    CGImageRelease(tmp);
}

/**
 *  重置
 */
- (void)reset
{
    self.imageView.transform = CGAffineTransformIdentity;
    self.contentSize=CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    self.imageView.center = CGPointMake(self.contentSize.width/2.0, self.contentSize.height/2.0);
}

- (void)dealloc
{
    self.image = nil;
	self.croppedImage = nil;
	self.imageView = nil;

    [super dealloc];
}

@end
