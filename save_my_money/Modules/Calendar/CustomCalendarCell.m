
#import "CustomCalendarCell.h"
#import <Masonry/Masonry.h>

@implementation CustomCalendarCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 创建容器视图
        self.containerView = [[UIView alloc] init];
        self.containerView.layer.borderWidth = 1.0;
        self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.containerView.layer.cornerRadius = 8.0;
        self.containerView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.containerView];
        
        // 日期标题标签（默认的日期）
        [self.containerView addSubview:self.titleLabel];
        self.shapeLayer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7);
        // 收入标签
         self.incomeLabel = [[UILabel alloc] init];
         self.incomeLabel.font = [UIFont systemFontOfSize:10];
         self.incomeLabel.textColor = [UIColor redColor];
         self.incomeLabel.textAlignment = NSTextAlignmentCenter;
         [self.containerView addSubview:self.incomeLabel];
         
         // 支出标签
         self.expenseLabel = [[UILabel alloc] init];
         self.expenseLabel.font = [UIFont systemFontOfSize:10];
        self.expenseLabel.textColor = [UIColor blueColor];
         self.expenseLabel.textAlignment = NSTextAlignmentCenter;
         [self.containerView addSubview:self.expenseLabel];
         
        
        // 使用 Masonry 布局
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView).inset(2); // 整体内缩一点，留出间距
            make.left.equalTo(self.contentView).offset(2);
            make.right.equalTo(self.contentView).inset(2);
            make.top.equalTo(self.contentView).inset(2);
            make.bottom.equalTo(self.contentView).offset(6);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView).offset(5);
            make.centerX.equalTo(self.containerView);
        }];
        
        // 使用 Masonry 布局
        [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10); // 与日期的距离为 8
            make.left.right.equalTo(self.containerView);
        }];
        
        [self.expenseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.incomeLabel.mas_bottom).offset(1); // 收入和支出之间的距离为 4
            make.left.right.equalTo(self.containerView);
        }];
    }
    return self;
}

@end
