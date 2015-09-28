//
//  ProductsListViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 17/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "ProductsListViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CustomCollectionViewCell.h"
#import "ProductDetailsViewController.h"
#import "UserInformation.h"
#import "APIHandler.h"
#import "Utilities.h"
#import "BBBadgeBarButtonItem.h"

#define kDoubleColumnProbability 40
@interface ProductsListViewController () {
    BBBadgeBarButtonItem *cartButton;
}

@end

@implementation ProductsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getListOfProducts];
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    // Add your action to your button
    [customButton addTarget:self action:@selector(cartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    // Customize your button as you want, with an image if you have a pictogram to display for example
    [customButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    
    // Then create and add our custom BBBadgeBarButtonItem
    cartButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    cartButton.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"cartItemCount"];
    
    self.navigationItem.rightBarButtonItem = cartButton;
}

- (void)cartButtonClicked {
    [UserInformation openCartView:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [productCollectionView reloadData];
    cartButton.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"cartItemCount"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getListOfProducts {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSString *deviceId = [userDefaults objectForKey:@"kPushNotificationUDID"];
    //    malhotra.m0012@gmail.com/naresh1234
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@/products",API_BASE_URL];
    
    if (_categoryId.length > 0) {
        urlString = [NSString stringWithFormat:@"%@/category/%@",urlString,_categoryId];
    }
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            listOfProducts = [[NSMutableArray alloc] initWithArray:[jsonDict objectForKey:@"data"]];
            [productCollectionView reloadData];
        }
    }];
}

#pragma mark C0llectionview Delegate-------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return listOfProducts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"productCell";
    
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary *productInfo = [listOfProducts objectAtIndex:indexPath.row];
    if (productInfo) {
        cell.titleLabel.text = [productInfo objectForKey:@"name"];
        cell.priceLabel.attributedText = [Utilities getAttributedStringForDiscounts:productInfo];
        NSString *imageUrl = [productInfo objectForKey:@"image"];
        [cell.thumbnailImageView setImage:[UIImage imageNamed:@"no_image_products.png"]];
        if (imageUrl && ![imageUrl isEqual:[NSNull null]]) {
            [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"no_image_products.png"]];
        }
        cell.wishListButton.tag = indexPath.row;
        if ([UserInformation checkProductPresentInWishList:productInfo]) {
            [cell.wishListButton setImage:[UIImage imageNamed:@"wishlist_selected.png"] forState:UIControlStateNormal];
        }
        else {
            [cell.wishListButton setImage:[UIImage imageNamed:@"wishlist_desel.png"] forState:UIControlStateNormal];
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.frame.size.width - 15)/2;
    return CGSizeMake(width,width+120);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        return UIEdgeInsetsMake(0,0,0,0);
    }
    return UIEdgeInsetsMake(0,8,0,8);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailsViewController *productDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"productDetailsView"];
    productDetailsView.productInfo = [listOfProducts objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:productDetailsView animated:YES];
}

#pragma mark userWishlist methods

- (IBAction)addToWishlistButtonClicked:(UIButton *)button {
    [UserInformation saveProductInUserWishlist:[listOfProducts objectAtIndex:button.tag]];
    [productCollectionView reloadData];
}


@end
