//
//  ShelflifeSourceDataTransform.m
//  ToDoList
//
//  Created by Peng he on 2017/4/12.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "ShelflifeSourceDataTransform.h"
#import "DateFormatOperate.h"
#import "DateRateTransform.h"

@implementation ShelflifeSourceDataTransform

+ (NSMutableArray *)fixDataFromShelflifeModel:(ShelflifeModel *)model
{
    NSString *productionDate = [DateFormatOperate fixStringForClientFromDate:model.productionDate joinTime:NO];
    NSString *expirationDays = [DateRateTransform outPutExprateDaysUnitString:model.quality_unit exprateDaysSum:model.quality_sum];
    NSString *endDate = [DateFormatOperate fixStringForClientFromDate:model.endDate joinTime:NO];
    NSString *tipTime = [[[DateFormatOperate fixStringForClientFromDate:model.tipDate joinTime:YES] componentsSeparatedByString:@" "] lastObject];
    NSString *frequency = [DateRateTransform outputFrequencyUnitString:model.frequency_unit frequencyRate:model.frequency_rate];
    NSMutableArray *dateMutArray = [NSMutableArray arrayWithObjects:productionDate,expirationDays,nil];
    NSMutableArray *timeMutarray = [NSMutableArray arrayWithObjects:endDate,tipTime,frequency,nil];
    NSMutableArray *dataSourceArray = [NSMutableArray arrayWithObjects:dateMutArray,timeMutarray,nil];
    return dataSourceArray;
}
@end
