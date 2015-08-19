//
//  AddressViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 25/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "AddressViewController.h"
#import "AppNavigationController.h"
#import "CountryListViewController.h"
#import "AddressListViewController.h"
#import "APIHandler.h"
#import "Utilities.h"

@interface AddressViewController () <UITextFieldDelegate, CountryListDelegate> {
    IBOutlet    UITextField         *tfFirstName;
    IBOutlet    UITextField         *tfLastName;
    IBOutlet    UITextField         *tfaddress1;
    IBOutlet    UITextField         *tfaddress2;
    IBOutlet    UITextField         *tfCity;
    IBOutlet    UITextField         *tfZip;
    IBOutlet    UITextField         *tfState;

    IBOutlet    UIButton            *submitButton;
    
    NSString                        *selectedZone;
}

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [tfFirstName becomeFirstResponder];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(hideKeyboard)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    if (_addressInfo) {
        tfFirstName.text = [_addressInfo objectForKey:@"firstname"];
        tfLastName.text = [_addressInfo objectForKey:@"lastname"];
        tfaddress1.text = [_addressInfo objectForKey:@"address_1"];
        tfaddress2.text = [_addressInfo objectForKey:@"address_2"];
        tfCity.text = [_addressInfo objectForKey:@"city"];
        tfZip.text = [_addressInfo objectForKey:@"postcode"];
        tfState.text = [_addressInfo objectForKey:@"zone"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self hideKeyboard];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}
//
//- (void)setUpUI {
//    [Utilities setPaddingForObject:tfaddress1];
//    [Utilities setPaddingForObject:tfaddress2];
//    [Utilities setPaddingForObject:tfCity];
//    [Utilities setPaddingForObject:tfState];
//    [Utilities setPaddingForObject:tfZip];
//    
//    [Utilities makeRoundCornerForObject:submitButton ofRadius:3];
//}
//
//#pragma mark button methods --------
//
- (IBAction)submitButtonClicked:(id)sender {
    if (tfaddress1.text.length == 0) {
        [APIHandler showMessage:@"Enter your house number or falt number."];
        return;
    }
    else if (tfCity.text.length == 0) {
        [APIHandler showMessage:@"Enter your city."];
        return;
    }
    else if (tfZip.text.length == 0) {
        [APIHandler showMessage:@"Enter your locality zipcode."];
        return;
    }
    else if (tfState.text.length == 0) {
        [APIHandler showMessage:@"Enter your state."];
        return;
    }
    
    //    NSString *deviceId = [userDefaults objectForKey:@"kPushNotificationUDID"];
    [ActivityIndicator startAnimatingWithText:@"Saving" forView:self.view];
    NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tfFirstName.text,@"firstname",
                                    tfLastName.text,@"lastname",
                                    @"company",@"company",
                                    @"company",@"company_id",
                                    tfaddress1.text,@"address_1",
                                    tfaddress2.text,@"address_2",
                                    tfCity.text,@"city",
                                    tfZip.text,@"postcode",
                                    selectedZone,@"zone_id",
                                    @"",@"tax_id",
                                    @"99",@"country_id",
                                    nil];

    NSString *urlString = [NSString stringWithFormat:@"%@account/address",API_BASE_URL];
    NSString *requestType = @"POST";
    
    if (_addressInfo) {
        urlString = [NSString stringWithFormat:@"%@/%@",urlString,[_addressInfo objectForKey:@"address_id"]];
        requestType = @"PUT";
    }
    
    [APIHandler getResponseFor:postDictionary url:[NSURL URLWithString:urlString] requestType:requestType complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)stateSelected:(NSDictionary *)stateInfo {
    tfState.text = [stateInfo objectForKey:@"name"];
    selectedZone = [stateInfo objectForKey:@"zone_id"];
}
#pragma mark textfield delegates -------

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == tfState) {
        CountryListViewController *countryListView = [self.storyboard instantiateViewControllerWithIdentifier:@"countryListView"];
        countryListView.delegate = self;
        AppNavigationController *appNavigationController = [[AppNavigationController alloc] initWithRootViewController:countryListView];
        [self presentViewController:appNavigationController animated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == tfaddress1) {
        [tfaddress2 becomeFirstResponder];
    }
    else if (textField == tfaddress2) {
        [tfCity becomeFirstResponder];
    }
    else if (textField == tfCity) {
        [tfZip becomeFirstResponder];
    }
    else if (textField == tfZip) {
        [tfState becomeFirstResponder];
    }
    else if (textField == tfState) {
        [self submitButtonClicked:nil];
    }
    return YES;
}

@end
