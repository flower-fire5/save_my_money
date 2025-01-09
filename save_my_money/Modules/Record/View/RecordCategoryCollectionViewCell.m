//
//  RecordCategoryCollectionViewCell.m
//  save_my_money
//
//  Created by hwy on 2025/1/4.
//

#import "RecordCategoryCollectionViewCell.h"
#import "CommonValue.h"
#import <Masonry/Masonry.h>

@interface RecordCategoryCollectionViewCell ()

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *lab;

@end

@implementation RecordCategoryCollectionViewCell

- (void)initUI {
    self.icon = [[UIImageView alloc]init];
    self.lab = [[UILabel alloc]init];
    self.lab.font = [UIFont systemFontOfSize:AdjustFont(12) weight:UIFontWeightLight];
    self.lab.textColor = kColor_Text_Gary;
    
    UIView *contentView = [[UIView alloc] init];
    
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.bottom.equalTo(self);
    }];
    
    [contentView addSubview:self.icon];
    self.icon.contentMode = UIViewContentModeCenter; // 图片居中显示
    self.icon.clipsToBounds = NO; // 不裁剪图片内容
    self.icon.translatesAutoresizingMaskIntoConstraints = NO;
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(contentView);
            make.width.equalTo(self.icon.mas_height).multipliedBy(1.667);
            make.centerX.equalTo(contentView.mas_centerX);
            make.centerY.equalTo(contentView.mas_centerY).offset(-15);
    }];
    
    [contentView addSubview:self.lab];
    self.lab.textAlignment = NSTextAlignmentCenter;
    [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.icon.mas_bottom).offset(5);
        make.bottom.equalTo(contentView.mas_bottom).offset(-8);
    }];
    
    
}

- (void)setModel:(BKCModel *)model {
    _model = model;
    [_lab setText:model.name];
    [_icon setImage:[UIImage imageNamed:_model.icon_n]];
}

- (void)setChoose:(BOOL)choose {
    _choose = choose;
    if (choose == YES) {
        [_icon setImage:[UIImage imageNamed:_model.icon_s]];
    }
    else {
        [_icon setImage:[UIImage imageNamed:_model.icon_n]];
    }
}

@end
