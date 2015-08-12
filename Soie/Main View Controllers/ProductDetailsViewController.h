//
//  ProductDetailsViewController.h
//  Soie
//
//  Created by Abhishek Tyagi on 17/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectSizeColorViewController.h"

@interface ProductDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PickerViewControllerDelegate> {
    IBOutlet UITableView        *productDetailsTableview;
    BOOL                        pageControlBeingUsed;
    NSMutableDictionary         *productOptions;
}

@property (nonatomic, strong) NSDictionary      *productInfo;
@property (nonatomic, strong) NSString          *selectedSize;
@property (nonatomic, strong) NSString          *selectedColor;
@property (nonatomic)         BOOL              isSizeSelected;

@end
