//
//  ProductsListViewController.h
//  Soie
//
//  Created by Abhishek Tyagi on 17/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductsListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    IBOutlet UICollectionView       *productCollectionView;
    NSMutableArray                  *listOfProducts;
}

@property (nonatomic, strong) NSString *categoryId;

@end
