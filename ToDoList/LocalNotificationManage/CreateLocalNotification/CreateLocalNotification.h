//
//  CreateLocalNotification.h
//  ToDoList
//
//  Created by Peng he on 2017/4/8.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShelflifeModel.h"
#import "NotificationTaskModel.h"

@interface CreateLocalNotification : NSObject

// 添加非智能本地推送
+ (void)addLocalNotification:(NotificationTaskModel *)aNotificationTaskModel;

@end
