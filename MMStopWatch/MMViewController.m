//
//  MMViewController.m
//  MMStopWatch
//
//  Created by Kyle Mai on 9/20/13.
//  Copyright (c) 2013 Kyle Mai. All rights reserved.
//

#import "MMViewController.h"
#import "MMRoundButton.h"
#import <QuartzCore/QuartzCore.h>


@interface MMViewController ()
{
    //main view controller
    MMRoundButton *stopWatchButton;
    MMRoundButton *timerButton;
    MMRoundButton *startButton;
    MMRoundButton *pauseButton;
    MMRoundButton *resetButton;
    MMRoundButton *setButton;
    MMRoundButton *cancelButton;
    NSTimer *stopWatchTimer;
    NSTimer *timerWatchTimer;
    UIView *pickerViewBackground;
    UIView *pickerView;
    UILabel *hourCountLabel;
    UILabel *timeLabel;
    UILabel *hourLabel;
    UILabel *minuteLabel;
    UILabel *secondLabel;
    UISlider *hourSlider;
    UISlider *minSlider;
    UISlider *secSlider;

    BOOL isTimer;
    BOOL shouldStopWatchLabelRun;
    BOOL shouldTimerWatchLabelRun;
    BOOL stopWatchStartButtonState;
    BOOL stopWatchPauseButtonState;
    BOOL timerStartButtonState;
    BOOL timerPauseButtonState;
    
    int long hourPickerValue;
    int long minutePickerValue;
    int long secondPickerValue;
    int long totalHoursInSecond;
    int long totalMinutesInSecond;
    int long totalSecondsInSecond;
}


@end

@implementation MMViewController

