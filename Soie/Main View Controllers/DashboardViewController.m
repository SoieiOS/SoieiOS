//
//  DashboardViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 12/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "DashboardViewController.h"
#import "ChildCategoryViewController.h"
#import "AppNavigationController.h"
#import "APIHandler.h"
#import "CartObject.h"
#import "UserInformation.h"
#import "MyAccountViewController.h"

@interface DashboardViewController () {
    NSMutableArray                  *listOfCategories;
    IBOutlet UIBarButtonItem        *sidebarButton;
}

@end

@implementation DashboardViewController

{
    BOOL _isReload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isReload = NO;
    self.isProgressiveIndicator = YES;
    self.isElasticIndicatorLimit = YES;
    // Do any additional setup after loading the view.
    NSDictionary *userInfo = [UserInformation getUserInformation];
    CartObject *cartInstance = [CartObject getInstance];
    
    if (!userInfo && !cartInstance.sessionId.length > 0) {
        [APIHandler getSessionId];
    }
    else {
        cartInstance.sessionId  = [[userInfo objectForKey:@"user"] objectForKey:@"session"];
        [CartObject getCartItems];
    }
    
    self.title = @"";
    
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    [self getListOfCategories];
    
    UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithTitle:@"User" style:UIBarButtonItemStyleDone target:self action:@selector(userButtonClicked)];
    
    UIBarButtonItem *cartButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(cartButtonClicked)];
    
    self.navigationItem.rightBarButtonItems = @[cartButton,userButton];
    
    [self getListOfCategories];
}

- (void)getListOfCategories {
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@/banner",API_BASE_URL];
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            CartObject *cartInstance = [CartObject getInstance];
            cartInstance.listOfBanners = [[[jsonDict objectForKey:@"data"] objectForKey:@"banner"] mutableCopy];
            listOfCategories = [[[jsonDict objectForKey:@"data"] objectForKey:@"cat_home"] mutableCopy];
            _isReload = YES;
            [self reloadPagerTabStripView];
        }
    }];
}

- (void)cartButtonClicked {
    CartObject *cartInstance = [CartObject getInstance];
    
    if (!cartInstance.listOfCartItems.count > 0) {
        [APIHandler showMessage:@"There are no items in the cart."];
        return;
    }
    AppNavigationController *appNavigationController = [[AppNavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"cartView"]];
    [self presentViewController:appNavigationController animated:YES completion:nil];
}

- (void)userButtonClicked {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL loggedIn = [defaults boolForKey:@"isloggedin"];
    AppNavigationController *appNavigationController = [[AppNavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"overviewView"]];

    if (loggedIn) {
        appNavigationController = [[AppNavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"myAccountView"]];
    }
    [self presentViewController:appNavigationController animated:YES completion:nil];
}


#pragma mark - XLPagerTabStripViewControllerDataSource

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (_isReload){
        for (int i = 0;i < listOfCategories.count; i++) {
            ChildCategoryViewController *childCategoryView = [self.storyboard instantiateViewControllerWithIdentifier:@"childCategoryView"];
            childCategoryView.categoryInfo = [listOfCategories objectAtIndex:i];
            [array addObject:childCategoryView];
        }
        return array;
    }
    return array;
}

- (IBAction)reloadTapped:(id)sender {
    _isReload = YES;
    [self reloadPagerTabStripView];
}

@end
