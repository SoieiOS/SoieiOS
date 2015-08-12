//
//  HomeViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 13/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "HomeViewController.h"
#import "ProductsListViewController.h"
#import "AppNavigationController.h"
#import "UIImageView+AFNetworking.h"
#import "APIHandler.h"
#import "Utilities.h"
#import "CustomTableViewCell.h"
#import "CartObject.h"
#import "AddressListViewController.h"
#import "UserInformation.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CartObject *cartInstance = [CartObject getInstance];
    NSDictionary *userInfo = [UserInformation getUserInformation];
    
    if (!userInfo && !cartInstance.sessionId.length > 0) {
        [APIHandler getSessionId];
    }
    else {
        cartInstance.sessionId  = [[userInfo objectForKey:@"user"] objectForKey:@"session"];
    }

    self.title = @"";
    
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    [self getListOfCategories];
    
    UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithTitle:@"User" style:UIBarButtonItemStyleDone target:self action:@selector(userButtonClicked)];
    
    UIBarButtonItem *cartButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(cartButtonClicked)];
    
    self.navigationItem.rightBarButtonItems = @[cartButton,userButton];
    
//    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"checkoutView"] animated:YES];
}

- (void)cartButtonClicked {
//    CartObject *cartInstance = [CartObject getInstance];
//
//    if (!cartInstance.listOfCartItems.count > 0) {
//        [APIHandler showMessage:@"There are no items in the cart."];
//        return;
//    }
    AppNavigationController *appNavigationController = [[AppNavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"cartView"]];
    [self presentViewController:appNavigationController animated:YES completion:nil];
}

- (void)userButtonClicked {
    AppNavigationController *appNavigationController = [[AppNavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"overviewView"]];
    [self presentViewController:appNavigationController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getListOfCategories {
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@/banner",API_BASE_URL];
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            listOfBanner = [[[jsonDict objectForKey:@"data"] objectForKey:@"banner"] mutableCopy];

            listOfCategories = [[[jsonDict objectForKey:@"data"] objectForKey:@"cat_home"] mutableCopy];
            [homeTableview reloadData];
        }
    }];
}

- (void)getListOfFeaturedProducts {
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@/featured",API_BASE_URL];
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            listOfFeaturedProducts = [[jsonDict objectForKey:@"data"] mutableCopy];
            [homeTableview reloadData];
        }
        [self getListOfNewCollection];
    }];
}

- (void)getListOfNewCollection {
    NSString *urlString = [NSString stringWithFormat:@"%@/newcollection",API_BASE_URL];
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){        
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            listOfNewCollection = [[jsonDict objectForKey:@"data"] mutableCopy];
            [homeTableview reloadData];
        }
    }];
}

#pragma mark Tableview Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return listOfCategories.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    /* Section header is in 0th index... */
    if (section == 0) {
        [label setText:@"Soie"];
    }
    else {
        [label setText:[[listOfCategories objectAtIndex:section-1] objectForKey:@"name"]];
    }
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 300;
    }
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell;
    if (indexPath.section == 0) {
        cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"scrollViewCell"];
        [self loadScrollViewForBanner:cell];
    }
    else {
        cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
        NSString *imageUrl = [[listOfCategories objectAtIndex:indexPath.section-1] objectForKey:@"image"];
        imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
//        if (indexPath.row == 1) {
//            cell.titleLabel.text = @"Featured Products";
//            [self loadScrollViewForFeaturedProducts:cell collection:listOfFeaturedProducts];
//        }
//        else {
//            cell.titleLabel.text = @"New Collections";
//            [self loadScrollViewForFeaturedProducts:cell collection:listOfNewCollection];
//        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductsListViewController *productListView = [self.storyboard instantiateViewControllerWithIdentifier:@"productsListView"];
    productListView.title = [[listOfCategories objectAtIndex:indexPath.section-1] objectForKey:@"name"];
    productListView.categoryId = [[listOfCategories objectAtIndex:indexPath.section-1] objectForKey:@"category_id"];
    [self.navigationController pushViewController:productListView animated:YES];
//    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"candidateFeedView"] animated:YES];
}

