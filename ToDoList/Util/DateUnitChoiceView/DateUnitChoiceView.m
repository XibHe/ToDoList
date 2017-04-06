//
//  DateUnitChoiceView.m
//  ToDoList
//
//  Created by Peng he on 2017/3/20.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "DateUnitChoiceView.h"
#define kButtonWidth    55
#define kButtonHeight   34
#define kButtonMargin   12

typedef enum
{
    DateUnitType_Day    =   1,  // 天
    DateUnitType_Mouth  =   2,  // 月
    DateUnitType_Year   =   3   // 年
}DateUnitType;

@interface DateUnitChoiceView ()
@property (nonatomic, strong) UIView * toolView;

@property (nonatomic, strong) UIButton * yearButton;

@property (nonatomic, strong) UIButton * mouthButton;

@property (nonatomic, strong) UIButton * dayButton;

@property (nonatomic, strong) UITextField * inputTextField;

@end

@implementation DateUnitChoiceView

+ (instancetype)dateUnitChoiceView
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // 不用监听键盘 直接在0.25秒内弹出工具条和键盘  这样可以同步展示  监听键盘再弹出工具条会卡顿
        //监听键盘弹出高度
      //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)createSubviews
{
    self.customBgView = [[UIView alloc] initWithFrame:self.bounds];
    self.customBgView.backgroundColor = [UIColor blackColor];
    self.customBgView.alpha = 0.5;
    [self addSubview:self.customBgView];
    
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-216-92-64, ScreenWidth, 92)];
    self.toolView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.toolView];
    
    self.toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    [self.toolView addSubview:self.toolbarView];
    
    UIImageView * toolbarBackgroundView = [[UIImageView alloc] initWithFrame:self.toolbarView.bounds];
    toolbarBackgroundView.image = [UIImage imageNamed:@"list_bg_both"];
    [self.toolbarView addSubview:toolbarBackgroundView];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 68, 42);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarView addSubview:cancelButton];
    
    UIButton * doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(ScreenWidth - 68, 0, 68, 42);
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton setTitleColor:Color(0, 119, 255) forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [doneButton addTarget:self action:@selector(makeSureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarView addSubview:doneButton];
    
    
    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.toolbarView.bottom, ScreenWidth, 50)];
    [self.toolView addSubview:self.inputView];
    
    UIImageView * inputViewBackgroundView = [[UIImageView alloc] initWithFrame:self.inputView.bounds];
    inputViewBackgroundView.image = [UIImage imageNamed:@"bg_popwin_background"];
    [self.inputView addSubview:inputViewBackgroundView];
    
    // 65 34   magin 12
    self.yearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.yearButton.frame = CGRectMake(ScreenWidth - kButtonMargin - kButtonWidth, (self.inputView.height - kButtonHeight) / 2, kButtonWidth, kButtonHeight);
    [self.yearButton setTitle:@"年" forState:UIControlStateNormal];
    [self.yearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.yearButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.yearButton setBackgroundImage:[UIImage imageNamed:@"bg_popwin_mouth"] forState:UIControlStateNormal];
    [self.yearButton setBackgroundImage:[UIImage imageNamed:@"bg_popwin_day"] forState:UIControlStateSelected];
    self.yearButton.tag = DateUnitType_Year;
    [self.yearButton addTarget:self action:@selector(choiceDateUnit:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView addSubview:self.yearButton];
    
    self.mouthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mouthButton.frame = CGRectMake(ScreenWidth - 2 * kButtonMargin - 2 * kButtonWidth, (self.inputView.height - kButtonHeight) / 2, kButtonWidth, kButtonHeight);
    [self.mouthButton setTitle:@"月" forState:UIControlStateNormal];
    [self.mouthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.mouthButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.mouthButton setBackgroundImage:[UIImage imageNamed:@"bg_popwin_mouth"] forState:UIControlStateNormal];
    [self.mouthButton setBackgroundImage:[UIImage imageNamed:@"bg_popwin_day"] forState:UIControlStateSelected];
    self.mouthButton.tag = DateUnitType_Mouth;
    [self.mouthButton addTarget:self action:@selector(choiceDateUnit:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView addSubview:self.mouthButton];
    
    self.dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dayButton.frame = CGRectMake(ScreenWidth - 3 * kButtonMargin - 3 * kButtonWidth, (self.inputView.height - kButtonHeight) / 2, kButtonWidth, kButtonHeight);
    [self.dayButton setTitle:@"天" forState:UIControlStateNormal];
    [self.dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dayButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.dayButton setBackgroundImage:[UIImage imageNamed:@"bg_popwin_mouth"] forState:UIControlStateNormal];
    [self.dayButton setBackgroundImage:[UIImage imageNamed:@"bg_popwin_day"] forState:UIControlStateSelected];
    self.dayButton.tag = DateUnitType_Day;
    [self.dayButton addTarget:self action:@selector(choiceDateUnit:) forControlEvents:UIControlEventTouchUpInside];
    self.dayButton.selected = YES;
    [self.inputView addSubview:self.dayButton];
    
    self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(kButtonMargin, (self.inputView.height - kButtonHeight) / 2, ScreenWidth - 2 * kButtonMargin - (ScreenWidth - self.dayButton.left), kButtonHeight)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kButtonMargin, self.inputView.height)];
    leftImageView.image = [UIImage imageNamed:@"alpha_nothing"];
    self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
    self.inputTextField.leftView = leftImageView;
    self.inputTextField.font = [UIFont systemFontOfSize:18];
    self.inputTextField.background = [UIImage imageNamed:@"bg_popwin_text"];
    self.inputTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.inputTextField.keyboardType = UIKeyboardTypePhonePad;
    self.inputTextField.placeholder = @"输入天数";
    [self.inputView addSubview:self.inputTextField];
    
    NSString *inputString = [NSString stringWithFormat:@"%ld",(long)self.inputInteger];
    CLog(@"self.inputTextField.text = %@",self.inputTextField.text);
    if ([inputString isEqualToString:@"0"]) {
        
        self.inputTextField.text = [inputString stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
    else {
        
        self.inputTextField.text = inputString;
    }
    
    UIButton *unitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    unitButton.tag = self.unitInteger + 1;
    [self choiceDateUnit:unitButton];
    
    [self.inputTextField becomeFirstResponder];
}

#pragma mark - Action
- (void)makeSureAction
{
    if ([self.inputTextField.text isEqualToString:@"0"]) {
        
        self.inputTextField.text = @"";
        [SVProgressHUD showErrorWithStatus:@"保质期天数不能为0!"];
    }
    else if (self.inputTextField.text.length > 0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dateUnitChoiceView:selectedDateSum:dateUnit:)])
        {
            [self.delegate dateUnitChoiceView:self selectedDateSum:[self.inputTextField.text integerValue] dateUnit:self.selectedDateUnit];
        }
        [self dismiss];
    }
    else{
        
        [self dismiss];
    }
    
}

