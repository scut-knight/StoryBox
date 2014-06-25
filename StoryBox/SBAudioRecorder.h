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
    AVAudioPlayer * audioPlayer;
    NSURL *currentPictureRecordURL;
    BOOL currentPicturehasRecord;
}
- (void)initAudioRecord;
- (void)startRecord;

- (void)connectToSoundDictionary;
- (void)writeSoundDictionaryToFile;
+ (SBAudioRecorder *)sharedAudioRecord;
- (void)addRecord:(NSString *)picPath;
-(void)playRecord;
- (BOOL)checkSoundAndSetup:(NSString *)picPath;

@property (strong,nonatomic) NSMutableDictionary * soundDictionary;
@property (strong,nonatomic) NSString *filePath;

@end
