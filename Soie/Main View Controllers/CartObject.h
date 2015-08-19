//
//  CartObject.h
//  Soie
//
//  Created by Abhishek Tyagi on 09/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartObject : NSObject

@property (nonatomic,strong) NSString *sessionId;
@property (nonatomic,strong) NSMutableArray *listOfCartItems;
@property (nonatomic,strong) NSMutableArray *listOfBanners;

@property (nonatomic) BOOL cartLoaded;

+(CartObject*)getInstance;
+(void)clearCartModel;
+(void)getCartItems;

@end
