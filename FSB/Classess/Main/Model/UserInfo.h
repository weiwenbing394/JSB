//
//  UserInfo.h
//  FSB
//
//  Created by 大家保 on 2017/8/16.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
//姓名
@property (nonatomic,copy) NSString *nickName;
//省
@property (nonatomic,copy) NSString *province;
//市
@property (nonatomic,copy) NSString *city;
//区
@property (nonatomic,copy) NSString *area;
//详细地址
@property (nonatomic,copy) NSString *address;
//身份证
@property (nonatomic,copy) NSString *idCard;
//手机
@property (nonatomic,copy) NSString *mobile;
//是否已绑定微信
@property (nonatomic,assign) BOOL isWechatAuthor;

@end
