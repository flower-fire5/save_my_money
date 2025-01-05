//
//  RecordKeyBoardView.h
//  save_my_money
//
//  Created by hwy on 2025/1/4.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark - typedef
typedef void (^BookComplete)(NSString *price, NSString *mark, NSDate *date);

#pragma mark - 声明
@interface RecordKeyBoardView : UIView

@property (nonatomic, strong, readonly) NSMutableString *money;
@property (nonatomic, copy  ) BookComplete complete;
@property (nonatomic, strong) RecordModel *model;

+ (instancetype)init;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
