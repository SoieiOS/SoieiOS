//
//  SelectSizeColorViewController.h
//  Soie
//
//  Created by Abhishek Tyagi on 25/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QuitWithResult, //When confirm button is pressed
    QuitWithBackButton, //When back button is pressed
    QuitWithCancel, //when View outside date picker is pressed
} PickerQuitMethod;

@protocol PickerViewControllerDelegate <NSObject>
- (void)pickerValueSelected:(NSString *)value optionId:(NSString *)optionId;
@optional
- (void)pickerWillDismissWithQuitMethod:(PickerQuitMethod)method;
- (void)pickerDidDismissWithQuitMethod:(PickerQuitMethod)method;

@end

@interface SelectSizeColorViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *pickerBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *separator1View;
@property (weak, nonatomic) IBOutlet UIView *separator2View;
@property (weak, nonatomic) IBOutlet UIView *separator3View;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UILabel    *titleLabel;
@property (strong, nonatomic) NSString            *pickerTitle;
@property (weak, nonatomic) IBOutlet UIButton   *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton   *backButton;

@property (strong, nonatomic)NSMutableArray     *listOfItems;
@property (strong, nonatomic)NSString           *optionId;

@property (nonatomic, weak) id<PickerViewControllerDelegate> delegate;


@end
