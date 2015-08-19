//
//  Utilities.h
//  INRVU
//
//  Created by Abhishek Tyagi on 23/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface Utilities : NSObject
+(void)setTransparentNavigationBar:(UINavigationController *)navigationController;
+(void)setDefaultNavigationBar:(UINavigationController *)navigationController;
+(void)makeRoundCornerForObject:(id)object ofRadius:(CGFloat)radius;
+(void)makeBorderForObject:(id)object ofSize:(CGFloat)size color:(UIColor *)color;
+(void)setPlaceholderColorForObject:(id)object ofColor:(UIColor *)color;
+(void)setPaddingForObject:(id)object;
+(void)setTitleColorOfDatePicker:(UIDatePicker *)datepicker;
+(CGFloat)heigthWithWidth:(CGFloat)width andFont:(UIFont *)font string:(NSString *)string;
+(FBLoginView *)loadFacbookButton:(CGRect )frame;
+ (void)setViewMovedUpForTextField:(UIView *)textField havingContainerView:(UIView *)containerView withDirection:(BOOL)movedUp;
+ (void)createCustomtextField:(UITextField *)textfield withLeftImage:(UIImage *)leftImage;
+ (NSString *)formattedAddress:(NSDictionary *)obj;
#pragma mark - Navgation Controller
+ (void)addViewController:(UIViewController *)addController asChildNavigationController:(UINavigationController *)navigationController WithAnimation:(BOOL)animation;

+ (void)removeChildViewControllerFromNavigaitonController:(UIViewController *)childController WithAnimation:(BOOL)animation;

#pragma mark Utilities---------

+ (UILabel*)createLabelOfSize:(CGRect)frame text:(NSString *)text font:(UIFont *)font fontColor:(UIColor *)fColor alignment:(NSTextAlignment)alignment;
+ (UITextView*)createTextViewOfSize:(CGRect)frame text:(NSString *)text font:(UIFont *)font fontColor:(UIColor *)fColor alignment:(NSTextAlignment)alignment ;
+ (UIImageView *)createImageViewOfSize:(CGRect)frame image:(UIImage*)image cornerRadius:(CGFloat)cornerRadius alpha:(CGFloat)alpha backgroundColor:(UIColor*)bColor;
@end