- (void)cancelAction
{
    [self dismiss];
}

- (void)choiceDateUnit:(UIButton *)button
{
    NSInteger buttonType = button.tag;
    switch (buttonType)
    {
        case DateUnitType_Day:
        {
            self.selectedDateUnit = SelectedDateUnit_Day;
            
            self.inputTextField.placeholder = @"输入天数";
            
            self.dayButton.selected = YES;
            self.mouthButton.selected = NO;
            self.yearButton.selected = NO;
            
            [self.dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.mouthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.yearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case DateUnitType_Mouth:
        {
            self.selectedDateUnit = SelectedDateUnit_Mouth;
            
            self.inputTextField.placeholder = @"输入月数";
            
            self.dayButton.selected = NO;
            self.mouthButton.selected = YES;
            self.yearButton.selected = NO;
            
            [self.dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.mouthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.yearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case DateUnitType_Year:
        {
            self.selectedDateUnit = SelectedDateUnit_Year;
            
            self.inputTextField.placeholder = @"输入年数";
            
            self.dayButton.selected = NO;
            self.mouthButton.selected = NO;
            self.yearButton.selected = YES;
            
            [self.dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.mouthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.yearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

//#pragma mark - 键盘监听
//-(void)keyboardDidShow:(NSNotification *)notification
//{
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    
//    CGRect keyboardRect = [aValue CGRectValue];
//    
//    CLog(@"height = %f",keyboardRect.size.height);
//    
//    
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    CLog(@"animationDuration = %f",animationDuration);  // 0.25
//    
//    // 移动输入视图
//    self.toolView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 92);
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    self.toolView.frame = CGRectMake(0, self.bounds.size.height - keyboardRect.size.height, self.bounds.size.width, 92);
//    [UIView commitAnimations];
//}

#pragma mark - 触摸消除
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

#pragma mark - 公开调用
- (void)show
{
    [self createSubviews];
    
    self.customBgView.frame = self.bounds;
    
    CLog(@"windows = %@",[UIApplication sharedApplication].windows);
    // 1.获得最上面的窗口
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    // 2.添加自己到窗口上
    [window addSubview:self];
    // 3.设置尺寸
    self.frame = window.bounds;
    
    [self.inputTextField becomeFirstResponder];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.inputTextField resignFirstResponder];
        self.toolView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 92);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [self removeFromSuperview];
    }];
}

@end
