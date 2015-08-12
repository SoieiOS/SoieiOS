//
//  CountryListViewController.h
//  Soie
//
//  Created by Abhishek Tyagi on 19/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountryListDelegate <NSObject>
@required
- (void)stateSelected:(NSDictionary *)stateInfo;
// ... other methods here
@end

@interface CountryListViewController : UITableViewController

@property (nonatomic, weak) id <CountryListDelegate> delegate;

@end
