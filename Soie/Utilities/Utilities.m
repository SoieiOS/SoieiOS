//
//  Utilities.m
//  INRVU
//
//  Created by Abhishek Tyagi on 23/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "Utilities.h"
#import "UIImage+Utilities.h"
#import "APIHandler.h"

@implementation Utilities

+(void)setTransparentNavigationBar:(UINavigationController *)navigationController {
    [navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.shadowImage = [UIImage new];
    navigationController.navigationBar.translucent = YES;
}

+(void)setDefaultNavigationBar:(UINavigationController *)navigationController {
    [navigationController setNavigationBarHidden:NO animated:NO];
    navigationController.navigationBar.translucent = NO;
    [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:78/255.0 green:85/255.0 blue:91/255.0 alpha:1.0]];
}

+(void)makeRoundCornerForObject:(id)object ofRadius:(CGFloat)radius {
    [[object layer]setMasksToBounds:YES];
    [[object layer] setCornerRadius:radius];
}

+(void)makeBorderForObject:(id)object ofSize:(CGFloat)size color:(UIColor *)color {
    [[object layer] setBorderWidth:size];
    [[object layer] setBorderColor:[color CGColor]];
}

+(void)setPlaceholderColorForObject:(id)object ofColor:(UIColor *)color {
    [object setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:[object placeholder] attributes:@{NSForegroundColorAttributeName: color}]];
}

+(void)setPaddingForObject:(id)object {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [object setLeftView:paddingView];
    [object setLeftViewMode:UITextFieldViewModeAlways];
}

+(NSAttributedString *)getAttributedStringForDiscounts:(NSDictionary *)productInfo {
    NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Rs %0.2f",[[productInfo objectForKey:@"price"] floatValue]]];
    if ([[productInfo objectForKey:@"special"] length] > 0) {
        NSMutableAttributedString *specialString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Rs %0.2f",[[productInfo objectForKey:@"special"] floatValue]]];
        [priceString addAttributes:@{
                                     NSFontAttributeName : [UIFont systemFontOfSize:11],
                                     NSForegroundColorAttributeName : [UIColor redColor]
                                     } range:NSMakeRange(0, [priceString length])];
        [priceString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:NSMakeRange(0, [priceString length])];
        
        [priceString appendAttributedString:specialString];
    }
    return priceString;
}

+ (NSString *)getStringFromHTMLString:(NSString *)htmlString {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    return [attributedString string];
}

