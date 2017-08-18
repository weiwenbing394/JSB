//
//  UITextField+TYExtensions.h
//  BaobiaoDog
//
//  Created by 大家宝 on 16/8/25.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TYExtensions)

/**
 *  创建目标UITextField
 *
 *  @param frame       frame大小
 *  @param placeholder 站位字符
 *  @param YESorNO     是不是密码
 *  @param leftView    左侧view
 *  @param rightView   右侧view
 *  @param font        字体大小
 *
 *  @return 目标UITextField
 */
+ (UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftView:(UIView*)leftView rightView:(UIView*)rightView font:(UIFont *)font;
@end
