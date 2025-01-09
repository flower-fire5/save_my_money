//
//  RecordCategoryCollectionViewCell.h
//  save_my_money
//
//  Created by hwy on 2025/1/4.
//

#import <UIKit/UIKit.h>
#import "BKCIncomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordCategoryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, nullable) BKCModel *model;
@property (nonatomic, assign, getter=isChoose) BOOL choose;

- (void)initUI;

@end

NS_ASSUME_NONNULL_END
