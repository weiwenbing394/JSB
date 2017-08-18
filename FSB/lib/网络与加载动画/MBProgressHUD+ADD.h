//
//  MBProgressHUD+ADD.h
//  XW_MB_AF_MANAGER
//
//  Created by 大家保 on 2016/10/19.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (ADD)


/**
 *  弹出提示
 *  @param information 提示文字
 */
+ (MBProgressHUD *)ToastInformation:(NSString *)information;

/**
 *  弹出提示
 *  @param information 提示文字
 */
+ (MBProgressHUD *)ToastInformation:(NSString *)information toView:(UIView *)view;


/**
 *  显示菊花
 */
+ (MBProgressHUD *)showHUDWithTitle:(NSString *)title;

/**
 *  显示菊花
 */
+ (MBProgressHUD *)showHUDWithTitle:(NSString *)title toView:(UIView *)view;

/**
 *  显示动画 HUD
 */
+ (MBProgressHUD *) showHUDWithImageArr:(NSMutableArray *)imageArr;

/**
 *  显示动画 HUD
 */

+ (MBProgressHUD *) showHUDWithImageArr:(NSMutableArray *)imageArr andShowView:(UIView *)showView;

#pragma mark  请自己提供图标
/**
 *  成功图标弹出
 */
+ (void)showSuccess:(NSString *)success;
/**
 *  成功图标弹出
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
/**
 *  失败图标弹出
 */
+ (void)showError:(NSString *)error;
/**
 *  失败图标弹出
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;
/**
 *  隐藏窗口 HUD
 */
+ (void) hiddenHUD;

/**
 *  隐藏窗口 HUD
 */
+ (void) hiddenHUDToView:(UIView *)view;

@end
