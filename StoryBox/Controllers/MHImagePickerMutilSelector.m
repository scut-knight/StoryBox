//
//  MHMutilImagePickerViewController.m
//  doujiazi
//
//  Created by Shine.Yuan on 12-8-7.
//  Copyright (c) 2012年 mooho.inc. All rights reserved.
//

#import "MHImagePickerMutilSelector.h"
#import <QuartzCore/QuartzCore.h>

/**
 *  这里需要提出一个静态的变量MHImagePickerMutilSelector。
 *  因为showInViewController:(UIViewController<UIImagePickerControllerDelegate,MHImagePickerMutilSelectorDelegate> *) withArr中需要使用这个变量。原来无ARC版本，如果不release该变量就没事。
 *  但是现在改成ARC后，没法不release，所以只好提出来作为静态变量。
 *  还有，上面那个方法的设计是在糟透了，应该放在HomeViewController里面的。
 */
static MHImagePickerMutilSelector *imagePickerMutilSelector = nil;

@interface MHImagePickerMutilSelector ()

@end

@implementation MHImagePickerMutilSelector

@synthesize imagePicker;
@synthesize delegate;
@synthesize selectedPan;

- (id)init
{
    self = [super init];
    if (self)
    {
        pics = [[NSMutableArray alloc] init];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    
    float kScreenHeight = 0;
    if (IS_IPHONE_5)
    {
        kScreenHeight = 568;
    }
    else{
        kScreenHeight = 480;
    }
    
    //显示当前选中相片的视图
    selectedPan = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-131, 320, 131)];//480
    [selectedPan setBackgroundColor:[UIColor blackColor]];
    
    //显示当前选中相片张数
    textlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 300, 14)];
    [textlabel setBackgroundColor:[UIColor clearColor]];
    [textlabel setFont:[UIFont systemFontOfSize:14.0f]];
    [textlabel setTextColor:[UIColor whiteColor]];
    [textlabel setText:@"当前选中0张(最多10张)"];
    
    [selectedPan addSubview:textlabel];
    
    //制作按钮
    btn_done = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_done setFrame:CGRectMake(530/2, 5, 47, 31)];
    //默认未选中相片情况下不可点击
    [btn_done setEnabled:NO];
    [btn_done setImage:[UIImage imageNamed:@"build-before.png"] forState:UIControlStateNormal];
    //点击事件
    [btn_done addTarget:self action:@selector(doneSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [selectedPan addSubview:btn_done];
    
    //往selectedPan中添加用于显示选中相片的tableviews
    tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 90, 320) style:UITableViewStylePlain];
    
    tbv.transform = CGAffineTransformMakeRotation(M_PI * -90 / 180);
    tbv.center = CGPointMake(160, 131-90/2);
    [tbv setRowHeight:100];
    [tbv setShowsVerticalScrollIndicator:NO];
    //按页滚动
    [tbv setPagingEnabled:YES];
    
    tbv.dataSource = self;
    tbv.delegate = self;
    
    //[tbv setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    
    [tbv setBackgroundColor:[UIColor clearColor]];
    //单元间无分割线
    [tbv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [selectedPan addSubview:tbv];
}

