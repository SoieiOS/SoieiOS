//
//  InputTextValidator.h
//  INRVU
//
//  Created by Abhishek Tyagi on 23/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputTextValidator : NSObject

+(BOOL)validateEmail:(NSString *)email;
+(BOOL)validateNumber:(NSString *)number;


@end
