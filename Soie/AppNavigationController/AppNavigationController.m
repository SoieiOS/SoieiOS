//
//  AppNavigationController.m
//  INRVU
//
//  Created by Abhishek Tyagi on 23/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "AppNavigationController.h"
#import "OverviewViewController.h"
#import "MyAccountViewController.h"

#import "Utilities.h"
@interface AppNavigationController ()

@end

@implementation AppNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
    [self.navigationBar setTintColor:[UIColor colorWithRed:221/255.0 green:163/255.0 blue:178/255.0 alpha:1.0]];
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, nil];
    self.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
//    [self checkFirstController];
}

- (void)setTransparentNavigationBar {
    [self.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
}

- (void)checkFirstController {
    if ([self.viewControllers count] > 0) {
        if ([[self.viewControllers objectAtIndex:0] isKindOfClass:[OverviewViewController class]]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            BOOL loggedIn = [defaults boolForKey:@"isloggedin"];
            if (loggedIn) {
                MyAccountViewController *myAccountView = [self.storyboard instantiateViewControllerWithIdentifier:@"myAccountView"];
                [self setViewControllers:[NSArray arrayWithObjects:myAccountView, nil]];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
