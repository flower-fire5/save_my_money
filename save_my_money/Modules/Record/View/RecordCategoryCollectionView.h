//
//  RecordCategoryCollectionView.h
//  save_my_money
//
//  Created by hwy on 2025/1/4.
//

#import <UIKit/UIKit.h>
#import "BKCIncomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordCategoryCollectionView : UICollectionView

@property (nonatomic, strong) BKCIncomeModel *model;
@property (nonatomic, strong) NSIndexPath *selectIndex;


// 初始化
+ (instancetype)initWithFrame:(CGRect)frame;
// 刷新当前选中
- (void)reloadSelectIndex;
// 滚动scroll
- (void)scrollToIndex:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
