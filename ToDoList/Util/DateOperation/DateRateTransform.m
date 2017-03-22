//
//  DateRateTransform.m
//  Steward
//
//  Created by Peng he on 15/7/29.
//  Copyright (c) 2015年 ChengpinKuaipai. All rights reserved.
//

#import "DateRateTransform.h"

@implementation DateRateTransform

//本地通知频率
+ (NSInteger)inputFrequencyWithWeek:(NSInteger)frequencyRate
{
    //"0" - "6" 分别表示周一到周日   for fixing (周五(-1),周六(0),周日(1))
    if (frequencyRate == 0 ) {
        return -5;
    }else if (frequencyRate == 1){
        return -4;
    }else if (frequencyRate == 2){
        return -3;
    }else if (frequencyRate == 3){
        return -2;
    }else if (frequencyRate == 4){
        return -1;
    }else if (frequencyRate == 5){
        return 0;
    }else {
        return 1;
    }
}

//频率单位 + 频度
+ (NSString *)outputFrequencyUnitString:(NSInteger)frequencyUnit frequencyRate:(NSInteger)frequencyRate
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"frequency" ofType:@"plist"];
    NSDictionary *frequencyDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *frequencyArray = @[@"永不",@"每天",@"每周",@"每月",@"每年"];
    //self.frequencyArray = [self.frequencyDictionary allKeys];
    NSArray *rangeArray = [frequencyDictionary objectForKey:[frequencyArray objectAtIndex:frequencyUnit]];
    
    if (frequencyUnit == 0) {
        return @"永不";
    }else if (frequencyUnit == 1){
        return @"每天";
    }else if (frequencyUnit == 2){
        
        NSString *weekString = [NSString stringWithFormat:@"%@ %@",@"每周",[rangeArray objectAtIndex:frequencyRate]];
        
        return weekString;
    }else if (frequencyUnit == 3){
        
        NSString *mothString;
        
        if ([[rangeArray objectAtIndex:frequencyRate] isEqualToString:@"月末"]) {
            
           mothString = [NSString stringWithFormat:@"%@ %@",@"每月",[rangeArray objectAtIndex:frequencyRate]];
            
        }else{
            
           mothString = [NSString stringWithFormat:@"%@ %@号",@"每月",[rangeArray objectAtIndex:frequencyRate]];
        }
    
        return mothString;
    }else{
        
        NSString *yearString = [NSString stringWithFormat:@"%@ %@",@"每年",[rangeArray objectAtIndex:frequencyRate]];

        return yearString;
    }
}

+ (NSString *)outPutExprateDaysUnitString:(NSInteger)daysUnit exprateDaysSum:(NSInteger)daysSum
{
   
    if (daysUnit == 0) {
        
        NSString *dayString = [NSString stringWithFormat:@"%ld天",(long)daysSum];
        
        return dayString;
    }else if (daysUnit == 1){
        
        NSString *monthString = [NSString stringWithFormat:@"%ld个月",(long)daysSum];
        
        return monthString;
    }
    else{
        
        NSString *yearString = [NSString stringWithFormat:@"%ld年",(long)daysSum];
        return yearString;
    }
}
@end
