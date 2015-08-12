//
//  UIImage+Utilities.h
//  Dinat
//
//  Created by Abhishek Neb on 2/6/15.
//  Copyright (c) 2015 Jasmeet Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utilities)
+ (UIImage *)scaleImage:(UIImage *)image WithSize:(CGSize)newSize;
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image withSide:(CGFloat)side;
@end
