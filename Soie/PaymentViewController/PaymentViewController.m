//
//  PaymentViewController.m
//  Soie
//
//  Created by Sachin Khard on 15/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "PaymentViewController.h"
#import "CCAvenuePayViewController.h"
#import "APIHandler.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Payment";
    
    self.useCouponCodeButton.selected = YES;
    [self useCouponCodeButtonAction:self.useCouponCodeButton];
    [self getCart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmButtonAction:(id)sender {
    [self setPaymentMethod];
}

- (IBAction)useCouponCodeButtonAction:(id)sender {
    if (self.useCouponCodeButton.selected) {
        self.couponView.hidden = YES;
        if (self.couponView.frame.origin.y < self.view.frame.size.height-64) {
            self.confirmView.frame = CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50);
        }
        else {
            self.confirmView.frame = CGRectMake(0, self.couponView.frame.origin.y, self.view.frame.size.width, 50);
        }
    }
    else {
        self.couponView.hidden = NO;
        self.confirmView.frame = CGRectMake(0, self.couponView.frame.origin.y+self.couponView.frame.size.height+10, self.view.frame.size.width, 50);
    }
    self.bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.confirmView.frame.origin.y+50);
    self.useCouponCodeButton.selected = !self.useCouponCodeButton.selected;
}

- (IBAction)applyCouponButtonAction:(id)sender {
    if ([self.enterCouponTextField.text length] > 0) {
        
        NSString *couponCode = self.enterCouponTextField.text;
        
        [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
        NSString *urlString = [NSString stringWithFormat:@"%@coupon",API_BASE_URL];
        
        NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc] init];
        [postDictionary setObject:couponCode forKey:@"coupon"];
        
        [APIHandler getResponseFor:postDictionary url:[NSURL URLWithString:urlString] requestType:@"POST" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
            [ActivityIndicator stopAnimatingForView:self.view];
            
            if (success) {
                NSArray *totalsArray = [[jsonDict objectForKey:@"data"] objectForKey:@"totals"];
                
                if ([[totalsArray valueForKey:@"title"] containsObject:@"Total"]) {
                    NSInteger index = [[totalsArray valueForKey:@"title"] indexOfObject:@"Total"];
                    NSString *totalAmount = [[totalsArray valueForKey:@"text"] objectAtIndex:index];
                    self.TotalAmoutLabel.text = totalAmount;
                    self.totalValueLabel.text = totalAmount;
                }
                if ([[totalsArray valueForKey:@"title"] containsObject:@"Sub-Total"]) {
                    NSInteger index = [[totalsArray valueForKey:@"title"] indexOfObject:@"Sub-Total"];
                    NSString *totalAmount = [[totalsArray valueForKey:@"text"] objectAtIndex:index];
                    self.subTotalValueLabel.text = totalAmount;
                }
                if ([[totalsArray valueForKey:@"title"] containsObject:[NSString stringWithFormat:@"Coupon (%@)",couponCode]]) {
                    NSInteger index = [[totalsArray valueForKey:@"title"] indexOfObject:[NSString stringWithFormat:@"Coupon (%@)",couponCode]];
                    NSString *totalAmount = [[totalsArray valueForKey:@"text"] objectAtIndex:index];
                    self.couponValueLabel.text = totalAmount;
                }
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[[jsonDict objectForKey:@"error"] objectForKey:@"warning"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
    else {
        [APIHandler showMessage:@"Please enter coupon code"];  
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.bgScrollView setContentOffset:CGPointMake(0, 200)];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.bgScrollView setContentOffset:CGPointMake(0, 0)];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Get Cart

- (void)getCart
{
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@cart",API_BASE_URL];
    
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            NSArray *totalsArray = [[jsonDict objectForKey:@"data"] objectForKey:@"totals"];
            NSString *couponCode = [[jsonDict objectForKey:@"data"] objectForKey:@"coupon"];

            if ([[totalsArray valueForKey:@"title"] containsObject:@"Total"]) {
                NSInteger index = [[totalsArray valueForKey:@"title"] indexOfObject:@"Total"];
                NSString *totalAmount = [[totalsArray valueForKey:@"text"] objectAtIndex:index];
                self.TotalAmoutLabel.text = totalAmount;
                self.totalValueLabel.text = totalAmount;
            }
            if ([[totalsArray valueForKey:@"title"] containsObject:@"Sub-Total"]) {
                NSInteger index = [[totalsArray valueForKey:@"title"] indexOfObject:@"Sub-Total"];
                NSString *totalAmount = [[totalsArray valueForKey:@"text"] objectAtIndex:index];
                self.subTotalValueLabel.text = totalAmount;
            }
            if ([[[jsonDict objectForKey:@"data"] objectForKey:@"coupon_status"] isEqualToString:@"1"] && [couponCode length] > 0 && [[totalsArray valueForKey:@"title"] containsObject:[NSString stringWithFormat:@"Coupon (%@)",couponCode]])
            {
                self.enterCouponTextField.text = couponCode;
                [self useCouponCodeButtonAction:self.useCouponCodeButton];
                
                NSInteger index = [[totalsArray valueForKey:@"title"] indexOfObject:[NSString stringWithFormat:@"Coupon (%@)",couponCode]];
                NSString *totalAmount = [[totalsArray valueForKey:@"text"] objectAtIndex:index];
                self.couponValueLabel.text = totalAmount;
            }
        }
        [self getShippingMethod];
    }];
}

