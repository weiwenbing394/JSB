//
//  XWCustomCalendarPickerView.h
//  XWCalendar
//
//  Created by 大家保 on 16/7/11.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCalendarUtil.h"
#import "XWCommon.h"

#define YEAR_START 1986   //滚轮显示的起始年份
#define YEAR_END   5000   //滚轮显示的结束年份
//设置时间的限制
typedef NS_ENUM(NSInteger , LimitType) {
    //没有限制
    LimitNo,
    //有最大日期
    LimitMax,
    //有最小日期
    LimitMin
};

typedef NS_ENUM(NSInteger, XianshiType) {
    //全显示
    AllXianshi,
    //不现实日
    NoDay
};

@class XWCustomCalendarPickerView;

@protocol XWCustomCalendarPickerViewDelegate <NSObject>

@optional

- (void)customCalendarPickerView:(XWCustomCalendarPickerView *)customCalendarPickerView notifyNewCalendar:(XWCalendarUtil *)cal;

- (void)cancelButtomClicked;

@end

@interface XWCustomCalendarPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
//代理方法
@property (nonatomic,assign)id<XWCustomCalendarPickerViewDelegate> delegate;
//可选的最大年份,月份，日期
@property (nonatomic, assign) NSDate  *MAX_DATE;
//可选的最小年份，月份，日期
@property (nonatomic, assign) NSDate  *MIN_DATE;
//时间限制模式
@property (nonatomic, assign) LimitType limitType;
//日历显示模式（年月日）
@property (nonatomic, assign) XianshiType xianshiType;
//初始化
- (instancetype)initWithTitle:(NSString *)title selectedDate:(NSDate *)date;
//显示
- (void)show;

@end
