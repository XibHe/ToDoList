//
//  EditLocalNotification.h
//  ToDoList
//
//  Created by Peng he on 2017/4/13.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationTaskModel.h"

@interface EditLocalNotification : NSObject

+ (void)updateNotificationTaskWithShelflife:(NotificationTaskModel *)taskModel;

@end
