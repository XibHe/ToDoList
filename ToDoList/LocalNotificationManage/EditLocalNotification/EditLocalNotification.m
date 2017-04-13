//
//  EditLocalNotification.m
//  ToDoList
//
//  Created by Peng he on 2017/4/13.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "EditLocalNotification.h"
#import "CreateLocalNotification.h"

@implementation EditLocalNotification

+ (void)updateNotificationTaskWithShelflife:(NotificationTaskModel *)taskModel
{
    CLog(@"更新本地通知 = %ld",(long)taskModel.typeId);
    // 通过key值 找到本地通知   先删除 再以key值添加本地通知
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    CLog(@"arrayOfLocalNotifications = %lu",(unsigned long)[arrayOfLocalNotifications count]);
    for (UILocalNotification *localNotification in arrayOfLocalNotifications)
    {
        NSString * key = [NSString stringWithFormat:@"Shelflife%ld",(long)taskModel.typeId];
        CLog(@"LocalNotificationManage = %@",key);
        if ([[localNotification.userInfo valueForKey:@"id"] isEqualToString:key]) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification]; // delete the notification from the system
        }
    }
    // 添加本地通知
    [CreateLocalNotification addLocalNotification:taskModel];
}

@end
