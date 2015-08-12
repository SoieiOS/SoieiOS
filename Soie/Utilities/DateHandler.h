//
//  DateHandler.h
//  INRVU
//
//  Created by Abhishek Tyagi on 24/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHandler : NSObject
+ (BOOL)compareStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (BOOL)validateEndSubmitDate:(NSString *)endDateString;
+ (NSString *)convertDateTimeInto:(NSString *)dateStr fromFormat:(NSString *)oldFormat withFormat:(NSString *)newFormat;
+ (NSString *)getCurrentTimeStamp;
+ (NSString *)getCurrentDateString:(NSString *)format;
+ (NSString *)getDate:(NSDate *)date withFormat:(NSString *)format;

@end
