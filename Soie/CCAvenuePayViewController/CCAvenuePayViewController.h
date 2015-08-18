//
//  CCAvenuePayViewController.h
//  Soie
//
//  Created by Sachin Khard on 15/08/15.
//  Copyright (c) 2015 Sachin Khard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCAvenuePayViewController : UIViewController {
    UIActivityIndicatorView *spinner;
}
@property (strong, nonatomic) NSString *sessionID;

@property (weak, nonatomic) IBOutlet UIWebView *payWebView;

@end

