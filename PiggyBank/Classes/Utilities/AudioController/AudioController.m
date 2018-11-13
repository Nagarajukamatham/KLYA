//
//  AudioController.m
//  PiggyBank
//
//  Created by Nagaraju on 02/05/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "AudioController.h"
@import AVFoundation;

@interface AudioController () <AVAudioPlayerDelegate>
@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (assign) BOOL backgroundMusicPlaying;
@property (assign) BOOL backgroundMusicInterrupted;
@property (assign) SystemSoundID pewPewSound;
@end

@implementation AudioController

#pragma mark - Public

- (instancetype)init
{
    self = [super init];
    if (self) {
       // [self configureAudioSession];
    }
    return self;
}


- (void)playSystemSound:(NSString*)soundName{
    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"wav"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &_pewPewSound);
    AudioServicesPlaySystemSound(self.pewPewSound);
}

#pragma mark - Private

- (void) configureAudioSession {
    // Implicit initialization of audio session
    self.audioSession = [AVAudioSession sharedInstance];
    
    // Set category of audio session
    // See handy chart on pg. 46 of the Audio Session Programming Guide for what the categories mean
    // Not absolutely required in this example, but good to get into the habit of doing
    // See pg. 10 of Audio Session Programming Guide for "Why a Default Session Usually Isn't What You Want"
    
    NSError *setCategoryError = nil;
    if ([self.audioSession isOtherAudioPlaying]) { // mix sound effects with music already playing
        [self.audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];
        self.backgroundMusicPlaying = NO;
    } else {
        [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    }
    if (setCategoryError) {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
    }
}

@end
