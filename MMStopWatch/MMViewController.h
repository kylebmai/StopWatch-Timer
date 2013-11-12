//
//  MMViewController.h
//  MMStopWatch
//
//  Created by Kyle Mai on 9/20/13.
//  Copyright (c) 2013 Kyle Mai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface MMViewController : UIViewController <UIAlertViewDelegate, AVAudioPlayerDelegate, AVAudioSessionDelegate>
{
    AVAudioPlayer *audioPlayer;
}
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic) int stopWatchTime;
@property (nonatomic) int long timerTime;

@end
