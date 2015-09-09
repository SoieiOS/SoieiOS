//
//  ChangePasswordViewController.m
//  INRVU
//
//  Created by Abhishek Tyagi on 03/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "APIHandler.h"
#import "Utilities.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIColor *color = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
//    [Utilities setPlaceholderColorForObject:currentPasswordTextField ofColor:color];
//    [Utilities setPlaceholderColorForObject:newPasswordTextField ofColor:color];
//    [Utilities setPlaceholderColorForObject:confirmPasswordTextField ofColor:color];

    self.title = @"Change Password";
    [self enableOrDisableAddButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enableOrDisableAddButton{
    if ([self checkPasswordWithMessage:FALSE]) {
        submitButton.enabled = YES;
//        saveButton.alpha = 1.0;
    }
    else {
        submitButton.enabled = NO;
//        saveButton.alpha = 0.4;
    }
}

- (IBAction)saveButtonClicked:(id)sender {
    if (![[[[NSUserDefaults standardUserDefaults] objectForKey:@"usernamePassword"] objectForKey:@"password"] isEqualToString:currentPasswordTextField.text]) {
//        NSLog(@"%@ and %@",)
        [APIHandler showMessage:@"Kindly enter the right password!"];
        return;
    }
    
    if ([self checkPasswordWithMessage:TRUE]) {
        [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
        NSString *urlString = [NSString stringWithFormat:@"%@account/password",API_BASE_URL];
        NSMutableDictionary *postDictionary = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                        newPasswordTextField.text,@"password",
                                        confirmPasswordTextField.text,@"confirm",
//                                        [[[NSUserDefaults standardUserDefaults] objectForKey:@"usernamePassword"] objectForKey:@"email"],@"email",
                                        nil] mutableCopy];
        [APIHandler getResponseFor:postDictionary url:[NSURL URLWithString:urlString] requestType:@"PUT" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
            [ActivityIndicator stopAnimatingForView:self.view];
            if (success) {
                [postDictionary setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"usernamePassword"] objectForKey:@"email"] forKey:@"email"];
                [[NSUserDefaults standardUserDefaults] setObject:postDictionary forKey:@"usernamePassword"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (BOOL)checkPasswordWithMessage:(BOOL)showMessage {
    if (currentPasswordTextField.text.length < 5 || newPasswordTextField.text.length < 5 || confirmPasswordTextField.text.length < 5) {
        if (showMessage) {
            [APIHandler showMessage:@"Password should be atleast 6 characters long."];
        }
        return NO;
    }else if ([currentPasswordTextField.text isEqualToString:newPasswordTextField.text]) {
        if (showMessage) {
            [APIHandler showMessage:@"Your new password is same as current password."];
        }
        return NO;
    }
    else if (![newPasswordTextField.text isEqualToString:confirmPasswordTextField.text]) {
        if (showMessage) {
            [APIHandler showMessage:@"Password mismatch"];
        }
        return NO;
    }
    else {
        return TRUE;
    }
}

#pragma mark textfield delegates ---------

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == currentPasswordTextField) {
        [newPasswordTextField becomeFirstResponder];
    }
    else if (textField == newPasswordTextField) {
        [confirmPasswordTextField becomeFirstResponder];
    }
    else if (textField == confirmPasswordTextField) {
        [self saveButtonClicked:self];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string isEqualToString:@""]) {
        textField.text = [textField.text stringByAppendingString:string];
        [self enableOrDisableAddButton];
        return NO;
    }
    else if ([string isEqualToString:@""]) {
        if (textField.text.length > 0) {
            textField.text = [textField.text substringToIndex:[textField.text length] - 1];
        }
        [self enableOrDisableAddButton];
        return NO;
    }
    return YES;
}

@end
