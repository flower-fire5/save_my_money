//
//  RecordCategoryCollectionViewCell.m
//  save_my_money
//
//  Created by hwy on 2025/1/4.
//

#import "RecordCategoryCollectionViewCell.h"
#import "CommonValue.h"

@interface RecordCategoryCollectionViewCell ()

@property (weak, nonatomic) UIImageView *icon;
@property (weak, nonatomic) UILabel *lab;

@end

@implementation RecordCategoryCollectionViewCell

- (void)initUI {
    self.lab.font = [UIFont systemFontOfSize:AdjustFont(12) weight:UIFontWeightLight];
    self.lab.textColor = kColor_Text_Gary;
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
