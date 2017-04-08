

//
//  UIBarButtonItem+Extension.m
//  ToDoList
//
//  Created by Peng he on 2017/3/17.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置图片
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置标题
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:Color(23, 126, 249) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    // 设置尺寸
    button.size = CGSizeMake(40, 40);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
