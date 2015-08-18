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
                                      @"Merchant_Id",           tempDic[@"Merchant_Id"],
                                      @"Amount",                tempDic[@"Amount"],
                                      @"Order_Id",              tempDic[@"Order_Id"],
                                      @"Redirect_Url",          tempDic[@"Redirect_Url"],
                                      @"Checksum",              tempDic[@"Checksum"],
                                      @"billing_cust_name",     tempDic[@"billing_cust_name"],
                                      @"billing_cust_address",  tempDic[@"billing_cust_address"],
                                      @"billing_cust_country",  tempDic[@"billing_cust_country"],
                                      @"billing_cust_state",    tempDic[@"billing_cust_state"],
                                      @"billing_cust_city",     tempDic[@"billing_cust_city"],
                                      @"billing_zip_code",      tempDic[@"billing_zip_code"],
                                      @"billing_cust_tel",      tempDic[@"billing_cust_tel"],
                                      @"billing_cust_email",    tempDic[@"billing_cust_email"],
                                      @"delivery_cust_name",    tempDic[@"delivery_cust_name"],
                                      @"delivery_cust_address", tempDic[@"delivery_cust_address"],
                                      @"delivery_cust_country", tempDic[@"delivery_cust_country"],
                                      @"delivery_cust_state",   tempDic[@"delivery_cust_state"],
                                      @"delivery_cust_city",    tempDic[@"delivery_cust_city"],
                                      @"delivery_zip_code",     tempDic[@"delivery_zip_code"],
                                      @"delivery_cust_tel",     tempDic[@"delivery_cust_tel"],
                                      @"delivery_cust_notes",   tempDic[@"delivery_cust_notes"],
                                      @"Merchant_Param",        tempDic[@"Merchant_Param"],
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

                [APIHandler showMessage:[NSString stringWithFormat:@"Your order has been successfully placed. Your order id is %@", [arr1 firstObject]]];
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
