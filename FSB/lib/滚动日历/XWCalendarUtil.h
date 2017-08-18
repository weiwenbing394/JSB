//
//  XWCalendarUtil.h
//  XWCalendar
//
//  Created by 大家保 on 16/7/11.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MONTH_COUNTS_IN_YEAR_GRE 12  //公历每年的月份的个数
#define DAY_COUNTS_IN_YEAR__GRE 31   //公历每月的最多的天数
#define CALENDAR_UNIT_FLAGS  (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit)           //从日期中获取的字段列表

@interface XWCalendarUtil : NSObject

//日历的年份起始值
@property (nonatomic, assign) NSUInteger yearStart;
//日历的年份结束值
@property (nonatomic, assign) NSUInteger yearEnd;
//系统的日历类
@property (nonatomic, retain) NSCalendar *greCal;
//年代
@property (nonatomic, copy) NSString * era;
//年份
@property (nonatomic, copy) NSString * year;
//月份
@property (nonatomic, copy) NSString * month;
//日期
@property (nonatomic, copy) NSString * day;
//星期
@property (nonatomic, copy) NSString * weekday;
//星期的数据
@property (nonatomic, retain) NSArray * weekdays;
//初始化方法
- (id)initWithYearStart:(NSUInteger)start end:(NSUInteger)end selectedDate:(NSDate *)selectedDate;
//指定范围yearStart - yearEnd的年份数据
- (NSMutableArray *)yearsInRange;
//指定年份的月份数据
- (NSMutableArray *)monthsInYear:(NSUInteger)_year;
//指定月份的日期数据
- (NSMutableArray *)daysInMonth:(NSString *)post_month year:(NSUInteger)post_year;
//依据公历日期计算星期
+ (int)weekDayWithYear:(NSUInteger)_year month:(NSUInteger)post_month day:(NSUInteger)_day;
//依据公历日期返回date
+ (NSDate *)backDateWithYear:(NSUInteger)_year month:(NSUInteger)post_month day:(NSUInteger)_day;
//根据date返回年月日
+ (NSArray *)backYearMonthDay:(NSDate *)postDate;

@end
