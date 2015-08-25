//
//  SelectAddAddressViewController.m
//  Soie
//
//  Created by Sachin Khard on 13/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "SelectAddAddressViewController.h"
#import "APIHandler.h"
#import "PaymentViewController.h"
#import "CustomTableViewCell.h"
#import "AddressViewController.h"
#import "Utilities.h"

#define HEADER_TITLE_SHIPPING @"Delivery Details"
#define HEADER_TITLE_BILLING @"Billing Details"

@interface SelectAddAddressViewController () {
    BOOL        reloadAddress;
}

@end

@implementation SelectAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    reloadAddress = YES;
    // Do any additional setup after loading the view from its nib.
    self.title = HEADER_TITLE_SHIPPING;
}

- (void)viewWillAppear:(BOOL)animated {
    if (reloadAddress) {
        [self getAddressListFromServer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAddressListFromServer {
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@account/address",API_BASE_URL];
    
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            self.addressArray = [[NSMutableArray alloc] initWithArray:[[jsonDict objectForKey:@"data"] objectForKey:@"addresses"]];
            [self.addressTable reloadData];
            reloadAddress = NO;
        }
    }];
}

#pragma mark - UITableView Delegate/Datasource Methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.addressArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *obj = [self.addressArray objectAtIndex:indexPath.row];

    float height = [Utilities heigthWithWidth:self.view.frame.size.width-16 andFont:[UIFont fontWithName:@"Times New Roman" size:16.0] string:[Utilities formattedAddress:obj]];
    return height+64;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    
    NSDictionary *obj = [self.addressArray objectAtIndex:indexPath.row];
    
    NSString *addressString = [Utilities formattedAddress:obj];
    
    cell.addressButton.tag = indexPath.row;
    cell.addressLabel.text = addressString;
    
    if ([self.navigationItem.title isEqualToString:HEADER_TITLE_SHIPPING]) {
        [cell.addressButton setTitle:@"Select Delivery Address" forState:UIControlStateNormal];
    }
    else {
        [cell.addressButton setTitle:@"Select Billing Address" forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
}

- (IBAction)addButtonClicked:(UIButton *)btn {
    reloadAddress = YES;
    AddressViewController *addressView = [self.storyboard instantiateViewControllerWithIdentifier:@"addressView"];
//    addressView.addressType = _addressType;
    [self.navigationController pushViewController:addressView animated:YES];
}

- (IBAction)addressButtonAction:(UIButton *)btn {
    NSDictionary *obj = [self.addressArray objectAtIndex:btn.tag];
    
    if ([self.navigationItem.title isEqualToString:HEADER_TITLE_SHIPPING]) {
        [self setShippingAddressWithAddressID:[obj objectForKey:@"address_id"]];
    }
    else {
        [self setBillingAddressWithAddressID:[obj objectForKey:@"address_id"]];
    }
}


#pragma mark - Set Shipping Address To Order

- (void)setShippingAddressWithAddressID:(NSString *)addressID{
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@shippingaddress",API_BASE_URL];
    
    NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"existing",@"shipping_address",
                                    addressID,@"address_id",
                                    nil];

    [APIHandler getResponseFor:postDictionary url:[NSURL URLWithString:urlString] requestType:@"POST" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            self.title = HEADER_TITLE_BILLING;
            [self.addressTable reloadData];
        }
    }];
}


#pragma mark - Set Billing Address To Order

- (void)setBillingAddressWithAddressID:(NSString *)addressID{
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@paymentaddress",API_BASE_URL];
    
    NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"existing",@"payment_address",
                                    addressID,@"address_id",
                                    nil];
    
    [APIHandler getResponseFor:postDictionary url:[NSURL URLWithString:urlString] requestType:@"POST" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            PaymentViewController *obj = [[PaymentViewController alloc] initWithNibName:@"PaymentViewController" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES];
            obj = nil;
        }
    }];
}

@end
