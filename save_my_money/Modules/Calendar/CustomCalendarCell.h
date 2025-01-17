//
//  CustomCalendarCell.h
//  save_my_money
//
//  Created by hwy on 2025/1/14.
//

#import <FSCalendar/FSCalendar.h>

@interface CustomCalendarCell : FSCalendarCell

@property (nonatomic, strong) UIView *containerView;   // 外框容器视图
@property (nonatomic, strong) UILabel *incomeLabel; // 收入标签
@property (nonatomic, strong) UILabel *expenseLabel; // 支出标签

@end
