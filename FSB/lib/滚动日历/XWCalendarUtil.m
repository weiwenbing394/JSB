//
//  XWCalendarUtil.m
//  XWCalendar
//
//  Created by 大家保 on 16/7/11.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "XWCalendarUtil.h"

@implementation XWCalendarUtil

//初始化方法
- (id)initWithYearStart:(NSUInteger)start end:(NSUInteger)end selectedDate:(NSDate *)selectedDate{
    if (self=[super init]) {
        self.yearStart=start;
        self.yearEnd=end;
        NSCalendar *cal=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        [cal setTimeZone:[NSTimeZone defaultTimeZone]];
        self.greCal=cal;
        self.weekdays=[NSArray arrayWithObjects:@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
        
        //设置当前时间相关的字段
        NSDate *currentDate;
        if (selectedDate) {
            currentDate=selectedDate;
        }else{
            currentDate=[NSDate date];
        }
        NSDateComponents *dc=[cal components:CALENDAR_UNIT_FLAGS fromDate:currentDate];
        self.era=[NSString stringWithFormat:@"%d",(int)dc.era];
        self.year=[NSString stringWithFormat:@"%d",(int)dc.year];
                self.month=[NSString stringWithFormat:@"%d",(int)dc.month];
        self.day=[NSString stringWithFormat:@"%d",(int)dc.day];
    }
    return self;
};

//指定范围yearStart - yearEnd的年份数据
- (NSMutableArray *)yearsInRange{
    NSMutableArray *array=[NSMutableArray array];
    for (int i=(int)self.yearStart; i<(int)self.yearEnd; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return array;
};
//指定年份的月份数据
- (NSMutableArray *)monthsInYear:(NSUInteger)_year{
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<MONTH_COUNTS_IN_YEAR_GRE; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",(i+1)]];
    }
    return array;
};
//指定月份的日期数据
- (NSMutableArray *)daysInMonth:(NSString *)post_month year:(NSUInteger)post_year{
    NSMutableArray   *array=[NSMutableArray array];
    NSDateComponents *dc=[[NSDateComponents alloc]init];
    dc.year=post_year;
    dc.month=[post_month intValue];
    dc.day=1;
    NSDate *date=[self.greCal dateFromComponents:dc];
    NSRange range=[self.greCal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    for (int i=0; i<range.length; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    return array;
};
//依据公历日期计算星期
+ (int)weekDayWithYear:(NSUInteger)_year month:(NSUInteger)post_month day:(NSUInteger)_day{
    NSDateComponents *dc=[[NSDateComponents alloc]init];
    dc.year=_year;
    dc.month=post_month;
    dc.day=_day;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:dc];
    NSDateComponents *comps= [gregorian components:(NSYearCalendarUnit |
                                                    NSMonthCalendarUnit |
                                                    NSDayCalendarUnit |
                                                    NSWeekdayCalendarUnit) fromDate:date];
    int weekday =(int)[comps weekday]-1;
    return weekday;
};
//依据公历日期返回date
+ (NSDate *)backDateWithYear:(NSUInteger)_year month:(NSUInteger)post_month day:(NSUInteger)_day{
    NSDateComponents *dc=[[NSDateComponents alloc]init];
    dc.year=_year;
    dc.month=post_month;
    dc.day=_day;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:dc];
    return date;
};
//根据date返回年月日
+ (NSArray *)backYearMonthDay:(NSDate *)postDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps= [gregorian components:(NSYearCalendarUnit |
                                                    NSMonthCalendarUnit |
                                                    NSDayCalendarUnit |
                                                    NSWeekdayCalendarUnit) fromDate:postDate];
    NSString *year=[NSString stringWithFormat:@"%d",(int)[comps year]];
    NSString *month=[NSString stringWithFormat:@"%d",(int)[comps month]];
    NSString *day=[NSString stringWithFormat:@"%d",(int)[comps day]];
    NSArray  *arr=[NSArray arrayWithObjects:year,month,day, nil];
    return arr;
};

@end
