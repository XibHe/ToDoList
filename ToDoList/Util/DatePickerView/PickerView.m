//
//  PickerView.m
//  Steward
//
//  Created by Peng he on 15/8/31.
//  Copyright (c) 2015年 ChengpinKuaipai. All rights reserved.
//

#import "PickerView.h"

#define CANCEL_BUTTON_TAG   100
#define DONE_BUTTON_TAG     200
@implementation PickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.alpha = 1;
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
    }
    return self;
}
- (void)assignTheNecessaryValue
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    //获得系统时间和日期
    NSDate *  senddate=[NSDate date];
    
    if (_pickerType == PickerType_AnyDate && _pickerMode == UIDatePickerModeDate) {
        
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        
        if (self.isCheckDate == YES) {
            
            _dateString = [dateformatter stringFromDate:self.CheckDate];
            
            self.pickerDate = self.CheckDate;
        }
        else{
            
            _dateString = [dateformatter stringFromDate:senddate];
            
            self.pickerDate = senddate;
        }
        
    }
    else if (_pickerMode == UIDatePickerModeTime) {
        [dateformatter setDateFormat:@"HH:mm"];
        //显示已选的日期
        if (self.isCheckDate == YES) {
            
            //[dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            _dateString = [dateformatter stringFromDate:self.CheckDate];
            CLog(@"已选的时间点 = %@",self.CheckDate);
            
            self.pickerDate = self.CheckDate;
        }
        else{
            
            _dateString = [dateformatter stringFromDate:senddate];
            
            self.pickerDate = senddate;
        }
        
    }
    else if (_pickerMode == UIDatePickerModeDate){
        
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        //显示已选的日期
        if (self.isCheckDate == YES) {
            
            _dateString = [dateformatter stringFromDate:self.CheckDate];
            
            self.pickerDate = self.CheckDate;
        }
        else{
            
            _dateString = [dateformatter stringFromDate:senddate];
            
            self.pickerDate = senddate;
        }
        
    }
    else if (_pickerMode == UIDatePickerModeDateAndTime){
        
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        if (self.isCheckDate == YES) {
            
            _dateString = [dateformatter stringFromDate:self.CheckDate];
            
            self.pickerDate = self.CheckDate;
        }
        else{
            
            _dateString = [dateformatter stringFromDate:senddate];
            
            self.pickerDate = senddate;
        }
        
        
    }
    
    
}

- (void)show
{
    [self assignTheNecessaryValue];
    [self createToolbar];
    if (_pickerMode < 0) {
        [self createPickerView];
        [self addSubview:_pickerView];
    }
    else{
        [self creatDatePickerView];
        [self addSubview:_datePickerView];
    }
    [self addSubview:_toolBar];
    
    [UIView animateWithDuration:0.25 animations:^{
        _toolBar.frame = CGRectMake(0, ScreenHeight - 280 - 44, ScreenWidth, 44);
        if (_pickerMode < 0) {
            _pickerView.frame = CGRectMake(0, ScreenHeight - 280, ScreenWidth, 280);
        }
        else{
            _datePickerView.frame = CGRectMake(0, ScreenHeight - 280, ScreenWidth, 280);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)remove
{
    [UIView animateWithDuration:0.25 animations:^{
        _toolBar.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 44);
        if (_pickerMode < 0) {
            _pickerView.frame = CGRectMake(0, _toolBar.frame.origin.y + _toolBar.frame.size.height, ScreenWidth, 280);
        }
        else{
            _datePickerView.frame = CGRectMake(0, _toolBar.frame.origin.y + _toolBar.frame.size.height, ScreenWidth, 280);
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

- (void)createPickerView
{
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _toolBar.frame.origin.y + _toolBar.frame.size.height, ScreenWidth, 280)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    
    //判断是否为频率选择器
    if (self.pickerType == PickerType_frequency) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"frequency" ofType:@"plist"];
        self.frequencyDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        self.frequencyArray = @[@"永不",@"每天",@"每周",@"每月",@"每年"];
        self.rangeArray = [self.frequencyDictionary objectForKey:[self.frequencyArray objectAtIndex:0]];
        
    }
}

- (void)creatDatePickerView
{
    _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, _toolBar.frame.origin.y + _toolBar.frame.size.height, ScreenWidth, 280)];
     [_datePickerView   setTimeZone:[NSTimeZone defaultTimeZone]];
    _datePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    //滚动datePicker到指定日期,self.CheckDate 可能为空,为空时会崩溃
    if (self.isCheckDate == YES && self.CheckDate) {
        CLog(@"ddd");
        [_datePickerView setDate:self.CheckDate animated:YES];
    }
    _datePickerView.datePickerMode = self.pickerMode;
    _datePickerView.backgroundColor = [UIColor whiteColor];
    CLog(@"pickerMode == %ld",(long)_datePickerView.datePickerMode);
    
    [_datePickerView setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [_datePickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)createToolbar
{
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 60)];
    
    UIImageView * toolbarBackgroundView = [[UIImageView alloc] initWithFrame:_toolBar.bounds];
    toolbarBackgroundView.image = [UIImage imageNamed:@"toolbarBack"];
    [_toolBar addSubview:toolbarBackgroundView];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 7, 68, 60-7);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:cancelButton];
    
    UIButton * doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(ScreenWidth - 68, 7, 68, 60-7);
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton setTitleColor:Color(0, 119, 255) forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [doneButton addTarget:self action:@selector(makeSureAction) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:doneButton];
    
}