+ (NSString *)formattedAddress:(NSDictionary *)obj {
    NSString *addressString = @"";
    
    if ([[obj objectForKey:@"firstname"] length] > 0) {
        addressString = [obj objectForKey:@"firstname"];
    }
    if ([[obj objectForKey:@"lastname"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@" %@",[obj objectForKey:@"lastname"]];
    }
    if ([[obj objectForKey:@"address_1"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@"\n%@",[obj objectForKey:@"address_1"]];
    }
    if ([[obj objectForKey:@"address_2"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@"\n%@",[obj objectForKey:@"address_2"]];
    }
    if ([[obj objectForKey:@"city"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@"\n%@",[obj objectForKey:@"city"]];
    }
    if ([[obj objectForKey:@"postcode"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@" %@",[obj objectForKey:@"postcode"]];
    }
    if ([[obj objectForKey:@"zone"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@"\n%@",[obj objectForKey:@"zone"]];
    }
    if ([[obj objectForKey:@"country"] length] > 0) {
        addressString = [addressString stringByAppendingFormat:@" %@",[obj objectForKey:@"country"]];
    }
    
    return addressString;
}

+(void)setTitleColorOfDatePicker:(UIPickerView *)picker {
    [picker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    SEL selector = NSSelectorFromString( @"setHighlightsToday:" );
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature :
                                [UIPickerView
                                 instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:picker];
}

+ (CGFloat)heigthWithWidth:(CGFloat)width andFont:(UIFont *)font string:(NSString *)string
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [string length])];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}

+(FBLoginView *)loadFacbookButton:(CGRect )frame {
    FBLoginView *loginview = [[FBLoginView alloc] initWithReadPermissions:
                              @[@"public_profile", @"email", @"user_birthday", @"user_friends"]];
    loginview.frame = frame;
    return loginview;
}

+ (void)setViewMovedUpForTextField:(UIView *)textField havingContainerView:(UIView *)containerView withDirection:(BOOL)movedUp {
    CGFloat keyboardHeight = 226;
    CGFloat difference = containerView.frame.origin.y + containerView.frame.size.height - CGRectGetMaxY(textField.frame)  - 130;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = containerView.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= (keyboardHeight - difference);
        if (rect.origin.y > containerView.frame.origin.y) {
            rect.origin.y = containerView.frame.origin.y;
        }
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y = 64;
        
    }
    
    
    containerView.frame = rect;
    
    [UIView commitAnimations];
}

+ (void)createCustomtextField:(UITextField *)textfield withLeftImage:(UIImage *)leftImage {
    
    if (!textfield) {
        return;
    }
    textfield.background = [UIImage imageNamed:@"white_button_small.png"];
    //    [textfield setCornerRadius];
    //    [textfield setDefaultViewFontWithType:TextFieldTypeViewFont];
    
    CGRect paddingFrame = CGRectZero;
    UIImageView *leftImgView = nil;
    if (leftImage) {
        leftImage = [UIImage scaleImage:leftImage WithSize:CGSizeMake(leftImage.size.width/2, leftImage.size.height/2)];
        leftImgView = [[UIImageView alloc] initWithImage:leftImage];
        paddingFrame = leftImgView.bounds;
    }
    paddingFrame.size.width += 10;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:paddingFrame];
    if (leftImgView) {
        [paddingView addSubview:leftImgView];
        leftImgView.center = paddingView.center;
    }
    textfield.leftView      = paddingView;
    textfield.leftViewMode  = UITextFieldViewModeAlways;
}

#pragma mark - Navgation Controller
+ (void)addViewController:(UIViewController *)addController asChildNavigationController:(UINavigationController *)navigationController WithAnimation:(BOOL)animation {
    
    if (!addController || !navigationController) {
        return;
    }
    [navigationController addChildViewController:addController];
    addController.view.frame = navigationController.view.bounds;
    [navigationController.view addSubview:addController.view];
    navigationController.view.userInteractionEnabled = NO;
    addController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [addController beginAppearanceTransition:YES animated:YES];
    NSTimeInterval interval = animation? 0.3 :0.0f;
    [UIView animateWithDuration:interval delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(void){
        addController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [addController endAppearanceTransition];
        [addController didMoveToParentViewController:navigationController];
        navigationController.view.userInteractionEnabled = YES;
        
    }];
}

+ (void)removeChildViewControllerFromNavigaitonController:(UIViewController *)childController WithAnimation:(BOOL)animation {
    
    if (!childController) {
        return;
    }
    NSTimeInterval interval = animation? 0.3 :0.0f;
    
    [childController willMoveToParentViewController:nil];
    [childController beginAppearanceTransition:NO animated:YES];
    childController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:interval delay:0.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^(void){
        childController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        [childController endAppearanceTransition];
        [childController.view removeFromSuperview];
        [childController removeFromParentViewController];
    }];
}

#pragma mark Utilities---------

+ (UILabel*)createLabelOfSize:(CGRect)frame text:(NSString *)text font:(UIFont *)font fontColor:(UIColor *)fColor alignment:(NSTextAlignment)alignment{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (text.length > 0) {
        label.text = text;
    }
    label.textColor = fColor;
    label.font = font;
    label.textAlignment = alignment;
    label.numberOfLines = 0;
    return label;
}

+ (UITextView*)createTextViewOfSize:(CGRect)frame text:(NSString *)text font:(UIFont *)font fontColor:(UIColor *)fColor alignment:(NSTextAlignment)alignment {
    
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    if (text.length > 0) {
        textView.text = text;
    }
    textView.textColor = fColor;
    textView.font = font;
    textView.textAlignment = alignment;
    textView.editable = FALSE;
    textView.selectable = TRUE;
    textView.backgroundColor = [UIColor clearColor];
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.tintColor = [UIColor colorWithRed:89/255.0 green:152/255.0 blue:205/255.0 alpha:1];
    return textView;
}

+ (UIImageView *)createImageViewOfSize:(CGRect)frame image:(UIImage*)image cornerRadius:(CGFloat)cornerRadius alpha:(CGFloat)alpha backgroundColor:(UIColor*)bColor{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.alpha = alpha;
    imageView.backgroundColor = bColor;
    imageView.layer.masksToBounds = YES;
    imageView.image = image;
    imageView.layer.cornerRadius = cornerRadius;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

@end