@synthesize audioPlayer;
@synthesize stopWatchTime;
@synthesize timerTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    //Audio session
//    [[AVAudioSession sharedInstance] setDelegate:self];
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //Initialize stuff
    stopWatchButton = [[MMRoundButton alloc] init];
    timerButton = [[MMRoundButton alloc] init];
    startButton = [[MMRoundButton alloc] init];
    pauseButton = [[MMRoundButton alloc] init];
    resetButton = [[MMRoundButton alloc] init];
    setButton = [[MMRoundButton alloc] init];
    cancelButton = [[MMRoundButton alloc] init];
    timerTime = 0;
    stopWatchTime = 0;
    shouldStopWatchLabelRun = NO;
    shouldTimerWatchLabelRun = NO;
    
    //Initialize UISliders
    hourSlider = [[UISlider alloc] init];
    [hourSlider addTarget:self action:@selector(updateHourSlider) forControlEvents:UIControlEventValueChanged];
    
    minSlider = [[UISlider alloc] init];
    [minSlider addTarget:self action:@selector(updateMinSlider) forControlEvents:UIControlEventValueChanged];
    
    secSlider = [[UISlider alloc] init];
    [secSlider addTarget:self action:@selector(updateSecSlider) forControlEvents:UIControlEventValueChanged];
    
    //Initialize  timer setting views
    pickerViewBackground = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    pickerViewBackground.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7];
    
    pickerView = [[UIView alloc] initWithFrame:CGRectMake(50.0, 100.0, 220.0, 368.0)];
    pickerView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.9];
    pickerView.layer.cornerRadius = 20;
    
    //Put in a background 1136x1136 to cover landscape mode
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"furb"]];
    [self.view addSubview:background];
    
    //Creating buttons
    [stopWatchButton makeButtonWithView:self.view Name:@"Stop Watch" Xaxis:40.0 Yaxis:40.0 radius:100];
    [stopWatchButton setButtonTitleFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0]];
    [stopWatchButton setButtonBorderColor:[UIColor whiteColor] borderWidth:2];
    [stopWatchButton setButtonBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.5] forState:UIControlStateNormal];
    [stopWatchButton setButtonBackgroundColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [stopWatchButton addButtonTarget:self setAction:@selector(stopWatchAction:)];
    
    [timerButton makeButtonWithView:self.view Name:@"Timer" Xaxis:180.0 Yaxis:40.0 radius:100];
    [timerButton setButtonTitleFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0]];
    [timerButton setButtonBorderColor:[UIColor whiteColor] borderWidth:2];
    [timerButton setButtonBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.5] forState:UIControlStateNormal];
    [timerButton setButtonBackgroundColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [timerButton addButtonTarget:self setAction:@selector(timerWatchAction:)];
    
    [startButton makeButtonWithView:self.view Name:@"Start" Xaxis:40.0 Yaxis:440.0 radius:60];
    [startButton setButtonTitleFont:[UIFont fontWithName:@"Roboto-Light" size:15.0]];
    [startButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
    [startButton setButtonBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.5] forState:UIControlStateNormal];
    [startButton setButtonBackgroundColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [startButton addButtonTarget:self setAction:@selector(startAction:)];
    
    [pauseButton makeButtonWithView:self.view Name:@"Pause" Xaxis:130.0 Yaxis:440.0 radius:60];
    [pauseButton setButtonTitleFont:[UIFont fontWithName:@"Roboto-Light" size:15.0]];
    [pauseButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
    [pauseButton setButtonBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.5] forState:UIControlStateNormal];
    [pauseButton setButtonBackgroundColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [pauseButton addButtonTarget:self setAction:@selector(pauseAction:)];
    
    [resetButton makeButtonWithView:self.view Name:@"Reset" Xaxis:220.0 Yaxis:440.0 radius:60];
    [resetButton setButtonTitleFont:[UIFont fontWithName:@"Roboto-Light" size:15.0]];
    [resetButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
    [resetButton setButtonBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.5] forState:UIControlStateNormal];
    [resetButton setButtonBackgroundColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [resetButton addButtonTarget:self setAction:@selector(resetAction:)];
    
    //Start initial state and override buttons layout
    [self initialState];
    
    //Adding watch output label
    [self watchOutputLabel];
    
    
}

- (void)watchOutputLabel
{
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 180.0, 320.0, 220.0)];
    timeLabel.text = @"00:00";
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont fontWithName:@"Roboto-Light" size:100.0];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    [self.view addSubview:timeLabel];
    
    hourCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 200.0, 150.0, 50.0)];
    hourCountLabel.text = @" 0 Hours";
    hourCountLabel.textColor = [UIColor whiteColor];
    hourCountLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20.0];
    //hourCountLabel.backgroundColor = [UIColor blueColor];
    [self.view addSubview:hourCountLabel];
}

/*
- (NSString *)stopWatchTimeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
*/

- (void)stopWatchTimeCounting
{
    stopWatchTime += 1;
    
    int seconds = stopWatchTime % 60;
    int minutes = (stopWatchTime / 60) % 60;
    int long hours = stopWatchTime / 3600;
    
    if (isTimer == NO) {
        timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        hourCountLabel.text = [NSString stringWithFormat:@"%2ld Hours", hours];
    }
}

- (void)timerWatchTimeCounting
{
    if (timerTime > 0) {
        timerTime -= 1;
    }
    else
    {
        timerTime = 0;              //Reset timer watch to 0
        totalHoursInSecond = 0;     //Reset hour to 0
        totalMinutesInSecond = 0;   //Reset minute to 0
        totalSecondsInSecond = 0;   //Reset second to 0
        hourPickerValue = 0;
        minutePickerValue = 0;
        secondPickerValue = 0;
        
        [timerWatchTimer invalidate];
        timerWatchTimer = nil;
        
        [startButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
        [startButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [startButton setEnable:YES];
        timerStartButtonState = YES;
        
        [pauseButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
        [pauseButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [pauseButton setEnable:YES];
        timerPauseButtonState = YES;
        
        //Setup sound to play
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat: @"banana"] ofType:@"mp3"]];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer setNumberOfLoops:-1];
        [self.audioPlayer play];
        
        UIAlertView *timerFinishedAlert = [[UIAlertView alloc] initWithTitle:@"Timer Has Finised!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"I Dare U Shut Me Up", nil];
        [timerFinishedAlert show];
    }
    
    int seconds = timerTime % 60;
    int minutes = (timerTime / 60) % 60;
    int long hours = timerTime / 3600;
    
    if (isTimer == YES) {
        timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        hourCountLabel.text = [NSString stringWithFormat:@"%2ld Hours", hours];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:0] isEqualToString:@"I Dare U Shut Me Up"])
    {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        
        UIAlertView *timerFinishedAlert = [[UIAlertView alloc] initWithTitle:@"Dave Says"
                                                                     message:@"You Are A Minion Abuser!"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Yes, yes I am"
                                                           otherButtonTitles: nil];
        [timerFinishedAlert show];
    }
}

