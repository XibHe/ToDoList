//
//  NotificationTaskModel.h
//  ToDoList
//
//  Created by Peng he on 2017/3/21.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NotificationStatus_Operation            = 1,    // 进行中
    NotificationStatus_Finish               = 2,    // 已完成
    NotificationStatus_Overdue              = 3     // 已过期
    
}NotificationStatus;

@interface NotificationTaskModel : NSObject

@property (nonatomic, copy) NSString *uuid;             // 消息所属用户UUID

@property (nonatomic, copy) NSString *taskId;           // 服务器返回TaskID

@property (nonatomic, assign) NSInteger typeId;         // 本地表中通知类型对应的不同类型的自增ID号

@property (nonatomic, copy) NSString *title;            // 标题

@property (nonatomic, copy) NSString *content;          // 内容：明文模版-->您的{0}还有{1}天到期

@property (nonatomic, copy) NSString *message;          // 消息JSON

@property (nonatomic, assign) NSInteger unit;           // 频率单位

@property (nonatomic, assign) NSInteger rate;           // 频率

@property (nonatomic, strong) NSDate *startTime;        // 开始时间

@property (nonatomic, strong) NSDate *endTime;          // 结束时间

@property (nonatomic, strong) NSDate *tipTime;          // 提醒时间

@property (nonatomic, assign) NSInteger status;         // 状态(进行中/完成/已过期)    进行中1 完成2 已过期3

@end
