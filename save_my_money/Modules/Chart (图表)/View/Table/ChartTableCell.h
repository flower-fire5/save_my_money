/**
 * 图表
 * @author 郑业强 2018-12-18 创建文件
 */

#import <UIKit/UIKit.h>
#import "RecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChartTableCell : UITableViewCell

@property (nonatomic, assign) CGFloat maxPrice;
@property (nonatomic, strong) RecordModel *model;
//@property (nonatomic, strong) BookGroupModel *model;

@end

NS_ASSUME_NONNULL_END