#pragma mark UIPickerViewDataSource 处理方法

// 返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    
    if (self.pickerType == PickerType_frequency) {
        
        return 2;
    }else{
        
        return [_dataSouceDict count];
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (self.pickerType == PickerType_frequency) {
        
        if (component == 0) {
            return [self.frequencyArray count];
        }else{
            return [self.rangeArray count];
        }
    }
    else{
        
        return [[_dataSouceDict objectForKey:@"pickerContent"] count];
    }
    
}

#pragma mark --- UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return [self.frequencyArray objectAtIndex:row];
    }else{
        return [self.rangeArray objectAtIndex:row];
        
    }
}

#pragma mark UIPickerViewDelegate 处理方法

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerType == PickerType_frequency) {
        
        if (component == 0) {
            self.rangeArray = [self.frequencyDictionary objectForKey:[self.frequencyArray objectAtIndex:row]];
            CLog(@"self.rangeArray = %@",self.rangeArray);
            
        }
        [pickerView reloadComponent:1];
        if (component == 1){
            
        }
        self.dateUnit = [_pickerView selectedRowInComponent:0];
        self.dateRate = [_pickerView selectedRowInComponent:1];
        CLog(@"频率选择器控件 = %ld,%ld",(long)self.dateUnit,(long)self.dateRate);
    }
}

#pragma mark datePickerView 值改变回调方法
- (void)dateChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    if (_pickerMode == UIDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else if (_pickerMode == UIDatePickerModeDate){
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        if (_pickerType == PickerType_pruductDate) {
            
            _datePickerView.maximumDate = [NSDate date];
            
        }else if (_pickerType == PickerType_endDate){
            //最小日期
            _datePickerView.minimumDate = [NSDate date];
            _datePickerView.maximumDate = self.maxDate;
            
        }else if (_pickerType == PickerType_warrantyDate){
            
            _datePickerView.minimumDate = self.minDate;
            
        }
        
    }
    else if (_pickerType == PickerType_AnyDate){
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
    }
    _dateString = [dateFormatter stringFromDate:datePicker.date];
    
    self.pickerDate = datePicker.date;
    CLog(@"未改变的日期 = %@,date = %@",_dateString,datePicker.date);
}

#pragma mark - Actions
- (void)cancelAction
{
    [self remove];
}

- (void)makeSureAction
{
    NSString * paramStr = @"";
    if (_pickerType == PickerType_AnyDate) // 判断是否是DatePicker
    {
        paramStr = _dateString;
    }
    else{
        paramStr = _dateString;
    }
    
    [_delegate callbackForConfirmWithParamStr:self Param:paramStr];
    
    [self remove];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self remove];
}
@end
