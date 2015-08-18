//
//  SelectAddAddressViewController.h
//  Soie
//
//  Created by Sachin Khard on 13/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAddAddressViewController : UIViewController

@property (nonatomic, strong)NSMutableArray *addressArray;
@property (weak, nonatomic) IBOutlet UITableView *addressTable;

@end
