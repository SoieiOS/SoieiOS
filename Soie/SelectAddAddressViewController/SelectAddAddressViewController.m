//
//  SelectAddAddressViewController.m
//  Soie
//
//  Created by Sachin Khard on 13/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "SelectAddAddressViewController.h"
//#import "AddressCell.h"
#import "APIHandler.h"
#import "PaymentViewController.h"
#import "CustomTableViewCell.h"

#define HEADER_TITLE_SHIPPING @"Delivery Details"
#define HEADER_TITLE_BILLING @"Billing Details"

@interface SelectAddAddressViewController ()

@end

@implementation SelectAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = HEADER_TITLE_SHIPPING;
    [self getAddressListFromServer];
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
        }
    }];
}

- (NSString *)formattedAddress:(NSDictionary *)obj {
    NSString *addressString = @"";
    
    if ([[obj objectForKey:@"firstname"] length] > 0) {
        addressString = [obj objectForKey:@"firstname"];
    }
    if ([[obj objectForKey:@"lastname"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@" %@",[obj objectForKey:@"lastname"]];
    }
    if ([[obj objectForKey:@"address_1"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@"\n%@",[obj objectForKey:@"address_1"]];
    }
    if ([[obj objectForKey:@"address_2"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@"\n%@",[obj objectForKey:@"address_2"]];
    }
    if ([[obj objectForKey:@"city"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@"\n%@",[obj objectForKey:@"city"]];
    }
    if ([[obj objectForKey:@"postcode"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@" %@",[obj objectForKey:@"postcode"]];
    }
    if ([[obj objectForKey:@"zone"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@"\n%@",[obj objectForKey:@"zone"]];
    }
    if ([[obj objectForKey:@"country"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@" %@",[obj objectForKey:@"country"]];
    }

    return addressString;
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

    float height = [self calculateTextHeight:[self formattedAddress:obj] maxWidth:284 fontName:[UIFont fontWithName:@"Times New Roman" size:16.0]]+10;

    return height+64;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    
    NSDictionary *obj = [self.addressArray objectAtIndex:indexPath.row];
    
    NSString *addressString = [self formattedAddress:obj];
    
    cell.addressButton.tag = indexPath.row;
    cell.addressLabel.text = addressString;
//    NSString *CellIdentifier = [NSString stringWithFormat:@"AddressCell-%ld",(long)indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    AddressCell *itemCell = nil;
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.backgroundColor = [UIColor clearColor];
//        
//        itemCell = [[AddressCell alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
//        [cell.contentView addSubview:itemCell];
//        itemCell.tag = 101;
//    }
//    
//    itemCell = (AddressCell *)[cell.contentView viewWithTag:101];
//    [itemCell.addressButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
//    [itemCell.addressButton addTarget:self action:@selector(addressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    itemCell.addressButton.tag = indexPath.row;
//    
    
//
//    float height = [self calculateTextHeight:addressString maxWidth:284 fontName:[UIFont fontWithName:@"Times New Roman" size:16.0]]+10;
//    itemCell.addressLabel.text = addressString;
//  
//    CGRect frame = itemCell.bgView.frame;
//    frame.size.height = height+16;
//    itemCell.bgView.frame = frame;
//    
//    frame = itemCell.addressLabel.frame;
//    frame.size.height = height;
//    itemCell.addressLabel.frame = frame;
//
//    frame = itemCell.addressButton.frame;
//    frame.origin.y = itemCell.bgView.frame.size.height+itemCell.bgView.frame.origin.y;
//    itemCell.addressButton.frame = frame;
//    
//    frame = itemCell.frame;
//    frame.size.height = itemCell.addressButton.frame.size.height+itemCell.addressButton.frame.origin.y+16;
//    itemCell.frame = frame;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
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

- (CGFloat)calculateTextHeight:(NSString *)str maxWidth:(CGFloat)width fontName:(UIFont *)font {
    CGFloat height = 0;
    if ([str length] > 0) {
        height = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{
                                             NSFontAttributeName : font
                                             }
                                   context:nil].size.height;
    }
    return height;
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
