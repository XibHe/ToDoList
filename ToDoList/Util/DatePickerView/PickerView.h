//
//  PickerView.h
//  Steward
//
//  Created by Peng he on 15/8/31.
//  Copyright (c) 2015年 ChengpinKuaipai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewDelegare;
typedef enum
{
    PickerType_pruductDate      = 0,     // 生产日期
    PickerType_endDate          = 1,     // 结束提醒日期
    PickerType_frequency        = 2,     // 频率选择器
    PickerType_warrantyDate     = 3,     // 过保日期
    PickerType_AnyDate          = 4      // 任意日期
    
}PickerType;

@interface PickerView : UIView<UIPickerViewDelegate , UIPickerViewDataSource>
{
    UIView * _toolBar;
    UIPickerView * _pickerView;
}
@property (nonatomic , retain) UIDatePicker * datePickerView;
@property (nonatomic , assign) id <PickerViewDelegare> delegate;
@property (nonatomic , assign) UIDatePickerMode pickerMode; // Time || Date 模式 如果没有，则赋值为-1
@property (nonatomic , retain) NSArray * argArray;
@property (nonatomic , retain) NSString * selectNum; // 保存非省名和地名的单条字符串

@property (nonatomic , retain) NSDictionary * dataSouceDict;// pickerView数据源
@property (nonatomic , copy) NSString * dateString; // 保存 Time || Date
@property (nonatomic , retain) NSDate * pickerDate; // 保存选择的时间或日期
@property (nonatomic , assign) PickerType pickerType;

//自定义频率选择器数据源
@property (nonatomic, strong) NSDictionary *frequencyDictionary;
@property (nonatomic ,strong) NSArray *frequencyArray;
@property (nonatomic ,strong) NSArray *rangeArray;
@property (nonatomic, assign) NSInteger dateUnit;
@property (nonatomic, assign) NSInteger dateRate;

//判断是否日期是否已经选择
@property (nonatomic, assign) BOOL isCheckDate;
@property (nonatomic, strong) NSDate *CheckDate;

//"到期日"最大不超过的日期
@property (nonatomic, strong) NSDate * maxDate;     // 最大日期
@property (nonatomic, strong) NSDate * minDate;     // 最小日期

- (void)show;
- (void)remove;
@end

@protocol PickerViewDelegare <NSObject>

- (void)callbackForConfirmWithParamStr:(PickerView *)myPickerView Param:(NSString *)paramStr;

@end
