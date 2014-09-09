//
//  SBViewerView.m
//  StoryBox
//
//  Created by bin on 14-7-10.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import "SBViewerView.h"
#import "SBAudioRecorder.h"

@implementation SBViewerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        // Initialization code
        if(IS_IPHONE_5)
        {
            [self setFrame:CGRectMake(0, 0, 320, 568)];
        }
        else
        {
            [self setFrame:CGRectMake(0, 0, 320, 480)];
        }
//        imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,80,320,480)];
        [self initNavigationBar];
        [self initImageScrollView];
        [self setBackgroundColor:[UIColor blackColor]];
        [self bringSubviewToFront:NavigationView];


    }
    return self;
}

-(id)initWithImage:(UIImage *)image withImageURL:(NSURL *)imageURL
{
    self = [super init];

    if(IS_IPHONE_5)
    {
        [self setFrame:CGRectMake(0, 0, 320, 568)];
    }
    else
    {
        [self setFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    [self setBackgroundColor:[UIColor blackColor]];
    
    float scale = 320.0 / image.size.width;
    viewHeight = scale * image.size.height;
    
    [self initNavigationBar];
    [self initImageScrollView];
    imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0, 0, 320, viewHeight)];
    
    [imageScrollView addSubview:imageView];
    [self addSubview:imageScrollView];
    
    [self bringSubviewToFront:NavigationView];
    
    BOOL hasSoundFile = [[SBAudioRecorder sharedAudioRecord] checkSoundAndSetup:imageURL];
    if(hasSoundFile)
    {
        playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playBtn setFrame:CGRectMake(280,250, 30, 30)];
        [playBtn setSelected:NO];
        [playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(clickPlay:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playBtn];
        playing = false;
    }
    return self;
}
     
-(void)clickPlay:(id)sender
{
    if(playing)
    {
        NSLog(@"pause");
        playing = false;
        [[SBAudioRecorder sharedAudioRecord] stopPlayRecord];
        [playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"play");
        playing = true;
        timer =  [NSTimer scheduledTimerWithTimeInterval:[[SBAudioRecorder sharedAudioRecord] playRecord] target:self selector:@selector(playEnd:) userInfo:nil repeats:NO];
;
        [playBtn setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    }
}

-(void)playEnd:(id)sender
{
    playing = false;
    [playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];

}

-(void)initImageScrollView
{
    // Do any additional setup after loading the view, typically from a nib.
    imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,45,320,480)];

    imageScrollView.backgroundColor = [UIColor whiteColor];
    imageScrollView.showsVerticalScrollIndicator = NO; //垂直方向的滚动指示
    imageScrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    imageScrollView.delegate = self;
    [imageScrollView setContentSize:CGSizeMake(320, viewHeight + 45)];
    [imageScrollView setBackgroundColor:[UIColor blackColor]];
}

/**
 *  导航条布局
 */
-(void)initNavigationBar
{
    NavigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    [NavigationView setBackgroundColor:[UIColor colorWithRed:(28.0/255) green:(33.0/255) blue:39.0/255 alpha:0.95]];
    [self addSubview:NavigationView];
    
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(20, 15, 40,15)];
    [back setImage:[UIImage imageNamed:@"titleBackBtn.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backEdit:) forControlEvents:UIControlEventTouchUpInside];
    [NavigationView addSubview:back];
}

/**
 *  返回按钮触发
 *
 *  @param sender
 */
-(void)backEdit:(id)sender
{
    // 停止播放录音
    [[SBAudioRecorder sharedAudioRecord] stopPlayRecord];
    [self.delegate hiddenTopView:NO];
    [self removeFromSuperview];
}



@end
