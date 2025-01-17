/**
 * 图表
 * @author 郑业强 2018-12-16 创建文件
 */

#import "ChartController.h"
#import "ChartNavigation.h"
#import "ChartSegmentControl.h"
#import "ChartDate.h"
#import "ChartTableView.h"
#import "ChartHUD.h"
#import "ChartTableCell.h"
#import "CHART_EVENT.h"
#import "RECORD_EVENT.h"
//#import "BDController.h"


#pragma mark - 声明
@interface ChartController()

@property (nonatomic, strong) ChartNavigation *navigation;
@property (nonatomic, strong) ChartSegmentControl *seg;
@property (nonatomic, strong) ChartDate *subdate;
@property (nonatomic, strong) ChartHUD *chud;
@property (nonatomic, strong) ChartTableView *table;

@property (nonatomic, assign) NSInteger navigationIndex;
@property (nonatomic, assign) NSInteger segmentIndex;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) RecordChartModel *model;
@property (nonatomic, strong) RecordModel *minModel;
@property (nonatomic, strong) RecordModel *maxModel;

@property (nonatomic, strong) NSDictionary<NSString *, NSInvocation *> *eventStrategy;

@end


#pragma mark - 实现
@implementation ChartController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setJz_navigationBarHidden:true];
    [self setDate:[NSDate date]];
    [self navigation];
    [self seg];
    [self subdate];
    [self table];
    [self chud];
    [self setNavigationIndex:0];
    
    [self updateDateRange];
    [self monitorNotification];
    [self setModel:[RecordChartModel statisticalChart:self.segmentIndex isIncome:self.navigationIndex cmodel:self.cmodel date:self.date]];
}
// 监听通知
- (void)monitorNotification {
    // 记账
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:RECORD_NEW_ITEM object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self setDate:[NSDate date]];
        [self setModel:[RecordChartModel statisticalChart:self.segmentIndex isIncome:self.navigationIndex cmodel:self.cmodel date:self.date]];
        [self updateDateRange];
    }];
}
// 更新时间范围
- (void)updateDateRange {
    // 获取 Realm 实例
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // 根据收入/支出筛选
    BOOL is_income = _navigationIndex == 1;
    NSMutableString *predicateFormat = [NSMutableString stringWithFormat:@"is_income == %d", is_income];
    
    // 添加分类筛选
    if (_cmodel) {
        [predicateFormat appendFormat:@" AND category_id == %ld", _cmodel.category_id];
    }
    
    // 查询数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat];
    RLMResults<RecordModel *> *results = [RecordModel objectsInRealm:realm withPredicate:predicate];
    
    // 获取最小时间
    _minModel = ({
        NSDate *minDate = [results valueForKeyPath:@"@min.date"];
        RecordModel *minModel = nil;
        if (minDate) {
            NSPredicate *minPredicate = [NSPredicate predicateWithFormat:@"date == %@", minDate];
            RLMResults<RecordModel *> *minResults = [results objectsWithPredicate:minPredicate];
            minModel = minResults.firstObject;
        }
        minModel;
    });
    
    // 获取最大时间
    _maxModel = ({
        NSDate *maxDate = [results valueForKeyPath:@"@max.date"];
        RecordModel *maxModel = nil;
        if (maxDate) {
            NSPredicate *maxPredicate = [NSPredicate predicateWithFormat:@"date == %@", maxDate];
            RLMResults<RecordModel *> *maxResults = [results objectsWithPredicate:maxPredicate];
            maxModel = maxResults.firstObject;
        }
        maxModel;
    });
    
    // 更新子视图的时间范围
    _subdate.minModel = _minModel;
    _subdate.maxModel = _maxModel;
}


#pragma mark - 事件
- (void)routerEventWithName:(NSString *)eventName data:(id)data {
    [self handleEventWithName:eventName data:data];
}
- (void)handleEventWithName:(NSString *)eventName data:(id)data {
    NSInvocation *invocation = self.eventStrategy[eventName];
    [invocation setArgument:&data atIndex:2];
    [invocation invoke];
    [super routerEventWithName:eventName data:data];
}
// 点击Cell
- (void)chartTableClick:(NSIndexPath *)indexPath {
    RecordModel *model = self.model.groupArr[indexPath.row];
    if (!_cmodel) {
        ChartController *vc = [[ChartController alloc] init];
        vc.cmodel = model;
        [self.navigationController pushViewController:vc animated:true];
    } else {
//        BDController *vc = [[BDController alloc] init];
//        vc.model = model;
//        [self.navigationController pushViewController:vc animated:true];
        NSLog(@"需要进入一个页面");
    }
}


