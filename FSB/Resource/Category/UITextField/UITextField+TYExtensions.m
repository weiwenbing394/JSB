//
//  UITextField+TYExtensions.m
//  BaobiaoDog
//
//  Created by 大家宝 on 16/8/25.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "UITextField+TYExtensions.h"

@implementation UITextField (TYExtensions)

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
+ (UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftView:(UIView*)leftView rightView:(UIView*)rightView font:(UIFont *)font
{
    UITextField*textField = [[UITextField alloc]initWithFrame:frame];
    //灰色提示框
    textField.placeholder = placeholder;
    //文字对齐方式
    textField.textAlignment = NSTextAlignmentLeft;
    textField.secureTextEntry = YESorNO;
    //边框
    //textField.borderStyle=UITextBorderStyleLine;
    //键盘类型
    //textField.keyboardType = UIKeyboardTypeEmailAddress;
    //关闭首字母大写
    textField.autocapitalizationType = NO;
    //清除按钮
    textField.clearButtonMode = YES;
    //左侧view
    if(leftView != nil){
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    //右图片
    if(rightView != nil){
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    //自定义键盘
    //textField.inputView
    //字体
    textField.font = font;
    //字体颜色
    textField.textColor = [UIColor blackColor];
    return textField ;
    
}
@end
