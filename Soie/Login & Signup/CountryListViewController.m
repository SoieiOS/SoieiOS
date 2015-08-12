//
//  CountryListViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 19/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "CountryListViewController.h"
#import "CustomTableViewCell.h"
#import "APIHandler.h"

@interface CountryListViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableDictionary                 *userInformation;
    NSMutableArray                      *listOfStates;
}

@end

@implementation CountryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listOfStates = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked)];
//    self.navigationItem.rightBarButtonItem = addButton;
    [self getListOfStates];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)cancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addButtonClicked {
    
}

- (void)getListOfStates {
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@/countries/99",API_BASE_URL];
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            listOfStates = [[[jsonDict objectForKey:@"data"] objectForKey:@"zone"] mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark Tableview Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listOfStates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    personalDetailsCell
    //    uploadThumbnailCell
    NSString *cellIdentifier = @"countryCell";
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.titleLabel.text = [[listOfStates objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate stateSelected:[listOfStates objectAtIndex:indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
