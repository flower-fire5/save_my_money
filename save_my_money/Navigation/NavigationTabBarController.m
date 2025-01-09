//
//  NavigationController.m
//  save_my_money
//
//  Created by hwy on 2025/1/3.
//

#import "NavigationTabBarController.h"
#import "BillDetailViewController.h"
#import "ChartsViewController.h"
#import "RecordViewController.h"
#import "BaseViewController.h"
#import "CalendarViewController.h"
#import "MoneyBoxViewController.h"
#import "BaseTabBar.h"

@interface NavigationTabBarController ()

@property (nonatomic, strong) BaseTabBar *bar;

@end

@implementation NavigationTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BillDetailViewController *home = [[BillDetailViewController alloc] init];
    [self addChildViewController:home title:@"明细" image:@"tabbar_detail_n" selImage:@"tabbar_detail_s"];
    
    CalendarViewController *calendar = [[CalendarViewController alloc]init];
    [self addChildViewController:calendar title:@"日历" image:@"tabbar_discover_n" selImage:@"tabbar_discover_s"];    //TODO:change icon
    
    RecordViewController *record = [[RecordViewController alloc] init];
    [self addChildViewController:record title:@"记账" image:@"tabbar_add_n" selImage:@"tabbar_add_h"];

    ChartsViewController *chart = [[ChartsViewController alloc] init];
    [self addChildViewController:chart title:@"图表" image:@"tabbar_chart_n" selImage:@"tabbar_chart_s"];
    
    // TODO: add money box
    MoneyBoxViewController *moneyBox = [[MoneyBoxViewController alloc]init];
    [self addChildViewController:moneyBox title:@"存钱罐" image:@"tabbar_mine_n" selImage:@"tabbar_mine_s"];
    
    

}

- (void)addChildViewController:(BaseViewController *)childVc title:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage {
    static NSInteger index = 0;
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.tag = index;
    childVc.navTitle = title;
    
    
    index++;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
}


#pragma mark - set
- (void)setIndex:(NSInteger)index {
    _index = index;
    _bar.index = index;
}


#pragma mark - get
- (BaseTabBar *)bar {
    if (!_bar) {
        @weakify(self)
        for (UIView *view in self.tabBar.subviews) {
            [view removeFromSuperview];
        }
        
        _bar = [[BaseTabBar alloc] init];
        [_bar setClick:^(NSInteger index) {
            @strongify(self)
            // 记账
            if (index == 2) {
                RecordViewController *vc = [[RecordViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationFullScreen; // 设置为全屏
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
            }
            else {
                // 我的
                if (index == 4) {
//                    BaseNavigationController *nav = self.viewControllers[index];
//                    MineController *vc = nav.viewControllers[0];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [vc.mine.table setContentOffset:CGPointZero animated:true];
//                    });
                }
                [self setSelectedIndex:index];
                [self.bar setIndex:index];
            }
        }];
        [self setValue:_bar forKey:@"tabBar"];
    }
    return _bar;
}


#pragma mark - 系统
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self bar];
}


@end
