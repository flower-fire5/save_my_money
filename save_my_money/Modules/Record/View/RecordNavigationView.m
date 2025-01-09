//
//  RecordNavigationView.m
//  save_my_money
//
//  Created by hwy on 2025/1/4.
//

#import "RecordNavigationView.h"
#import "CommonValue.h"
#import "RECORD_EVENT.h"
#import <Masonry/Masonry.h>

#define BTN_FONT [UIFont systemFontOfSize:AdjustFont(16)]

@interface RecordNavigationView ()

@property (strong, nonatomic) UIButton *expensesBtn;
@property (strong, nonatomic) UIButton *incomeBtn;
@property (nonatomic, strong) UIView *line;
@property (strong, nonatomic) UIButton *cancelBtn;

@end

@implementation RecordNavigationView

- (void)initUI {
    self.expensesBtn = [[UIButton alloc]init];
    self.incomeBtn = [[UIButton alloc]init];
    self.cancelBtn = [[UIButton alloc]init];
    [self setBackgroundColor:kColor_Main_Color];
    [self.expensesBtn.titleLabel setFont:BTN_FONT];
    [self.expensesBtn setTitleColor:kColor_Text_Black forState:UIControlStateNormal];
    [self.expensesBtn setTitle:@"支出" forState:UIControlStateNormal];
    [self.incomeBtn.titleLabel setFont:BTN_FONT];
    [self.incomeBtn setTitleColor:kColor_Text_Black forState:UIControlStateNormal];
    [self.incomeBtn setTitle:@"收入" forState:UIControlStateNormal];
    
    @weakify(self)
    [[self.expensesBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self routerEventWithName:BOOK_CLICK_NAVIGATION data:@(0)];
    }];
    [[self.incomeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self routerEventWithName:BOOK_CLICK_NAVIGATION data:@(1)];
    }];
    [self.cancelBtn setTitleColor:kColor_Text_Black forState:UIControlStateNormal];
    [self.cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:AdjustFont(14)]];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [self addSubview:self.expensesBtn];
    [self.expensesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(44);
        make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@60);
            make.left.equalTo(self.mas_centerX).offset(-60);
        }];
    
    [self addSubview:self.incomeBtn];
    [self.incomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(44);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@60);
            make.left.equalTo(self.mas_centerX);
        }];
        
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(44);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(@60);
    }];
    [self line];
    
    
    NSLog(@"Record Navigation View Init");
}

- (void)setIndex:(NSInteger)index {
    [self setIndex:index animation:YES];
}

- (void)setIndex:(NSInteger)index animation:(BOOL)animation {
    _index = index;
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@2);
        if (index == 0) {
            make.centerX.equalTo(self.expensesBtn.mas_centerX);
            make.width.equalTo(self.expensesBtn.titleLabel.mas_width);
        } else if (index == 1) {
            make.centerX.equalTo(self.incomeBtn.mas_centerX);
            make.width.equalTo(self.incomeBtn.titleLabel.mas_width);
        }
    }];
    
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    } else {
        [self layoutIfNeeded];
    }
}


#pragma mark - get

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kColor_Text_Black;
        [self addSubview:_line];
        
        // 默认布局，初始指向支出按钮
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom); // 底部距离父视图 2 点
            make.height.equalTo(@2);                        // 高度固定为 2 点
            make.width.equalTo(self.expensesBtn.titleLabel.mas_width); // 宽度与按钮文字宽度一致
            make.centerX.equalTo(self.expensesBtn.mas_centerX); // 初始位置位于支出按钮的中心
        }];
    }
    return _line;
}




@end