/**
 *  导航条布局
 *
 *  @param navigationController
 *  @param viewController
 *  @param animated
 */
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    float kScreenHeight=0;
    if (IS_IPHONE_5)
    {
        kScreenHeight = 568;
    }
    else{
        kScreenHeight = 480;
    }
    //导航条半透明?
    navigationController.navigationBar.translucent = YES;
    //设置导航栏导航按钮的字体为红色
    [navigationController.navigationBar setTintColor:[UIColor colorWithRed:223/255.0 green:110/255.0 blue:118/255.0 alpha:1]];

    [[navigationController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, 320, kScreenHeight-131)];
    //遍历导航条各组件，隐藏取消按钮
    for (UINavigationItem *item in navigationController.navigationBar.subviews)
    {
        if ([item isKindOfClass:[UIButton class]]&&([item.title isEqualToString:@"取消"]||[item.title isEqualToString:@"Cancel"]))
        {
//            printf("cancel");
            UIButton *button = (UIButton *)item;
            [button setHidden:YES];
        }
    }
    
    //如果当前不是导航的根视图，则设定为选择图片视图，否则则设定为选择相册视图
    if (navigationController.viewControllers.count >= 2)
    { // 当前为图片列表
        [[viewController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, 320, kScreenHeight-131)];
        [viewController setTitle:@"选择图片"];
        //设置导航条背景，1title.png在/supporting files/images/albumgroup中
        [navigationController.navigationBar setBackgroundImage:[UIImage  imageNamed:@"1title.png"] forBarMetrics:UIBarMetricsDefault];
      
        //覆盖掉导航条右侧的cancel按钮
        UIView *custom = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:custom];
        [viewController.navigationItem setRightBarButtonItem:btn animated:NO];
        
        [self setWantsFullScreenLayout:YES];
        NSLog(@"选择图片子视图");
    }
    else
    {
        [viewController setTitle:@""];
        //设置导航条背景，1title.png在/supporting files/images/albumgroup中
        [navigationController.navigationBar setBackgroundImage: [UIImage imageNamed:@"title.png"] forBarMetrics:UIBarMetricsDefault];//add
        NSLog(@"选择图片根视图");
    }
}


/**
 *  实现tableview的委托，返回tableview行数
 *
 *  @param tableView
 *  @param section
 *
 *  @return
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"bin:%d",pics.count);
    return pics.count;
}

/**
 *  实现tableview的委托，返回tableview组数
 *
 *  @param tableView
 *
 *  @return
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 *  实现tableview的委托,更新tableview单元
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return
 */
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
       
        //选中相片+删除选中按钮的容器
        UIView * rotateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80 , 80)];
        [rotateView setBackgroundColor:[UIColor blueColor]];
        rotateView.transform = CGAffineTransformMakeRotation(M_PI * 90 / 180);
        rotateView.center = CGPointMake(45, 45);
        [cell.contentView addSubview:rotateView];
        
        UIImageView * imv =[[UIImageView alloc] initWithImage:[pics objectAtIndex:row]];
        [imv setBackgroundColor:[UIColor clearColor]];
        [imv setFrame:CGRectMake(0, 0, 80, 80)];
        [imv setClipsToBounds:YES];
        [imv setContentMode:UIViewContentModeScaleAspectFill];
        
        //为选中相片加上白色边框
        [imv.layer setBorderColor:[UIColor whiteColor].CGColor];
        [imv.layer setBorderWidth:2.0f];
        
        [rotateView addSubview:imv];
        
        //删除选中按钮（红色圈的叉）
        UIButton * btn_delete=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn_delete setFrame:CGRectMake(0, 0, 22, 22)];
        [btn_delete setImage:[UIImage imageNamed:@"close-circled.png"] forState:UIControlStateNormal];
        
        [btn_delete setCenter:CGPointMake(5, 5)];//70 10
        [btn_delete addTarget:self action:@selector(deletePicHandler:) forControlEvents:UIControlEventTouchUpInside];
        [btn_delete setTag:row];
        
        [rotateView addSubview:btn_delete];
    }
    
    return cell;
}

/**
 *  删除选中按钮，把该图片从选中列表中移除
 *
 *  @param btn
 */
-(void)deletePicHandler:(UIButton*)btn
{
    [pics removeObjectAtIndex:btn.tag];
    [self updateTableView];
}

/**
 *  更新tableview，当选中相片为0时，制作按钮不可用
 */
