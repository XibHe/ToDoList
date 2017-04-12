//
//  NewTaskViewController.h
//  ToDoList
//
//  新增/编辑提醒任务
//
//  Created by Peng he on 2017/3/16.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    DateType_Production    = 1,      // 生产日期
    DateType_Deadline      = 2,      // 到期日
    DateType_RemindTime    = 3,      // 提醒时间
    DateType_Frequency     = 4,      // 提醒频率
    DateType_AnyDate       = 5
}DateType;
@interface NewTaskViewController : UIViewController

@property (nonatomic, assign) DateType dateType;              // 时间日期类型
@property (nonatomic, assign) BOOL isEditTask;                // 编辑任务
@property (nonatomic, strong) NSMutableArray *dataSource;     // 输入内容数据源
@end
