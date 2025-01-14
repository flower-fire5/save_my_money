/**
 * 记账model
 * @author 郑业强 2018-12-31 创建文件
 */

#import "RecordModel.h"
#import "commonValue.h"

#define RecordModelId @"RecordModelId"

@implementation RecordModel

//+ (void)load {
//    [RecordModel mj_setupIgnoredPropertyNames:^NSArray *{
//        return @[@"date"];
//    }];
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super init];
//    if (!self) {
//        return nil;
//    }
//    self = [NSObject decodeClass:self decoder:aDecoder];
//    return self;
//}

//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [NSObject encodeClass:self encoder:aCoder];
//}
//
//- (instancetype)copyWithZone:(NSZone *)zone {
//    RecordModel *model = [[[self class] allocWithZone:zone] init];
//    model.category_id = self.category_id;
//    model.price = self.price;
//    model.year = self.year;
//    model.month = self.month;
//    model.day = self.day;
//    model.mark = self.mark;
//    model.date = self.date;
//    return model;
//}

+ (NSString *)primaryKey {
    return @"Id"; // 使用 `Id` 作为主键
}

//- (BOOL)isEqual:(id)object {
//    if (![object isKindOfClass:[RecordModel class]]) {
//        return false;
//    }
//    RecordModel *model = object;
//    if ([self Id] == [model Id]) {
//        return true;
//    }
//    return false;
//}
//
//- (NSString *)dateStr {
//    NSString *str = [NSString stringWithFormat:@"%ld-%02ld-%02ld", _year, _month, _day];
//    NSDate *date = [NSDate dateWithYMD:str];
//    return [NSString stringWithFormat:@"%ld年%02ld月%02ld日   %@", _year, _month, _day, [date dayFromWeekday]];
//}
//
- (NSDate *)date {
    return [NSDate dateWithYMD:[NSString stringWithFormat:@"%ld-%02ld-%02ld", _year, _month, _day]];
}
//
//- (NSInteger)dateNumber {
//    return [[NSString stringWithFormat:@"%ld%02ld%02ld", _year, _month, _day] integerValue];
//}
//
//- (NSInteger)week {
//    return [self.date weekOfYear];
//}

// 获取Id
+ (NSNumber *)getId {
    NSNumber *Id = [NSUserDefaults objectForKey:RecordModelId];
    if (!Id) {
        Id = @(0);
    }
    Id = @([Id integerValue] + 1);
    [NSUserDefaults setObject:Id forKey:RecordModelId];
    return Id;
}


@end

// 提供便捷操作的宏
RLM_ARRAY_TYPE(RecordModel)

@implementation RecordMonthModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self = [NSObject decodeClass:self decoder:aDecoder];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [NSObject encodeClass:self encoder:aCoder];
}

- (NSString *)dateStr {
    return [NSString stringWithFormat:@"%02ld月%02ld日   %@", [_date month], [_date day], [_date dayFromWeekday]];
}

- (NSString *)moneyStr {
    NSMutableString *strm = [NSMutableString string];
    if (_income != 0) {
        [strm appendFormat:@"收入: %@", [@(_income) description]];
    }
    if (_income != 0 && _pay != 0) {
        [strm appendString:@"    "];
    }
    if (_pay != 0) {
        [strm appendFormat:@"支出: %@", [@(_pay) description]];
    }
    return strm;
}

