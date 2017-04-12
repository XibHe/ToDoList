//
//  NewTaskViewController.m
//  ToDoList
//
//  Created by Peng he on 2017/3/16.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "NewTaskViewController.h"
#import "TimeDateCell.h"
#import "PickerView.h"
#import "DateFormatOperate.h"
#import "DateUnitChoiceView.h"
#import "DateRateTransform.h"
#import "UIBarButtonItem+Extension.h"
#import "ShelflifeOperate.h"
#import "NotificationTaskModel.h"
#import "CreateLocalNotification.h"
static NSString *cellIndentify = @"cell";

@interface NewTaskViewController ()<UITableViewDataSource,UITableViewDelegate,PickerViewDelegare,DateUnitChoiceViewDelegate>
{
    NSArray        *_titleSource;    // title数组
    NSMutableArray *_dateMutArray;   // 保质期限数据源
    NSMutableArray *_timeMutarray;   // 提醒设置数据源
    
    UITextField    *_titleField;    //  提醒任务名称
    
    NSInteger      _dateSum;        //保质期天数
    NSInteger      _dateUnit;      //保质期天数单位(日，月，年)
    
    //记录生产日期,到期日,触发时间
    NSDate         *_productDate;
    NSDate         *_endRemindDate;
    NSDate         *_tipDate;
    
    //时间,频率单位
    NSString       *_remindUnit;
    NSString       *_remindRate;
}
@property (nonatomic, strong) UITableView *listTableView;
@end

@implementation NewTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
}

- (void)initSubViews
{
    _titleSource = @[@[@"生产日期",@"保质期天数"],@[@"到期日",@"时间",@"提醒频次"]];
    
    if (_isEditTask) {
        self.title = @"编辑提醒任务";
        _dateMutArray = _dataSourceArray[0];
        _timeMutarray  = _dataSourceArray[1];
    } else {
        self.title = @"添加提醒任务";
        _dateMutArray = [NSMutableArray arrayWithObjects:@"选择日期",@"选择天数",nil];
        _timeMutarray  = [NSMutableArray arrayWithObjects:@"选择日期",@"选择时间",@"选择频次",nil];
    }
    _dataSourceArray = [NSMutableArray arrayWithObjects:_dateMutArray,_timeMutarray,nil];
    
    _listTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.rowHeight = ScreenWidth * 88 / 375 / 2;
    [self.view addSubview:_listTableView];
    
    _titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _titleField.placeholder = @"请输入提醒任务名称";
    _titleField.backgroundColor = [UIColor lightGrayColor];
    _listTableView.tableHeaderView = _titleField;
    if (_isEditTask) {
        _titleField.text = _shelflifeModel.title;
    }
    
    // 确定按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(makeSureClick) title:@"确定"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _titleSource[section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeDateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (!cell) {
        cell = [[TimeDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    cell.titleLabel.text = _titleSource[indexPath.section][indexPath.row];
    cell.remindLabel.text = _dataSourceArray[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScreenWidth * 80 / 375 / 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    
    UILabel *sectionTitle = [[UILabel alloc] init];
    sectionTitle.textAlignment = NSTextAlignmentLeft;
    [sectionView addSubview:sectionTitle];
    [sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionView);
        make.left.equalTo(sectionView.mas_left).with.offset(ScreenHeight * 20 / 667 / 2);
    }];
    if (section == 0) {
        sectionTitle.text = @"保质期限";
    } else if (section == 1) {
        sectionTitle.text = @"提醒设置";
    }
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //生产日期
            self.dateType = DateType_Production;
            PickerView *datePickerView = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            datePickerView.delegate = self;
            datePickerView.pickerMode = UIDatePickerModeDate;
            datePickerView.pickerType = PickerType_pruductDate;
            if (_productDate) {
                datePickerView.isCheckDate = YES;
                datePickerView.CheckDate = _productDate;
            } else {
                datePickerView.isCheckDate = NO;
            }
            [self.view.superview insertSubview:datePickerView aboveSubview:self.view];
            [datePickerView show];
        } else if (indexPath.row == 1) {
            // 保质期天数
            DateUnitChoiceView * dateUnitChoiceView = [DateUnitChoiceView dateUnitChoiceView];
            dateUnitChoiceView.delegate = self;
            dateUnitChoiceView.inputInteger = _dateSum;
            dateUnitChoiceView.unitInteger = _dateUnit;
            [dateUnitChoiceView show];
        }
    } else if (indexPath.section == 1) {
        // 日期，时间，频率选择控件
        PickerView *datePickerView = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        datePickerView.delegate = self;
        [self.view.superview insertSubview:datePickerView aboveSubview:self.view];
        
        if (indexPath.row == 0) {
            // 到期日
            self.dateType = DateType_Deadline;
            datePickerView.pickerMode = UIDatePickerModeDate;
            datePickerView.pickerType = PickerType_endDate;
            datePickerView.maxDate = [self exprateDate];
            if (_endRemindDate) {
                datePickerView.isCheckDate = YES;
                datePickerView.CheckDate = _endRemindDate;
            } else {
                datePickerView.isCheckDate = NO;
            }
            [self.view.superview insertSubview:datePickerView aboveSubview:self.view];
            [datePickerView show];
        } else if (indexPath.row == 1) {
            // 到期提醒时间
            self.dateType = DateType_RemindTime;
            datePickerView.pickerMode = UIDatePickerModeTime;
            if (_tipDate) {
                datePickerView.isCheckDate = YES;
                datePickerView.CheckDate = _tipDate;
            } else {
                datePickerView.isCheckDate = NO;
            }
            [self.view.superview insertSubview:datePickerView aboveSubview:self.view];
            [datePickerView show];
        } else if (indexPath.row == 2) {
            // 提醒频次
            self.dateType = DateType_Frequency;
            datePickerView.pickerMode = -1;
            datePickerView.pickerType = PickerType_frequency;
            [datePickerView show];
        }
    }
}