#pragma mark - Get Shipping Methods

// {"success":true,"data":{"error_warning":"","shipping_methods":{"flat":{"title":"Flat Rate","quote":{"flat":{"code":"flat.flat","title":"Flat Shipping Rate","cost":"5.00","tax_class_id":"9","text":"Rs.5.00"}},"sort_order":"1","error":false}},"code":"","comment":""}}

- (void)getShippingMethod{
    
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@shippingmethods",API_BASE_URL];
    
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            self.shippingRateLabel.text = [[[[[[jsonDict objectForKey:@"data"] objectForKey:@"shipping_methods"] objectForKey:@"flat"] objectForKey:@"quote"] objectForKey:@"flat"] objectForKey:@"text"];
            [self setShippingMethod];
        }
    }];
}

#pragma mark - Set Shipping Methods

- (void)setShippingMethod{
    
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@shippingmethods",API_BASE_URL];
    
    NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc] init];
    [postDictionary setObject:@"flat.flat" forKey:@"shipping_method"];
    [postDictionary setObject:@"test comments" forKey:@"comment"];

    [APIHandler getResponseFor:postDictionary url:[NSURL URLWithString:urlString] requestType:@"POST" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            [self getPaymentMethod];
        }
    }];
}


// {"success":true,"data":{"error_warning":"","payment_methods":{"paytm":{"code":"paytm","title":"Credit Card \/ Debit Card (Paytm PG)","sort_order":null,"terms":""},"cod":{"code":"cod","title":"Cash On Delivery","terms":"","sort_order":"5"}},"code":"","comment":"test comment","agree":""}}

#pragma mark - Get Payment Methods

- (void)getPaymentMethod{
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@paymentmethods",API_BASE_URL];
    
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            NSDictionary *methodsDic = [[jsonDict objectForKey:@"data"] objectForKey:@"payment_methods"];
            self.paymentMethodsArray = [[NSArray alloc] initWithArray:[methodsDic allValues]];
            
            float yCord = 5;
            
            for (int i = 0; i <[self.paymentMethodsArray count]; i++) {
                
                NSString *title = [[self.paymentMethodsArray objectAtIndex:i] objectForKey:@"title"];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(9, yCord, 180, 30)];
                [btn addTarget:self action:@selector(paymentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
                [btn setTitle:title forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 28, 0, 0)];
                [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
                [btn setBackgroundImage:[UIImage imageNamed:@"NonSelectedRadio.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"RadioButton.png"] forState:UIControlStateSelected];
                [self.paymentTypeView addSubview:btn];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                btn.selected = NO;
                btn.tag = 100+i;
                
                if (i==0) {
                    btn.selected = YES;
                    self.selectedPaymentMethodCode = [[self.paymentMethodsArray objectAtIndex:i] objectForKey:@"code"];
                }
                
                yCord += 35;
            }
            
            if (yCord < self.paymentTypeView.frame.size.height) {
                yCord = self.paymentTypeView.frame.size.height;
            }
            
            self.paymentTypeView.frame = CGRectMake(8, 27, self.view.frame.size.width-16, yCord);
            self.paymentMethodView.frame = CGRectMake(0, 240, self.view.frame.size.width, yCord+33);

            self.useCouponCodeButton.frame = CGRectMake(8, self.paymentMethodView.frame.origin.y+self.paymentMethodView.frame.size.height+15, 160, 30);
            self.couponView.frame = CGRectMake(8, self.useCouponCodeButton.frame.origin.y+self.useCouponCodeButton.frame.size.height+8, self.view.frame.size.width-16, 128);
            
            if (!self.useCouponCodeButton.selected) {
                self.useCouponCodeButton.selected = YES;
                [self useCouponCodeButtonAction:self.useCouponCodeButton];
            }
        }
    }];
}

- (void)paymentButtonAction:(id)sender {
    
    UIButton *btn = (UIButton *)[self.paymentTypeView viewWithTag:[sender tag]];
    btn.selected = YES;

    for (int i = 0; i <[self.paymentMethodsArray count]; i++) {
        UIButton *btn = (UIButton *)[self.paymentTypeView viewWithTag:100+i];
        if ([sender tag] != 100+i) {
            btn.selected = NO;
        }
    }
    
    self.selectedPaymentMethodCode = [[self.paymentMethodsArray objectAtIndex:[sender tag]-100] objectForKey:@"code"];
}

#pragma mark - Set Payment Methods

