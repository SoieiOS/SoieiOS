//
//  ChildCategoryViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 12/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "ChildCategoryViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CustomCollectionViewCell.h"
#import "ProductDetailsViewController.h"
#import "UserInformation.h"
#import "APIHandler.h"
#import "Utilities.h"
@interface ChildCategoryViewController ()

@end

@implementation ChildCategoryViewController

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listOfProducts = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    
    pageNumber = 1;
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    [self getListOfProducts:pageNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [productCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getListOfProducts:(NSInteger)page {
    NSString *urlString = [NSString stringWithFormat:@"%@/products/category/%@/limit/10/page/%ld",API_BASE_URL,[_categoryInfo objectForKey:@"category_id"],(long)page];

    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            allProductsLoaded = YES;
            if ([[jsonDict objectForKey:@"data"] count] > 0) {
                [listOfProducts addObjectsFromArray:[jsonDict objectForKey:@"data"]];
                allProductsLoaded = NO;
            }
            isLoading = NO;
            [productCollectionView reloadData];
        }
    }];
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [_categoryInfo objectForKey:@"name"];
}


#pragma mark Collectionview Delegate-------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return listOfProducts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"productCell";
    
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
//    [Utilities makeRoundCornerForObject:cell ofRadius:8];
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
    return CGSizeMake(width,width+100);
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

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!allProductsLoaded && !isLoading && listOfProducts.count%10==0) {
        isLoading = YES;
        NSLog(@"Cell displayed");
        pageNumber = pageNumber + 1;
        [self getListOfProducts:pageNumber];
    }
}
#pragma mark userWishlist methods 

- (IBAction)addToWishlistButtonClicked:(UIButton *)button {
    NSLog(@"Button : %ld",(long)button.tag);
    [UserInformation saveProductInUserWishlist:[listOfProducts objectAtIndex:button.tag]];
    
    NSLog(@"%@",[UserInformation getUserWishList]);
    [productCollectionView reloadData];
}

@end
