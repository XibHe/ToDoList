//
//  TimeDateCell.m
//  ToDoList
//
//  Created by Peng he on 2017/3/17.
//  Copyright © 2017年 Peng he. All rights reserved.
//

#import "TimeDateCell.h"

@implementation TimeDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureSubViews];
    }
    return self;
}

- (void)configureSubViews
{
    // icon
    _iconImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(ScreenHeight * 20 / 667 / 2);
    }];
    
    // title
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_iconImage.mas_right).with.offset(ScreenHeight * 20 / 667 / 2);
    }];
    
    // remind title
    _remindLabel = [[UILabel alloc] init];
    _remindLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_remindLabel];
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-ScreenHeight * 20 / 667 / 2);
    }];
}

@end
