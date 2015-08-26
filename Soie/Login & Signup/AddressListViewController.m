//
//  AddressListViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 25/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressViewController.h"
#import "CustomTableViewCell.h"
#import "UserInformation.h"
#import "APIHandler.h"
#import "Utilities.h"

@interface AddressListViewController () <UITableViewDataSource, UITableViewDelegate> {
    BOOL                                reloadAddress;
    NSMutableDictionary                 *userInformation;
    NSMutableArray                      *listOfAddresses;
}

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listOfAddresses = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    reloadAddress = YES;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self getListOfAddresses];
}

- (void)addButtonClicked {
    reloadAddress = YES;
    AddressViewController *addressView = [self.storyboard instantiateViewControllerWithIdentifier:@"addressView"];
    addressView.addressType = _addressType;
    [self.navigationController pushViewController:addressView animated:YES];
}

- (void)getListOfAddresses {
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@account/address",API_BASE_URL];
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            listOfAddresses = [[[jsonDict objectForKey:@"data"] objectForKey:@"addresses"] mutableCopy];
            [self.tableView reloadData];
            reloadAddress = NO;
        }
    }];
}

#pragma mark get user information ----

- (void)getUserInformation {
    userInformation = [[[UserInformation getUserInformation] objectForKey:@"user"] mutableCopy];
}

#pragma mark Tableview Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listOfAddresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"addressCell";
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    NSDictionary *addressInfo = [listOfAddresses objectAtIndex:indexPath.row];
    
    NSString *addressString = [Utilities formattedAddress:addressInfo];
    
    cell.addressLabel.text = addressString;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *obj = [listOfAddresses objectAtIndex:indexPath.row];
    
    float height = [Utilities heigthWithWidth:self.view.frame.size.width-16 andFont:[UIFont fontWithName:@"Times New Roman" size:16.0] string:[Utilities formattedAddress:obj]];
    return height+20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    reloadAddress = YES;
    AddressViewController *addressView = [self.storyboard instantiateViewControllerWithIdentifier:@"addressView"];
    addressView.addressInfo = [listOfAddresses objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:addressView animated:YES];
}

@end
