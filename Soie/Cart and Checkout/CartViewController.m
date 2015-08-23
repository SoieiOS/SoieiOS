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
#import "APIHandler.h"
#import "AppNavigationController.h"

@implementation CartViewController {
    CartObject                      *cartInstance;
    IBOutlet UICollectionView       *cartCollectionView;
    IBOutlet UILabel                *priceLabel;
    IBOutlet UILabel                *itemsCountLabel;

}

- (void)viewDidLoad {
    self.title = @"My cart";
    cartInstance = [CartObject getInstance];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    [self getCartItems];
//    [self getTotalPrice];
}

- (void)getCartItems {
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/cart",API_BASE_URL];
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        if (success) {

            NSLog(@"Response : %@",jsonDict);

            [cartInstance setListOfCartItems:[[[jsonDict objectForKey:@"data"] objectForKey:@"products"] mutableCopy]];
            [cartCollectionView reloadData];
            
            itemsCountLabel.text = [NSString stringWithFormat:@"ITEMS(%ld)",(unsigned long)cartInstance.listOfCartItems.count];
            if ([[[jsonDict objectForKey:@"data"] objectForKey:@"totals"] count]>1) {
                [self getTotalPrice:[[[[jsonDict objectForKey:@"data"] objectForKey:@"totals"] objectAtIndex:1] objectForKey:@"text"]];
            }
//
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(unsigned long)cartInstance.listOfCartItems.count] forKey:@"cartItemCount"];
        }
        else if ([[jsonDict objectForKey:@"error"] isEqualToString:@"Cart is empty"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"cartItemCount"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[jsonDict objectForKey:@"error"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)cancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)getTotalPrice:(NSString *)price {
    float totalPrice = 0;
    for (int i = 0; i < cartInstance.listOfCartItems.count; i++) {
        NSDictionary *productInfo = [cartInstance.listOfCartItems objectAtIndex:i];
        NSString *price = [[productInfo objectForKey:@"price"] stringByReplacingOccurrencesOfString:@"Rs." withString:@""];
        price = [price stringByReplacingOccurrencesOfString:@"," withString:@""];
        totalPrice = totalPrice + [price floatValue];
    }
    priceLabel.text = [NSString stringWithFormat:@"Total :%@",price];
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"isloggedin"]) {
        AppNavigationController *appNavigationController = [[AppNavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"overviewView"]];
        [self presentViewController:appNavigationController animated:YES completion:nil];
        return;
    }
    SelectAddAddressViewController *selectAddAddressView = [self.storyboard instantiateViewControllerWithIdentifier:@"selectAddAddressView"];
    [self.navigationController pushViewController:selectAddAddressView animated:YES];
    
//    SelectAddAddressViewController *obj = [[SelectAddAddressViewController alloc] initWithNibName:@"SelectAddAddressViewController" bundle:nil];
//    [self.navigationController pushViewController:obj animated:YES];
//    obj = nil;
    
}

- (IBAction)deleteProductFromCart:(id)sender {
    [ActivityIndicator startAnimatingWithText:@"Deleting" forView:self.view];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/cart",API_BASE_URL];
    NSDictionary *productInfo = [cartInstance.listOfCartItems objectAtIndex:[sender tag]];
    [APIHandler getResponseFor:[[NSDictionary alloc] initWithObjectsAndKeys:[productInfo objectForKey:@"key"],@"product_id", nil] url:[NSURL URLWithString:urlString] requestType:@"DELETE" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];

        if (success || [[jsonDict objectForKey:@"error"] isEqualToString:@"Cart is empty"]) {
            NSLog(@"Response : %@",jsonDict);
            
            [cartInstance.listOfCartItems removeObjectAtIndex:[sender tag]];
            [cartCollectionView reloadData];
            if ([[[jsonDict objectForKey:@"data"] objectForKey:@"totals"] count]>1) {
                [self getTotalPrice:[[[[jsonDict objectForKey:@"data"] objectForKey:@"totals"] objectAtIndex:1] objectForKey:@"text"]];
            }
            if ([[jsonDict objectForKey:@"error"] isEqualToString:@"Cart is empty"]) {
//                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"cartItemCount"];

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[jsonDict objectForKey:@"error"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",cartInstance.listOfCartItems.count] forKey:@"cartItemCount"];

        }
    }];
}

#pragma mark alert view delegate -------------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@""]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark C0llectionview Delegate-------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return cartInstance.listOfCartItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"productCell";
    
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
//    [Utilities makeRoundCornerForObject:cell ofRadius:8];
    NSDictionary *productInfo = [cartInstance.listOfCartItems objectAtIndex:indexPath.row];
    if (productInfo.allKeys.count > 0) {
        cell.titleLabel.text = [productInfo objectForKey:@"name"];
        cell.priceLabel.text = [productInfo objectForKey:@"price"];
        cell.quantityLabel.text = [NSString stringWithFormat:@"Qty: %@",[productInfo objectForKey:@"quantity"]];
        NSString *imageUrl = [productInfo objectForKey:@"thumb"];
        [cell.thumbnailImageView setImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
        if (imageUrl && ![imageUrl isEqual:[NSNull null]]) {
            [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"no_image_products.png"]];
        }
        cell.removeButton.tag = indexPath.row;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.frame.size.width - 10;
    return CGSizeMake(width,80);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0,5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    ProductDetailsViewController *productDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"productDetailsView"];
//    productDetailsView.productInfo = [listOfProducts objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:productDetailsView animated:YES];
}


@end
