/**
 * 导航栏
 * @author 郑业强 2018-12-17 创建文件
 */

#import "BaseView.h"
#import "RecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChartNavigation : BaseView

@property (nonatomic, assign) NSInteger navigationIndex;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) RecordModel *cmodel;

@end

NS_ASSUME_NONNULL_END
