//
//  SBAudioRecorder.h
//  StoryBox
//
//  Created by bin on 14-6-23.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface SBAudioRecorder : NSObject
{
    AVAudioSession * audioSession;
//    NSURL *tempFilePath;
    AVAudioRecorder *recorder;
    BOOL recording;
    int recordNumber;
}
- (void)initAudioRecord;
- (void)startRecord;
- (void)saveToFile;

- (void)connectToSoundDictionary;
- (void)writeSoundDictionaryToFile;
+ (SBAudioRecorder *)sharedAudioRecord;
- (void)addRecord:(NSString *)picPath;

@property (strong,nonatomic) NSMutableDictionary * soundDictionary;
@property (strong,nonatomic) NSString *filePath;
//luyin{
//    AVAudioSession * audioSession = [AVAudioSession sharedInstance]; if (!recording) {
//        recording = YES;
//        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
//        [audioSession setActive:YES error:nil];
//        [LuBut setTitle:@"停止" forState:UIControlStateNormal];
@end
