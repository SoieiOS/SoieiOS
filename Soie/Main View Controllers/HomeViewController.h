//
//  HomeViewController.h
//  Soie
//
//  Created by Abhishek Tyagi on 13/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface HomeViewController : UIViewController {
    IBOutlet UIBarButtonItem        *sidebarButton;
    IBOutlet UITableView            *homeTableview;
    
    NSMutableArray                  *listOfBanner;
    NSMutableArray                  *listOfCategories;
    NSMutableArray                  *listOfFeaturedProducts;
    NSMutableArray                  *listOfNewCollection;

    BOOL                        pageControlBeingUsed;
}

@end
