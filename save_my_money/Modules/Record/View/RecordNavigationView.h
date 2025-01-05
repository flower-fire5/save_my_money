//
//  RecordNavigationView.h
//  save_my_money
//
//  Created by hwy on 2025/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordNavigationView : UIView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat offsetX;

- (void)initUI;
- (void)setIndex:(NSInteger)index;
- (void)setIndex:(NSInteger)index animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
