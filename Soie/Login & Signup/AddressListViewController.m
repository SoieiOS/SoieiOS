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

@interface AddressListViewController () <UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate> {
    
    NSMutableDictionary                 *userInformation;
    NSMutableArray                      *listOfAddresses;
}

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listOfAddresses = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self getListOfAddresses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addButtonClicked {
    AddressViewController *addressView = [self.storyboard instantiateViewControllerWithIdentifier:@"addressView"];
    addressView.addressType = _addressType;
    [self.navigationController pushViewController:addressView animated:YES];
}

- (void)getListOfAddresses {
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_BASE_URL,_addressType];
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        if (success) {
            NSLog(@"Response : %@",jsonDict);
//            listOfAddresses = [[[jsonDict objectForKey:@"data"] objectForKey:@"addresses"] mutableCopy];
//            [self.tableView reloadData];
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

//    NSDictionary *addressInfo = [listOfAddresses objectAtIndex:indexPath.row];
//    NSDictionary *addressInfo1 = [addressInfo objectForKey:[addressInfo objectForKey:@"address_id"]];
//    cell.titleLabel.text = [addressInfo1 objectForKey:@"firstname"];
//    cell.subTitleLabel.text = [userInformation objectForKey:@"firstname"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
