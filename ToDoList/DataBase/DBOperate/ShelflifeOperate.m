//
//  ShelflifeOperate.m
//  ToDoList
//
//  Created by Peng he on 2017/3/21.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "ShelflifeOperate.h"
#import "ToDoListDB.h"

@implementation ShelflifeOperate

// 插入数据
+ (NSInteger)insertWithShelflife:(ShelflifeModel *)shelflife
{
    FMDatabase *dataBase = [ToDoListDB open];
    [dataBase beginTransaction];
    NSString *sql = @"INSERT INTO Shelflife (sequence, title, productionDate, quality_sum, quality_unit, endDate, tipDate, frequency_unit, frequency_rate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    NSMutableDictionary * dict ;
    [dataBase setCachedStatements:dict];
    
    [dataBase executeUpdate:sql,
     shelflife.sequence,
     shelflife.title,
     shelflife.productionDate,
     [NSNumber numberWithInteger:shelflife.quality_sum],
     [NSNumber numberWithInteger:shelflife.quality_unit],
     shelflife.endDate,
     shelflife.tipDate,
     [NSNumber numberWithInteger:shelflife.frequency_unit],
     [NSNumber numberWithInteger:shelflife.frequency_rate]];
    [dataBase commit];
    
    //返回自增id
    return (NSInteger)[dataBase lastInsertRowId];
}

// 通过自增ID查询到一条记录
+ (ShelflifeModel *)getaShelflifeInfo:(NSInteger)ID
{
    ShelflifeModel * shelflifeModel;
    FMDatabase * dataBase = [ToDoListDB open];
    NSString * sql = @"SELECT * FROM Shelflife WHERE id = ?";
    FMResultSet * resultSet = [dataBase executeQuery:sql,[NSNumber numberWithInteger:ID]];
    while ([resultSet next]) {
        shelflifeModel = [[ShelflifeModel alloc] init];
        shelflifeModel.ID = [resultSet intForColumn:@"id"];
        shelflifeModel.sequence = [resultSet stringForColumn:@"sequence"];
        shelflifeModel.title = [resultSet stringForColumn:@"title"];
        shelflifeModel.productionDate = [resultSet dateForColumn:@"productionDate"];
        shelflifeModel.quality_sum = [resultSet intForColumn:@"quality_sum"];
        shelflifeModel.quality_unit = [resultSet intForColumn:@"quality_unit"];
        shelflifeModel.endDate = [resultSet dateForColumn:@"endDate"];
        shelflifeModel.tipDate = [resultSet dateForColumn:@"tipDate"];
        shelflifeModel.frequency_unit = [resultSet intForColumn:@"frequency_unit"];
        shelflifeModel.frequency_rate = [resultSet intForColumn:@"frequency_rate"];
    }
    [resultSet close];
    
    return shelflifeModel;
}

// 更新数据
+ (void)updateWithShelflife:(ShelflifeModel *)shelflife
{
    FMDatabase * dataBase = [ToDoListDB open];
    [dataBase beginTransaction];
    NSString *sql = @"UPDATE Shelflife SET sequence = ?, title = ?, productionDate = ?, quality_sum = ?, quality_unit = ?, endDate = ?, tipDate = ?, frequency_unit = ?, frequency_rate = ? WHERE id = ?";
    [dataBase executeUpdate:sql,
     shelflife.sequence,
     shelflife.title,
     shelflife.productionDate,
     [NSNumber numberWithInteger:shelflife.quality_sum],
     [NSNumber numberWithInteger:shelflife.quality_unit],
     shelflife.endDate,
     shelflife.tipDate,
     [NSNumber numberWithInteger:shelflife.frequency_unit],
     [NSNumber numberWithInteger:shelflife.frequency_rate],
     [NSNumber numberWithInteger:shelflife.ID]];
    [dataBase commit];
}

// 查询全部数据
+ (NSMutableArray *)getAllShelflifeInfo
{
    NSMutableArray * aShelflifeModelArray = [[NSMutableArray alloc] init];
    FMDatabase * dataBase = [ToDoListDB open];
    NSString * sql = @"SELECT * FROM Shelflife order by endDate";
    FMResultSet * resultSet = [dataBase executeQuery:sql];
    while ([resultSet next])
    {
        ShelflifeModel * shelflifeModel = [[ShelflifeModel alloc] init];
        shelflifeModel.ID             = [resultSet intForColumn:@"id"];
        shelflifeModel.productionDate = [resultSet dateForColumn:@"productionDate"];
        shelflifeModel.quality_sum    = [resultSet intForColumn:@"quality_sum"];
        shelflifeModel.quality_unit   = [resultSet intForColumn:@"quality_unit"];
        shelflifeModel.endDate        = [resultSet dateForColumn:@"endDate"];
        shelflifeModel.tipDate        = [resultSet dateForColumn:@"tipDate"];
        shelflifeModel.frequency_rate = [resultSet intForColumn:@"frequency_rate"];
        shelflifeModel.frequency_unit = [resultSet intForColumn:@"frequency_unit"];
        shelflifeModel.title          = [resultSet stringForColumn:@"title"];
        shelflifeModel.sequence       = [resultSet stringForColumn:@"sequence"];
        [aShelflifeModelArray addObject:shelflifeModel];
    }
    [resultSet close];
    return aShelflifeModelArray;
}

//删除某一id的数据
+ (void)deleteShelflifeInfoWithID:(NSInteger)ID
{
    FMDatabase *dataBase = [ToDoListDB open];
    [dataBase beginTransaction];
    NSString *sql = @"DELETE FROM Shelflife WHERE id = ?";
    [dataBase executeUpdate:sql,[NSNumber numberWithInteger:ID]];
    [dataBase commit];
}
@end
