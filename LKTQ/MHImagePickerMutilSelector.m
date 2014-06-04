//
//  MHMutilImagePickerViewController.m
//  doujiazi
//
//  Created by Shine.Yuan on 12-8-7.
//  Copyright (c) 2012年 mooho.inc. All rights reserved.
//

#import "MHImagePickerMutilSelector.h"
#import <QuartzCore/QuartzCore.h>

@interface MHImagePickerMutilSelector ()

@end

@implementation MHImagePickerMutilSelector

@synthesize imagePicker;
@synthesize delegate;
@synthesize selectedPan;

- (id)init
{
    self = [super init];
    if (self) {

        pics=[[NSMutableArray alloc] init];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        
    }
    return self;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    float kScreenHeight=0;
    if (IS_IPHONE_5) {
        kScreenHeight=568;
    }
    else{
        kScreenHeight=480;
    }
    navigationController.navigationBar.translucent = YES;
    [navigationController.navigationBar setTintColor:[UIColor colorWithRed:223/255.0 green:110/255.0 blue:118/255.0 alpha:1]];
    
    [[navigationController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, 320, kScreenHeight-131)];
    for (UINavigationItem *item in navigationController.navigationBar.subviews)
    {

        if ([item isKindOfClass:[UIButton class]]&&([item.title isEqualToString:@"取消"]||[item.title isEqualToString:@"Cancel"]))
            
        {
            printf("cancel");
            UIButton *button = (UIButton *)item;
            [button setHidden:YES];
        }
    }
    if (navigationController.viewControllers.count>=2) { // 当前为图片列表
       
        [[viewController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, 320, kScreenHeight-131)];
         [viewController setTitle:@"选择图片"];
          [navigationController.navigationBar setBackgroundImage:[UIImage  imageNamed:@"1title.png"] forBarMetrics:UIBarMetricsDefault];
      
        UIView *custom = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:custom];
        [viewController.navigationItem setRightBarButtonItem:btn animated:NO];
        [btn release];
        [custom release];
        
         [self setWantsFullScreenLayout:YES];
        printf("1");
    }else{
         [viewController setTitle:@""];
        [navigationController.navigationBar setBackgroundImage: [UIImage imageNamed:@"title.png"] forBarMetrics:UIBarMetricsDefault];//add

        printf("2");
        
        
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pics.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger row=indexPath.row;
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
       
        UIView* rotateView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 80 , 80)];
        [rotateView setBackgroundColor:[UIColor blueColor]];
        rotateView.transform=CGAffineTransformMakeRotation(M_PI * 90 / 180);
        rotateView.center=CGPointMake(45, 45);
        [cell.contentView addSubview:rotateView];
        [rotateView release];
        
        UIImageView* imv=[[UIImageView alloc] initWithImage:[pics objectAtIndex:row]];
        [imv setBackgroundColor:[UIColor clearColor]];
        [imv setFrame:CGRectMake(0, 0, 80, 80)];
        [imv setClipsToBounds:YES];
        [imv setContentMode:UIViewContentModeScaleAspectFill];
        
        [imv.layer setBorderColor:[UIColor whiteColor].CGColor];
        [imv.layer setBorderWidth:2.0f];
        
        [rotateView addSubview:imv];
        [imv release];
        
        UIButton*   btn_delete=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn_delete setFrame:CGRectMake(0, 0, 22, 22)];
        [btn_delete setImage:[UIImage imageNamed:@"close-circled.png"] forState:UIControlStateNormal];
        
        [btn_delete setCenter:CGPointMake(5, 5)];//70 10
        [btn_delete addTarget:self action:@selector(deletePicHandler:) forControlEvents:UIControlEventTouchUpInside];
        [btn_delete setTag:row];
        
        [rotateView addSubview:btn_delete];
    }
    
    return cell;
}

-(void)deletePicHandler:(UIButton*)btn
{
    [pics removeObjectAtIndex:btn.tag];
    [self updateTableView];
}

