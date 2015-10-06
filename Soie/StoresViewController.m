//
//  StoresViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 05/10/15.
//  Copyright © 2015 Abhishek Tyagi. All rights reserved.
//

#import "StoresViewController.h"
#import "ActivityIndicator.h"

@interface StoresViewController () <UIWebViewDelegate> {
    IBOutlet    UIWebView           *storeWebview;
    IBOutlet UIBarButtonItem        *sidebarButton;
}

@end

@implementation StoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    NSString *fullURL = @"http://soie.in/stores";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    [storeWebview loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ActivityIndicator stopAnimatingForView:self.view];
}

@end
