//
//  NavigationViewController.m
//  ToDoList
//
//  Created by Peng he on 2017/3/16.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "NavigationViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController


// 第一次使用的时候调用
+ (void)initialize
{
    // 设置导航条
    UINavigationBar * navBar = [UINavigationBar appearance];
    // 背景
    //    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [navBar setBarTintColor:Color(255, 255, 255)];
    if (iOS8)
    {
        [navBar setTranslucent:NO];
    }
    // 字体颜色 大小
    NSMutableDictionary * titleAttrs = [NSMutableDictionary dictionary];
    titleAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    titleAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:19];
    [navBar setTitleTextAttributes:titleAttrs];
    
    // 设置整个项目所有的item的主题样式
    UIBarButtonItem * item = [UIBarButtonItem appearance];
    // 设置普通状态
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            self.interactivePopGestureRecognizer.delegate = nil;
        }
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"button_back" highlightImage:@"button_back"];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    [super pushViewController:viewController animated:YES];
}

// 导航条点击返回按钮
- (void)back
{
    [self popViewControllerAnimated:YES];
}


@end
