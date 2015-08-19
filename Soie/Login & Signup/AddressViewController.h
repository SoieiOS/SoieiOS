//
//  AddressViewController.h
//  Soie
//
//  Created by Abhishek Tyagi on 25/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressViewController : UIViewController


@property (nonatomic) BOOL      isPaymentAddress;
@property (nonatomic, strong) NSString *addressType;
@property (nonatomic, strong) NSDictionary  *addressInfo;
@end
