//
//  ProductDetailsViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 17/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "CustomTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "BDKNotifyHUD.h"
#import "Utilities.h"
#import "APIHandler.h"
#import "CartObject.h"

@interface ProductDetailsViewController () {
    CartObject      *cartInstance;
}
@property (strong, nonatomic) BDKNotifyHUD *notify;

@end

@implementation ProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    cartInstance = [CartObject getInstance];
    
    productOptions = [[NSMutableDictionary alloc] init];
    
    if ([[_productInfo objectForKey:@"stock_status"] isEqualToString:@"Out Of Stock"]) {
        [APIHandler showMessage:@"Out of stock"];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell;
    if (indexPath.row == 0) {
        cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"scrollViewCell"];
        cell.titleLabel.text = [_productInfo objectForKey:@"name"];
//        NSString *imageUrl = [_avatarInfo objectForKey:@"Avatars_info"];
//        [cell.iconImageView setImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
//        if (imageUrl && ![imageUrl isEqual:[NSNull null]]) {
//            [cell.iconImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
//        }
        [self loadScrollView:cell];
    }
    else if (indexPath.row == 1) {
        cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"priceReviewCell"];
        cell.titleLabel.text = [NSString stringWithFormat:@"Rs %0.1f",[[_productInfo objectForKey:@"price"] floatValue]];
        [Utilities makeRoundCornerForObject:cell.addToCartButton ofRadius:15];
    }
    else if (indexPath.row == 2) {
        cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"sizeColorCell"];
    }
    else if (indexPath.row == 3) {
        cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
        if ([[_productInfo objectForKey:@"description"] length] > 0) {
            cell.titleLabel.text = [_productInfo objectForKey:@"description"];
        }
        else {
            cell.titleLabel.text = @"No Description";
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 290;
    }
    else if (indexPath.row == 1) {
        return 50;
    }
    else if (indexPath.row == 2) {
        return 62;
    }
    else if (indexPath.row == 3) {
        CGFloat descriptionHeight = [Utilities heigthWithWidth:self.view.frame.size.width-20 andFont:[UIFont systemFontOfSize:15] string:[_productInfo objectForKey:@"description"]];
        return descriptionHeight+48;
    }
    return 83;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loadScrollView:(CustomTableViewCell *)cell {
//    NSArray *images = [_productInfo objectForKey:@"images"];
    NSArray *images = [[NSArray alloc] initWithObjects:[_productInfo objectForKey:@"image"],[_productInfo objectForKey:@"image"],[_productInfo objectForKey:@"image"],[_productInfo objectForKey:@"image"],[_productInfo objectForKey:@"image"], nil];
    for (int i = 0; i < [images count]; i++) {
        CGRect frame;
        frame.origin.x = cell.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = cell.scrollView.frame.size;
        
        UIImageView *subview = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i),0, self.view.frame.size.width, cell.scrollView.frame.size.height)];
        [subview setImageWithURL:[NSURL URLWithString:[images objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"userPlaceholder.jpg"]];
//        subview.contentMode = UIViewContentModeScaleAspectFit;
        //        subview.backgroundColor = [UIColor blackColor];
        [cell.scrollView addSubview:subview];
    }
    
    cell.pageControl.numberOfPages = images.count;
    
    cell.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * images.count, cell.frame.size.height-30);

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCell *cell = (CustomTableViewCell *)[productDetailsTableview cellForRowAtIndexPath:newIndexPath];
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    cell.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCell *cell = (CustomTableViewCell *)[productDetailsTableview cellForRowAtIndexPath:newIndexPath];
    CGRect frame;
    frame.origin.x = cell.scrollView.frame.size.width * cell.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = cell.scrollView.frame.size;
    [cell.scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
}

- (IBAction)selectSizeButtonClicked:(id)sender {
    _isSizeSelected = TRUE;
    if ([[_productInfo objectForKey:@"options"] count] == 1) {
        return;
    }
    [self openPickerViewWithTitle:@"Select Size" items:[[[_productInfo objectForKey:@"options"] objectAtIndex:1] objectForKey:@"option_value"] optionId:[[[_productInfo objectForKey:@"options"] objectAtIndex:1] objectForKey:@"product_option_id"]];
}

- (IBAction)selectColorButtonClicked:(id)sender {
    _isSizeSelected = FALSE;
    [self openPickerViewWithTitle:@"Select Size" items:[[[_productInfo objectForKey:@"options"] objectAtIndex:0] objectForKey:@"option_value"] optionId:[[[_productInfo objectForKey:@"options"] objectAtIndex:0] objectForKey:@"product_option_id"]];
}

- (IBAction)addToCartButtonClicked:(id)sender {
    if (!_selectedColor.length > 0) {
        [APIHandler showMessage:@"Kindly select color."];
        return;
    }
    else if (!_selectedSize.length > 0) {
        [APIHandler showMessage:@"Kindly select size."];
        return;
    }
    
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@cart_bulk",API_BASE_URL];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [_productInfo objectForKey:@"id"], @"product_id",
                                @"1", @"quantity",
                                productOptions, @"option",
//                                cartInstance.sessionId,@"sessionId",
                                nil];
    [APIHandler getResponseFor:[[NSArray alloc] initWithObjects:dictionary, nil] url:[NSURL URLWithString:urlString] requestType:@"POST" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            }
    }];

    [cartInstance.listOfCartItems addObject:_productInfo];
    [self displayNotification];
}

- (BDKNotifyHUD *)notify {
    if (_notify != nil) return _notify;
    _notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"] text:@"Added"];
    _notify.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notify;
}

- (void)displayNotification {
    if (self.notify.isAnimating) return;
    
    [self.view addSubview:self.notify];
    [self.notify presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
        [self.notify removeFromSuperview];
    }];
}

- (void)openPickerViewWithTitle:(NSString *)title items:(NSMutableArray *)items optionId:(NSString *)optionId {
    SelectSizeColorViewController *selectSizeColorView = [self.storyboard instantiateViewControllerWithIdentifier:@"selectSizeColorView"];
    selectSizeColorView.delegate = self;
    selectSizeColorView.titleLabel.text = title;
    selectSizeColorView.listOfItems = items;
    selectSizeColorView.optionId = optionId;
    //    [self presentViewController:selectSizeColorView animated:YES completion:nil];
    
    [Utilities addViewController:selectSizeColorView asChildNavigationController:self.navigationController WithAnimation:YES];
}

#pragma mark - PickerViewControllerDelegate
- (void)pickerValueSelected:(NSString *)value optionId:(NSString *)optionId {
//    [APIHandler showMessage:value];
    if (_isSizeSelected) {
        _selectedSize = value;
    }
    else {
        _selectedColor = value;
    }
    [productOptions setObject:value forKey:optionId];
}

//optional
- (void)pickerDidDismissWithQuitMethod:(PickerQuitMethod)method {
    NSLog(@"Picker did dismiss with %lu", method);
}

//optional
- (void)pickerWillDismissWithQuitMethod:(PickerQuitMethod)method {
    NSLog(@"Picker will dismiss with %lu", method);
}

@end
