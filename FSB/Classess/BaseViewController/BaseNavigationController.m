//
//  QMYBNavigationController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

/**
 *  当第一次使用这个类的时候就会调用一次
 */
+ (void)initialize {
    
    
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSFontAttributeName :SystemFont(18)}];
    
    //设置item
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    itemAttrs[NSFontAttributeName] = SystemFont(16);
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
    
}


/**
 *  可以在这个方法中拦截所有的push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


//电池栏
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
};

//电池烂
- (UIViewController *)childViewControllerForStatusBarHidden{
    return self.topViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden=YES;
}


@end
