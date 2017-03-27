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

static NSString *cellIndentify = @"taskCell";
@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataSourceArray;         // 数据源
    UITableView    *_listTableView;
    id             _reloadDataObserver;       // 刷新数据源的通知
}
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentify];
    }
    ShelflifeModel *shelflifeModel = _dataSourceArray[indexPath.row];
    cell.textLabel.text = shelflifeModel.title;
    cell.detailTextLabel.text = [DateFormatOperate fixStringForClientFromDate:shelflifeModel.endDate joinTime:NO];
    return cell;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_reloadDataObserver];
    _reloadDataObserver = nil;
}

@end
