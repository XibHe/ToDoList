//
//  LocalNotificationManage.m
//  Steward
//
//  Created by Peng he on 15/7/28.
//  Copyright (c) 2015年 ChengpinKuaipai. All rights reserved.
//

#import "LocalNotificationManage.h"
#import "DateTools.h"
#import "DateRateTransform.h"
#import <objc/runtime.h>
#import "DateFormatOperate.h"

@implementation LocalNotificationManage

//添加一个本地推送
+ (void)addLocalNotification:(NotificationTaskModel *)aNotificationTaskModel
{
    NSString *keyString = nil;
    keyString = [NSString stringWithFormat:@"Shelflife%ld",(long)aNotificationTaskModel.typeId];
    [[self class] configureShelflifeLoacalNotification:aNotificationTaskModel withNotificationKey:keyString];
    
    CLog(@"localNotification keyString = %@",keyString);
    CLog(@"aNotificationTaskModel.tipTime = %@",aNotificationTaskModel.tipTime);
    CLog(@"aNotificationTaskModel.title = %@",aNotificationTaskModel.title);
}

//添加非智能保质期的本地推送
+ (void)configureShelflifeLoacalNotification:(NotificationTaskModel *)aNotificationTaskModel withNotificationKey:(NSString *)key
{
    if (aNotificationTaskModel.status == NotificationStatus_Finish)
    {
        return;
    }
    
    NSString * endDateString = [[[DateFormatOperate fixStringForServerFromData:aNotificationTaskModel.endTime] componentsSeparatedByString:@" "] firstObject];
    NSString * tipTimeString = [[[DateFormatOperate fixStringForServerFromData:aNotificationTaskModel.tipTime] componentsSeparatedByString:@" "] lastObject];
    NSString * endFullDateString = [NSString stringWithFormat:@"%@ %@",endDateString,tipTimeString];
    
    NSDate * endDate = [DateFormatOperate fixDateFromString:endFullDateString];
    
    NSComparisonResult comparisonResult = [[NSDate date] compare:endDate];
    
    // 当前日期 >= 截止日期 --> 已过期
    if (comparisonResult == NSOrderedDescending || comparisonResult == NSOrderedSame)
    {
        return;
    }
    
    UILocalNotification *myLocalNotification = [[UILocalNotification alloc] init];
    
    //拼接时间/周几
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    
    NSString *unitString = [NSString stringWithFormat:@"%ld",(long)aNotificationTaskModel.unit];
    CLog(@"频率单位 = %@",unitString);
   // CLog(@"非智能保质期 触发时间点 H = %ld,M = %ld",(long)[[aNotificationTaskModel.tipTime substringToIndex:2] integerValue],(long)[[aNotificationTaskModel.tipTime substringWithRange:NSMakeRange(3, 2)] integerValue]);
    
    if (unitString &&[unitString isEqualToString:@"0"]) {
        //永不重复
        
        NSDateComponents *componentsForFireNever = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit|  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
        
        [componentsForFireNever setYear:aNotificationTaskModel.endTime.year];        //年
        [componentsForFireNever setMonth:aNotificationTaskModel.endTime.month];       //返回表示几月
        [componentsForFireNever setDay:aNotificationTaskModel.endTime.day];       //返回表示每月几号
        
       // NSString * suffixString = [[aNotificationTaskModel.tipTime componentsSeparatedByString:@" "] lastObject];
        
        [componentsForFireNever setHour: aNotificationTaskModel.tipTime.hour];
        [componentsForFireNever setMinute:aNotificationTaskModel.tipTime.minute];
        [componentsForFireNever setSecond:aNotificationTaskModel.tipTime.second];
        
        NSDate * fireDate = [calendar dateFromComponents: componentsForFireNever];
        
        // 保质期 频率为永不的话，不会超过超过过保日期，不用做判断
        
        myLocalNotification.fireDate = fireDate;
        CLog(@"myLocalNotification.fireDate = %@",[calendar dateFromComponents: componentsForFireNever]);
        myLocalNotification.repeatInterval= 0;
        
    }
    else if (unitString &&[unitString isEqualToString:@"1"])
    {
        NSDateComponents *componentsForFireDate = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit|  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
        
        [componentsForFireDate setHour: aNotificationTaskModel.tipTime.hour];
        [componentsForFireDate setMinute:aNotificationTaskModel.tipTime.minute];
        [componentsForFireDate setSecond:aNotificationTaskModel.tipTime.second];
        
        // 提醒时间
        NSDate * fireDate = [calendar dateFromComponents:componentsForFireDate];
        // 比较提醒时间和当前时间
        NSComparisonResult comparisonResult_tipDate = [[NSDate date] compare:fireDate];
        
        int dayCount = 1;
        while (comparisonResult_tipDate == NSOrderedDescending)
        {
            // 提醒时间 < 当前时间
            // 提醒时间 加 一天时间
            fireDate = [fireDate dateByAddingDays:dayCount];
            comparisonResult_tipDate = [[NSDate date] compare:fireDate];
        }
        
        // 第一次提醒时间大于结束时间的话 跳出
        NSComparisonResult comparisonResult_endDate = [fireDate compare:endDate];
        
        // 提醒日期 > 截止日期 --> 超出范围
        if (comparisonResult_endDate == NSOrderedDescending)
        {
            return;
        }
        
        //每天重复
        myLocalNotification.fireDate = fireDate;
        //myLocalNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:20];
        myLocalNotification.repeatInterval= NSDayCalendarUnit;
        
    }else if (unitString &&[unitString isEqualToString:@"2"]){
        
        //每周(周几)重复
        NSDateComponents *componentsForFireDateWeek = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit|  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
        [componentsForFireDateWeek setWeekday: [DateRateTransform inputFrequencyWithWeek:aNotificationTaskModel.rate]]; //返回表示周几的Integer
        
        //NSString * suffixString = [[aNotificationTaskModel.tipTime componentsSeparatedByString:@" "] lastObject];
        
        [componentsForFireDateWeek setHour:aNotificationTaskModel.tipTime.hour];
        [componentsForFireDateWeek setMinute:aNotificationTaskModel.tipTime.minute];
        [componentsForFireDateWeek setSecond:aNotificationTaskModel.tipTime.second];
        CLog(@"每h周的触发时间是%ld,%ld,%ld",(long)aNotificationTaskModel.tipTime.hour,(long)aNotificationTaskModel.tipTime.minute,aNotificationTaskModel.tipTime.second);
        
        // 提醒时间
        NSDate * tipDate = [calendar dateFromComponents:componentsForFireDateWeek];
        // 比较提醒时间和当前时间
        NSComparisonResult comparisonResult_tipDate = [[NSDate date] compare:tipDate];
        
        int weekCount = 1;
        while (comparisonResult_tipDate == NSOrderedDescending)
        {
            // 提醒时间 < 当前时间
            // 提醒时间 加 一周时间
            tipDate = [tipDate dateByAddingWeeks:weekCount];
            comparisonResult_tipDate = [[NSDate date] compare:tipDate];
        }
        
        // 第一次提醒时间大于结束时间的话 跳出
        NSComparisonResult comparisonResult_endDate = [tipDate compare:endDate];
        
        // 提醒日期 >= 截止日期 --> 超出范围
        if (comparisonResult_endDate == NSOrderedDescending)
        {
            return;
        }
        
        myLocalNotification.fireDate = tipDate;
        myLocalNotification.repeatInterval= NSWeekCalendarUnit;
        CLog(@"myLocalNotification.fireDate = %@",myLocalNotification.fireDate);
        
    }else if (unitString &&[unitString isEqualToString:@"3"]){
        
        //每月的几号
        NSDateComponents *componentsForFireDateMonth = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
        
        [componentsForFireDateMonth setMonth:now.month]; //返回表示几月
        [componentsForFireDateMonth setDay:aNotificationTaskModel.rate + 1]; //返回表示每月几号
        
        //NSString * suffixString = [[aNotificationTaskModel.tipTime componentsSeparatedByString:@" "] lastObject];
        
        [componentsForFireDateMonth setHour:aNotificationTaskModel.tipTime.hour];
        [componentsForFireDateMonth setMinute:aNotificationTaskModel.tipTime.minute];
        [componentsForFireDateMonth setSecond:aNotificationTaskModel.tipTime.second];
        CLog(@"每月的触发时间是%ld,%ld.%ld",(long)aNotificationTaskModel.tipTime.hour,(long)aNotificationTaskModel.tipTime.minute,(long)aNotificationTaskModel.tipTime.second);
        
        // 提醒时间
        NSDate * fireDate = [calendar dateFromComponents:componentsForFireDateMonth];
        // 比较提醒时间和当前时间
        NSComparisonResult comparisonResult_tipDate = [[NSDate date] compare:fireDate];
        
        int monthCount = 1;
        while (comparisonResult_tipDate == NSOrderedDescending)
        {
            // 提醒时间 < 当前时间
            // 提醒时间 加 一月时间
            fireDate = [fireDate dateByAddingMonths:monthCount];
            comparisonResult_tipDate = [[NSDate date] compare:fireDate];
        }
        
        // 第一次提醒时间大于结束时间的话 跳出
        NSComparisonResult comparisonResult_endDate = [fireDate compare:endDate];
        
        // 提醒日期 >= 截止日期 --> 超出范围
        if (comparisonResult_endDate == NSOrderedDescending)
        {
            return;
        }
        
        myLocalNotification.fireDate = fireDate;
        myLocalNotification.repeatInterval= NSMonthCalendarUnit;
        
        
    }else if (unitString &&[unitString isEqualToString:@"4"]){
        
        //每年(年初，年中，年末)
        
    }
    
    // 创建本地通知
    myLocalNotification.timeZone=[NSTimeZone localTimeZone];
    myLocalNotification.alertBody = aNotificationTaskModel.content;
    //        myLocalNotification.soundName =  [[NSBundle mainBundle] pathForResource:@"guanjiaNotiSound" ofType:@"wav"];
    myLocalNotification.soundName =  @"guanjiaNotiSound.wav";
    //        [myLocalNotification setApplicationIconBadgeNumber:1];
    myLocalNotification.userInfo = @{@"information":[self dictionaryWithModel:aNotificationTaskModel],@"id":key};
    CLog(@"fireDate=%@",myLocalNotification.fireDate);
    [[UIApplication sharedApplication] scheduleLocalNotification:myLocalNotification];
}

+ (NSDictionary *)dictionaryWithModel:(id)model {
    CLog(@"dictionaryWithModel = %@",model);
    if (model == nil) {
        return nil;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 获取类名/根据类名获取类对象
    NSString *className = NSStringFromClass([model class]);
    id classObject = objc_getClass([className UTF8String]);
    
    // 获取所有属性
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    
    // 遍历所有属性
    for (int i = 0; i < count; i++) {
        // 取得属性
        objc_property_t property = properties[i];
        // 取得属性名
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        // 取得属性值
        id propertyValue = nil;
        id valueObject = [model valueForKey:propertyName];
        
        if ([valueObject isKindOfClass:[NSDictionary class]]) {
            propertyValue = [NSDictionary dictionaryWithDictionary:valueObject];
        } else if ([valueObject isKindOfClass:[NSArray class]]) {
            propertyValue = [NSArray arrayWithArray:valueObject];
        } else {
            propertyValue = [NSString stringWithFormat:@"%@", [model valueForKey:propertyName]];
        }
        
        [dict setObject:propertyValue forKey:propertyName];
    }
    CLog(@"dict = %@",dict);
    return dict;
}

@end
