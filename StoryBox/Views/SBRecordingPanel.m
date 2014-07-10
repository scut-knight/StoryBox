//
//  SBRecordingPanel.m
//  StoryBox
//
//  Created by spacewander on 14-6-25.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import "SBRecordingPanel.h"

@interface SBRecordingPanel ()

- (void) record;
- (void) play;
- (BOOL) canPlayAudio;
@end

@implementation SBRecordingPanel

/**
 *  初始化录音面板
 *
 *  @param frame 面板宽为100，高为50
 *  @param url   图片URL
 */
- (id)initWithFrame:(CGRect)frame andWithImageURL:(NSURL *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        imageURL = url;
        canPlayAudio = [self canPlayAudio];
        
        self.opaque = NO;
        recordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [recordBtn setImage:[UIImage imageNamed:@"recording.png"] forState:UIControlStateNormal];
        [self addSubview:recordBtn];
        
        playBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self addSubview:playBtn];
        
        // 假如可以播放音频
        if (canPlayAudio) {
//            [recordBtn setFrame:CGRectMake(0, 10, 40, 40)];
//            [recordBtn addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchDown];
//            [playBtn setFrame:CGRectMake(60, 10, 40, 40)];
//            [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchDown];
            // 变为只显示播放按钮
            [playBtn setFrame:CGRectMake(30, 10, 40, 40)];
            [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchDown];
            recordBtn.hidden = YES;
        }
        else { // 否则得先录音
            [recordBtn setFrame:CGRectMake(30, 10, 40, 40)];
            [recordBtn addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchDown];
            playBtn.hidden = YES;
        }
    }
    return self;
}

- (void) record
{
    
}

- (void) play
{
    
}

- (BOOL) canPlayAudio
{
    return YES;
}
@end