#pragma mark - PickerViewDelegate
- (void)callbackForConfirmWithParamStr:(PickerView *)myPickerView Param:(NSString *)paramStr
{
    switch (self.dateType) {
        case DateType_Production:
        {
            CLog(@"pickerView返回的生产日期 = %@",myPickerView.pickerDate);
            NSString *productDate = [DateFormatOperate fixStringForClientFromDate:myPickerView.pickerDate joinTime:NO];
            [_dateMutArray replaceObjectAtIndex:0 withObject:productDate];
            _productDate = myPickerView.pickerDate;
            [self reloadSectionIndexpath:0 section:0];
        }
            break;
        case DateType_Deadline:
        {
            CLog(@"pickerView返回的到期日 = %@",myPickerView.pickerDate);
            NSString *endRemindDate = [DateFormatOperate fixStringForClientFromDate:myPickerView.pickerDate joinTime:NO];
            [_timeMutarray replaceObjectAtIndex:0 withObject:endRemindDate];
            _endRemindDate = myPickerView.pickerDate;
            [self reloadSectionIndexpath:0 section:1];
        }
            break;
        case DateType_RemindTime:
        {
            CLog(@"pickerView返回的提醒时间 = %@",myPickerView.pickerDate);
            NSString *tipTime = [[[DateFormatOperate fixStringForClientFromDate:myPickerView.pickerDate joinTime:YES] componentsSeparatedByString:@" "] lastObject];
            [_timeMutarray replaceObjectAtIndex:1 withObject:tipTime];
            _tipDate = myPickerView.pickerDate;
            [self reloadSectionIndexpath:1 section:1];
        }
            break;
        case DateType_Frequency:
        {
            if ([myPickerView.dateUnitString isEqualToString:@""]) {
                _remindUnit = @"0";
            } else{
                _remindUnit = myPickerView.dateUnitString;
            }
            _remindRate = myPickerView.dateRateString;
            NSString *frequency = [DateRateTransform outputFrequencyUnitString:[_remindUnit integerValue] frequencyRate:[_remindRate integerValue]];
            [_timeMutarray replaceObjectAtIndex:2 withObject:frequency];
            [self reloadSectionIndexpath:2 section:1];
        }
            break;
        default:
            break;
    }
}

