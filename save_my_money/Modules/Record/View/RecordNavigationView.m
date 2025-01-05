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

@property (weak, nonatomic) UIButton *expensesBtn;
@property (weak, nonatomic) UIButton *incomeBtn;
@property (nonatomic, strong) UIView *line;
@property (weak, nonatomic) UIButton *cancelBtn;

@end

@implementation RecordNavigationView

- (void)initUI {
    [self setBackgroundColor:kColor_Main_Color];
    [self.expensesBtn.titleLabel setFont:BTN_FONT];
    [self.expensesBtn setTitleColor:kColor_Text_Black forState:UIControlStateNormal];
    [self.incomeBtn.titleLabel setFont:BTN_FONT];
    [self.incomeBtn setTitleColor:kColor_Text_Black forState:UIControlStateNormal];
    [self line];
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
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [self.expensesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(44);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@"60");
            make.left.equalTo(self.mas_centerX).offset(-60);
        }];
    [self addSubview:self.expensesBtn];
    
    [self.incomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(44);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@"60");
            make.left.equalTo(self.mas_centerX).offset(60);
        }];
    [self addSubview:self.incomeBtn];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(44);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(@"60");
    }];
    [self addSubview:self.cancelBtn];
    
    
}

- (void)setIndex:(NSInteger)index {
    [self setIndex:index animation:NO];
}

- (void)setIndex:(NSInteger)index animation:(BOOL)animation {
    _index = index;
    NSTimeInterval time = animation == true ? 0.3f : 0;
    @weakify(self)
    [UIView animateWithDuration:time animations:^{
        @strongify(self)
        if (index == 0) {
            self.line.centerX = self.expensesBtn.left + self.expensesBtn.width / 2;
        } else if (index == 1) {
            self.line.centerX = self.incomeBtn.left + self.incomeBtn.width / 2;
        }
    }];
}


#pragma mark - get
- (UIView *)line {
    if (!_line) {
        CGFloat width = [@"收入" sizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:BTN_FONT].width;
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottom - 2, width, 2)];
        _line.backgroundColor = kColor_Text_Black;
        _line.left = (SCREEN_WIDTH - countcoordinatesX(60) * 2) / 2 + (countcoordinatesX(60) - [@"收入" sizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:BTN_FONT].width) / 2;
        [self addSubview:_line];
    }
    return _line;
}




@end