-(void)updateTableView
{
    if (pics.count > 0)
    {
        [btn_done setEnabled:YES];
        [btn_done setImage:[UIImage imageNamed:@"build-after.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btn_done setEnabled:NO];
        [btn_done setImage:[UIImage imageNamed:@"build-before.png"] forState:UIControlStateNormal];
    
    }
    textlabel.text=[NSString stringWithFormat:@"当前选中%i张(最多10张)",pics.count];
    
    [tbv reloadData];
    
    //如果选中相片大于3张，则tableview向右作出偏移以将最后选中的相片显示完全
    if (pics.count > 3)
    {
        CGFloat offsetY = tbv.contentSize.height - tbv.frame.size.height-(320-90);
        [tbv setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }else{
        [tbv setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

/**
 *  实现UIImagePickerControllerDelegate委托，从相册中选取照片
 *
 *  @param picker
 *  @param image
 *  @param editingInfo
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //[btn_addCover.imageView setImage:image forState:UIControlStateNormal];
    
    //[picker dismissModalViewControllerAnimated:YES];
    
    //如果选中相片大于10张，返回，否则加入选中列表中
    if (pics.count>=10)
    {
        return;
    }
    
    [pics addObject:image];
    [self updateTableView];
}

/**
 *  制作按钮点击触发，触发协议里的imagePickerMutilSelectorDidGetImages函数
 *
 *  @param sender
 */
-(void)doneSelect:(id)sender
{
    printf("doned");
    if (delegate && [delegate respondsToSelector:@selector(imagePickerMutilSelectorDidGetImages:)])
    {
        [delegate performSelector:@selector(imagePickerMutilSelectorDidGetImages:) withObject:pics];
    }
    [self close];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    printf("cancle");
//    if (delegate && [delegate respondsToSelector:@selector(imagePickerMutilSelectorDidGetImages:)]) {
//        [delegate performSelector:@selector(imagePickerMutilSelectorDidGetImages:) withObject:pics];
//    }
    
//    [self close];
}

-(void)close
{
//    [imagePicker dismissModalViewControllerAnimated:YES];
    [imagePicker dismissViewControllerAnimated:YES completion:NULL];
    [self.view removeFromSuperview];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)dealloc
{
    NSLog(@"相册dealloc");
    for (int i=0; i<self.view.subviews.count; ++i)
    {
        UIView * _v=[self.view.subviews objectAtIndex:i];
        for (int j=0; j<_v.subviews.count; ++j)
        {
            UIView * _v_v=[_v.subviews objectAtIndex:j];
            [_v_v removeFromSuperview];
        }
        [_v removeFromSuperview];
    }
    
    delegate=nil;
    [pics removeAllObjects];//add
    
    [imagePicker.view removeFromSuperview];
    imagePicker=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 *  复制旧列表中的图片到当前列表中
 *
 *  @param arr 旧列表
 */
-(void)addImageToArray:(NSArray*)arr
{
    [btn_done setEnabled:YES];
    [btn_done setImage:[UIImage imageNamed:@"build-after.png"] forState:UIControlStateNormal];
    for (int i=0; i<arr.count; ++i)
    {
        [pics addObject:[arr objectAtIndex:i]];
    }
}

/**
 *  类方法，供调用新建该类实例
 *
 *  @param vc
 *  @param arry
 */
+(void)showInViewController:(UIViewController<UIImagePickerControllerDelegate,MHImagePickerMutilSelectorDelegate> *)vc  withArr:(NSArray*)arry
{
//    MHImagePickerMutilSelector *
    imagePickerMutilSelector = [[MHImagePickerMutilSelector alloc] init];
    //设置代理
    imagePickerMutilSelector.delegate = vc;
    //如果已选中图片列表不为空，则用该列表来初始化
    if (arry != Nil)
    {
        [imagePickerMutilSelector addImageToArray:arry];
    }
    UIImagePickerController * picker=[[UIImagePickerController alloc] init];
    //将UIImagePicker的代理指向到imagePickerMutilSelector
    picker.delegate = imagePickerMutilSelector;
    [picker setAllowsEditing:NO];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //将UIImagePicker的导航代理指向到imagePickerMutilSelector
    picker.navigationController.delegate = imagePickerMutilSelector;
    //使imagePickerMutilSelector得知其控制的UIImagePicker实例，为释放时需要。
    imagePickerMutilSelector.imagePicker = picker;

    [picker.view addSubview:imagePickerMutilSelector.selectedPan];
    
    [vc presentViewController:picker animated:YES completion:NULL];
}

@end
