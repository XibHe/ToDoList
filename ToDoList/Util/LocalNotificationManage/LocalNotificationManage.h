//
//  LocalNotificationManage.h
//  Steward
//
//  生成本地通知的工具类
//
//  Created by Peng he on 15/7/28.
//  Copyright (c) 2015年 ChengpinKuaipai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShelflifeModel.h"
#import "NotificationTaskModel.h"

@interface LocalNotificationManage : NSObject

//添加非智能本地推送
+ (void)addLocalNotification:(NotificationTaskModel *)aNotificationTaskModel;

//添加非智能保质期的本地推送
+ (void)configureShelflifeLoacalNotification:(NotificationTaskModel *)aNotificationTaskModel withNotificationKey:(NSString *)key;

@end
