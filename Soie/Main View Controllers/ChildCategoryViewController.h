//
//  ChildCategoryViewController.h
//  Soie
//
//  Created by Abhishek Tyagi on 12/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"

@interface ChildCategoryViewController : UIViewController <XLPagerTabStripChildItem,UICollectionViewDataSource, UICollectionViewDelegate> {
    IBOutlet UICollectionView       *productCollectionView;
    NSMutableArray                  *listOfProducts;
}

@property (nonatomic, strong) NSString      *categoryId;
@property (nonatomic, strong) NSDictionary  *categoryInfo;

@end
