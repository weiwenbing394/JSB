//
//  rule.h
//  tuilema
//
//  Created by jery on 15/11/20.
//  Copyright © 2015年 yanming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface numberBOOL : NSObject

#pragma mark 检测车牌号
+ (BOOL)checkCarNumber:(NSString *) password;

#pragma mark 数字或者字母输入限制
+ (BOOL)checkNumberAndZimu_TYHJ2:(NSString *)str;

#pragma mark 省份证号输入限制
+ (BOOL)checkiDcard_TYHJ2:(NSString *)str;

#pragma mark 正则表达式控制文本框只能输入字母数字汉字
+ (BOOL)checkHanziZimuShuzi:(NSString *)str;

#pragma 正则匹配是否纯字母
+ (BOOL)checkALLzimu:(NSString *)str;

#pragma 正则匹配是否纯数字(带小数点)
+ (BOOL)checkALLNumberAndDian:(NSString *)number;

#pragma 正则匹配是否纯数字
+ (BOOL)checkALLNumber:(NSString *)number;

#pragma 正则匹配手机号

+ (BOOL)checkTelNumber:(NSString *) telNumber;

#pragma 正则匹配用户密码6-12位数字和字母组合

+ (BOOL)checkPassword:(NSString *) password;

#pragma 正则匹配数字和字母组合
+ (BOOL)checkNumberAndZimu:(NSString *) password;

#pragma 正则中文或英文或数字

+ (BOOL)checkNumberAndZimuAndZhongwen : (NSString *) userName;

#pragma 正则匹配用户姓名,8位的中文或英文

+ (BOOL)checkUserName : (NSString *) userName;

#pragma 正则匹配用户姓名,1至3位的中文

+ (BOOL)checkUserNameChinese : (NSString *) userName;
#pragma 正则匹配用户身份证号

+ (BOOL)checkUserIdCard: (NSString *) idCard;

#pragma 正则匹配用户邮箱
+ (BOOL)checkUserEmailAddress:(NSString *)email;

#pragma 正则匹员工号,12位的数字

+ (BOOL)checkEmployeeNumber : (NSString *) number;

#pragma 正则匹配URL

+ (BOOL)checkURL : (NSString *) url;

#pragma 正则匹配银行卡号

+ (BOOL) checkCardNo:(NSString*) cardNo;

@end
