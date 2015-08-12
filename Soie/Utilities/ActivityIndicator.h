//
//  ActivityIndicator.h
//  INRVU
//
//  Created by Abhishek Tyagi on 23/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ActivityIndicator : NSObject {
    UILabel *lblLoading;
}

+(ActivityIndicator*)getInstanceForYorigin:(CGFloat)yOrigin forXorigin:(CGFloat)xOrigin;
+ (void)startAnimatingWithText:(NSString *)string forView:(UIView *)view;
+ (void)stopAnimatingForView:(UIView *)view;
@end
