//
//  YiwaiCareView.h
//  FSB
//
//  Created by 大家保 on 2017/8/14.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YiwaiCareView : UIView

@property (nonatomic,copy)void (^vauleBlock)(NSDate *startDte,int careDay,float careMoney);

//单例
+ (instancetype)share;
//显示
- (void)showInView:(UIView *)view andCurrentDate:(NSDate *)currentDate;
//隐藏
- (void)hideInView:(UIView *)view;

@end
