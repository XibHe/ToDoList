//
//  ListViewController.m
//  ToDoList
//
//  Created by Peng he on 2017/3/16.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "ListViewController.h"
#import "NewTaskViewController.h"
#import "ShelflifeOperate.h"
#import "ShelflifeModel.h"
#import "DateFormatOperate.h"
#import "UnderwayTaskCell.h"
#import "DeleteLocalNotification.h"
#import "ShelflifeSourceDataTransform.h"

static NSString *cellIndentify = @"taskCell";
@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate>
{
    NSMutableArray *_dataSourceArray;         // 数据源
    UITableView    *_listTableView;
    id             _reloadDataObserver;       // 刷新数据源的通知
}
@property (nonatomic, strong) MGSwipeButton *swipeButton;  // 滑动cell显示得右侧按钮
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"任务清单";
    [self initSubViews];
    
    _reloadDataObserver = [[NSNotificationCenter defaultCenter] addObserverForName:TReloadDataObserver object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        _dataSourceArray = [ShelflifeOperate getAllShelflifeInfo];
        [_listTableView reloadData];
    }];
}

#pragma mark - 初始化布局
- (void)initSubViews
{
    _dataSourceArray = [ShelflifeOperate getAllShelflifeInfo];
    _listTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.rowHeight = ScreenWidth * 120 / 375 / 2;
    [self.view addSubview:_listTableView];
    
    // 导航栏右侧添加按钮
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"icon_add_nav"] forState:UIControlStateNormal];
    plusButton.size = plusButton.currentBackgroundImage.size;
    [plusButton addTarget:self action:@selector(addTaskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark - 新增任务
- (void)addTaskBtnClick:(UIButton *)sender
{
    NewTaskViewController *newTaskVC = [[NewTaskViewController alloc] init];
    [self.navigationController pushViewController:newTaskVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnderwayTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (!cell) {
        cell = [[UnderwayTaskCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentify];
    }
    ShelflifeModel *shelflifeModel = _dataSourceArray[indexPath.row];
    cell.textLabel.text = shelflifeModel.title;
    cell.detailTextLabel.text = [DateFormatOperate fixStringForClientFromDate:shelflifeModel.endDate joinTime:NO];
    cell.rightButtons = [self createLeftButtons:2 withStar:0];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShelflifeModel *shelflifeModel = [_dataSourceArray objectAtIndex:indexPath.row];
    NewTaskViewController *newTaskVC = [[NewTaskViewController alloc] init];
    newTaskVC.dataSourceArray = [ShelflifeSourceDataTransform fixDataFromShelflifeModel:shelflifeModel];
    newTaskVC.shelflifeModel = shelflifeModel;
    newTaskVC.isEditTask = YES;
    [self.navigationController pushViewController:newTaskVC animated:YES];
}

#pragma mark - 初始化cell的侧滑按钮
-(NSArray *)createLeftButtons:(NSInteger)number withStar:(NSInteger)star
{
    NSMutableArray * resultArray = [NSMutableArray array];
    NSArray *iconArray = @[@"button_delete",@"button_addStar"];
    for (NSInteger i = 0; i < [iconArray count]; i ++) {
        _swipeButton.backgroundColor = [UIColor clearColor];
        _swipeButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:iconArray[i]] backgroundColor:nil insets:UIEdgeInsetsMake(0, 0, 0, -17) callback:^BOOL(MGSwipeTableCell *sender) {
            return YES;
        }];
        [resultArray addObject:self.swipeButton];
    }
    return resultArray;
}

#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *listTableViewindexPath = [_listTableView indexPathForCell:cell];
    ShelflifeModel *shelflifeModel = [_dataSourceArray objectAtIndex:listTableViewindexPath.row];
    // 删除
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        // 删除保质期表中一条数据
        [ShelflifeOperate deleteShelflifeInfoWithID:shelflifeModel.ID];
        // 删除NotificationTask库中的一条数据(暂时忽略此步操作)
        // 删除对应的本地通知
        [DeleteLocalNotification deleteNotificationWithShelflife:shelflifeModel.ID];
        // 删除数据源
        [_dataSourceArray removeObjectAtIndex:listTableViewindexPath.row];
        [_listTableView reloadData];
    } else if (direction == MGSwipeDirectionRightToLeft && index == 1) {
    // 加星
    }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_reloadDataObserver];
    _reloadDataObserver = nil;
}

@end
