//
//  ListViewController.m
//  ToDoList
//
//  Created by Peng he on 2017/3/16.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "ListViewController.h"
#import "NewTaskViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"任务清单";
    
    // 添加按钮
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


@end
