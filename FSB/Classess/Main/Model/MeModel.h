//
//  MeModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeModel : NSObject<NSCoding>
//加密口令
@property (nonatomic,copy) NSString *token;
//是否是审核环境
@property (nonatomic,assign) BOOL isProud;
//手机号
@property (nonatomic,copy) NSString *mobile;


//当前日期重疾险是否有效
@property (nonatomic,assign) BOOL haveZhongjiCare;
//重疾险开始生效日期
@property (nonatomic,assign) double zhongjiCareStartTime;
//重疾险结束保障日期
@property (nonatomic,assign) double zhongjiCareEndTime;
//重疾险当前保额
@property (nonatomic,assign) float zhongjiCareCurrentMoney;

//当前日期意外险是否生效
@property (nonatomic,assign) BOOL haveYiwaiCare;
//意外险开始生效日期
@property (nonatomic,assign) double yiwaiCareStartTime;
//意外险结束保障日期
@property (nonatomic,assign) double yiwaiCareEndTime;
//意外险当前保额
@property (nonatomic,assign) float yiwaiCareCurrentMoney;

//当前保障等级
@property (nonatomic,assign) float careLevel;

@end
