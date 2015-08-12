//
//  EditPersonalInfoViewController.h
//  INRVU
//
//  Created by Abhishek Tyagi on 03/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserInformationUpdated <NSObject>
@required
- (void)userInformationUpdatedForKey:(NSString *)key value:(NSString *)value;
@end

@interface EditPersonalInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    IBOutlet UITableView        *editPersonalInfoTableview;
}

@property (nonatomic, strong) NSDictionary  *userInformation;
@property (nonatomic, strong) NSDictionary  *textfieldProperties;
@property (nonatomic, strong) NSString      *placeholderText;
@property (nonatomic)         NSInteger     keyboardType;
@property (nonatomic)         NSInteger     returnKeyType;

@property (nonatomic, weak) id<UserInformationUpdated>    delegate;

@end
