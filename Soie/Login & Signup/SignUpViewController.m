//
//  SignUpViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 12/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "SignUpViewController.h"
#import "Utilities.h"
#import "APIHandler.h"
#import "InputTextValidator.h"
#import "UserInformation.h"

@interface SignUpViewController () <UITextFieldDelegate>{
    IBOutlet    UITextField         *tfFirstName;
    IBOutlet    UITextField         *tfLastName;
    IBOutlet    UITextField         *tfEmail;
    IBOutlet    UITextField         *tfPhoneNumber;
    IBOutlet    UITextField         *tfPassword;
    IBOutlet    UITextField         *tfConfirmPassword;
    IBOutlet    UIButton            *signUpButton;
}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [tfEmail becomeFirstResponder];
    [self setUpUI];
}

- (void)setUpUI {
    [Utilities setPaddingForObject:tfEmail];
    [Utilities setPaddingForObject:tfFirstName];
    [Utilities setPaddingForObject:tfConfirmPassword];
    [Utilities setPaddingForObject:tfLastName];
    [Utilities setPaddingForObject:tfPassword];
    [Utilities setPaddingForObject:tfPhoneNumber];

    [Utilities makeRoundCornerForObject:signUpButton ofRadius:3];
}

#pragma mark button methods --------

- (IBAction)signUpButtonClicked:(id)sender {
    if (tfFirstName.text.length == 0) {
        [APIHandler showMessage:@"Enter your first name."];
        return;
    }
    else if (tfLastName.text.length == 0) {
        [APIHandler showMessage:@"Enter your last name."];
        return;
    }
    else if (tfPhoneNumber.text.length != 10) {
        [APIHandler showMessage:@"Enter valid 10 digit phone number."];
        return;
    }
    else if (![InputTextValidator validateEmail:tfEmail.text]) {
        [APIHandler showMessage:@"Enter valid email address."];
        return;
    }
    else if (tfPassword.text.length < 6 || tfConfirmPassword.text.length < 6) {
        [APIHandler showMessage:@"Enter password of minimum 6 characters."];
        return;
    }
    else if (![tfPassword.text isEqualToString:tfConfirmPassword.text]) {
        [APIHandler showMessage:@"Password mismatch."];
        return;
    }
    
    //    NSString *deviceId = [userDefaults objectForKey:@"kPushNotificationUDID"];
    [ActivityIndicator startAnimatingWithText:@"Loging In" forView:self.view];
    NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tfConfirmPassword.text,@"confirm",
                                    tfEmail.text,@"email",
                                    tfFirstName.text,@"firstname",
                                    tfLastName.text,@"lastname",
                                    tfPassword.text,@"password",
                                    tfPhoneNumber.text,@"telephone",
                                    @"1",@"agree",
                                    nil];
    NSString *urlString = [NSString stringWithFormat:@"%@register",API_BASE_URL];
    
    [APIHandler getResponseFor:postDictionary url:[NSURL URLWithString:urlString] requestType:@"POST" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            [UserInformation saveUserInformation:[[NSDictionary alloc] initWithObjectsAndKeys:postDictionary,@"user", nil]];
            NSLog(@"%@",[UserInformation getUserInformation]);
        }
    }];
}

#pragma mark textfield delegates -------

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == tfFirstName) {
        [tfLastName becomeFirstResponder];
    }
    else if (textField == tfLastName) {
        [tfPhoneNumber becomeFirstResponder];
    }
    else if (textField == tfPhoneNumber) {
        [tfEmail becomeFirstResponder];
    }
    else if (textField == tfEmail) {
        [tfPassword becomeFirstResponder];
    }
    else if (textField == tfPassword) {
        [tfConfirmPassword becomeFirstResponder];
    }
    else if (textField == tfConfirmPassword) {
        [self signUpButtonClicked:nil];
    }
    return YES;
}

@end
