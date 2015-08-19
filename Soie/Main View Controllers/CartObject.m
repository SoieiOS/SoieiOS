//
//  CartObject.m
//  Soie
//
//  Created by Abhishek Tyagi on 09/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "CartObject.h"
#import "APIHandler.h"

@implementation CartObject

static CartObject *cartInstance =nil;
+(CartObject *)getInstance
{
    @synchronized(self)
    {
        if(cartInstance==nil)
        {
            cartInstance= [CartObject new];
            NSMutableArray *emptyArray = [[NSMutableArray alloc] init];            
            [cartInstance setListOfCartItems:[emptyArray mutableCopy]];
            [cartInstance setListOfBanners:[emptyArray mutableCopy]];
            [cartInstance setSessionId:@""];
//            /cart
        }
    }
    return cartInstance;
}

+(void)clearCartModel {
    cartInstance = nil;
}

+(void)getCartItems {
    if (cartInstance.cartLoaded) {
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/cart",API_BASE_URL];
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            [cartInstance setCartLoaded:YES];
            [cartInstance setListOfCartItems:[[[jsonDict objectForKey:@"data"] objectForKey:@"products"] mutableCopy]];
        }
    }];
}
@end
