#import "ClipViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageCropperView.h"
#import "MaskView.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface ClipViewController ()

@property (nonatomic, retain) IBOutlet MaskView *maskView;
@property (nonatomic, retain) IBOutlet ImageCropperView *cropper;

@property (nonatomic, retain) IBOutlet UIButton *back;      //取消按钮
@property (nonatomic, retain) IBOutlet UIButton *btn;       //确定按钮

@property (nonatomic, retain) IBOutlet UIButton *Type1;
@property (nonatomic, retain) IBOutlet UIButton *Type2;
@property (nonatomic, retain) IBOutlet UIButton *Type3;
@property (nonatomic, retain) IBOutlet UIImageView *bottomView;
//@property (nonatomic, retain) IBOutlet UISegmentedControl *selectControl;
@property (nonatomic, retain)UIImage* image;

@property (nonatomic, retain) UIView *viewC;//add
@property (nonatomic, retain) id<UpdateCurrentImageDelegate>delegate;//add

@end
@implementation ClipViewController
@synthesize cropper, btn,Type1,Type2,Type3,bottomView;
@synthesize maskView;
@synthesize image;
@synthesize back;
@synthesize viewC;
@synthesize delegate;

-(void)initWith:(UIImage*)img with:(UIView *)VC withDelegate:(id)parent;
{
    self.image = img;
    self.viewC = VC;
    self.delegate = parent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [cropper setup];
    cropper.image =self.image;
    [cropper setWidthAndHeight:1 withHeight:1];                     //默认 1:1
    
    //设置按钮标题颜色，默认第一个为蓝色
    [Type1 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [Type2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Type3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //设置边框宽度和颜色
    cropper.layer.borderWidth = 1.0;
    cropper.layer.borderColor = [UIColor blueColor].CGColor;
    
    //为响应按钮点击绑定函数
    //bin?:为何不直接拖进来作为IBACTION?
    [btn addTarget:self action:@selector(Cropper:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [Type1 addTarget:self action:@selector(OneToOne:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [Type2 addTarget:self action:@selector(FourToThree:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [Type3 addTarget:self action:@selector(HD:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    //遮罩层不可交互
    self.maskView.userInteractionEnabled = NO;
    //遮罩层背景为黑色
    self.maskView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [self.maskView setDrawFrame:self.cropper.frame];
    
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
 *  取消按钮事件（返回上一个界面）
 *
 *  @param sender
 */
- (void)back:(id)sender
{
    [self.delegate UpdateCurrentImage:image];
    [self.view.superview addSubview:self.viewC];
    [self.view removeFromSuperview];
}

/**
 *  确定按钮事件（裁剪图片，返回上一个界面）
 *
 *  @param sender
 */
- (void)Cropper:(id)sender
{
        [cropper finishCropping];
        [self.delegate UpdateCurrentImage:cropper.croppedImage];
        [self.view.superview addSubview:self.viewC];
        [self.view removeFromSuperview];
}

/**
 *  1:1按钮事件
 *
 *  @param sender
 */
-(void)OneToOne:(id)sender
{
    //选中的按钮标题设置为蓝色，其余保持默认
    [Type1 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [Type2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Type3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //设置裁剪比例
    [cropper setWidthAndHeight:1 withHeight:1];
    //设置遮罩大小
    [maskView setDrawFrame:cropper.frame];
}

/**
 *  4:3按钮事件
 *
 *  @param sender
 */
-(void)FourToThree:(id)sender
{
    [Type1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Type2 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [Type3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    if([Type2.titleLabel.text isEqualToString:@"4:3"])
    {
        [cropper setWidthAndHeight:4 withHeight:3];//默认4：3
        [maskView setDrawFrame:cropper.frame];
            [Type2 setTitle:@"3:4" forState:UIControlStateNormal];
        
    }
    else
    {
        [cropper setWidthAndHeight:3 withHeight:4];//默认3:4
        [maskView setDrawFrame:cropper.frame];
            [Type2 setTitle:@"4:3" forState:UIControlStateNormal];
    }
}

/**
 *  HD按钮事件
 *
 *  @param sender
 */
-(void)HD:(id)sender
{
    [Type1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Type2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Type3 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [cropper setWidthAndHeight:16 withHeight:9];//默认16:9
    [maskView setDrawFrame:cropper.frame];
}
@end