#pragma mark - DateUnitChoiceViewDelegate
- (void)dateUnitChoiceView:(DateUnitChoiceView *)dateUnitChoiceView selectedDateSum:(NSInteger)dateSum dateUnit:(SelectedDateUnit)dateUnit
{
    _dateSum = dateSum;
    _dateUnit = dateUnit;
    NSString *days = [DateRateTransform outPutExprateDaysUnitString:_dateUnit exprateDaysSum:_dateSum];
    [_dateMutArray replaceObjectAtIndex:1 withObject:days];
    [self reloadSectionIndexpath:1 section:0];
}

#pragma mark - 根据生产日期和保质期天数换算保质期截止日期
- (NSDate *)exprateDate
{
    NSDate * maxDate;
    switch (_dateUnit)
    {
        case SelectedDateUnit_Day:
        {
            maxDate = [_productDate dateByAddingDays:_dateSum];
        }
            break;
        case SelectedDateUnit_Mouth:
        {
            maxDate = [_productDate dateByAddingMonths:_dateSum];
        }
            break;
        case SelectedDateUnit_Year:
        {
            maxDate = [_productDate dateByAddingYears:_dateSum];
        }
            break;
        default:
            break;
    }
    return maxDate;
}

#pragma mark - 局部刷新tableView
- (void)reloadSectionIndexpath:(NSInteger)row section:(NSInteger)section
{
    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [_listTableView reloadRowsAtIndexPaths:@[rowIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 确定按钮
- (void)makeSureClick
{
    if ([_titleField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"提醒任务名称不能为空!"];
        return;
    }
    
    // 新增提醒任务model
    ShelflifeModel *shelflifeModel = [[ShelflifeModel alloc] init];
    shelflifeModel.title = _titleField.text;
    shelflifeModel.productionDate = _productDate;
    shelflifeModel.quality_sum = _dateSum;
    shelflifeModel.quality_unit = _dateUnit;
    shelflifeModel.endDate = _endRemindDate;
    shelflifeModel.tipDate = _tipDate;
    // 提醒频率默认为0(永不)
    if (_remindUnit) {
        shelflifeModel.frequency_unit = [_remindUnit integerValue];
    } else {
        shelflifeModel.frequency_unit = 0;
    }
    shelflifeModel.frequency_rate = [_remindRate integerValue];
    
    // 1.插入保质期表
    shelflifeModel.ID = [ShelflifeOperate insertWithShelflife:shelflifeModel];
    CLog(@"新建提醒任务ID = %ld",(long)shelflifeModel.ID);
    
    // 2.插入到通知任务表(暂时忽略此步操作)
    NotificationTaskModel *notificationTask = [[NotificationTaskModel alloc] init];
    notificationTask.title = shelflifeModel.title;
    notificationTask.typeId = shelflifeModel.ID;
    notificationTask.content = [NSString stringWithFormat:@"保质期任务%@快到期了!",shelflifeModel.title];
    notificationTask.startTime = shelflifeModel.productionDate;
    notificationTask.endTime = shelflifeModel.endDate;
    notificationTask.tipTime = shelflifeModel.tipDate;
    notificationTask.unit = shelflifeModel.frequency_unit;
    notificationTask.rate = shelflifeModel.frequency_rate;
    notificationTask.status = NotificationStatus_Operation;
    
    // 3.添加非智能保质期的本地推送
    [CreateLocalNotification addLocalNotification:notificationTask];
    
    // 刷新列表数据的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TReloadDataObserver object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
