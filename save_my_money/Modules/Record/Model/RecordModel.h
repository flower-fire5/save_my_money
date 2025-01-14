/**
 * 记账model
 * @author 郑业强 2018-12-31 创建文件
 */

#import "BKCIncomeModel.h"
#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN


@interface RecordModel : RLMObject

@property NSInteger Id;
@property double price;
@property NSInteger year;
@property NSInteger month;
@property NSInteger day;
@property NSString *mark;
@property NSInteger category_id;
@property (nonatomic, strong) NSDate *date;         // 日期
@property (nonatomic, assign) BOOL is_income;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon_n;
@property (nonatomic, strong) NSString *icon_l;
@property (nonatomic, strong) NSString *icon_s;



// 使用主键
+ (NSString *)primaryKey;

// 获取Id
+ (NSNumber *)getId;

@end


// 数据统计(首页)
@interface RecordMonthModel : NSObject<NSCoding>

@property (nonatomic, strong) NSDate *date;         // 日期
@property (nonatomic, copy  ) NSString *dateStr;    // 日期(例: 01月03日 星期五)
@property (nonatomic, copy  ) NSString *moneyStr;   // 支出收入(例: 收入: 23  支出: 165)
@property (nonatomic, assign) CGFloat income;       // 收入
@property (nonatomic, assign) CGFloat pay;          // 支出
@property (nonatomic, strong) NSMutableArray<RecordModel *> *list;  // 数据

// 统计数据
+ (NSMutableArray<RecordMonthModel *> *)statisticalMonthWithYear:(NSInteger)year month:(NSInteger)month;

@end


// 数据统计(图表)
@interface RecordChartModel : NSObject<NSCoding>

@property (nonatomic, assign) CGFloat sum;                          // 总值
@property (nonatomic, assign) CGFloat max;                          // 最大值
@property (nonatomic, assign) CGFloat avg;                          // 平均值
@property (nonatomic, assign) BOOL is_income;                       // 是否是收入
@property (nonatomic, strong) NSMutableArray<RecordModel *> *groupArr;  // 排行榜
@property (nonatomic, strong) NSMutableArray<RecordModel *> *chartArr;  // 图表
@property (nonatomic, strong) NSMutableArray<NSMutableArray<RecordModel *> *> *chartHudArr;  // 图表

// 统计数据(图表首页)
+ (RecordChartModel *)statisticalChart:(NSInteger)status isIncome:(BOOL)isIncome cmodel:(RecordModel *)cmodel date:(NSDate *)date;

@end


NS_ASSUME_NONNULL_END
