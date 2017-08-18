//
//  rule.m
//  tuilema
//
//  Created by jery on 15/11/20.
//  Copyright © 2015年 yanming. All rights reserved.
//

#import "numberBOOL.h"

@implementation numberBOOL

#pragma mark 检测车牌号
+ (BOOL)checkCarNumber:(NSString *) password{
    NSString *pattern = @"^[a-zA-Z0-9]{6}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
};

#pragma mark 正则表达式控制文本框只能输入字母数字汉字
+ (BOOL)checkHanziZimuShuzi:(NSString *)str {
    NSString *pattern = @"^[^_ `~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}



#pragma mark 检验是不是数字或者字母
+ (BOOL)checkNumberAndZimu_TYHJ2:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
#pragma mark 省份证号输入限制
+ (BOOL)checkiDcard_TYHJ2:(NSString *)str {
    NSString *pattern = @"^[xX0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
#pragma 正则匹配是否纯字母
+ (BOOL)checkALLzimu:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
#pragma 正则匹配是否纯数字(带小数点)
+ (BOOL)checkALLNumberAndDian:(NSString *)number {
    NSString *pattern = @"^[0-9.]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}
#pragma 正则匹配是否纯数字
+ (BOOL)checkALLNumber:(NSString *)number {
    NSString *pattern = @"^[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}


#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^((17[0-9])|(13[0-9])|(147)|(15[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}


#pragma 正则匹配用户密码6-12位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^[a-zA-Z0-9]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

#pragma 正则匹配数字和字母组合(6位)
+ (BOOL)checkNumberAndZimu:(NSString *) password{
    NSString *pattern = @"^[a-zA-Z0-9]{0,6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
};

#pragma 正则中文或英文或数字

+ (BOOL)checkNumberAndZimuAndZhongwen : (NSString *) userName{
    NSString *pattern = @"^[a-z0-9A-Z一-龥]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
};

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName
{
    NSString *pattern = @"^[a-zA-Z一-龥]{1,8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}

#pragma 正则匹配用户姓名,1至3位的中文
+ (BOOL)checkUserNameChinese : (NSString *) userName{
    NSString *pattern=@"^[一-龥]{1,3}";
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch=[pred evaluateWithObject:userName];
    return isMatch;
}


#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|[Xx])$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma 正则匹配用户邮箱
+ (BOOL)checkUserEmailAddress:(NSString *)email{
    
    NSString *pattern = @"(^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:email];
    return isMatch;
}

#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number
{
    NSString *pattern = @"^[0-9]{12}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
    
}

#pragma 正则匹配银行卡号
+ (BOOL) checkCardNo:(NSString*) cardNo{
    if (16>cardNo.length) {
        return NO;
    }
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}


@end
