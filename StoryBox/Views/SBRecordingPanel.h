//
//  SBRecordingPanel.h
//  StoryBox
//
//  Created by spacewander on 14-6-25.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  要放在主界面上的录音/播放面板
 */
@interface SBRecordingPanel : UIView
{
    UIButton *recordBtn;
    UIButton *playBtn;
    BOOL canPlayAudio;
    BOOL recording;
}

-(id) initWithFrame:(CGRect)frame;
@end