+ (NSMutableArray<RecordMonthModel *> *)statisticalMonthWithYear:(NSInteger)year month:(NSInteger)month {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // 获取符合条件的 RecordModel 数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %ld AND month == %ld", year, month];
    RLMResults<RecordModel *> *models = [RecordModel objectsInRealm:realm withPredicate:predicate];
    
    // 用于按日期分组的字典
    NSMutableDictionary<NSString *, RecordMonthModel *> *dictm = [NSMutableDictionary dictionary];
    
    // 遍历数据并统计
    for (RecordModel *model in models) {
        NSString *key = [NSString stringWithFormat:@"%ld-%02ld-%02ld", model.year, model.month, model.day];
        
        // 如果字典中没有当天的统计模型，初始化
        if (!dictm[key]) {
            RecordMonthModel *submodel = [[RecordMonthModel alloc] init];
            submodel.date = [NSDate dateWithYMD:key];
            submodel.list = [NSMutableArray array];
            submodel.income = 0;
            submodel.pay = 0;
            [dictm setObject:submodel forKey:key];
        }
        
        // 获取当天的统计模型
        RecordMonthModel *submodel = dictm[key];
        [submodel.list addObject:model];
        
        // 累加收入或支出
        if (model.is_income) {
            submodel.income += model.price;
        } else {
            submodel.pay += model.price;
        }
    }
    
    // 将统计结果转换为数组，并按日期排序
    NSMutableArray<RecordMonthModel *> *arrm = [NSMutableArray arrayWithArray:[dictm allValues]];
    [arrm sortUsingComparator:^NSComparisonResult(RecordMonthModel *obj1, RecordMonthModel *obj2) {
        return [obj1.date compare:obj2.date];
    }];
    
    return arrm;
}
@end




@implementation RecordChartModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self = [NSObject decodeClass:self decoder:aDecoder];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [NSObject encodeClass:self encoder:aCoder];
}

