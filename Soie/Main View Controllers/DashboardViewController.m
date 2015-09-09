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
#import "BBBadgeBarButtonItem.h"

@interface DashboardViewController () {
    NSMutableArray                  *listOfCategories;
    IBOutlet UIBarButtonItem        *sidebarButton;
    BBBadgeBarButtonItem            *cartButton;
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
//    NSDictionary *userInfo = [UserInformation getUserInformation];
    CartObject *cartInstance = [CartObject getInstance];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"isloggedin"]) {
        [APIHandler autoLoginUser:[userDefaults objectForKey:@"usernamePassword"] completionBlock:nil];
    }
    else if (cartInstance.sessionId.length == 0){
        [APIHandler getSessionId];
    }
    
    
    self.title = @"";
    
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    [self getListOfCategories];

    UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_tab_profile.png"] style:UIBarButtonItemStyleDone target:self action:@selector(userButtonClicked)];
    
//    UIBarButtonItem *cartButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(cartButtonClicked)];
    
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    // Add your action to your button
    [customButton addTarget:self action:@selector(cartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    // Customize your button as you want, with an image if you have a pictogram to display for example
    [customButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    
    // Then create and add our custom BBBadgeBarButtonItem
    cartButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    self.navigationItem.rightBarButtonItems = @[cartButton,userButton];
    

}

- (void)viewWillAppear:(BOOL)animated {
    cartButton.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"cartItemCount"];
}

- (void)cartButtonClicked {
    [UserInformation openCartView:self];
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

- (void)userButtonClicked {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL loggedIn = [defaults boolForKey:@"isloggedin"];
//    AppNavigationController *appNavigationController = [[AppNavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"overviewView"]];
    id viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"overviewView"];
    if (loggedIn) {
//        appNavigationController = [[AppNavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"myAccountView"]];
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myAccountView"];
    }
    [self.navigationController pushViewController:viewController animated:YES];
//    [self presentViewController:viewController animated:YES completion:nil];
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
