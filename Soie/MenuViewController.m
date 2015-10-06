//
//  MenuViewController.m
//  INRVU
//
//  Created by Abhishek Tyagi on 27/05/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "AppNavigationController.h"
#import "CategoryViewController.h"
#import "UserInformation.h"
#import "WishlistViewController.h"
#import "CustomTableViewCell.h"
#import "Utilities.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self createHeaderView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    menuItems = @[@"User",@"Home",@"Explore", @"Favourites",@"Blog",@"Store"];
}

- (void)createHeaderView {
    self.tableView.opaque = NO;
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 160)];
        
//        UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [profileButton addTarget:self
//                          action:@selector(profileButtonClicked)
//                forControlEvents:UIControlEventTouchUpInside];
//        [profileButton setTitle:@"" forState:UIControlStateNormal];
//        profileButton.frame = CGRectMake(0, 0, 385, 64);
//        [view addSubview:profileButton];
        
        userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
        userImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        userImageView.layer.masksToBounds = YES;
        userImageView.layer.cornerRadius = 50;
        userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        userImageView.layer.borderWidth = 0.0f;
        userImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        userImageView.layer.shouldRasterize = YES;
        userImageView.clipsToBounds = YES;
        userImageView.backgroundColor = [UIColor lightGrayColor];
        userImageView.image = [UIImage imageNamed:@"userPlaceholder.jpg"];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
//        label.text = @"Welcome, ";
//        label.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor darkGrayColor];
//        label.textAlignment = NSTextAlignmentLeft;
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 200, 20)];
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"Hello";

        view.backgroundColor = [UIColor clearColor];
        [view addSubview:userImageView];
//        [view addSubview:label];
        [view addSubview:nameLabel];
        view;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
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
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@Cell",[menuItems objectAtIndex:indexPath.row]]];
    if (indexPath.row == 0) {
        NSDictionary *userInfo = [[UserInformation getUserInformation] objectForKey:@"user"];
        
        if (userInfo) {
            cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@",[userInfo objectForKey:@"firstname"],[userInfo objectForKey:@"lastname"]];
            cell.subTitleLabel.text = [userInfo objectForKey:@"email"];
        }
        else {
            cell.titleLabel.text = @"Guest";
            cell.subTitleLabel.text = @"";
        }
        

        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"profilePicture"];
        if (imageData != nil && ![imageData isEqual:[NSNull null]]) {
            if (imageData.length > 0) {
                [Utilities makeRoundCornerForObject:cell.iconImageView ofRadius:cell.iconImageView.frame.size.width/2];
                cell.iconImageView.image = [UIImage imageWithData:imageData];
            }
        }
    }
//    cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 150;
    }
    else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        return;
    }
    id viewController;
    if (indexPath.row == 1) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
    }
    else if (indexPath.row == 2) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"categoryView"];
        [viewController setListOfCategories:[UserInformation getCategoryList]];
        [viewController setIsParentView:YES];
    }
    else if (indexPath.row == 3) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"wishlistView"];
        [viewController setListOfProducts:[UserInformation getUserWishList]];
    }
    else if (indexPath.row == 4) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"blogView"];
    }
    else if (indexPath.row == 5) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"storesView"];
    }
    AppNavigationController* navController = (AppNavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[viewController] animated: NO ];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
    return;
    
}

- (NSString*)getViewIdentifier:(NSString*)viewName {
    NSString *viewIdentitfier;
    viewName = [viewName stringByReplacingOccurrencesOfString:@" " withString:@""];
    viewName = [viewName lowercaseString];
    viewIdentitfier = [NSString stringWithFormat:@"%@Segue",viewName];
    return viewIdentitfier;
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
