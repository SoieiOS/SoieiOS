//
//  APIHandler.h
//  INRVU
//
//  Created by Abhishek Tyagi on 23/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ActivityIndicator.h"
#import "Constants.h"

typedef void (^SuccessfullBlockResponse)(BOOL, NSDictionary *);
typedef void (^SuccessfullBlockLocationCoordinates)(BOOL, NSDictionary*);

@interface APIHandler : NSObject
+(NSString*)CSRFTokenFromURL:(NSString *)url;
+(void)getResponseFor:(id )dictionary url:(NSURL*)url requestType:(NSString *)requestType complettionBlock:(SuccessfullBlockResponse)successblock;
+(void)showMessage:(NSString *)str;
+(void)getSessionId;

+ (void)autoLoginUser:(NSDictionary *)postDictionary completionBlock:(SuccessfullBlockResponse)completionBlock;

@end
