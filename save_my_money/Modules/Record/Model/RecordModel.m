/**
 * 记账model
 * @author 郑业强 2018-12-31 创建文件
 */

#import "RecordModel.h"
#import "commonValue.h"

#define RecordModelId @"RecordModelId"

@implementation RecordModel

+ (void)load {
    [RecordModel mj_setupIgnoredPropertyNames:^NSArray *{
        return @[@"date"];
    }];
}

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

- (instancetype)copyWithZone:(NSZone *)zone {
    RecordModel *model = [[[self class] allocWithZone:zone] init];
    model.Id = self.Id;
    model.category_id = self.category_id;
    model.price = self.price;
    model.year = self.year;
    model.month = self.month;
    model.day = self.day;
    model.week = self.week;
    model.mark = self.mark;
    model.dateStr = self.dateStr;
    model.date = self.date;
    model.dateNumber = self.dateNumber;
    model.cmodel = [self.cmodel copy];
    return model;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[RecordModel class]]) {
        return false;
    }
    RecordModel *model = object;
    if ([self Id] == [model Id]) {
        return true;
    }
    return false;
}

- (NSString *)dateStr {
    NSString *str = [NSString stringWithFormat:@"%ld-%02ld-%02ld", _year, _month, _day];
    NSDate *date = [NSDate dateWithYMD:str];
    return [NSString stringWithFormat:@"%ld年%02ld月%02ld日   %@", _year, _month, _day, [date dayFromWeekday]];
}

- (NSDate *)date {
    return [NSDate dateWithYMD:[NSString stringWithFormat:@"%ld-%02ld-%02ld", _year, _month, _day]];
}

- (NSInteger)dateNumber {
    return [[NSString stringWithFormat:@"%ld%02ld%02ld", _year, _month, _day] integerValue];
}

- (NSInteger)week {
    return [self.date weekOfYear];
}

// 获取Id
//+ (NSNumber *)getId {
//    NSNumber *Id = [NSUserDefaults objectForKey:RecordModelId];
//    if (!Id) {
//        Id = @(0);
//    }
//    Id = @([Id integerValue] + 1);
//    [NSUserDefaults setObject:Id forKey:RecordModelId];
//    return Id;
//}


@end



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

