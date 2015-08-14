//
//  UserInformation.m
//  Soie
//
//  Created by Abhishek Tyagi on 25/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "UserInformation.h"
#import "APIHandler.h"

@implementation UserInformation

+ (void)saveUserInformation:(NSDictionary *)dictionary {
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    NSString *responseString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Json data  : %@", responseString);
    [[NSUserDefaults standardUserDefaults] setObject:responseString forKey:@"userInformation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getUserInformation {
    NSError *error;
    NSData *jsonData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [[NSDictionary alloc] init];
    if (jsonData) {
        jsonDict = [NSJSONSerialization
                    JSONObjectWithData:jsonData
                    options:kNilOptions
                    error:&error];
    }
    
    NSLog(@"Details ::::::::::::: %@",jsonDict);
    return jsonDict;
}

#pragma mark update category ----

+ (void)updateCategoryList
{
    NSString *urlString = [NSString stringWithFormat:@"%@/categories/level/2",API_BASE_URL];
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        
        if (success) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[[jsonDict objectForKey:@"data"] mutableCopy]];
            [userDefaults setObject:data forKey:@"kCategoryList"];
            [userDefaults synchronize];
            
            
        }
    }];
}

+ (NSMutableArray *)getCategoryList {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"kCategoryList"];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+ (void)saveProductInUserWishlist:(NSDictionary *)productInfo {
    NSMutableArray *wishList = [self getUserWishList];
    
    if (![self checkProductPresentInWishList:productInfo]) {
        [wishList addObject:productInfo];
    }
    else {
        [wishList removeObject:productInfo];
    }
    [self saveWishList:wishList];
}

+ (void)saveWishList:(NSMutableArray *)wishList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:wishList];
    [userDefaults setObject:data forKey:@"kUserWishList"];
    [userDefaults synchronize];
}

+ (NSMutableArray *)getUserWishList {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserWishList"];
    if (data) {
        return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    }
    
    return [[NSMutableArray alloc] init];
}

+ (void)removeProductFromWishList:(NSDictionary *)productInfo {
    NSMutableArray *wishList = [self getUserWishList];
    [wishList removeObject:productInfo];
    [self saveWishList:wishList];
}

+ (BOOL)checkProductPresentInWishList:(NSDictionary *)productInfo {
    BOOL isExists = NO;
    NSMutableArray *wishList = [self getUserWishList];

    for (NSDictionary *product in wishList) {
        if ([[product objectForKey:@"id"] integerValue] == [[productInfo objectForKey:@"id"] integerValue] ) {
            isExists = YES;
        }
    }
    return isExists;
}

@end
