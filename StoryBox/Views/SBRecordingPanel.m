//
//  SBRecordingPanel.m
//  StoryBox
//
//  Created by spacewander on 14-6-25.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import "SBRecordingPanel.h"
#import "SBAudioRecorder.h"

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
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        canPlayAudio = [self canPlayAudio];
        
        self.opaque = NO;
        recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [recordBtn setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
        [recordBtn setTag:0];
        [recordBtn setSelected:NO];
        [self addSubview:recordBtn];
        
        playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [playBtn setTag:1];
        [playBtn setSelected:NO];
        [self addSubview:playBtn];
        
//        280,200, 30, 80
        [recordBtn setFrame:CGRectMake(0, 50, 30, 30)];
        [recordBtn addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchDown];
        [playBtn setFrame:CGRectMake(0, 0, 30, 30)];
        [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchDown];
        
        // 假如可以播放音频
        if (canPlayAudio) {
            // 变为只显示播放按钮
            recordBtn.hidden = YES;
        }
        else { // 否则得先录音
            playBtn.enabled = NO;
        }
    }
    return self;
}

- (void) record
{
    if(recording)
    {
        [recordBtn setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
        recording = NO;
        playBtn.enabled = YES;
    }
    else
    {
        [recordBtn setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        recording = YES;
    }
    
    [[SBAudioRecorder sharedAudioRecord] startRecord];
}

- (void) play
{
    [[SBAudioRecorder sharedAudioRecord] playRecord];
}

- (BOOL) canPlayAudio
{
//    return [[SBAudioRecorder sharedAudioRecord] checkSoundAndSetup:imageURL];// 思来想去还是不用判断是否曾经有过音频了。因为一个故事盒子可能有多个图片，假如有些图片有音频，有些图片没有音频，应该算是有还是没有音频呢？
    return NO;
}
@end
