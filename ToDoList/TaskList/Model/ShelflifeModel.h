//
//  ShelflifeModel.h
//  ToDoList
//
//  保质期提醒任务model
//
//  Created by Peng he on 2017/3/21.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    ShelflifeStatus_Deleted     = 0,     // 已删除
    ShelflifeStatus_Operation   = 1,     // 进行中
    ShelflifeStatus_Finish      = 2,     // 完成
    ShelflifeStatus_Overdue     = 3      // 已过期
    
}ShelflifeStatus;
@interface ShelflifeModel : NSObject

@property (nonatomic, assign) NSInteger ID;                     // 自增ID
@property (nonatomic, copy)   NSString  *sequence;              // 用于区分同一条数据在编辑/新增时,服务器中数据是否为同一条数据
@property (nonatomic, copy)   NSString  *title;                 // 保质期标题
@property (nonatomic, strong) NSDate    *productionDate;        // 生产日期
@property (nonatomic, assign) NSInteger quality_sum;            // 保质期选择天数
@property (nonatomic, assign) NSInteger quality_unit;           // 保质期单位
@property (nonatomic, strong) NSDate    *endDate;               // 结束日期
@property (nonatomic, strong) NSDate    *tipDate;               // 提醒时间
@property (nonatomic, assign) NSInteger frequency_unit;         // 提醒频率单位
@property (nonatomic, assign) NSInteger frequency_rate;         // 提醒频率

@end
