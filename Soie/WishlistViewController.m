//
//  WishlistViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 14/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "WishlistViewController.h"
#import "CustomCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "Utilities.h"
#import "UserInformation.h"
#import "ProductDetailsViewController.h"
#import "BBBadgeBarButtonItem.h"

@interface WishlistViewController () {
    BBBadgeBarButtonItem *cartButton;
}

@end

@implementation WishlistViewController

static NSString * const reuseIdentifier = @"productCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view.
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    // Add your action to your button
    [customButton addTarget:self action:@selector(cartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    // Customize your button as you want, with an image if you have a pictogram to display for example
    [customButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    
    // Then create and add our custom BBBadgeBarButtonItem
    cartButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    
    self.navigationItem.rightBarButtonItem = cartButton;
}

- (void)viewWillAppear:(BOOL)animated {
    cartButton.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"cartItemCount"];
}

- (void)cartButtonClicked {
    [UserInformation openCartView:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

#pragma mark Collectionview Delegate-------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _listOfProducts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"productCell";
    
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [Utilities makeRoundCornerForObject:cell ofRadius:8];
    NSDictionary *productInfo = [_listOfProducts objectAtIndex:indexPath.row];
    if (productInfo) {
        cell.titleLabel.text = [productInfo objectForKey:@"name"];
        cell.priceLabel.attributedText = [Utilities getAttributedStringForDiscounts:productInfo];
        NSString *imageUrl = [productInfo objectForKey:@"image"];
        [cell.thumbnailImageView setImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
        if (imageUrl && ![imageUrl isEqual:[NSNull null]]) {
            [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
        }
        cell.removeButton.tag = indexPath.row;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.frame.size.width - 15)/2;
    return CGSizeMake(width,width+63);
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
    productDetailsView.productInfo = [_listOfProducts objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:productDetailsView animated:YES];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark userWishlist methods

- (IBAction)removeFromWishlistButtonClicked:(UIButton *)button {
    NSLog(@"Button : %ld",(long)button.tag);
    [UserInformation removeProductFromWishList:[_listOfProducts objectAtIndex:button.tag]];
    
    NSLog(@"%@",[UserInformation getUserWishList]);
    
    _listOfProducts = [UserInformation getUserWishList];
    
    [productCollectionView reloadData];
}

@end
