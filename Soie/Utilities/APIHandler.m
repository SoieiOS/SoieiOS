//
//  APIHandler.m
//  INRVU
//
//  Created by Abhishek Tyagi on 23/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "APIHandler.h"
#import "Constants.h"
#import "CartObject.h"

@interface NSURLRequest (DummyInterface)
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@implementation APIHandler

+(NSString*)CSRFTokenFromURL:(NSString *)url
{
    // Pass in any url with a CSRF protected form
    NSURL *baseURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:baseURL];
    for (NSHTTPCookie *cookie in cookies)
    {
        if ([[cookie name] isEqualToString:@"csrftoken"])
            NSLog(@"Cookie : %@",cookie);
            return [cookie value];
    }
    return nil;
}

+(void)getResponseFor:(id)dictionary url:(NSURL*)url requestType:(NSString *)requestType complettionBlock:(SuccessfullBlockResponse)successblock
{
    NSError *error;

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:requestType];
    [request setValue:@"10571113" forHTTPHeaderField:@"X-Oc-Merchant-Id"];
    [request setValue:@"en" forHTTPHeaderField:@"X-Oc-Merchant-Language"];
    if (dictionary !=nil && ![dictionary isEqual:[NSNull null]]) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        NSString *responseString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"Json data  : %@", responseString);
        [request setHTTPMethod:@"POST"];
        CartObject *cartInstance = [CartObject getInstance];
        [request setValue:cartInstance.sessionId forHTTPHeaderField:@"X-Oc-Session"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    }
    [self sendAsyncRequest:request completionBlock:successblock];
}

+ (void)sendAsyncRequest:(NSMutableURLRequest *)request completionBlock:(SuccessfullBlockResponse)completionBlock
{
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *jsonData, NSError *error)
     {
         NSLog(@"error %@",[error description]);
         if (jsonData == nil ) {
             [self showMessage:@"We were unable to connect to the required services. Please try again later."];
             completionBlock(FALSE,nil);
             return ;
         }
         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         NSInteger responseStatusCode = [httpResponse statusCode];
         NSString *responseString = [self removeTabLineSpace:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
         NSData *jsonData1 = [responseString dataUsingEncoding:NSUTF8StringEncoding];
         id jsonDict = [NSJSONSerialization
                        JSONObjectWithData:jsonData1
                        options:kNilOptions
                        error:&error];
         
         NSLog(@"Details ::::::::::::: %@",jsonDict);
         
         if ([[jsonDict objectForKey:@"success"] boolValue]) {
//             if ([jsonDict isKindOfClass:[NSArray class]]) {
//                 completionBlock(true,[[NSDictionary alloc] initWithObjectsAndKeys:jsonDict,@"dictionary", nil]);
//                 [self showMessage:@"Error"];
//                 return;
//             }
//             NSString *error = [jsonDict objectForKey:@"error"];
             
//             if (error == nil) {
                 completionBlock(TRUE,jsonDict);
//             }
//             else {
//                 completionBlock(FALSE,jsonDict);
//                 [self displayErrorMessage:jsonDict];
//             }
         }
         else {
             completionBlock(FALSE,jsonDict);
             [self displayErrorMessage:jsonDict];
         }
     }];
}

+(void)getSessionId {
    NSString *urlString = [NSString stringWithFormat:@"%@/session",API_BASE_URL];
    [self getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            CartObject *cartInstance = [CartObject getInstance];
            [cartInstance setSessionId:[[jsonDict objectForKey:@"data"] objectForKey:@"session"]];
        }
    }];
}

+ (NSString *)removeTabLineSpace:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    return string;
}


+ (void)displayErrorMessage:(NSDictionary *)jsonDict {
    NSString *errorMsg = @"";
    
    if ([[jsonDict objectForKey:@"error"] isKindOfClass:[NSDictionary class]]) {
        errorMsg = [[jsonDict objectForKey:@"error"] objectForKey:@"warning"];
    }
    else {
        errorMsg = [jsonDict objectForKey:@"error"];
    }
    
    
    if (errorMsg.length > 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"We were unable to connect to the required services. Please try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

+(void)showMessage:(NSString *)str {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:applicationName
                                                      message:str
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}
@end
