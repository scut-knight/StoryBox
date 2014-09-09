#import "ClipViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageCropperView.h"
#import "MaskView.h"

static ClipViewController * sharedSingleton_ = nil;

@interface ClipViewController ()

- (IBAction)OneToOne:(id)sender;
- (IBAction)FourToThree:(id)sender;
- (IBAction)HD:(id)sender;
- (IBAction)Cropper:(id)sender;
- (IBAction)back:(id)sender;
- (void)drawCropper;
- (void)drawMask;

@property (nonatomic, retain) IBOutlet MaskView *maskView;
@property (nonatomic, retain) IBOutlet ImageCropperView *cropper;

@property (nonatomic, retain) IBOutlet UIButton *back;      //取消按钮
@property (nonatomic, retain) IBOutlet UIButton *btn;       //确定按钮

@property (nonatomic, retain) IBOutlet UIButton *Type1;   // 1:1
@property (nonatomic, retain) IBOutlet UIButton *Type2;   // 4:3 or 3:4
@property (nonatomic, retain) IBOutlet UIButton *Type3;   // 16:9/HD
@property (nonatomic, retain) IBOutlet UIImageView *bottomView;
@property (nonatomic, retain) UIImage* image;

@property (nonatomic, retain) UIView *viewC;//add
@property (nonatomic, retain) id<UpdateCurrentImageDelegate>delegate;//add

@end

@implementation ClipViewController

/**
 *  合成cropper的接口函数
 */
@synthesize cropper;

#pragma mark implement singleton

+ (ClipViewController *)sharedInstance
{
    if (sharedSingleton_ == nil) {
        sharedSingleton_ = [[super allocWithZone:NULL]
                            initWithNibName:@"ClipViewController_iPhone" bundle:nil];
    }
    return sharedSingleton_;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [ClipViewController sharedInstance];
}

-(void)initWith:(UIImage*)img with:(UIView *)VC withDelegate:(id)parent;
{
    self.image = img;
    self.viewC = VC;
    self.delegate = parent;
    [self drawCropper];
    [self drawMask];
}

- (void) drawCropper
{
    [cropper setup];
    
    cropper.image = self.image; // 调用[cropper setImage]
    
    [self.cropper setWidthAndHeight:1 withHeight:1];                     //默认 1:1
    
    //设置按钮标题颜色，默认第一个为蓝色
    [self.Type1 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.Type2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.Type3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //设置边框宽度和颜色
    cropper.layer.borderWidth = 1.0;
    cropper.layer.borderColor = [UIColor blueColor].CGColor;
}

- (void) drawMask
{
    //遮罩层不可交互
    self.maskView.userInteractionEnabled = NO;
    //遮罩层背景为黑色
    self.maskView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [self.maskView setDrawFrame:self.cropper.frame];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self drawCropper];
    [self drawMask];
    
    //根据设备调整UI
    if(IS_IPHONE_5)
    {
        [self.bottomView setFrame:CGRectMake(0.0, 472, 320, 96)];
        [self.back setFrame:CGRectMake(20, 504, 30, 30)];
        [self.Type1 setFrame:CGRectMake(87, 504, 30, 30)];
        [self.Type2 setFrame:CGRectMake(145, 504, 30, 30)];
        [self.Type3 setFrame:CGRectMake(205, 504, 30, 30)];
        [self.btn setFrame:CGRectMake(270, 504, 30, 30)];
    }
    else
    {
        [self.bottomView setFrame:CGRectMake(0.0, 384, 320, 96)];
        [self.back setFrame:CGRectMake(20, 416, 30, 30)];
        [self.Type1 setFrame:CGRectMake(87, 416, 30, 30)];
        [self.Type2 setFrame:CGRectMake(145, 416, 30, 30)];
        [self.Type3 setFrame:CGRectMake(205, 416, 30, 30)];
        [self.btn setFrame:CGRectMake(270, 416, 30, 30)];
    }
}

/**
 *  1:1按钮事件
 *
 *  @param sender
 */
- (IBAction)OneToOne:(id)sender
{
    //选中的按钮标题设置为蓝色，其余保持默认
    [self.Type1 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.Type2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.Type3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //设置裁剪比例
    [self.cropper setWidthAndHeight:1 withHeight:1];
    //设置遮罩大小
    [self.maskView setDrawFrame:self.cropper.frame];
}

/**
 *  4:3按钮事件
 *
 *  @param sender
 */
- (IBAction)FourToThree:(id)sender
{
    [self.Type1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.Type2 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.Type3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    if([self.Type2.titleLabel.text isEqualToString:@"4:3"])
    {
        [self.cropper setWidthAndHeight:4 withHeight:3];//默认4：3
        [self.maskView setDrawFrame:self.cropper.frame];
        [self.Type2 setTitle:@"3:4" forState:UIControlStateNormal];
        
    }
    else
    {
        [self.cropper setWidthAndHeight:3 withHeight:4];//默认3:4
        [self.maskView setDrawFrame:self.cropper.frame];
        [self.Type2 setTitle:@"4:3" forState:UIControlStateNormal];
    }
}

/**
 *  HD按钮事件
 *
 *  @param sender
 */
- (IBAction)HD:(id)sender
{
    [self.Type1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.Type2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.Type3 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.cropper setWidthAndHeight:16 withHeight:9];//默认16:9
    [self.maskView setDrawFrame:self.cropper.frame];
}

/**
 *  确定按钮事件（裁剪图片，返回上一个界面）
 *
 *  @param sender
 */
- (IBAction)Cropper:(id)sender
{
    [self.cropper finishCropping];
    [self.delegate UpdateCurrentImage:self.cropper.croppedImage];
    [self.view.superview addSubview:self.viewC];
    [self.view removeFromSuperview];
}

/**
 *  取消按钮事件（返回上一个界面）
 *
 *  @param sender
 */
- (IBAction)back:(id)sender
{
    [self.delegate UpdateCurrentImage:self.image];
    [self.view.superview addSubview:self.viewC];
    [self.view removeFromSuperview];
}

@end
