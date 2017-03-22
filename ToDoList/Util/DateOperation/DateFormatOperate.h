//
//  DateFormatOperate.h
//  ToDoList
//
//  时间格式转化
//
//  Created by Peng he on 2017/3/20.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatOperate : NSObject

/**
 本地时间(根据系统时区，加了一定的时区时间),慎用！！！
 */
+ (NSDate *)localeDate;

/**
 2015-10-28 12:38:23
 传入NSDate，传出服务器需要的格式字符串，注意！传入的NSDate必须是：格林威治标准时间GMT 或者 世界协调时间UTC！不可以传入已经转为系统时区的时间
 */
+ (NSString *)fixStringForServerFromData:(NSDate *)date;

/**
 2015/10/28 12:56
 传入NSDate，传出客户端需要的格式字符串，注意！传入的NSDate必须是：格林威治标准时间GMT 或者 世界协调时间UTC！不可以传入已经转为系统时区的时间
 */
+ (NSString *)fixStringForClientFromDate:(NSDate *)date joinTime:(BOOL)joinTime;


+ (NSString *)fixStringForClientFromData:(NSDate *)date withDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

/**
 传入标准格式的字符串，传出NSDate类型的数据：格林威治标准时间GMT 或者 世界协调时间UTC
 */
+ (NSDate *)fixDateFromString:(NSString *)dateString;


@end
