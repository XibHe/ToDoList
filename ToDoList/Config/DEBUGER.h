//
//  DEBUGER.h
//  Steward
//
//  Created by Jerry on 15/6/25.
//  Copyright (c) 2015年 ChengpinKuaipai. All rights reserved.
//

//RELEASE版本屏蔽Log
//需要打NSLog时,使用CLog输出,使用方式于NSLog一致

#ifdef DEBUG // 处于开发阶段
#define CLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define CLog(...)
#endif

#ifdef DEBUG
#define PrintError(isok, format, ...) if(!isok) NSLog(format, ## __VA_ARGS__)
#else
#define PrintError(isok, format, ...)
#endif