- (void)initialState
{
    isTimer = NO;
    
    stopWatchStartButtonState = YES;
    stopWatchPauseButtonState = YES;
    timerStartButtonState = YES;
    timerPauseButtonState = YES;
    
    [stopWatchButton setButtonBorderColor:[UIColor orangeColor] borderWidth:2];
    [stopWatchButton setButtonBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [timerButton setButtonBorderColor:[UIColor whiteColor] borderWidth:2];
    [timerButton setButtonBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.5] forState:UIControlStateNormal];
}

- (void)checkButtonsStates
{
    if (isTimer == NO)
    {
        if (stopWatchTimer == nil) {
            timeLabel.text = @"00:00";
            stopWatchStartButtonState = YES;
            stopWatchPauseButtonState = YES;
        }
        
        if (stopWatchStartButtonState == YES) {
            [startButton setEnable:YES];
            [startButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
            [startButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            [startButton setEnable:NO];
            [startButton setButtonBorderColor:[UIColor lightGrayColor] borderWidth:1];
            [startButton setButtonTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        if (stopWatchPauseButtonState == YES) {
            [pauseButton setEnable:YES];
            [pauseButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [pauseButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
        }
        else {
            [pauseButton setEnable:NO];
            [pauseButton setButtonTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [pauseButton setButtonBorderColor:[UIColor lightGrayColor] borderWidth:1];
        }
    }
    else
    {
        if (timerWatchTimer == nil) {
            timeLabel.text = @"00:00";
            timerStartButtonState = YES;
            timerPauseButtonState = YES;
        }
        
        if (timerStartButtonState == YES) {
            [startButton setEnable:YES];
            [startButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
            [startButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            [startButton setEnable:NO];
            [startButton setButtonBorderColor:[UIColor lightGrayColor] borderWidth:1];
            [startButton setButtonTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        if (timerPauseButtonState == YES) {
            [pauseButton setEnable:YES];
            [pauseButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [pauseButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
        }
        else {
            [pauseButton setEnable:NO];
            [pauseButton setButtonTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [pauseButton setButtonBorderColor:[UIColor lightGrayColor] borderWidth:1];
        }
    }
}

- (IBAction)stopWatchAction:(id)sender
{
    [stopWatchButton setButtonBorderColor:[UIColor orangeColor] borderWidth:2];
    [stopWatchButton setButtonBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [timerButton setButtonBorderColor:[UIColor whiteColor] borderWidth:2];
    [timerButton setButtonBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.5] forState:UIControlStateNormal];
    
    isTimer = NO;
    
    int seconds = stopWatchTime % 60;
    int minutes = (stopWatchTime / 60) % 60;
    int long hours = stopWatchTime / 3600;
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    hourCountLabel.text = [NSString stringWithFormat:@"%2ld Hours", hours];
    
    [self checkButtonsStates];
}

- (IBAction)timerWatchAction:(id)sender
{
    [timerButton setButtonBorderColor:[UIColor orangeColor] borderWidth:2];
    [timerButton setButtonBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [stopWatchButton setButtonBorderColor:[UIColor whiteColor] borderWidth:2];
    [stopWatchButton setButtonBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.5] forState:UIControlStateNormal];
    
    isTimer = YES;
    
    int seconds = timerTime % 60;
    int minutes = (timerTime / 60) % 60;
    int long hours = timerTime / 3600;
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    hourCountLabel.text = [NSString stringWithFormat:@"%2ld Hours", hours];
    
    [self checkButtonsStates];
}

- (IBAction)startAction:(id)sender
{
    if (isTimer == NO)
    {
        stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(stopWatchTimeCounting) userInfo:Nil repeats:YES];
        
        [startButton setButtonBorderColor:[UIColor lightGrayColor] borderWidth:1];
        [startButton setButtonTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [startButton setEnable:NO];
        stopWatchStartButtonState = NO;
        
        [pauseButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [pauseButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
        [pauseButton setEnable:YES];
        stopWatchPauseButtonState = YES;
        
        shouldStopWatchLabelRun = YES;
    }
    else
    {
        if (timerWatchTimer == nil)
        {
            [self getTimePicker];
        }
        else
        {
            timerWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerWatchTimeCounting) userInfo:Nil repeats:YES];
            
            [startButton setButtonBorderColor:[UIColor lightGrayColor] borderWidth:1];
            [startButton setButtonTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [startButton setEnable:NO];
            timerStartButtonState = NO;
            
            [pauseButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [pauseButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
            [pauseButton setEnable:YES];
            timerPauseButtonState = YES;
            
            shouldTimerWatchLabelRun = YES;
        }
        
    }
}

- (IBAction)pauseAction:(id)sender
{
    if (isTimer == NO)
    {
        if (stopWatchTimer != nil)
        {
            [stopWatchTimer invalidate];
            //stopWatchTimer = nil;
            
            [pauseButton setButtonTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [pauseButton setButtonBorderColor:[UIColor lightGrayColor] borderWidth:1];
            [pauseButton setEnable:NO];
            stopWatchPauseButtonState = NO;
            
            [startButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
            [startButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [startButton setEnable:YES];
            stopWatchStartButtonState = YES;
            
            shouldStopWatchLabelRun = NO;
        }
    }
    else
    {
        if (timerWatchTimer != nil)
        {
            [timerWatchTimer invalidate];
            //timerWatchTimer = nil;
            
            [pauseButton setButtonTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [pauseButton setButtonBorderColor:[UIColor lightGrayColor] borderWidth:1];
            [pauseButton setEnable:NO];
            timerPauseButtonState = NO;
            
            [startButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
            [startButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [startButton setEnable:YES];
            timerStartButtonState = YES;
            
            shouldTimerWatchLabelRun = NO;
        }
    }
}

- (IBAction)resetAction:(id)sender
{
    if (isTimer == NO)
    {
        timeLabel.text = @"00:00";     //Reset label output
        hourCountLabel.text = @" 0 Hours";
        
        stopWatchTime = 0;      //Reset stop watch to 0
        
        [stopWatchTimer invalidate];
        stopWatchTimer = nil;
        
        [startButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
        [startButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [startButton setEnable:YES];
        stopWatchStartButtonState = YES;
        
        [pauseButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
        [pauseButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [pauseButton setEnable:YES];
        stopWatchPauseButtonState = YES;
    }
    else
    {
        timeLabel.text = @"00:00";     //Reset label output
        hourCountLabel.text = @" 0 Hours";
        
        timerTime = 0;              //Reset timer watch to 0
        totalHoursInSecond = 0;     //Reset hour to 0
        totalMinutesInSecond = 0;   //Reset minute to 0
        totalSecondsInSecond = 0;   //Reset second to 0
        hourPickerValue = 0;
        minutePickerValue = 0;
        secondPickerValue = 0;
        
        [timerWatchTimer invalidate];
        timerWatchTimer = nil;
        
        [startButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
        [startButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [startButton setEnable:YES];
        timerStartButtonState = YES;
        
        [pauseButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
        [pauseButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [pauseButton setEnable:YES];
        timerPauseButtonState = YES;
    }
}

- (void)getTimePicker
{
    //slider.transform = CGAffineTransformMakeRotation(M_PI * 0.5);

    //Create hour label
    hourLabel.text = @"";
    hourLabel = nil;
    hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, 50.0, 40.0)];
    hourLabel.text = @"00";
    hourLabel.textAlignment = NSTextAlignmentCenter;
    hourLabel.font = [UIFont fontWithName:@"Roboto-Light" size:30.0];
    [pickerView addSubview:hourLabel];
    
    //Create hour text label
    UILabel *hourTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 50.0, 20.0)];
    hourTextLabel.text = @"Hours";
    hourTextLabel.textAlignment = NSTextAlignmentCenter;
    hourTextLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10.0];
    [pickerView addSubview:hourTextLabel];
    
    //Create minute label
    minuteLabel.text = @"";
    minuteLabel = nil;
    minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(85.0, 20.0, 50.0, 40.0)];
    minuteLabel.text = @"00";
    minuteLabel.textAlignment = NSTextAlignmentCenter;
    minuteLabel.font = [UIFont fontWithName:@"Roboto-Light" size:30.0];
    [pickerView addSubview:minuteLabel];
    
    //Create minute text label
    UILabel *minuteTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(85.0, 60.0, 50.0, 20.0)];
    minuteTextLabel.text = @"Minutes";
    minuteTextLabel.textAlignment = NSTextAlignmentCenter;
    minuteTextLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10.0];
    [pickerView addSubview:minuteTextLabel];
    
    //Create second label
    secondLabel.text = @"";
    secondLabel = nil;
    secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 20.0, 50.0, 40.0)];
    secondLabel.text = @"00";
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.font = [UIFont fontWithName:@"Roboto-Light" size:30.0];
    [pickerView addSubview:secondLabel];
    
    //Create second text label
    UILabel *secondTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 60.0, 50.0, 20.0)];
    secondTextLabel.text = @"Seconds";
    secondTextLabel.textAlignment = NSTextAlignmentCenter;
    secondTextLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10.0];
    [pickerView addSubview:secondTextLabel];
    
    //Set hour slider
    hourSlider.transform = CGAffineTransformMakeRotation(M_PI * (-0.5));
    [hourSlider setFrame:CGRectMake(20.0, 100.0, 50.0, 150.0)];
    [hourSlider setMinimumValue:0];
    [hourSlider setMaximumValue:24];
    [hourSlider setValue:0];
    [hourSlider setMinimumTrackTintColor:[UIColor darkGrayColor]];
    [hourSlider setMaximumTrackTintColor:[UIColor darkGrayColor]];
    [pickerView addSubview:hourSlider];
    
    //Set minute slider
    minSlider.transform = CGAffineTransformMakeRotation(M_PI * (-0.5));
    [minSlider setFrame:CGRectMake(85.0, 100.0, 50.0, 150.0)];
    [minSlider setMinimumValue:0];
    [minSlider setMaximumValue:59];
    [minSlider setValue:0];
    [minSlider setMinimumTrackTintColor:[UIColor darkGrayColor]];
    [minSlider setMaximumTrackTintColor:[UIColor darkGrayColor]];
    [pickerView addSubview:minSlider];
    
    //Set second slider
    secSlider.transform = CGAffineTransformMakeRotation(M_PI * (-0.5));
    [secSlider setFrame:CGRectMake(150.0, 100.0, 50.0, 150.0)];
    [secSlider setMinimumValue:0];
    [secSlider setMaximumValue:59];
    [secSlider setValue:0];
    [secSlider setMinimumTrackTintColor:[UIColor darkGrayColor]];
    [secSlider setMaximumTrackTintColor:[UIColor darkGrayColor]];
    [pickerView addSubview:secSlider];
    
    //Create button for the view
    [setButton makeButtonWithView:pickerView Name:@"Set" Xaxis:30.0 Yaxis:280.0 radius:60.0];
    [setButton setButtonTitleFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
    [setButton setButtonBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [setButton setButtonBackgroundColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [setButton setButtonBorderColor:[UIColor lightGrayColor] borderWidth:1.0];
    [setButton setButtonTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [setButton addButtonTarget:self setAction:@selector(setTimer)];
    [setButton setEnable:NO];
    
    //Create button for the view
    [cancelButton makeButtonWithView:pickerView Name:@"Cancel" Xaxis:130.0 Yaxis:280.0 radius:60.0];
    [cancelButton setButtonTitleFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
    [cancelButton setButtonBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancelButton setButtonBackgroundColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [cancelButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1.0];
    [cancelButton addButtonTarget:self setAction:@selector(cancelTimePicker)];
    
    //add picker view to picker view background
    [pickerViewBackground addSubview:pickerView];
    
    //add to main view
    [self.view addSubview:pickerViewBackground];
    pickerViewBackground.alpha = 0.0f;
    [UIView animateWithDuration:0.5 animations:^() {
        pickerViewBackground.alpha = 1.0f;
    }];
}

- (void)updateHourSlider
{
    [self getTotalTimeForTimer];
    
    hourPickerValue = [[NSNumber numberWithFloat:hourSlider.value] integerValue];
    
    if (hourPickerValue < 10) {
        hourLabel.text = [NSString stringWithFormat:@"0%ld", hourPickerValue];
    }
    else
        hourLabel.text = [NSString stringWithFormat:@"%ld", hourPickerValue];
}

- (void)updateMinSlider
{
    [self getTotalTimeForTimer];
    
    minutePickerValue = [[NSNumber numberWithFloat:minSlider.value] integerValue];
    
    if (minutePickerValue < 10) {
        minuteLabel.text = [NSString stringWithFormat:@"0%ld", minutePickerValue];
    }
    else
        minuteLabel.text = [NSString stringWithFormat:@"%ld", minutePickerValue];
}

- (void)updateSecSlider
{
    [self getTotalTimeForTimer];
    
    secondPickerValue = [[NSNumber numberWithFloat:secSlider.value] integerValue];
    
    if (secondPickerValue < 10) {
        secondLabel.text = [NSString stringWithFormat:@"0%ld", secondPickerValue];
    }
    else
        secondLabel.text = [NSString stringWithFormat:@"%ld", secondPickerValue];
}

- (void)getTotalTimeForTimer
{
    //Set timer to value
    totalHoursInSecond = hourPickerValue * 3600;
    totalMinutesInSecond = minutePickerValue * 60;
    totalSecondsInSecond = secondPickerValue;
    
    timerTime = totalHoursInSecond + totalMinutesInSecond + totalSecondsInSecond;
    
    if (timerTime > 0)
    {
        [setButton setEnable:YES];
        [setButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1.0];
        [setButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [setButton setEnable:NO];
        [setButton setButtonBorderColor:[UIColor lightGrayColor] borderWidth:1.0];
        [setButton setButtonTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (void)setTimer
{
    timerWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerWatchTimeCounting) userInfo:Nil repeats:YES];
    
    [startButton setButtonBorderColor:[UIColor lightGrayColor] borderWidth:1];
    [startButton setButtonTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [startButton setEnable:NO];
    timerStartButtonState = NO;
    
    [pauseButton setButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pauseButton setButtonBorderColor:[UIColor whiteColor] borderWidth:1];
    [pauseButton setEnable:YES];
    timerPauseButtonState = YES;
    
    //Get timer value
    [self getTotalTimeForTimer];
    
    shouldTimerWatchLabelRun = YES;
    
    [UIView animateWithDuration:0.5 animations:^() {
        pickerViewBackground.alpha = 0.0f;
    }];
}

- (void)cancelTimePicker
{
    [UIView animateWithDuration:0.5 animations:^() {
        pickerViewBackground.alpha = 0.0f;
    }];
    
    //[pickerViewBackground removeFromSuperview];
}

@end
