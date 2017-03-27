//
//  ShelflifeOperate.h
//  ToDoList
//
//  Created by Peng he on 2017/3/21.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "ShelflifeModel.h"

@interface ShelflifeOperate : ShelflifeModel

// 插入数据
+ (NSInteger)insertWithShelflife:(ShelflifeModel *)shelflife;

// 通过自增ID查询到一条记录
+ (ShelflifeModel *)getaShelflifeInfo:(NSInteger)ID;

// 查询全部数据
+ (NSMutableArray *)getAllShelflifeInfo;

@end