- (void)setPaymentMethod{
    
    if ([self.selectedPaymentMethodCode length] > 0) {
        [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
        NSString *urlString = [NSString stringWithFormat:@"%@paymentmethods",API_BASE_URL];
        
        NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc] init];
        [postDictionary setObject:self.selectedPaymentMethodCode forKey:@"payment_method"];
        [postDictionary setObject:@"1" forKey:@"agree"];
        [postDictionary setObject:@"test comment" forKey:@"comment"];
        
        [APIHandler getResponseFor:postDictionary url:[NSURL URLWithString:urlString] requestType:@"POST" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
            [ActivityIndicator stopAnimatingForView:self.view];
            
            if (success) {
                [self confirmOrder];
            }
        }];
    }
    else {
        [APIHandler showMessage:@"Please select payment method"];
    }
}

#pragma mark - Confirm Order

- (void)confirmOrder{
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@confirm",API_BASE_URL];
    
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"POST" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            if ([self.selectedPaymentMethodCode isEqualToString:@"cod"]) {
                [self confirmOrderForCOD];
            }
            else if ([self.selectedPaymentMethodCode isEqualToString:@"ccavenue"]) {
                CCAvenuePayViewController *obj = [[CCAvenuePayViewController alloc] initWithNibName:@"CCAvenuePayViewController" bundle:nil];
                [self.navigationController pushViewController:obj animated:YES];
                obj = nil;
            }
            else if ([self.selectedPaymentMethodCode isEqualToString:@"paytm"]) {
                NSString *orderId = [[[jsonDict objectForKey:@"data"] objectForKey:@"order"] objectForKey:@"order_id"];
                NSString *totalAmount = [[[[jsonDict objectForKey:@"data"] objectForKey:@"totals"] lastObject] objectForKey:@"text"];
                
                [self performPaymentFromPaytm:orderId txnAmount:totalAmount];
            }
        }
    }];
}

#pragma mark - Confirm Order For COD

- (void)confirmOrderForCOD{
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@confirm",API_BASE_URL];
    
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"PUT" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            [APIHandler showMessage:[NSString stringWithFormat:@"Your Order has been successfully placed. Your Order Id is %@",jsonDict[@"order_id"]]];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"cartItemCount"];
        }
    }];
}

#pragma mark - Paytm SDK Methods

-(NSString*)generateOrderIDWithPrefix:(NSString *)prefix
{
    srand ( (unsigned)time(NULL) );
    int randomNo = rand(); //just randomizing the number
    NSString *orderID = [NSString stringWithFormat:@"%@%d", prefix, randomNo];
    return orderID;
}

-(void)showController:(PGTransactionViewController *)controller
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)removeController:(PGTransactionViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)performPaymentFromPaytm:(NSString *)orderId txnAmount:(NSString *)totalAmount
{
    //Step 1: Create a default merchant config object
    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
    
    //Step 2: If you have your own checksum generation and validation url set this here. Otherwise use the default Paytm urls
    
    //Production
    mc.checksumGenerationURL = @"http://market.knottykart.com/index.php?route=payment/paytm/checksum";
    mc.checksumValidationURL = @"http://market.knottykart.com/index.php?route=payment/paytm/verifychecksum";
    
    //Step 3: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
    NSMutableDictionary *orderDict = [NSMutableDictionary new];
    
    //Merchant configuration in the order object
    
    //Production
    orderDict[@"CHANNEL_ID"] = @"WAP";
    orderDict[@"INDUSTRY_TYPE_ID"] = @"Retail124";
    orderDict[@"MID"] = @"Knotty58987772359204";
    orderDict[@"WEBSITE"] = @"Knottykartwap";
    
    //Order configuration in the order object
    orderDict[@"TXN_AMOUNT"] = totalAmount;
    orderDict[@"ORDER_ID"] = orderId;
    orderDict[@"CUST_ID"] = @"18870";
    orderDict[@"MOBILE_NO"] = @"9990323840";
    orderDict[@"EMAIL"] = @"sachinkhard@gmail.com";
    
    PGOrder *order = [PGOrder orderWithParams:orderDict];
    
    //Step 4: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
    //PGTransactionViewController and set the serverType to eServerTypeProduction
    
    [PGServerEnvironment createProductionEnvironment];
    PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    txnController.serverType = eServerTypeProduction;
    txnController.merchant = mc;
    txnController.delegate = self;
    [self showController:txnController];
}

#pragma mark - PGTransactionViewController delegate

- (void)didSucceedTransaction:(PGTransactionViewController *)controller
                     response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didSucceedTransactionresponse= %@", [response description]);
    [APIHandler showMessage:[NSString stringWithFormat:@"Your Order has been successfully placed. Your Order Id is %@", response[@"ORDERID"]]];

//    [self removeController:controller];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"cartItemCount"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFailTransaction error = %@ response= %@", error, [response description]);
    if (response)
    {
        [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:response[@"RESPMSG"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else if (error)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    [self removeController:controller];
}

- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didCancelTransaction error = %@ response= %@", error, response);
    NSString *msg = nil;
    if (!error) {
        msg = [NSString stringWithFormat:@"Successful"];
    }
    else {
        msg = [NSString stringWithFormat:@"UnSuccessful"];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self removeController:controller];
}

- (void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFinishCASTransaction:response = %@", response);
}


@end
