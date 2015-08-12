//
//  LoginViewController.h
//  Soie
//
//  Created by Abhishek Tyagi on 12/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate> {
    FBLoginView                 *loginview;
    BOOL                        facebookInformationLoaded;
}

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;


@end
