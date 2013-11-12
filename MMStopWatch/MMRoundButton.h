//
//  MMRoundButton.h
//  MMStopWatch
//
//  Created by Kyle Mai on 9/20/13.
//  Copyright (c) 2013 Kyle Mai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMRoundButton : NSObject
{
    UIButton *button;
}

- (void)makeButtonWithView:(UIView *)view Name:(NSString *)name Xaxis:(float)x Yaxis:(float)y radius:(float)radius;
- (void)addButtonTarget:(id)target setAction:(SEL)selector;
- (void)setButtonBorderColor:(UIColor *)color borderWidth:(float)width;
- (void)setButtonBackgroundColor:(UIColor *)color forState:(UIControlState)state;
- (void)setButtonTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setButtonTitleFont:(UIFont *)font;
- (void)setEnable:(BOOL)state;

@end
