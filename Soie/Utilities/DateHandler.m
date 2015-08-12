//
//  DateHandler.m
//  INRVU
//
//  Created by Abhishek Tyagi on 24/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "DateHandler.h"

@implementation DateHandler

+ (BOOL)compareStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSTimeInterval distanceBetweenDates = [startDate timeIntervalSinceDate:endDate];
    double secondsInAnHour = 60*60*24;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    
    if (hoursBetweenDates > 0) {
        return TRUE;
    }
    else if (hoursBetweenDates == 0){
        return TRUE;
    }
    else {
        return FALSE;
    }
}

+ (BOOL)validateEndSubmitDate:(NSString *)endDateString {
    //    endPublishDate = "November 27, 2014";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"MMMM dd yyyy"];
    endDateString = [endDateString stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSDate *endDate = [formatter dateFromString:endDateString];
    
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *today = [NSDate date];
    
    
    if ([endDateString isEqualToString:@"December 31 1899"]) {
        return NO;
    }
    
    if ([endDate compare:today] == NSOrderedDescending) {
        //        NSLog(@"date1 is later than date2");
        return NO;
    } else if ([endDate compare:today] == NSOrderedAscending) {
        //        NSLog(@"date1 is earlier than date2");
        return YES;
    } else {
        //        NSLog(@"dates are the same");
        return NO;
    }
}

+ (NSString *)convertDateTimeInto:(NSString *)dateStr fromFormat:(NSString *)oldFormat withFormat:(NSString *)newFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:oldFormat];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    //    Thu Nov 20 2014
    [dateFormatter setDateFormat:newFormat];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getCurrentTimeStamp {
    NSDate *date  = [NSDate date];
    NSString *dateTimeStamp=[NSString stringWithFormat:@"%lli",[@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
    NSLog(@"Date TimeStamp Returned %@",dateTimeStamp);
    return dateTimeStamp;
}

+ (NSString *)getCurrentDateString:(NSString *)format {
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:today];
}

+ (NSString *)getDate:(NSDate *)date withFormat:(NSString *)format {
    NSString *dateString = @"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setDateFormat:format];
    dateString = [dateFormat stringFromDate:date];
    return dateString;
}
@end
