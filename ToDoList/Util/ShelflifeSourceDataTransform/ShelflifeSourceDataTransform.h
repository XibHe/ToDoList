//
//  ShelflifeSourceDataTransform.h
//  ToDoList
//
//  将Shelflife表中的日期数据转化为NewTaskViewController中用于显示的数据源
//
//  Created by Peng he on 2017/4/12.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShelflifeModel.h"

@interface ShelflifeSourceDataTransform : NSObject

+ (NSMutableArray *)fixDataFromShelflifeModel:(ShelflifeModel *)model;

@end
