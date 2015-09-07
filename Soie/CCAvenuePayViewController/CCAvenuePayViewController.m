//
//  CCAvenuePayViewController.m
//  Soie
//
//  Created by Sachin Khard on 15/08/15.
//  Copyright (c) 2015 Sachin Khard. All rights reserved.
//

#import "CCAvenuePayViewController.h"
#import "APIHandler.h"

@interface CCAvenuePayViewController ()

@end

@implementation CCAvenuePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"CCAvenue";

    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center;
    spinner.hidesWhenStopped = YES;
    [self.payWebView addSubview:spinner];
    [self.payWebView setOpaque:NO];

    [self getAllParamsForCCAvenuePayment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAllParamsForCCAvenuePayment {
    
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@ccavenue",API_BASE_URL];
    
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            NSDictionary *tempDic = jsonDict[@"data"];
            
            NSArray *webViewParams = [NSArray arrayWithObjects:
                                      @"encRequest",            tempDic[@"encRequest"],
                                      @"access_code",           tempDic[@"access_code"],
                                      nil];
            
            [self UIWebViewWithPost:self.payWebView url:tempDic[@"action"] params:webViewParams];
        }
    }];
}

#pragma mark UIWebView Delegate
- (void)UIWebViewWithPost:(UIWebView *)uiWebView url:(NSString *)url params:(NSArray *)params{
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    [s appendString: [NSString stringWithFormat:@"<html><body onload=\"document.forms[0].submit()\">"
                      "<form action=\"%@\" id=\"ccavenueform\" name = \"ccavenueform\" method=\"POST\">", url]];
    
    if([params count] % 2 == 1) {
        NSLog(@"UIWebViewWithPost error: params don't seem right");
        return;
    }
    
    for (int i=0; i < [params count] / 2; i++) {
        [s appendString: [NSString stringWithFormat:@"<input type=\"hidden\" name=\"%@\" value=\"%@\">\n", [params objectAtIndex:i*2], [params objectAtIndex:(i*2)+1]]];
    }
    [s appendString: @"</form></body></html>"];
    
    [uiWebView loadHTMLString:s baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSData *postData = [request HTTPBody];
    NSString *postParams = [[NSString alloc] initWithData:postData encoding:NSStringEncodingConversionAllowLossy];
    
    if ([postParams rangeOfString:@"AuthDesc="].location != NSNotFound) {
        NSRange range = [postParams rangeOfString:@"AuthDesc="];
        NSString *authParams = [postParams substringFromIndex:(range.location+range.length)];
        NSArray *arr = [authParams componentsSeparatedByString:@"&"];

        if ([arr count] > 0) {
            NSString *authStatus = [arr firstObject];
            
            if ([authStatus isEqualToString:@"Y"]) {
                range = [postParams rangeOfString:@"Order_Id="];
                NSString *orderParams = [postParams substringFromIndex:(range.location+range.length)];
                NSArray *arr1 = [orderParams componentsSeparatedByString:@"&"];

                [APIHandler showMessage:[NSString stringWithFormat:@"Your Order has been successfully placed. Your Order Id is %@", [arr1 firstObject]]];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"cartItemCount"];

//                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];

            }
            else
            {
                [APIHandler showMessage:@"Transaction UnSuccessful"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [webView stopLoading];
        }
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [spinner stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [spinner stopAnimating];
}


@end
