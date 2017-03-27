# ToDoList
* 一个关于待办事项提醒的小例子

# 主要功能点
* 添加一个基于本地通知的提醒任务
* 设置提醒的开始日期，结束日期，触发提醒的时间点以及提醒的频次

# 如何将日期、触发时间点、提醒频次组合成一个有效的本地通知
* 声明一个UILocalNotification对象
* 使用NSDateComponents拼接触发通知的日期和时间点
* 设置UILocalNotification对象的fireDate属性，即，触发通知的具体日期时间
* 设置UILocalNotification对象的repeatInterval属性，即，触发通知的频率
* 最后使用[[UIApplication sharedApplication] scheduleLocalNotification:myLocalNotification]配置通知

###以频率为永不（只提醒一次）为例，配置UILocalNotification对象，如下

```
NSDateComponents *componentsForFireNever = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit|  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
        
        [componentsForFireNever setYear:aNotificationTaskModel.endTime.year];        //年
        [componentsForFireNever setMonth:aNotificationTaskModel.endTime.month];     //返回表示几月
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
        
            // 创建本地通知
    myLocalNotification.timeZone=[NSTimeZone localTimeZone];
    myLocalNotification.alertBody = aNotificationTaskModel.content;
    //        myLocalNotification.soundName =  [[NSBundle mainBundle] pathForResource:@"guanjiaNotiSound" ofType:@"wav"];
    myLocalNotification.soundName =  @"guanjiaNotiSound.wav";
    //        [myLocalNotification setApplicationIconBadgeNumber:1];
    myLocalNotification.userInfo = @{@"information":[self dictionaryWithModel:aNotificationTaskModel],@"id":key};
    CLog(@"fireDate=%@",myLocalNotification.fireDate);
    [[UIApplication sharedApplication] scheduleLocalNotification:myLocalNotification];

```
# 使用LocalNotificationManagee类统一处理不同类型的通知

##LocalNotificationManage.h

```
@interface LocalNotificationManage : NSObject

//添加非智能本地推送
+ (void)addLocalNotification:(NotificationTaskModel *)aNotificationTaskModel;

//添加非智能保质期的本地推送
+ (void)configureShelflifeLoacalNotification:(NotificationTaskModel *)aNotificationTaskModel withNotificationKey:(NSString *)key;

@end
```


