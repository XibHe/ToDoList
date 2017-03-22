//
//  Definition.h
//  ToDoList
//
//  Created by Peng he on 2017/3/16.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#define iOS8    [[[UIDevice currentDevice] systemVersion] intValue] >= 8
// 设置颜色
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 获取设备物理高度
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
// 获取设备物理宽度
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width

#define DOCUMENTPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]//文档路径