-(void)updateTableView
{
    if (pics.count>0) {
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
    
    if (pics.count>3) {
        CGFloat offsetY=tbv.contentSize.height-tbv.frame.size.height-(320-90);
        [tbv setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }else{
        [tbv setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //[btn_addCover.imageView setImage:image forState:UIControlStateNormal];
    
    //[picker dismissModalViewControllerAnimated:YES];
    if (pics.count>=10) {
        return;
    }
    
    [pics addObject:image];
    [self updateTableView];
}
-(void)doneSelect:(id)sender
{
    printf("doned");
    if (delegate && [delegate respondsToSelector:@selector(imagePickerMutilSelectorDidGetImages:)]) {
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
    [self release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    
    float kScreenHeight=0;
    if (IS_IPHONE_5) {
        kScreenHeight=568;
    }
    else{
        kScreenHeight=480;
    }
    
    selectedPan=[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-131, 320, 131)];//480
    [selectedPan setBackgroundColor:[UIColor blackColor]];
    
    textlabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 13, 300, 14)];
    [textlabel setBackgroundColor:[UIColor clearColor]];
    [textlabel setFont:[UIFont systemFontOfSize:14.0f]];
    [textlabel setTextColor:[UIColor whiteColor]];
    [textlabel setText:@"当前选中0张(最多10张)"];
    [selectedPan addSubview:textlabel];
    [textlabel release];
    
    btn_done=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_done setFrame:CGRectMake(530/2, 5, 47, 31)];
    [btn_done setEnabled:NO];
    [btn_done setImage:[UIImage imageNamed:@"build-before.png"] forState:UIControlStateNormal];//btn_navigationbar_done

    [btn_done addTarget:self action:@selector(doneSelect:) forControlEvents:UIControlEventTouchUpInside];//add
    
    [selectedPan addSubview:btn_done];
    
    tbv=[[UITableView alloc] initWithFrame:CGRectMake(0, 50, 90, 320) style:UITableViewStylePlain];
    
    tbv.transform=CGAffineTransformMakeRotation(M_PI * -90 / 180);
    tbv.center=CGPointMake(160, 131-90/2);
    [tbv setRowHeight:100];
    [tbv setShowsVerticalScrollIndicator:NO];
    [tbv setPagingEnabled:YES];
    
    tbv.dataSource=self;
    tbv.delegate=self;
    
    //[tbv setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    
    [tbv setBackgroundColor:[UIColor clearColor]];
    
    [tbv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [selectedPan addSubview:tbv];
    [tbv release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)dealloc
{
    printf("相册dealloc");
    for (int i=0; i<self.view.subviews.count; ++i) {
        UIView * _v=[self.view.subviews objectAtIndex:i];
        for (int j=0; j<_v.subviews.count; ++j) {
            UIView * _v_v=[_v.subviews objectAtIndex:j];
            [_v_v removeFromSuperview];
        }
        [_v removeFromSuperview];
    }
    
    [delegate release],delegate=nil;
    [pics removeAllObjects];//add
    [pics release];
    
    [imagePicker.view removeFromSuperview];
    [imagePicker release],imagePicker=nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)addImageToArray:(NSArray*)arr
{
    [btn_done setEnabled:YES];
    [btn_done setImage:[UIImage imageNamed:@"build-after.png"] forState:UIControlStateNormal];
    for (int i=0; i<arr.count; ++i) {
        [pics addObject:[arr objectAtIndex:i]];
    }
}
+(void)showInViewController:(UIViewController<UIImagePickerControllerDelegate,MHImagePickerMutilSelectorDelegate> *)vc  withArr:(NSArray*)arry
{
    MHImagePickerMutilSelector* imagePickerMutilSelector=[[MHImagePickerMutilSelector alloc] init] ;//自动释放
    imagePickerMutilSelector.delegate=vc;//设置代理
    if (arry!=Nil) {//添加
        [imagePickerMutilSelector addImageToArray:arry];
    }
    UIImagePickerController* picker=[[UIImagePickerController alloc] init]  ;
    picker.delegate=imagePickerMutilSelector;//将UIImagePicker的代理指向到imagePickerMutilSelector
    [picker setAllowsEditing:NO];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalTransitionStyle= UIModalTransitionStyleCoverVertical;
    picker.navigationController.delegate=imagePickerMutilSelector;//将UIImagePicker的导航代理指向到imagePickerMutilSelector
    imagePickerMutilSelector.imagePicker=picker;//使imagePickerMutilSelector得知其控制的UIImagePicker实例，为释放时需要。

    [picker.view addSubview:imagePickerMutilSelector.selectedPan];
    [imagePickerMutilSelector.selectedPan release];
    
    [vc presentViewController:picker animated:YES completion:NULL];
}

@end
