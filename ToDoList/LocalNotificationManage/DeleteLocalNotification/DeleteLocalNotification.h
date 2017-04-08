//
//  DeleteLocalNotification.h
//  ToDoList
//
//  Created by Peng he on 2017/4/8.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShelflifeModel.h"

@interface DeleteLocalNotification : NSObject

// 删除保质期任务的通知(用于保质期列表删除)
+ (void)deleteNotificationWithShelflife:(NSInteger)ID;

@end