#pragma mark scrollview methods ------------

- (void)loadScrollViewForBanner:(CustomTableViewCell *)cell {
    //    NSArray *images = [_productInfo objectForKey:@"images"];
    for (int i = 0; i < [listOfBanner count]; i++) {
        CGRect frame;
        frame.origin.x = cell.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = cell.scrollView.frame.size;
        
        UIImageView *subview = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i),0, self.view.frame.size.width, cell.scrollView.frame.size.height)];
        NSString *imageUrl = [[listOfBanner objectAtIndex:i] objectForKey:@"image"];
        imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [subview setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
//        subview.contentMode = UIViewContentModeScaleAspectFit;
        //        subview.backgroundColor = [UIColor blackColor];
        [cell.scrollView addSubview:subview];
    }
    
    cell.pageControl.numberOfPages = listOfBanner.count;
    
    cell.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * listOfBanner.count, cell.frame.size.height-30);
    
}

- (void)loadScrollViewForFeaturedProducts:(CustomTableViewCell *)cell collection:(NSMutableArray *)array {
    //    NSArray *images = [_productInfo objectForKey:@"images"];
    CGFloat width = 200;
    CGFloat height = 300;
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *productInfo = [array objectAtIndex:i];
        
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake((width+10)*i+10,10, width, height)];
        subview.backgroundColor = [UIColor whiteColor];
//        [Utilities makeBorderForObject:subview ofSize:2 color:[UIColor blackColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 200, 200)];
        NSString *imageUrl = [productInfo objectForKey:@"image"];
        imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [subview addSubview:imageView];
        
        [subview addSubview:[Utilities createLabelOfSize:CGRectMake(0,210, width, 30) text:[productInfo objectForKey:@"name"] font:[UIFont systemFontOfSize:13] fontColor:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter]];
        
        if ([[productInfo objectForKey:@"special"] floatValue] == 0) {
            [subview addSubview:[Utilities createLabelOfSize:CGRectMake(0,245, width, 25) text:@"No Discount" font:[UIFont systemFontOfSize:13] fontColor:[UIColor lightGrayColor] alignment:NSTextAlignmentCenter]];
            [subview addSubview:[Utilities createLabelOfSize:CGRectMake(0,270, width, 25) text:[NSString stringWithFormat:@"Rs %.2f",[[productInfo objectForKey:@"price"] floatValue]] font:[UIFont boldSystemFontOfSize:13] fontColor:[UIColor redColor] alignment:NSTextAlignmentCenter]];
        }
        else {
            [subview addSubview:[Utilities createLabelOfSize:CGRectMake(0,245, width, 25) text:[NSString stringWithFormat:@"Rs %.2f",[[productInfo objectForKey:@"price"] floatValue]] font:[UIFont systemFontOfSize:13] fontColor:[UIColor lightGrayColor] alignment:NSTextAlignmentCenter]];
//            [subview addSubview:[Utilities createImageViewOfSize:CGRectMake(0,257, width, 2) image:nil cornerRadius:0 alpha:1 backgroundColor:[UIColor blackColor]]];
            [subview addSubview:[Utilities createLabelOfSize:CGRectMake(0,270, width, 25) text:[NSString stringWithFormat:@"Rs %.2f",[[productInfo objectForKey:@"special"] floatValue]] font:[UIFont boldSystemFontOfSize:13] fontColor:[UIColor redColor] alignment:NSTextAlignmentCenter]];
        }
        [cell.scrollView addSubview:subview];
    }
    cell.pageControl.hidden = YES;
    cell.scrollView.contentSize = CGSizeMake((width+10) * array.count+10,height);
    NSLog(@"Width : %f",(width+10) * array.count);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCell *cell = (CustomTableViewCell *)[homeTableview cellForRowAtIndexPath:newIndexPath];
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    cell.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCell *cell = (CustomTableViewCell *)[homeTableview cellForRowAtIndexPath:newIndexPath];
    CGRect frame;
    frame.origin.x = cell.scrollView.frame.size.width * cell.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = cell.scrollView.frame.size;
    [cell.scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
}

@end
