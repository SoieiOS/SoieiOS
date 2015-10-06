//
//  OverviewViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 12/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "OverviewViewController.h"
#import "Utilities.h"

@interface OverviewViewController ()

@end

@implementation OverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Utilities makeRoundCornerForObject:loginButton ofRadius:3];
    [Utilities makeRoundCornerForObject:signUpButton ofRadius:3];
    [Utilities makeBorderForObject:loginButton ofSize:2 color:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    [self addBackgroundView];
        
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
//    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)cancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addBackgroundView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.image = [UIImage imageNamed:@"login_bg.png"];
    [self.view insertSubview:imageView atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
//    [Utilities setTransparentNavigationBar:self.navigationController];
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