#pragma mark - set
- (void)setModel:(RecordChartModel *)model {
    _model = model;
    _table.model = model;
}
- (void)setNavigationIndex:(NSInteger)navigationIndex {
    _navigationIndex = navigationIndex;
    _navigation.navigationIndex = navigationIndex;
    _subdate.navigationIndex = navigationIndex;
    _table.navigationIndex = navigationIndex;
}
- (void)setSegmentIndex:(NSInteger)segmentIndex {
    _segmentIndex = segmentIndex;
    _subdate.segmentIndex = segmentIndex;
    _table.segmentIndex = segmentIndex;
}


#pragma mark - get
- (ChartNavigation *)navigation {
    if (!_navigation) {
        @weakify(self)
        _navigation = [ChartNavigation loadFirstNib:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBarHeight)];
        [_navigation setCmodel:_cmodel];
        [[_navigation.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl *button) {
            @strongify(self)
            [self.chud show];
        }];
        [self.view addSubview:_navigation];
    }
    return _navigation;
}
- (ChartSegmentControl *)seg {
    if (!_seg) {
        @weakify(self)
        _seg = [ChartSegmentControl loadFirstNib:CGRectMake(0, NavigationBarHeight, SCREEN_WIDTH, countcoordinatesX(50))];
        [[_seg.seg rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *seg) {
            @strongify(self)
            [self setDate:({
                NSInteger index = seg.selectedSegmentIndex;
                NSIndexPath *indexPath = self.subdate.selectIndexs[index];
                ChartSubModel *model = self.subdate.sModels[index][indexPath.row];
                NSInteger month = model.month == -1 ? 1 : model.month;
                NSInteger day = model.day == -1 ? 1 : model.day;
                NSDate *date = [NSDate dateWithYMD:[NSString stringWithFormat:@"%ld-%02ld-%02ld", model.year, month, day]];
                date;
            })];
            [self setSegmentIndex:seg.selectedSegmentIndex];
            [self setModel:[RecordChartModel statisticalChart:self.segmentIndex isIncome:self.navigationIndex cmodel:self.cmodel date:self.date]];
        }];
        [self.view addSubview:_seg];
    }
    return _seg;
}
- (ChartDate *)subdate {
    if (!_subdate) {
        @weakify(self)
        _subdate = [ChartDate loadCode:CGRectMake(0, _seg.bottom, SCREEN_WIDTH, countcoordinatesX(45))];
        [_subdate setComplete:^(ChartSubModel *model) {
            @strongify(self)
            NSInteger month = model.month == -1 ? 1 : model.month;
            NSInteger day = model.day == -1 ? 1 : model.day;
            NSString *str = [NSString stringWithFormat:@"%ld-%02ld-%02ld", model.year, month, day];
            [self setDate:[NSDate dateWithYMD:str]];
            [self setModel:[RecordChartModel statisticalChart:self.segmentIndex isIncome:self.navigationIndex cmodel:self.cmodel date:self.date]];
        }];
        [self.view addSubview:_subdate];
    }
    return _subdate;
}
- (ChartTableView *)table {
    if (!_table) {
        _table = [ChartTableView initWithFrame:({
            CGFloat top = self.subdate.bottom;
            CGFloat height = SCREEN_HEIGHT - top;
            height -= self.navigationController.viewControllers.count == 1 ? TabbarHeight : 0;
            CGRectMake(0, top, SCREEN_WIDTH, height);
        })];
        _table.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_table];
    }
    return _table;
}
- (ChartHUD *)chud {
    if (!_chud) {
        @weakify(self)
        _chud = [ChartHUD loadCode:CGRectMake(0, _seg.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - _seg.bottom - TabbarHeight)];
        [_chud setComplete:^(NSInteger index) {
            @strongify(self)
            [self setNavigationIndex:index];
            [self updateDateRange];
            [self setModel:[RecordChartModel statisticalChart:self.segmentIndex isIncome:self.navigationIndex cmodel:self.cmodel date:self.date]];
        }];
        [self.view addSubview:_chud];
    }
    return _chud;
}
- (NSDictionary<NSString *, NSInvocation *> *)eventStrategy {
    if (!_eventStrategy) {
        _eventStrategy = @{
                           CHART_TABLE_CLICK: [self createInvocationWithSelector:@selector(chartTableClick:)]
                           };
    }
    return _eventStrategy;
}


@end
