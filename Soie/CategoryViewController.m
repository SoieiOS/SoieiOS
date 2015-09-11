//
//  CategoryViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 03/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "CategoryViewController.h"
#import "CustomTableViewCell.h"
#import "ProductsListViewController.h"
#import "UserInformation.h"
#import "BBBadgeBarButtonItem.h"

@interface CategoryViewController () {
    BBBadgeBarButtonItem *cartButton;
}

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isParentView) {
        sidebarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = sidebarButton;
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    // Add your action to your button
    [customButton addTarget:self action:@selector(cartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    // Customize your button as you want, with an image if you have a pictogram to display for example
    [customButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    
    // Then create and add our custom BBBadgeBarButtonItem
    cartButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    
    self.navigationItem.rightBarButtonItem = cartButton;
}

- (void)viewWillAppear:(BOOL)animated {
    cartButton.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"cartItemCount"];
}

- (void)cartButtonClicked {
    [UserInformation openCartView:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _listOfCategories.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    cell.textLabel.text = [[_listOfCategories objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![[[_listOfCategories objectAtIndex:indexPath.row] objectForKey:@"categories"] isEqual:[NSNull null]]) {
        if ([[[_listOfCategories objectAtIndex:indexPath.row] objectForKey:@"categories"] count] > 0) {
            CategoryViewController *categoryView = [self.storyboard instantiateViewControllerWithIdentifier:@"categoryView"];
            categoryView.listOfCategories = [[[_listOfCategories objectAtIndex:indexPath.row] objectForKey:@"categories"] mutableCopy];
            categoryView.title = [[_listOfCategories objectAtIndex:indexPath.row] objectForKey:@"name"];
            [self.navigationController pushViewController:categoryView animated:YES];
        return;
        }
    }
    ProductsListViewController *productListView = [self.storyboard instantiateViewControllerWithIdentifier:@"productsListView"];
    productListView.title = [[_listOfCategories objectAtIndex:indexPath.row] objectForKey:@"name"];
    productListView.categoryId = [[_listOfCategories objectAtIndex:indexPath.row] objectForKey:@"category_id"];
    [self.navigationController pushViewController:productListView animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
