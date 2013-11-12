//
//  MMRoundButton.m
//  MMStopWatch
//
//  Created by Kyle Mai on 9/20/13.
//  Copyright (c) 2013 Kyle Mai. All rights reserved.
//

#import "MMRoundButton.h"

@implementation MMRoundButton

- (void)makeButtonWithView:(UIView *)view Name:(NSString *)name Xaxis:(float)x Yaxis:(float)y radius:(float)radius
{
    NSString *buttonNameMultiLine = [name stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(x, y, radius, radius)];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = radius / 2;
    button.layer.borderWidth = 2;
    [button setTitle:buttonNameMultiLine forState:UIControlStateNormal];
    
    [view addSubview:button];
}

- (void)addButtonTarget:(id)target setAction:(SEL)selector
{
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setButtonBorderColor:(UIColor *)color borderWidth:(float)width
{
    [button.layer setBorderColor:[color CGColor]];
    button.layer.borderWidth = width;
}

- (void)setButtonBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    //Create image from a color
    CGRect rect = CGRectMake(0, 0, button.frame.size.width, button.frame.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //*************************
    
    //Recreate the image with rounded corner
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    const CGRect RECT = CGRectMake(button.layer.borderWidth / 2, button.layer.borderWidth / 2, image.size.width - (button.layer.borderWidth / 2), image.size.height - (button.layer.borderWidth / 2) );
    [[UIBezierPath bezierPathWithRoundedRect:RECT cornerRadius:button.frame.size.width / 2] addClip];
    [image drawInRect:RECT];
    UIImage* imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //*************************
    
    [button setBackgroundImage:imageNew forState:state];
}

- (void)setButtonTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [button setTitleColor:color forState:state];
}

- (void)setButtonTitleFont:(UIFont *)font
{
    [button.titleLabel setFont:font];
}

- (void)setEnable:(BOOL)state
{
    [button setEnabled:state];
}



@end
