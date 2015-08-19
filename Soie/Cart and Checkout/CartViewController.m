//
//  CartViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 09/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "CartViewController.h"
#import "CustomCollectionViewCell.h"
#import "CartObject.h"
#import "Utilities.h"
#import "UIImageView+AFNetworking.h"
#import "AddressListViewController.h"
#import "SelectAddAddressViewController.h"

@implementation CartViewController {
    CartObject                      *cartInstance;
    IBOutlet UICollectionView       *cartCollectionView;
    IBOutlet UILabel                *priceLabel;
}

- (void)viewDidLoad {
    self.title = @"My cart";
    cartInstance = [CartObject getInstance];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    [self getTotalPrice];
}

- (void)cancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)getTotalPrice {
    float totalPrice = 0;
    for (int i = 0; i < cartInstance.listOfCartItems.count; i++) {
        NSDictionary *productInfo = [cartInstance.listOfCartItems objectAtIndex:i];
        totalPrice = totalPrice + [[productInfo objectForKey:@"price"] floatValue];
    }
    priceLabel.text = [NSString stringWithFormat:@"%0.1f",totalPrice];
}

- (IBAction)stepperValueChanged:(UIStepper *)stepper
{
//    NSLog(@"Value : %f",stepper.value);
//    NSLog(@"Tag : %ld",(long)stepper.tag);
//    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    CustomTableViewCell *cell = (CustomTableViewCell *)[cartTableView cellForRowAtIndexPath:newIndexPath];
//    cell.numberLabel.text = [NSString stringWithFormat:@"%.0f",stepper.value];
//    NSLog(@"%@",[NSString stringWithFormat:@"%.0f",stepper.value]);
//    NSString *qtyValue = [NSString stringWithFormat:@"%0.0f",stepper.value];
//    
//    [cartInstance.listOfCartItems removeObjectAtIndex:stepper.tag];
//    [cartTableView reloadData];
}

- (IBAction)proceedToCheckoutButtonClicked:(id)sender {
    SelectAddAddressViewController *selectAddAddressView = [self.storyboard instantiateViewControllerWithIdentifier:@"selectAddAddressView"];
//    addressListView.addressType = @"paymentaddress";
    [self.navigationController pushViewController:selectAddAddressView animated:YES];
    
//    SelectAddAddressViewController *obj = [[SelectAddAddressViewController alloc] initWithNibName:@"SelectAddAddressViewController" bundle:nil];
//    [self.navigationController pushViewController:obj animated:YES];
//    obj = nil;
    
}

//#pragma mark Tableview Delegates
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;//cartInstance.listOfCartItems.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CustomTableViewCell *cell;
//    cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cartItemCell"];
//    
////    NSDictionary *productInfo = [cartInstance.listOfCartItems objectAtIndex:indexPath.row];
////    cell.titleLabel.text = [productInfo objectForKey:@"name"];
//    cell.quantityStepper.tag = indexPath.row;
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 170;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

#pragma mark C0llectionview Delegate-------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return cartInstance.listOfCartItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"productCell";
    
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [Utilities makeRoundCornerForObject:cell ofRadius:8];
    NSDictionary *productInfo = [cartInstance.listOfCartItems objectAtIndex:indexPath.row];
    if (productInfo.allKeys.count > 0) {
        cell.titleLabel.text = [productInfo objectForKey:@"name"];
        cell.priceLabel.text = [productInfo objectForKey:@"price"];
        cell.titleLabel.text = [productInfo objectForKey:@"name"];
        NSString *imageUrl = [productInfo objectForKey:@"image"];
        [cell.thumbnailImageView setImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
        if (imageUrl && ![imageUrl isEqual:[NSNull null]]) {
            [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.frame.size.width - 15)/2;
    return CGSizeMake(228,259);
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
//    ProductDetailsViewController *productDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"productDetailsView"];
//    productDetailsView.productInfo = [listOfProducts objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:productDetailsView animated:YES];
}


@end
