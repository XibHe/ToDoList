//
//  DateFormatOperate.m
//  ToDoList
//
//  Created by Peng he on 2017/3/20.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "DateFormatOperate.h"

@implementation DateFormatOperate
+ (NSDate *)localeDate
{
    NSDate *date = [NSDate date];
    
    //    NSLog(@"data = %@",date);
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    //    NSLog(@"localeDate %@", localeDate);
    
    return localeDate;
}

+ (NSString *)fixStringForServerFromData:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    //    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *fixString = [dateFormatter stringFromDate:date];
    
    //    NSLog(@"fixString = %@",fixString);
    
    return fixString;
}

+ (NSString *)fixStringForClientFromData:(NSDate *)date withDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
    NSString *returnValue = @"";
    
    NSDateFormatter *dateFormatter = nil;
    
    if (date != nil)
    {
        if (dateFormatter ==nil)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
        }
        // kCFDateFormatterFullStyle : 2015年10月29日 星期四
        // kCFDateFormatterMediumStyle : 2015年10月29日
        // kCFDateFormatterShortStyle : 15/10/29
        
        [dateFormatter setDateStyle:dateStyle];
        
        // NSDateFormatterShortStyle : 2015年10月29日 23:35
        // NSDateFormatterMediumStyle : 2015年10月29日 23:35:35
        // NSDateFormatterLongStyle : 2015年10月29日 GMT+8 23:36:17
        [dateFormatter setTimeStyle:timeStyle];
        
        //        [dateFormatter setLocale:[NSLocale currentLocale]];
        
        returnValue = [dateFormatter stringFromDate:date];
    }
    
    //    NSLog(@"returnValue = %@",returnValue);
    
    return returnValue;
}

+ (NSString *)fixStringForClientFromDate:(NSDate *)date joinTime:(BOOL)joinTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    if (joinTime)
    {
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    }
    
    NSString *fixString = [dateFormatter stringFromDate:date];
    
    return fixString;
}

+ (NSDate *)fixDateFromString:(NSString *)dateString
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSDate * fixDate = [dateFormatter dateFromString:dateString];
    
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //
    //    NSInteger interval = [zone secondsFromGMTForDate: fixDate];
    //
    //    NSDate *localeDate = [fixDate  dateByAddingTimeInterval: interval];
    
    //    NSLog(@"fixDate = %@",localeDate);
    
    return fixDate;
}

@end
