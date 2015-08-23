//
//  LoginViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 12/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "LoginViewController.h"
#import "Utilities.h"
#import "APIHandler.h"
#import "InputTextValidator.h"
#import "UserInformation.h"

@interface LoginViewController () <UITextFieldDelegate>{
    IBOutlet    UITextField         *tfEmail;
    IBOutlet    UITextField         *tfpassword;
    IBOutlet    UIButton            *loginButton;
    
    IBOutlet    UIScrollView        *scrollView;
    IBOutlet    UIPageControl       *pageControl;
    
    BOOL                            isKeyboardOpen;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpUI];
}

- (void)setUpUI {
    [Utilities setPaddingForObject:tfEmail];
    [Utilities createCustomtextField:tfEmail withLeftImage:[UIImage imageNamed:@"unnamed-3.png"]];

    [Utilities setPaddingForObject:tfpassword];
    [Utilities createCustomtextField:tfpassword withLeftImage:[UIImage imageNamed:@"unnamed-4.png"]];

    [Utilities makeRoundCornerForObject:loginButton ofRadius:3];
    [Utilities makeBorderForObject:loginButton ofSize:2 color:[UIColor colorWithRed:244/255.0 green:192/255.0 blue:205/255.0 alpha:1.0]];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(hideKeyboard)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
}

- (void)hideKeyboard {
    if (isKeyboardOpen) {
        [self.view endEditing:YES];
        isKeyboardOpen = FALSE;
        [Utilities setViewMovedUpForTextField:tfEmail havingContainerView:self.view withDirection:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self createTutorials];
}

- (void)createTutorials {
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIImage *image1 = [UIImage imageNamed:@"iosScreen750.png"];
    UIImage *image2 = [UIImage imageNamed:@"iosScreen7501.png"];
    UIImage *image3 = [UIImage imageNamed:@"iosScreen7502.png"];
    
    NSArray *images = [NSArray arrayWithObjects:image1,image2,image3, nil];
    for (int i = 0; i < images.count; i++) {
        CGRect frame;
        frame.origin.x = self.view.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.view.frame.size;
        
        UIImageView *subview = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i),0, self.view.frame.size.width, scrollView.frame.size.height)];
        subview.image = [images objectAtIndex:i];
//        subview.contentMode = UIViewContentModeScaleAspectFit;
        //        subview.backgroundColor = [UIColor blackColor];
        [scrollView addSubview:subview];
    }
    
    pageControl.hidden = NO;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * images.count, scrollView.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

#pragma mark button methods --------

- (IBAction)loginButtonClicked:(id)sender {
    if (![InputTextValidator validateEmail:tfEmail.text]) {
        [APIHandler showMessage:@"Enter valid email address."];
        return;
    }
    else if (tfpassword.text.length < 5) {
        [APIHandler showMessage:@"Enter valid password"];
        return;
    }
    //    NSString *deviceId = [userDefaults objectForKey:@"kPushNotificationUDID"];
    [ActivityIndicator startAnimatingWithText:@"Loging In" forView:self.view];
    NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tfEmail.text,@"email",
                                    tfpassword.text,@"password",
                                    nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:postDictionary forKey:@"usernamePassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *urlString = [NSString stringWithFormat:@"%@login",API_BASE_URL];
    
    [APIHandler getResponseFor:postDictionary url:[NSURL URLWithString:urlString] requestType:@"POST" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            [UserInformation saveUserInformation:[[NSDictionary alloc] initWithObjectsAndKeys:[jsonDict objectForKey:@"data"],@"user", nil]];
            NSLog(@"%@",[UserInformation getUserInformation]);
            NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
            [userDefaults1 setBool:YES forKey:@"isloggedin"];
            [userDefaults1 synchronize];
//            NAVIGATE_TO_VIEW(myAccountViews);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark textfield delegates -------

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!isKeyboardOpen) {
        isKeyboardOpen = TRUE;
        [Utilities setViewMovedUpForTextField:textField havingContainerView:self.view withDirection:YES];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == tfEmail) {
        [tfpassword becomeFirstResponder];
    }
    else if (textField == tfpassword) {
        [self loginButtonClicked:nil];
    }
    return YES;
}

@end
