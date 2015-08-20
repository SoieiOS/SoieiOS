//
//  UserInformation.h
//  Soie
//
//  Created by Abhishek Tyagi on 25/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation : NSObject
+ (void)saveUserInformation:(NSDictionary *)dictionary;
+ (NSDictionary *)getUserInformation;
+ (NSMutableArray *)getCategoryList;
+ (void)updateCategoryList;


+ (void)saveProductInUserWishlist:(NSDictionary *)productInfo;
+ (void)removeProductFromWishList:(NSDictionary *)productInfo;
+ (NSMutableArray *)getUserWishList ;
+ (BOOL)checkProductPresentInWishList:(NSDictionary *)productInfo;

+ (void)openCartView:(id)sender;
+ (NSString *)saveCartItemNumber;
@end
