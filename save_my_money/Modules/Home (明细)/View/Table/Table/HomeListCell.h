/**
 * 列表cell
 * @author 郑业强 2018-12-17 创建文件
 */

#import <UIKit/UIKit.h>
#import "RecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeListCell : UITableViewCell

//@property (nonatomic, strong) BKModel *model;
@property (nonatomic, strong) NSMutableArray<RecordMonthModel *> *models;

- (void)endRefresh;

@end

NS_ASSUME_NONNULL_END
