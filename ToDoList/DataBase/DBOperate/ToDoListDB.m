//
//  ToDoListDB.m
//  ToDoList
//
//  Created by Peng he on 2017/3/21.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "ToDoListDB.h"
#define DB_FILE_NAME  @"ToDoList.sqlite"

static FMDatabase * dataBase;

@implementation ToDoListDB

// 单例，打开数据库
+ (FMDatabase *)open
{
    /**
     *退出登录：
     关闭数据库
     重新打开数据
     将数据库切换到未登录文件夹，
     *登录：
     清空未登录文件夹
     关闭数据库
     重新打开数据库
     将数据库切换到登录用户数据库
     
     *切换数据：
     判断是否有对应文件夹：
     如果没有创建文件夹，拷贝数据库。
     如果有文件夹，读取文件夹内的数据库。
     */
    
    if (dataBase)
    {
        return dataBase;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *userFilePath = [DOCUMENTPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"D3DC208EF6F98DD6FA5080AF10CE14F6"]];
    NSString *userSrcPath;
    // 如果不存在用户文件夹，创建文件夹，拷贝数据库。用户文件夹存在，读取文件夹内容。
    BOOL isDirectory = YES;
    if (![fileManager fileExistsAtPath:userFilePath isDirectory:&isDirectory])
    {
        NSError * userFilePatherror;
        
        if ([fileManager createDirectoryAtPath:userFilePath withIntermediateDirectories:YES attributes:nil error:&userFilePatherror])
        {
            CLog(@"用户文件夹创建成功");
            
            userSrcPath = [userFilePath stringByAppendingPathComponent:DB_FILE_NAME];
            CLog(@"文档路径 = %@",userSrcPath);
            if (!userSrcPath)
            {
                CLog(@"数据库创建失败!!!");
                return nil;
            }
            
            NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"ToDoList" ofType:@"sqlite"];
            CLog(@"资源路径 = %@",srcPath);
            NSError *error;
            if (![fileManager copyItemAtPath:srcPath toPath:userSrcPath error:&error])
            {
                CLog(@"数据库copy失败 = %@",[error localizedDescription]);
                return nil;
            }
        }
        else
        {
            CLog(@"用户文件夹创建失败 = %@",[userFilePatherror localizedDescription]);
        }
    }
    else
    {
        userSrcPath = [userFilePath stringByAppendingPathComponent:DB_FILE_NAME];
    }
    
    CLog(@"用户数据库路径 = %@",userSrcPath);
    
    NSError * error;
    
    CLog(@"文件夹内容 = %@",[fileManager contentsOfDirectoryAtPath:userSrcPath error:&error]);
    
    for (NSString * filename in [fileManager contentsOfDirectoryAtPath:userSrcPath error:&error])
    {
        CLog(@"fileName = %@",filename);
    }
    
    dataBase = [[FMDatabase alloc] initWithPath:userSrcPath];
    BOOL isOpen = [dataBase open];
    NSLog(@"open 数据库打开了没 = %d", isOpen);
    return dataBase;
}

// 关闭数据库
+ (void)close
{
    if (dataBase)
    {
        [dataBase close];
        dataBase = nil;
    }
}

@end
