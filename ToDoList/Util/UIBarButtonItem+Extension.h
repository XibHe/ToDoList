//
//  UIBarButtonItem+Extension.h
//  ToDoList
//
//  自定义BarButton
//
//  Created by Peng he on 2017/3/17.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage;

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title;
@end
