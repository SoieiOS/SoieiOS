//
//  CartObject.m
//  Soie
//
//  Created by Abhishek Tyagi on 09/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "CartObject.h"

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
            [cartInstance setSessionId:@""];
        }
    }
    return cartInstance;
}

+(void)clearCartModel {
    cartInstance = nil;
}
@end
