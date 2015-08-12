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
#import "APIHandler.h"
#import "Utilities.h"

#define kDoubleColumnProbability 40
@interface ProductsListViewController ()

@end

@implementation ProductsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getListOfProducts];
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

/*-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    MosaicLayout *layout = (MosaicLayout *)productCollectionView.collectionViewLayout;
    [layout invalidateLayout];
}*/

#pragma mark C0llectionview Delegate-------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return listOfProducts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"productCell";
    
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [Utilities makeRoundCornerForObject:cell ofRadius:8];
    NSDictionary *friendInfo = [listOfProducts objectAtIndex:indexPath.row];
    if (friendInfo.allKeys.count > 0) {
        cell.titleLabel.text = [friendInfo objectForKey:@"name"];
        cell.priceLabel.text = [friendInfo objectForKey:@"price"];
        cell.titleLabel.text = [friendInfo objectForKey:@"name"];
        NSString *imageUrl = [friendInfo objectForKey:@"image"];
        [cell.thumbnailImageView setImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
        if (imageUrl && ![imageUrl isEqual:[NSNull null]]) {
            [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.frame.size.width - 15)/2;
    return CGSizeMake(width,width+23);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
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

@end
