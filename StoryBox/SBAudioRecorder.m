//
//  SBAudioRecorder.m
//  StoryBox
//
//  Created by bin on 14-6-23.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import "SBAudioRecorder.h"

@implementation SBAudioRecorder
@synthesize soundDictionary,filePath;

+ (SBAudioRecorder *)sharedAudioRecord
{
    static SBAudioRecorder *sharedAudioRecordInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAudioRecordInstance = [[self alloc] init];
        [sharedAudioRecordInstance initAudioRecord];
    });
    return sharedAudioRecordInstance;
}

- (void)initAudioRecord
{
//     audioSession = [AVAudioSession sharedInstance];
    recording = NO;
    [self connectToSoundDictionary];
}

- (void)startRecord
{
    NSError *error;
    audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    [audioSession setActive:YES error: &error];

    if (!recording)
    {
        recording = YES;
    
        NSDictionary *setting = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat: 44100.0],AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey, [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey, [NSNumber numberWithInt: 2], AVNumberOfChannelsKey, [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey, [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,nil];

        currentPictureRecordURL = [self formSoundFileURL:recordNumber];
        
        recorder = [[AVAudioRecorder alloc] initWithURL:currentPictureRecordURL settings:setting error:nil];
        
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        [recorder record];
        NSLog(@"start");
        }
        else
        {
            NSLog(@"stop");
            recording = NO;
            [audioSession setActive:NO error:nil];
            [recorder stop];
        }
}

-(void)playRecord
{
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:currentPictureRecordURL error:&error];
    NSLog(@"err:%@",error);
    audioPlayer.volume = 1.0;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
    NSLog(@"%i",audioPlayer.isPlaying);
}


-(NSURL *)formSoundFileURL:(int)soundNum
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString * fullDir = [documentsDirectory stringByAppendingPathComponent:@"SoundRecord"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error=nil;
    if (![fileManager fileExistsAtPath:fullDir])
    {
        [fileManager createDirectoryAtPath:fullDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString * fullPath = [NSString stringWithFormat:@"%@/%i.caf",fullDir,soundNum];
    
    NSURL * url = [NSURL URLWithString:[fullPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    return url;
}

- (void)addRecord:(NSString *)picPath
{
    NSString *soundFile = [NSString stringWithFormat:@"%i",recordNumber];
    [soundDictionary setObject:soundFile forKey:picPath];
    [self writeSoundDictionaryToFile];
    recordNumber ++;
    NSLog(@"add done");
}

- (void)connectToSoundDictionary
{
    //读取声音字典
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    filePath = [documentsDirectory stringByAppendingPathComponent:@"soundDictionary.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        soundDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }
    else
    {
        soundDictionary = [[NSMutableDictionary alloc] init];
    }
    recordNumber = [soundDictionary count];
    NSLog(@"count:%i",recordNumber);
}

- (void)writeSoundDictionaryToFile
{
    [soundDictionary writeToFile:filePath atomically:YES];
    NSLog(@"soundDictionaryPath:%@",filePath);
}

- (BOOL)checkSoundAndSetup:(NSURL *)picPath
{
    NSString * name = [soundDictionary objectForKey:picPath];
    if(name)
    {
        int soundNum = [name intValue];
        NSLog(@"找到声音记录:%i",soundNum);
        currentPictureRecordURL = [self formSoundFileURL:soundNum];
        currentPicturehasRecord = YES;
        return YES;
    }
    else
    {
        NSLog(@"没有声音记录");
        currentPicturehasRecord = NO;
    }
    return NO;
}
@end
