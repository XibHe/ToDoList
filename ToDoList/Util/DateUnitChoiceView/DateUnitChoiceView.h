//
//  DateUnitChoiceView.h
//  ToDoList
//
//  自定义天数选择器控件
//
//  Created by Peng he on 2017/3/20.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateUnitChoiceViewDelegate;
@class DateUnitChoiceView;

typedef enum
{
    SelectedDateUnit_Day    =   0,  // 天
    SelectedDateUnit_Mouth  =   1,  // 月
    SelectedDateUnit_Year   =   2   // 年
}SelectedDateUnit;

@interface DateUnitChoiceView : UIView
@property (nonatomic, assign) id <DateUnitChoiceViewDelegate> delegate;

@property (nonatomic, strong) UIView * customBgView;

@property (nonatomic, strong) UIView * toolbarView;

@property (nonatomic, strong) UIView * inputView;

@property (nonatomic, assign) SelectedDateUnit selectedDateUnit;

//再次输入时带入已经输入的内容
@property (nonatomic, assign) NSInteger inputInteger;
@property (nonatomic, assign) NSInteger unitInteger;

+ (instancetype)dateUnitChoiceView;

- (void)show;

- (void)dismiss;

@end

@protocol DateUnitChoiceViewDelegate <NSObject>

- (void)dateUnitChoiceView:(DateUnitChoiceView *)dateUnitChoiceView selectedDateSum:(NSInteger)dateSum dateUnit:(SelectedDateUnit)dateUnit;

@end