//+ (NSMutableArray<RecordMonthModel *> *)statisticalMonthWithYear:(NSInteger)year month:(NSInteger)month {
//    // 根据时间过滤
//    NSMutableArray<RecordModel *> *bookArr = [NSUserDefaults objectForKey:PIN_BOOK];
//    NSString *preStr = [NSString stringWithFormat:@"year == %ld AND month == %ld", year, month];
////    NSPredicate *pre = [NSPredicate predicateWithFormat:preStr];
////    NSMutableArray<RecordModel *> *models = [NSMutableArray arrayWithArray:[bookArr filteredArrayUsingPredicate:pre]];
//    NSMutableArray<RecordModel *> *models = [NSMutableArray kk_filteredArrayUsingPredicate:preStr array:bookArr];
//    
//    // 统计数据
//    NSMutableDictionary *dictm = [NSMutableDictionary dictionary];
//    for (RecordModel *model in models) {
//        NSString *key = [NSString stringWithFormat:@"%ld-%02ld-%02ld", model.year, model.month, model.day];
//        // 初始化
//        if (![[dictm allKeys] containsObject:key]) {
//            RecordMonthModel *submodel = [[RecordMonthModel alloc] init];
//            submodel.list = [NSMutableArray array];
//            submodel.income = 0;
//            submodel.pay = 0;
//            submodel.date = [NSDate dateWithYMD:key];
//            [dictm setObject:submodel forKey:key];
//        }
//        // 添加数据
//        RecordMonthModel *submodel = dictm[key];
//        [submodel.list addObject:model];
//        // 收入
//        if (model.cmodel.is_income == true) {
//            [submodel setIncome:submodel.income + model.price];
//        }
//        // 支出
//        else {
//            [submodel setPay:submodel.pay + model.price];
//        }
//        [dictm setObject:submodel forKey:key];
//    }
//    
//    // 排序
//    NSMutableArray<RecordMonthModel *> *arrm = [NSMutableArray arrayWithArray:[dictm allValues]];
//    arrm = [NSMutableArray arrayWithArray:[arrm sortedArrayUsingComparator:^NSComparisonResult(RecordMonthModel *obj1, RecordMonthModel *obj2) {
//        return [obj1.dateStr compare:obj2.dateStr];
//    }]];
//    return arrm;
//}

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
//+ (RecordChartModel *)statisticalChart:(NSInteger)status isIncome:(BOOL)isIncome cmodel:(RecordModel *)cmodel date:(NSDate *)date {
//    NSMutableString *preStr = [NSMutableString string];
//    NSMutableArray *arrm = [NSUserDefaults objectForKey:PIN_BOOK];
//    [preStr appendFormat:@"cmodel.is_income == %d", isIncome];
//    if (cmodel) {
//        [preStr appendFormat:@" AND cmodel.Id == %ld", cmodel.cmodel.Id];
//    }
//
//    // 周
//    if (status == 0) {
//        NSDate *start = [date offsetDays:-[date weekday] + 1];
//        NSDate *end = [date offsetDays:7 - [date weekday]];
//        NSDateFormatter *fora = [[NSDateFormatter alloc] init];
//        [fora setDateFormat:@"yyyyMMdd"];
//        [fora setTimeZone:[NSTimeZone localTimeZone]];
//        NSInteger startStr = [[fora stringFromDate:start] integerValue];
//        NSInteger endStr = [[fora stringFromDate:end] integerValue];
//        
//        [preStr appendFormat:@" AND dateNumber >= %ld AND dateNumber <= %ld", startStr, endStr];
//    }
//    // 月
//    else if (status == 1) {
//        [preStr appendFormat:@" AND year == %ld AND month == %ld", date.year, date.month];
//    }
//    // 年
//    else if (status == 2) {
//        [preStr appendFormat:@" AND year == %ld", date.year];
//    }
//    NSMutableArray<RecordModel *> *models = [NSMutableArray kk_filteredArrayUsingPredicate:preStr array:arrm];
//    
//    
//    NSMutableArray<RecordModel *> *chartArr = [NSMutableArray array];
//    NSMutableArray<NSMutableArray<RecordModel *> *> *chartHudArr = [NSMutableArray array];
//    // 周
//    if (status == 0) {
//        NSDate *first = [date offsetDays:-[date weekday] + 1];
//        for (int i=0; i<7; i++) {
//            NSDate *date = [first offsetDays:i];
//            RecordModel *model = [[RecordModel alloc] init];
//            model.year = date.year;
//            model.month = date.month;
//            model.day = date.day;
//            model.price = 0;
//            [chartArr addObject:model];
//            [chartHudArr addObject:[NSMutableArray array]];
//        }
//        
//        for (RecordModel *model in models) {
//            NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:[@(chartArr[7 - [model.date weekday]].price) description]];
//            NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:[@(model.price) description]];
//            number1 = [number1 decimalNumberByAdding:number2];
//            chartArr[7 - [model.date weekday]].price += [number1 doubleValue];
//            [chartHudArr[[model.date weekday] - 1] addObject:model];
//        }
//    }
//    // 月
//    else if (status == 1) {
//        for (int i=1; i<=[date daysInMonth]; i++) {
//            RecordModel *model = [[RecordModel alloc] init];
//            model.year = date.year;
//            model.month = [date daysInMonth];
//            model.day = i;
//            model.price = 0;
//            [chartArr addObject:model];
//            [chartHudArr addObject:[NSMutableArray array]];
//        }
//        for (RecordModel *model in models) {
//            chartArr[model.day-1].price += model.price;
//            [chartHudArr[model.day-1] addObject:model];
//        }
//    }
//    // 年
//    else if (status == 2) {
//        for (int i=1; i<=12; i++) {
//            RecordModel *model = [[RecordModel alloc] init];
//            model.year = date.year;
//            model.month = i;
//            model.day = 1;
//            model.price = 0;
//            [chartArr addObject:model];
//            [chartHudArr addObject:[NSMutableArray array]];
//        }
//        for (RecordModel *model in models) {
//            chartArr[model.month-1].price += model.price;
//            [chartHudArr[model.month-1] addObject:model];
//        }
//    }
//    
//    // 排序
//    for (NSMutableArray *arrm in chartHudArr) {
//        [arrm sortUsingComparator:^NSComparisonResult(RecordModel *obj1, RecordModel *obj2) {
//            return obj1.price < obj2.price;
//        }];
//    }
//    
//    
//    NSMutableArray<RecordModel *> *groupArr = [NSMutableArray array];
//    if (!cmodel) {
//        for (RecordModel *model in models) {
//            NSInteger index = -1;
//            for (NSInteger i=0; i<groupArr.count; i++) {
//                RecordModel *submodel = groupArr[i];
//                if (submodel.category_id == model.category_id) {
//                    index = i;
//                }
//            }
//            if (index == -1) {
//                RecordModel *submodel = [model copy];
//                [groupArr addObject:submodel];
//            }
//            else {
//                NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:[@(groupArr[index].price) description]];
//                NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:[@(model.price) description]];
//                number1 = [number1 decimalNumberByAdding:number2];
//                groupArr[index].price = [number1 doubleValue];
//                
////                groupArr[index].price += model.price;
//            }
//        }
//    } else {
//        for (RecordModel *model in models) {
//            RecordModel *submodel = [model copy];
//            [groupArr addObject:submodel];
//        }
//    }
//    
//    
//    [groupArr sortUsingComparator:^NSComparisonResult(RecordModel *obj1, RecordModel *obj2) {
//        return obj1.price < obj2.price;
//    }];
//    
//    
//    RecordChartModel *model = [[RecordChartModel alloc] init];
//    model.groupArr = groupArr;
//    model.chartArr = chartArr;
//    model.chartHudArr = chartHudArr;
//    model.sum = [[chartArr valueForKeyPath:@"@sum.price.floatValue"] floatValue];
//    model.max = [[chartArr valueForKeyPath:@"@max.price.floatValue"] floatValue];
//    model.avg = [[NSString stringWithFormat:@"%.2f", model.sum / chartArr.count] floatValue];
//    model.is_income = isIncome;
//    return model;
//}

@end

