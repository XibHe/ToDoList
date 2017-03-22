//
//  DateRateTransform.h
//  Steward
//
//  时间频率转化
//
//  Created by Peng he on 15/7/29.
//  Copyright (c) 2015年 ChengpinKuaipai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateRateTransform : NSObject

//本地通知频率
+ (NSInteger)inputFrequencyWithWeek:(NSInteger)frequencyRate;
//频率单位 + 频度
+ (NSString *)outputFrequencyUnitString:(NSInteger)frequencyUnit frequencyRate:(NSInteger)frequencyRate;

+ (NSString *)outPutExprateDaysUnitString:(NSInteger)daysUnit exprateDaysSum:(NSInteger)daysSum;

@end
