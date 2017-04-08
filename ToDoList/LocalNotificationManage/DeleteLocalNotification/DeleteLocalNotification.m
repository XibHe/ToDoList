//
//  DeleteLocalNotification.m
//  ToDoList
//
//  Created by Peng he on 2017/4/8.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "DeleteLocalNotification.h"

@implementation DeleteLocalNotification

// 删除保质期任务的通知(用于保质期列表删除)
+ (void)deleteNotificationWithShelflife:(NSInteger)ID
{
    // 通过创建本地通知时的通知key值找到本地通知后删除
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        NSString * key = [NSString stringWithFormat:@"Shelflife%ld",(long)ID];
        CLog(@"DeleteLocalNotification key = %@",key);
        if ([[localNotification.userInfo valueForKey:@"id"] isEqualToString:key]) {
            // delete the notification from the system
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
}

@end
