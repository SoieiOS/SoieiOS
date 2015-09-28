//
//  SelectSizeColorViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 25/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "SelectSizeColorViewController.h"
#import "Utilities.h"

@implementation SelectSizeColorViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerBackgroundView.layer.cornerRadius = 10.0;
    self.pickerBackgroundView.layer.borderColor = self.mainColor.CGColor;
    self.pickerBackgroundView.layer.borderWidth = 1.0;
    
    self.separator1View.backgroundColor = self.separator2View.backgroundColor = self.separator3View.backgroundColor = self.mainColor;
    
    self.titleLabel.textColor = self.mainColor;
    
//    [Utilities setTitleColorOfDatePicker:_pickerView];
    
    
    [self.confirmButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:self.mainColor forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[self.mainColor colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    
    [self.backButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.backButton setTitleColor:self.mainColor forState:UIControlStateNormal];
    [self.backButton setTitleColor:[self.mainColor colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    
    //Add gesture recognizer to superview...
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelTapGesture:)];
    [self.pickerBackgroundView.superview addGestureRecognizer:gestureRecognizer];
    //...but turn off gesture recognition on lower views
    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [self.pickerBackgroundView addGestureRecognizer:gestureRecognizer];
    
    _titleLabel.text = _pickerTitle;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark methods ----------

- (void)cancelTapGesture:(UITapGestureRecognizer *)sender {
//    [self.delegate pickerWillDismissWithQuitMethod:QuitWithCancel];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.delegate pickerDidDismissWithQuitMethod:QuitWithCancel];
//    }];
    [Utilities removeChildViewControllerFromNavigaitonController:self WithAnimation:YES];
}

- (IBAction)confirmDate:(id)sender {
    //TODO: Set date
    
    
    NSInteger row = [_pickerView selectedRowInComponent:0];
    [self.delegate pickerValueSelected:[[_listOfItems objectAtIndex:row] objectForKey:@"name"]  optionId:_optionId];
//    [self.delegate pickerWillDismissWithQuitMethod:QuitWithResult];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.delegate pickerDidDismissWithQuitMethod:QuitWithResult];
//    }];
    [Utilities removeChildViewControllerFromNavigaitonController:self WithAnimation:YES];

}

- (IBAction)quitPicking:(id)sender {
//    [self.delegate pickerWillDismissWithQuitMethod:QuitWithBackButton];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.delegate pickerDidDismissWithQuitMethod:QuitWithBackButton];
//    }];
    [Utilities removeChildViewControllerFromNavigaitonController:self WithAnimation:YES];

}

#pragma mark Picker View --------

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _listOfItems.count;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return _listOfItems[row];
//}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = [_listOfItems[row] objectForKey:@"name"];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];

    return [[NSAttributedString alloc] initWithString:title attributes:
            @{NSForegroundColorAttributeName: self.mainColor,
              NSParagraphStyleAttributeName: paragraphStyle}];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSLog(@"%@",[_listOfItems[row] objectForKey:@"name"]);
}

#pragma mark - Properties
- (UIColor *)mainColor {
    return [UIColor whiteColor];
}

@end
