//
//  WishlistViewController.h
//  Soie
//
//  Created by Abhishek Tyagi on 14/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface WishlistViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    IBOutlet UICollectionView       *productCollectionView;
    IBOutlet UIBarButtonItem        *sidebarButton;
}

@property (nonatomic, strong) NSMutableArray        *listOfProducts;
@end
