//
//  UIImage+Utilities.m
//  Dinat
//
//  Created by Abhishek Neb on 2/6/15.
//  Copyright (c) 2015 Jasmeet Kaur. All rights reserved.
//

#import "UIImage+Utilities.h"

@implementation UIImage (Utilities)
+ (UIImage *)scaleImage:(UIImage *)image WithSize:(CGSize)newSize {

    UIImage *newImage = [image copy];
    if (CGSizeEqualToSize(image.size, newSize) ) {
        return newImage;
    }
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
    [newImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)generatePhotoThumbnail:(UIImage *)image withSide:(CGFloat)side
{
    // Create a thumbnail version of the image for the event object.
    CGSize size = image.size;
    CGSize croppedSize;
    
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension.
    // So clip the extra portion from x or y coordinate
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping

    
    UIImage* cropped = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    
    
    // Resize the image
    UIImage *thumbnail = [UIImage scaleImage:cropped WithSize:CGSizeMake(side, side)];
    CGImageRelease(imageRef);

    // Done Resizing
    
    return thumbnail;
}

@end
