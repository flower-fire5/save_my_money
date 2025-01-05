//
//  BaseViewController.m
//  save_my_money
//
//  Created by hwy on 2025/1/3.
//

#import "BaseViewController.h"

#import <JZNavigationExtension/JZNavigationExtension.h>

#pragma mark - enum
typedef NS_ENUM(NSInteger, BarButtonItemState) {
    BarButtonItemStateLeft,     // 文字居左
    BarButtonItemStateRight,    // 文字居右
};

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setJz_navigationBarTransitionStyle:JZNavigationBarTransitionStyleSystem];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    [self.view setBackgroundColor:kColor_BG];
    [self initUI];
//    for (id obj in self.navigationController.navigationBar.subviews) {
//        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
//            UIView *hook = [(BaseNavigationController *)self.navigationController hook_background];
//            [self.navigationController.navigationBar insertSubview:hook belowSubview:obj];
//        }
//    }
}

- (void)initUI {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
