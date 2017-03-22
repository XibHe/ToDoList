//
//  ToDoListDB.h
//  ToDoList
//
//  读取本地数据库
//
//  Created by Peng he on 2017/3/21.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface ToDoListDB : NSObject

// 打开数据库
+ (FMDatabase *)open;

// 关闭数据库
+ (void)close;

@end
