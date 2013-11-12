//
//  MMAppDelegate.h
//  MMStopWatch
//
//  Created by Kyle Mai on 9/20/13.
//  Copyright (c) 2013 Kyle Mai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MMViewController.h"


@interface MMAppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>
{
    MMViewController *MMVC;
    NSDate *sleepStopWatchTime;
    NSDate *sleepTimerTime;
    NSDate *wakeupStopWatchTime;
    NSDate *wakeupTimerTime;
}

@property (strong, nonatomic) UIWindow *window;

@end
