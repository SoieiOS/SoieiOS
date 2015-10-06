//
//  DashboardViewController.h
//  Soie
//
//  Created by Abhishek Tyagi on 12/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTwitterPagerTabStripViewController.h"
#import "SWRevealViewController.h"

@interface DashboardViewController : XLTwitterPagerTabStripViewController

@property (nonatomic, strong) NSMutableArray                  *listOfCategories;
@end
