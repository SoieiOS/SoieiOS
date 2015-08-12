//
//  MenuViewController.h
//  INRVU
//
//  Created by Abhishek Tyagi on 27/05/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UITableViewController <UIAlertViewDelegate> {
    NSArray             *menuItems;
    UILabel             *nameLabel;
    UIImageView         *userImageView;
}

@end
