#import "CalendarViewController.h"
#import <FSCalendar/FSCalendar.h>
#import <Realm/Realm.h>
#import <Masonry/Masonry.h>
#import "CustomCalendarCell.h"
#import "RecordModel.h"
#import "HomeNavigation.h"
#import "RECORD_EVENT.h"

@interface CalendarViewController () <FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance>

@property (nonatomic, strong) FSCalendar *calendar;
@property (nonatomic, strong) RLMResults<RecordModel *> *records;
@property (nonatomic, strong) HomeNavigation *navigation;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:158/255.0 blue:115/255.0 alpha:1];
    [self setJz_navigationBarHidden:true];

    // 初始化日历
    self.calendar = [[FSCalendar alloc] init];
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    self.calendar.backgroundColor = [UIColor whiteColor];
    self.calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    self.calendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
    self.calendar.appearance.borderRadius = 0.5;
    self.calendar.layer.cornerRadius = 10;
    self.calendar.layer.masksToBounds = YES; // 确保内容裁剪到圆角内
    
    // 注册自定义单元格
    [self.calendar registerClass:[CustomCalendarCell class] forCellReuseIdentifier:@"CustomCalendarCell"];
    [self.view addSubview:self.calendar];
    
    // Masonry 布局
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@400);
    }];
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:RECORD_NEW_ITEM object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self handleNewRecordNotification];
    }];
    // 加载数据
    [self loadRecordData];
}


- (void)handleNewRecordNotification {
    // 重新加载数据
    [self loadRecordData];

    // 刷新日历视图
    [self.calendar reloadData];
}

#pragma mark - 加载数据

- (void)loadRecordData {
    RLMRealm *realm = [RLMRealm defaultRealm];
    self.records = [RecordModel allObjectsInRealm:realm];
}

#pragma mark - FSCalendar 数据源

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    // 不显示事件点
    return 0;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position {
    CustomCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"CustomCalendarCell" forDate:date atMonthPosition:position];
    
    // 获取指定日期的收入和支出
    double income = 0.0, expense = 0.0;
    for (RecordModel *record in self.records) {
        if ([[self dateWithoutTime:record.date] isEqualToDate:[self dateWithoutTime:date]]) {
            if (record.is_income) {
                income += record.price;
            } else {
                expense += record.price;
            }
        }
    }
    
    // 设置收入和支出标签
    cell.incomeLabel.text = income > 0 ? [NSString stringWithFormat:@"+%.2f", income] : @"";
    cell.expenseLabel.text = expense > 0 ? [NSString stringWithFormat:@"-%.2f", expense] : @"";
    
    return cell;
}

#pragma mark - Helper Methods

- (NSDate *)dateWithoutTime:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [calendar dateFromComponents:components];
}


@end
