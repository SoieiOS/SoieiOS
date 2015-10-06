//
//  BlogViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 05/10/15.
//  Copyright © 2015 Abhishek Tyagi. All rights reserved.
//

#import "BlogViewController.h"
#import "ActivityIndicator.h"

@interface BlogViewController () <UIWebViewDelegate> {
    IBOutlet    UIWebView           *blogWebview;
    IBOutlet UIBarButtonItem        *sidebarButton;
}

@end

@implementation BlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    NSString *fullURL = @"http://blog.soie.in/";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];

    [blogWebview loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ActivityIndicator stopAnimatingForView:self.view];
}

@end