// 统计数据(图表首页)
+ (RecordChartModel *)statisticalChart:(NSInteger)status isIncome:(BOOL)isIncome cmodel:(RecordModel *)cmodel date:(NSDate *)date {
    RLMRealm *realm = [RLMRealm defaultRealm];
    NSMutableString *predicateFormat = [NSMutableString stringWithFormat:@"is_income == %d", isIncome];
    
    // 添加分类筛选
    if (cmodel) {
        [predicateFormat appendFormat:@" AND category_id == %ld", cmodel.category_id];
    }
    
    // 根据时间范围筛选
    NSPredicate *predicate = nil;
    if (status == 0) { // 周
        NSDate *start = [date offsetDays:-[date weekday] + 1];
        NSDate *end = [date offsetDays:7 - [date weekday]];
        
        predicate = [NSPredicate predicateWithFormat:@"is_income == %d AND ((year == %ld AND month == %ld AND day >= %ld) AND (year == %ld AND month == %ld AND day <= %ld))",
                     isIncome,
                     start.year, start.month, start.day,
                     end.year, end.month, end.day];
    } else if (status == 1) { // 月
        predicate = [NSPredicate predicateWithFormat:@"is_income == %d AND year == %ld AND month == %ld",
                     isIncome,
                     date.year,
                     date.month];
    } else if (status == 2) { // 年
        predicate = [NSPredicate predicateWithFormat:@"is_income == %d AND year == %ld",
                     isIncome,
                     date.year];
    }
    
    RLMResults<RecordModel *> *models = [RecordModel objectsInRealm:realm withPredicate:predicate];
    
    // 初始化图表数据
    NSMutableArray<RecordModel *> *chartArr = [NSMutableArray array];
    NSMutableArray<NSMutableArray<RecordModel *> *> *chartHudArr = [NSMutableArray array];
    
    // 构建不同时间范围的空数据
    if (status == 0) { // 周
        NSDate *startOfWeek = [date offsetDays:-[date weekday] + 1];
        for (int i = 0; i < 7; i++) {
            NSDate *currentDate = [startOfWeek offsetDays:i];
            RecordModel *emptyModel = [[RecordModel alloc] init];
            emptyModel.year = currentDate.year;
            emptyModel.month = currentDate.month;
            emptyModel.day = currentDate.day;
            emptyModel.price = 0;
            [chartArr addObject:emptyModel];
            [chartHudArr addObject:[NSMutableArray array]];
        }
        
        for (RecordModel *model in models) {
            NSInteger dayIndex = model.day - startOfWeek.day;
            if (dayIndex >= 0 && dayIndex < 7) {
                chartArr[dayIndex].price += model.price;
                [chartHudArr[dayIndex] addObject:model];
            }
        }
    } else if (status == 1) { // 月
        NSInteger daysInMonth = [date daysInMonth];
        for (int i = 1; i <= daysInMonth; i++) {
            RecordModel *emptyModel = [[RecordModel alloc] init];
            emptyModel.year = date.year;
            emptyModel.month = date.month;
            emptyModel.day = i;
            emptyModel.price = 0;
            [chartArr addObject:emptyModel];
            [chartHudArr addObject:[NSMutableArray array]];
        }
        
        for (RecordModel *model in models) {
            NSInteger dayIndex = model.day - 1;
            chartArr[dayIndex].price += model.price;
            [chartHudArr[dayIndex] addObject:model];
        }
    } else if (status == 2) { // 年
        for (int i = 1; i <= 12; i++) {
            RecordModel *emptyModel = [[RecordModel alloc] init];
            emptyModel.year = date.year;
            emptyModel.month = i;
            emptyModel.day = 1;
            emptyModel.price = 0;
            [chartArr addObject:emptyModel];
            [chartHudArr addObject:[NSMutableArray array]];
        }
        
        for (RecordModel *model in models) {
            NSInteger monthIndex = model.month - 1;
            chartArr[monthIndex].price += model.price;
            [chartHudArr[monthIndex] addObject:model];
        }
    }
    
    // 统计按分类分组的数据
    NSMutableArray<RecordModel *> *groupArr = [NSMutableArray array];
    if (!cmodel) {
        for (RecordModel *model in models) {
            NSInteger index = -1;
            for (NSInteger i = 0; i < groupArr.count; i++) {
                RecordModel *groupModel = groupArr[i];
                if (groupModel.category_id == model.category_id) {
                    index = i;
                }
            }
            if (index == -1) {
                RecordModel *submodel = [[RecordModel alloc] init];
                submodel.price = model.price;
                submodel.is_income = model.is_income;
                submodel.name = model.name;
                submodel.category_id = model.category_id;
                submodel.year = model.year;
                submodel.month = model.month;
                submodel.day = model.day;
                submodel.icon_l = model.icon_l;
                submodel.icon_n = model.icon_n;
                submodel.icon_s = model.icon_s;
                [groupArr addObject:submodel];
            } else {
                groupArr[index].price += model.price;
            }
        }
    } else {
        for (RecordModel *model in models) {
            RecordModel *submodel = [[RecordModel alloc] init];
            submodel.price = model.price;
            submodel.is_income = model.is_income;
            submodel.name = model.name;
            submodel.category_id = model.category_id;
            submodel.year = model.year;
            submodel.month = model.month;
            submodel.day = model.day;
            submodel.icon_l = model.icon_l;
            submodel.icon_n = model.icon_n;
            submodel.icon_s = model.icon_s;
            [groupArr addObject:submodel];
        }
    }
    
    [groupArr sortUsingComparator:^NSComparisonResult(RecordModel *obj1, RecordModel *obj2) {
        return obj2.price > obj1.price;
    }];
    
    // 计算总额和最大值
    float sum = [[chartArr valueForKeyPath:@"@sum.price"] floatValue];
    float max = [[chartArr valueForKeyPath:@"@max.price"] floatValue];
    float avg = chartArr.count > 0 ? sum / chartArr.count : 0;
    
    // 构建最终的统计模型
    RecordChartModel *chartModel = [[RecordChartModel alloc] init];
    chartModel.groupArr = groupArr;
    chartModel.chartArr = chartArr;
    chartModel.chartHudArr = chartHudArr;
    chartModel.sum = sum;
    chartModel.max = max;
    chartModel.avg = avg;
    chartModel.is_income = isIncome;
    
    return chartModel;
}
@end

