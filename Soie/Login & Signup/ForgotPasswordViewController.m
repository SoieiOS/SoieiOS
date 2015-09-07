//
//  ForgotPasswordViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 07/09/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "ForgotPasswordViewController.h" 
#import "InputTextValidator.h"
#import "APIHandler.h"

@interface ForgotPasswordViewController () <UITextFieldDelegate>{
    IBOutlet    UITextField         *tfEmail;
    IBOutlet    UIButton            *submitButton;
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Forgot Password";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonClicked:(id)sender {
    if (![InputTextValidator validateEmail:tfEmail.text]) {
        [APIHandler showMessage:@"Enter valid email address."];
        return;
    }
    //    NSString *deviceId = [userDefaults objectForKey:@"kPushNotificationUDID"];
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tfEmail.text,@"email",
                                    nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@forgotten",API_BASE_URL];
    
    [APIHandler getResponseFor:postDictionary url:[NSURL URLWithString:urlString] requestType:@"POST" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
