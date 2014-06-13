//
//  ShareView.m
//  LKTQ
//
//  Created by mac on 13-12-27.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import "ShareView.h"
#import "CameraCustom.h"
#import "UITitleLabel.h"

@implementation ShareView

- (id)initWithFrame:(CGRect)frame  withImageVA:(NSMutableArray*)imageVA withTextEditVA:(NSMutableArray *)textEVA
{
    self = [super initWithFrame:frame];
    if (self)
    {
        imageVArr = imageVA;
        textEditVArr = textEVA;
        
        [CameraCustom photoMerge:imageVArr textViewArray:textEditVArr];     //合成
        NSLog(@"path1=%@",self.pathImageM);
       
        [self viewLoad];
        [self initIconShare];                                               //添加社会化分享按钮
        
    }
    return self;
}

-(void)viewLoad
{
    bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [bg setImage:[UIImage imageNamed:@"shareView_bg-color.png"]];
    [self addSubview:bg];
    
    //顶部导航栏
    topView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [topView setImage:[UIImage imageNamed:@"Navigation.png"]];
    [self addSubview:topView];

    //返回按钮
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(10,32, 40, 14)];//(230, 280, 50, 50)
    [backBtn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    //继续制作按钮
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(233,32, 77,15)];//(230, 280, 50, 50)
//    [homeBtn setTitle:@"首页" forState:UIControlStateNormal];
    [homeBtn setImage:[UIImage imageNamed:@"homeBtn.png"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(clickHome:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:homeBtn];
    
    //分开保存到相册按钮，已失效
//    outputBtn=[UIButton buttonWithType:UIButtonTypeCustom];
////    [outputBtn setTitle:@"保存所有的照片到手机相册" forState:UIControlStateNormal];
//    [outputBtn setImage:[UIImage imageNamed:@"Singlesave.png"] forState:UIControlStateNormal];
//    [outputBtn setFrame:CGRectMake(45,98, 230, 44)];
//    [outputBtn addTarget:self action:@selector(clickOutput:) forControlEvents:UIControlEventTouchUpInside];
////    [self addSubview:outputBtn];
    
    //合并保存按钮
    outputAllBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [outputAllBtn setImage:[UIImage imageNamed:@"Mergesave.png"] forState:UIControlStateNormal];
//    [outputAllBtn setFrame:[positionSwitch switchRect:CGRectMake(45,80, 230, 44)]];//(230, 280, 50, 50)
    [outputAllBtn setFrame:CGRectMake(45,98, 230, 44)];//(45,168, 230, 44)
    [outputAllBtn addTarget:self action:@selector(clickOutputAll:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:outputAllBtn];
    
    //社会化分享按钮容器
    self.pannerShareView = [[UIView alloc]initWithFrame:CGRectMake(0, 238, 320, 220)];
    self.pannerShareView.alpha = 0.8;
    [self addSubview:self.pannerShareView];
    
    label = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
    [label setImage:[UIImage imageNamed:@"labale_shareView.png"]];
    [self.pannerShareView addSubview:label];
}

/**
 *  初始化社会化分享按钮
 */
-(void)initIconShare
{
    //目前设置只有两个按钮
    int num = 2;
    UIButton* iconBtn;
    int gap = 74;
    //分两行，每行4个图标
    for (int i=0; i<num; ++i)
    {
        int rows = 0;
        if (i<4)
        {
            rows = 0;
        }
        else if(i<8)
        {
            rows = 1;
        }
        
        iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconBtn setFrame:CGRectMake(24+i%4*gap, 36+74*rows, 50, 50)];
        [iconBtn setTag:i];
        [iconBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shareIcon%d.png",i]] forState:UIControlStateNormal];
        [iconBtn addTarget:self action:@selector(clickIcon:) forControlEvents:UIControlEventTouchUpInside];
      
        //把按钮添加到容器中并置于前端
        [self.pannerShareView addSubview:iconBtn];
        [self.pannerShareView bringSubviewToFront:iconBtn];
        
    }
}

/**
 *  接收所有社会化分享按钮的触发事件
 *
 *  @param sender
 */
-(void)clickIcon:(id)sender
{
    int flag = [sender tag];
    NSLog(@"分享方式:%d",flag);
    //获取分享相片
    self.pathImageM = [CameraCustom pathOfImageOfBox];
    [self getShareTypeSocial:flag];
    [self initCustomShareInter];
}

/**
 *  返回按钮触发
 *
 *  @param sender
 */
-(void)clickBack:(id)sender
{
    NSLog(@"back");
    
    [self.delegate reloadimageView];
    [self.delegate resetTitleView];
   
    [self removeFromSuperview];
}

/**
 *  继续制作按钮触发
 *
 *  @param sender
 */
-(void)clickHome:(id)sender
{
    NSLog(@"homeBtn");

    [self.delegate clear];
}


//-(void)clickOutput:(id)sender
//{
//      printf("output");
// 
//    [CameraCustom saveAllImageOneByOne: imageVArr textViewArray:textEditVArr];
//    
//    [sender setImage:[UIImage imageNamed:@"Singlefinish.png"] forState:UIControlStateNormal];
//    [sender setEnabled:NO];
//}

/**
 *  保存到相册按钮触发
 *
 *  @param sender
 */
-(void)clickOutputAll:(id)sender
{
    NSLog(@"output");

    //获取拼接后的图片
    self.pathImageM = [CameraCustom pathOfImageOfBox];
    self.img_Merged = [UIImage imageWithContentsOfFile:self.pathImageM];
    //保存到相册
    [CameraCustom saveImage_merged:self.img_Merged];
    
    //更改保存按钮样式并使其失效
    [sender setImage:[UIImage imageNamed:@"Mergefinish.png"] forState:UIControlStateNormal];
    [sender setEnabled:NO];
}

/**
 *  获取分享类型
 *
 *  @param index 按钮序号
 */
-(void)getShareTypeSocial:(int)index
{
    switch (index)
    {
        case 0:
            shareTypeSocial = ShareTypeWeixiTimeline ;//微信朋友圈
            break;
        case 1:
            shareTypeSocial = ShareTypeSinaWeibo; //新浪微博
            break;
        case 2:
            shareTypeSocial = ShareTypeWeixiSession;//微信好友
            break;
        case 3:
            shareTypeSocial = ShareTypeQQSpace;//QQ空间
            break;
        case 4:
            shareTypeSocial = ShareTypeRenren;//人人
            
            break;
        case 5:
            shareTypeSocial = ShareTypeDouBan;//豆瓣
            break;
        case 6:
            shareTypeSocial = ShareTypeTencentWeibo;//腾讯微博
            break;
        case 7:
            shareTypeSocial = ShareTypeQQ;//QQ好友
            break;
        default:
            break;
    }
    
}

/**
 *  调用社交分享接口
 */
-(void)initCustomShareInter
{
    
    @autoreleasepool
    {
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil               //分享视图标题
                                                                  oneKeyShareList:nil               //一键分享菜单
                                                                   qqButtonHidden:NO                //QQ分享按钮是否隐藏
                                                            wxSessionButtonHidden:NO                //微信好友分享按钮是否隐藏
                                                           wxTimelineButtonHidden:NO                //微信朋友圈分享按钮是否隐藏
                                                             showKeyboardOnAppear:NO                //是否显示键盘
                                                                shareViewDelegate:nil               //分享视图委托
                                                              friendsViewDelegate:nil               //好友视图委托
                                                            picViewerViewDelegate:nil];             //图片浏览视图委托
        
        
        
        //    NSString *imagePath =[CameraCustom returnPathImage];
        //构造分享内容
        
        SSPublishContentMediaType  mediaType;
        
        //如果是分享到微信朋友圈，则设定为图片消息类型，否则为新闻消息类型
        if (shareTypeSocial == ShareTypeWeixiTimeline)
        {
            mediaType = SSPublishContentMediaTypeImage;
        }
        else
        {
            mediaType = SSPublishContentMediaTypeNews;
        }
        id<ISSContent> publishContent = [ShareSDK content:@"分享内容:该消息来自故事盒子，分享瞬间美好，留住回忆人生"
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK imageWithPath: self.pathImageM]
                                                    title:@"故事盒子"
                                                      url:@"http://www.sharesdk.cn"
                                              description:@"这是一条测试信息"
                                                mediaType:mediaType];
        
        //授权选项
//        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
        
        //判断
//        id<ISSPlatformUser> userAuth=[ShareSDK currentAuthUserWithType:shareTypeSocial];
     
        //    [ShareSDK cancelAuthWithType:shareTypeSocial];
        //    if ([ShareSDK hasAuthorizedWithType:shareTypeSocial]) {
        //        //授权
        //        [ShareSDK authWithType:shareTypeSocial                                              //需要授权的平台类型
        //                    options:authOptions                                          //授权选项，包括视图定制，自动授权//nil
        //                        result:^(SSAuthState state, id<ICMErrorInfo> error) {       //授权返回后的回调方法
        //                            if (state == SSAuthStateSuccess)
        //                            {
        //                                NSLog(@"授权成功");
        //                                [ShareSDK showShareViewWithType:shareTypeSocial
        //                                                      container:[ShareSDK container]
        //                                                        content:publishContent
        //                                                  statusBarTips:YES
        //                                                    authOptions:nil
        //                                                   shareOptions:shareOptions
        //                                                         result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
        //
        //                                                             if (state == SSPublishContentStateSuccess)
        //                                                             {
        //                                                                 NSLog(@"分享成功");
        //                                                                 [self removeFromSuperview];
        //                                                             }
        //                                                             else if (state == SSPublishContentStateFail)
        //                                                             {
        //                                                                 NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
        //                                                             }
        //                                                         }];
        //                            }
        //                            else if (state == SSAuthStateFail)
        //                            {
        //                                NSLog(@"授权失败");
        //                            }
        //                        }];
        //
        //
        //    }
        //    else
        //    {
        
        [ShareSDK showShareViewWithType:shareTypeSocial
                              container:[ShareSDK container]
                                content:publishContent
                          statusBarTips:YES
                            authOptions:nil
                           shareOptions:shareOptions
                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
        {
            if (state == SSPublishContentStateSuccess)
            {
                 NSLog(@"分享成功");
                 //                                         [self removeFromSuperview];
                 UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                 [alert setTag:0];
                 [alert show];
            }
            else if (state == SSPublishContentStateFail)
            {
                 NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                 UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"分享失败，重试" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                 [alert setTag:1];
                 [alert show];
             
            }
        }];
        
        
        //    }
        //    //构造显示容器
        //    id<ISSContainer>container=[ShareSDK container];
        //
        //    //弹出分享菜单
        //    [ShareSDK showShareActionSheet:container
        //                         shareList:nil
        //                           content:publishContent
        //                     statusBarTips:YES
        //                       authOptions:nil
        //                      shareOptions:shareOptions                    //传入分享选项对象
        //                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
        //                                if (state == SSPublishContentStateSuccess)
        //                                {
        //                                    NSLog(@"分享成功");
        //                                }
        //                                else if (state == SSPublishContentStateFail)
        //                                {
        //                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
        //                                }
        //                            }];
        
    }
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0)
    {//成功
//        [self removeFromSuperview];
    }
    else//失败
    {
        
    }
}

/**
 *  移除界面元素
 */
-(void)clearView
{
    [bg removeFromSuperview];
    [topView removeFromSuperview];
    [label removeFromSuperview];
    [self.pannerShareView removeFromSuperview];

//    for (int j=0; j<self.subviews.count;++j) {
//        UIView * _v=[self.subviews objectAtIndex:j];
//        for (int i=0; i<_v.subviews.count; ++i) {
//            UIView * t=[_v.subviews objectAtIndex:i];
//            [t removeFromSuperview];
//        }
//        [_v removeFromSuperview];
//        
//    }
}

-(void)dealloc
{
    [self clearView];
    printf("shareviw dealloc,");
}

@end
