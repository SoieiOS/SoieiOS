//
//  ActivityIndicator.m
//  INRVU
//
//  Created by Abhishek Tyagi on 23/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "ActivityIndicator.h"
#import "Constants.h"

@implementation ActivityIndicator

static ActivityIndicator *activityIndicator =nil;
static UIActivityIndicatorView *activityIndicatorView = nil;
static UILabel *lblLoading;

+(ActivityIndicator *)getInstanceForYorigin:(CGFloat)yOrigin forXorigin:(CGFloat)xOrigin
{
    @synchronized(self)
    {
        if(activityIndicator==nil)
        {
            activityIndicator= [ActivityIndicator new];
            activityIndicatorView = [self loadCustomActivityIndicatorWithYorigin:yOrigin Xorigin:xOrigin withText:@"Loading"];
        }
    }
    return activityIndicator;
}

+(UIActivityIndicatorView *)loadCustomActivityIndicatorWithYorigin:(float)y Xorigin:(float)x withText:(NSString *)text {
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(x+10, y, 80, 80)];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityIndicator.frame = CGRectMake(y+40, x, 80, 80);
    }

    activityIndicator.hidesWhenStopped = TRUE;
    
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.alpha = 1.0f;
    activityIndicator.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    activityIndicator.layer.cornerRadius = 10.0f;
    activityIndicator.layer.borderWidth = 0;
    activityIndicator.layer.borderColor = [[UIColor clearColor] CGColor];
    lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 80, 20)];
    lblLoading.text = text;
    lblLoading.font = [UIFont systemFontOfSize:10];
    lblLoading.textAlignment = NSTextAlignmentCenter;
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.backgroundColor = [UIColor clearColor];
    [activityIndicator addSubview:lblLoading];
    
    return activityIndicator;
}

+ (void)startAnimatingWithText:(NSString *)string forView:(UIView *)view {
    [view addSubview:activityIndicatorView];
    lblLoading.text = string;
    [activityIndicatorView startAnimating];
}

+ (void)stopAnimatingForView:(UIView *)view {
    for (id subView in view.subviews) {
        if ([subView isKindOfClass:[UIActivityIndicatorView class]]) {
            [subView removeFromSuperview];
        }
    }
    [activityIndicatorView stopAnimating];
}

@end
