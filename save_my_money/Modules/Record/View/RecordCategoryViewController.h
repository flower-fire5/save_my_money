//
//  RecordCategoryViewController.h
//  save_my_money
//
//  Created by hwy on 2025/1/4.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#pragma mark - typedef
typedef void (^RecordCategoryControllerBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface RecordCategoryViewController : BaseViewController

@property (nonatomic, assign) BOOL is_income;                 // 是否是收入
@property (nonatomic, copy  ) RecordCategoryControllerBlock complete;     // 成功


@end

NS_ASSUME_NONNULL_END
