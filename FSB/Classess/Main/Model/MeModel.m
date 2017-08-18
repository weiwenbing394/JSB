//
//  MeModel.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MeModel.h"

@implementation MeModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder  encodeObject:self.token forKey:@"token"];
    [aCoder  encodeBool:self.isProud forKey:@"isProud"];
    [aCoder  encodeObject:self.mobile forKey:@"mobile"];
    
    [aCoder  encodeBool:self.haveZhongjiCare forKey:@"haveZhongjiCare"];
    [aCoder  encodeDouble:self.zhongjiCareStartTime forKey:@"zhongjiCareStartTime"];
    [aCoder  encodeDouble:self.zhongjiCareEndTime forKey:@"zhongjiCareEndTime"];
    [aCoder  encodeFloat:self.zhongjiCareCurrentMoney forKey:@"zhongjiCareCurrentMoney"];
    
    [aCoder  encodeBool:self.haveYiwaiCare forKey:@"haveYiwaiCare"];
    [aCoder  encodeDouble:self.yiwaiCareStartTime forKey:@"yiwaiCareStartTime"];
    [aCoder  encodeDouble:self.yiwaiCareEndTime forKey:@"yiwaiCareEndTime"];
    [aCoder  encodeFloat:self.yiwaiCareCurrentMoney forKey:@"yiwaiCareCurrentMoney"];
    
    [aCoder  encodeFloat:self.careLevel forKey:@"careLevel"];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        
        self.token=[aDecoder decodeObjectForKey:@"token"];
        self.isProud=[aDecoder decodeBoolForKey:@"isProud"];
        self.mobile=[aDecoder decodeObjectForKey:@"mobile"];
        
        self.haveZhongjiCare=[aDecoder decodeBoolForKey:@"haveZhongjiCare"];
        self.zhongjiCareStartTime=[aDecoder decodeDoubleForKey:@"zhongjiCareStartTime"];
        self.zhongjiCareEndTime=[aDecoder decodeDoubleForKey:@"zhongjiCareEndTime"];
        self.zhongjiCareCurrentMoney=[aDecoder decodeFloatForKey:@"zhongjiCareCurrentMoney"];
        
        self.haveZhongjiCare=[aDecoder decodeBoolForKey:@"haveZhongjiCare"];
        self.yiwaiCareStartTime=[aDecoder decodeDoubleForKey:@"yiwaiCareStartTime"];
        self.yiwaiCareEndTime=[aDecoder decodeDoubleForKey:@"yiwaiCareEndTime"];
        self.yiwaiCareCurrentMoney=[aDecoder decodeFloatForKey:@"yiwaiCareCurrentMoney"];
        
        self.careLevel=[aDecoder decodeFloatForKey:@"careLevel"];
        
    }
    
    return self;
}


@end
