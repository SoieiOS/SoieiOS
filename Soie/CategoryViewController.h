//
//  CategoryViewController.h
//  Soie
//
//  Created by Abhishek Tyagi on 03/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface CategoryViewController : UITableViewController {
    IBOutlet UIBarButtonItem        *sidebarButton;
}

@property (nonatomic, strong) NSMutableArray        *listOfCategories;
@property (nonatomic ) BOOL                         isParentView;

@end
