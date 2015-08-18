//
//  PaymentViewController.h
//  Soie
//
//  Created by Sachin Khard on 15/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentsSDK.h"


@interface PaymentViewController : UIViewController<PGTransactionDelegate>

@property (strong, nonatomic) NSArray *paymentMethodsArray;
@property (strong, nonatomic) NSString *selectedPaymentMethodCode;

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet UILabel *TotalAmoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingRateLabel;
@property (weak, nonatomic) IBOutlet UIView *paymentMethodView;
@property (weak, nonatomic) IBOutlet UIView *paymentTypeView;
@property (weak, nonatomic) IBOutlet UIButton *useCouponCodeButton;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UITextField *enterCouponTextField;
@property (weak, nonatomic) IBOutlet UILabel *subTotalValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;
- (IBAction)confirmButtonAction:(id)sender;
- (IBAction)useCouponCodeButtonAction:(id)sender;
- (IBAction)applyCouponButtonAction:(id)sender;
@end
