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

- (id)initWithFrame:(CGRect)frame andWithImageURL:(NSURL *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        imageURL = url;
        canPlayAudio = [self canPlayAudio];
        
        self.opaque = NO;
        recordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [recordBtn setTitle:@"录音" forState:UIControlStateNormal];
        [self addSubview:recordBtn];
        
        playBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [self addSubview:playBtn];
        
        // 假如可以播放音频
        if (canPlayAudio != NO) {
            [recordBtn setFrame:CGRectMake(0, 10, 40, 30)];
            [playBtn setFrame:CGRectMake(60, 10, 40, 30)];
        }
        else { // 否则得先录音
            [recordBtn setFrame:CGRectMake(30, 10, 40, 30)];
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
    return NO;
}
@end
