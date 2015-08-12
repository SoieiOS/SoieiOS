//
//  ChangePasswordViewController.h
//  INRVU
//
//  Created by Abhishek Tyagi on 03/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet    UITextField         *currentPasswordTextField;
    IBOutlet    UITextField         *newPasswordTextField;
    IBOutlet    UITextField         *confirmPasswordTextField;
    IBOutlet    UIBarButtonItem     *saveButton;
}

@end
