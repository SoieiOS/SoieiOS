//
//  CustomCollectionViewCell.h
//  FrndiNeed
//
//  Created by Abhishek Tyagi on 26/01/15.
//  Copyright (c) 2015 Quovantis Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView      *thumbnailImageView;
@property (nonatomic, strong) IBOutlet UILabel          *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel          *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel          *manufacturerLabel;
@property (nonatomic, strong) IBOutlet UIButton         *wishListButton;
@property (nonatomic, strong) IBOutlet UIButton         *removeButton;
@end
