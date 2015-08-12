//
//  CustomTableViewCell.h
//  INRVU
//
//  Created by Abhishek Tyagi on 23/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet  UILabel         *titleLabel;
@property (nonatomic, strong) IBOutlet  UILabel         *subTitleLabel;
@property (nonatomic, strong) IBOutlet  UILabel         *statusLabel;
@property (nonatomic, strong) IBOutlet  UIButton        *buyNowButton;
@property (nonatomic, strong) IBOutlet  UIButton        *addToCartButton;
@property (nonatomic, strong) IBOutlet  UIButton        *accessoryButton;
@property (nonatomic, strong) IBOutlet  UILabel         *numberLabel;
@property (nonatomic, strong) IBOutlet  UIImageView     *iconImageView;
@property (nonatomic, strong) IBOutlet  UIImageView     *backgroundImageview;
@property (nonatomic, strong) IBOutlet  UIImageView     *selectionImageview;
@property (nonatomic, strong) IBOutlet  UISwitch        *deadLineswitch;
@property (nonatomic, strong) IBOutlet  UIDatePicker    *datePickerview;
@property (nonatomic, strong) IBOutlet  UITextView      *textView;
@property (nonatomic, strong) IBOutlet  UITextField     *textField;
@property (nonatomic, strong) IBOutlet  UIScrollView    *scrollView;
@property (nonatomic, strong) IBOutlet  UIPageControl   *pageControl;
@property (nonatomic, strong) IBOutlet  UIStepper       *quantityStepper;

@end
