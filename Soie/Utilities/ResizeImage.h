//
//  ResizeImage.h
//  GreenJob Pro
//
//  Created by Abhishek Tyagi on 07/11/14.
//  Copyright (c) 2014 Quovantis Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ResizeImage : NSObject

+ (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
