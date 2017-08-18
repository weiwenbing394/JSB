//
//  XWCustomCalendarPickerView.m
//  XWCalendar
//
//  Created by 大家保 on 16/7/11.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "XWCustomCalendarPickerView.h"

@interface XWCustomCalendarPickerView ()

- (void)_setYears;
- (void)_setMonthsInYear:(NSUInteger)_year;
- (void)_setDaysInMonth:(NSString *)_month year:(NSUInteger)_year;
- (void)changeDays;

//可选的最大年份
@property (nonatomic, assign) NSInteger MAX_YEAR;
//可选的最大月份
@property (nonatomic, assign) NSInteger MAX_MONTH;
//可选的最大日期
@property (nonatomic, assign) NSInteger MAX_DAY;
//可选的最小年份
@property (nonatomic, assign) NSInteger MIN_YEAR;
//可选的最小月份
@property (nonatomic, assign) NSInteger MIN_MONTH;
//可选的最小日期
@property (nonatomic, assign) NSInteger MIN_DAY;

@end

@implementation XWCustomCalendarPickerView{
    UIPickerView    *_pickerView;
    UILabel         *_titleLabel;
    UIView          *_datePickerView;//datePicker背景
    UIButton        *_calendarBtn;
    
    NSMutableArray *years;  //年份数据容器
    NSMutableArray *months; //月份数据容器
    NSMutableArray *days;   //日期的数据容器
    XWCalendarUtil *cal;    //日历类
}

//初始化
- (instancetype)initWithTitle:(NSString *)title selectedDate:(NSDate *)date{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor=kColor(0, 0, 0, 0);
        self.layer.cornerRadius=5;
        self.clipsToBounds=YES;
//        self.userInteractionEnabled=YES;
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
//        [self addGestureRecognizer:tap];
        [self creatView:title withDate:date];
    }
    return self;
};

//设置限制模式
- (void)setLimitType:(LimitType)limitType{
    _limitType=limitType;
    [_pickerView reloadAllComponents];
}

//设置最大日期
- (void)setMAX_DATE:(NSDate *)MAX_DATE{
    NSArray *arr;
    if (MAX_DATE) {
        arr=[XWCalendarUtil backYearMonthDay:MAX_DATE];
    }else{
        arr=[XWCalendarUtil backYearMonthDay:[NSDate date]];
    }
    _MAX_YEAR=[arr[0] integerValue];
    _MAX_MONTH=[arr[1] integerValue];
    _MAX_DAY=[arr[2] integerValue];
    [_pickerView reloadAllComponents];
}

//设置最小日期
- (void)setMIN_DATE:(NSDate *)MIN_DATE{
    NSArray *arr;
    if (MIN_DATE) {
        arr=[XWCalendarUtil backYearMonthDay:MIN_DATE];
    }else{
        arr=[XWCalendarUtil backYearMonthDay:[NSDate date]];
    }
    _MIN_YEAR=[arr[0] integerValue];
    _MIN_MONTH=[arr[1] integerValue];
    _MIN_DAY=[arr[2] integerValue];
    [_pickerView reloadAllComponents];
}



//视图初始化
- (void)creatView:(NSString *)title withDate:(NSDate *)post{
    //生成日期选择器
    _datePickerView=[[UIView alloc] initWithFrame:CGRectMake(0,0,GETWIDTH(self),GETHEIGHT(self))];
    _datePickerView.backgroundColor=[UIColor whiteColor];
    _datePickerView.userInteractionEnabled = YES;
    [self addSubview:_datePickerView];
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//    [_datePickerView addGestureRecognizer:tapGesture];
    //取消按钮
    UIButton *dateCancleButton=[[UIButton alloc] initWithFrame:CGRectMake(0,0,50,44)];
    [dateCancleButton addTarget:self action:@selector(dateCancleClick) forControlEvents:UIControlEventTouchUpInside];
    [dateCancleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dateCancleButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [dateCancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [dateCancleButton.titleLabel setFont:k15Font];
    [dateCancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_datePickerView addSubview:dateCancleButton];
    //确定按钮
    UIButton *dateConfirmButton=[[UIButton alloc] initWithFrame:CGRectMake(GETWIDTH(self)-50,Y(dateCancleButton),GETWIDTH(dateCancleButton),GETHEIGHT(dateCancleButton))];
    [dateConfirmButton addTarget:self action:@selector(dateConfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [dateConfirmButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [dateConfirmButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [dateConfirmButton.titleLabel setFont:k15Font];
    [dateConfirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_datePickerView addSubview:dateConfirmButton];

    //标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(MaxX(dateCancleButton), Y(dateCancleButton), kScreenWidth - MaxX(dateCancleButton)*2, GETHEIGHT(dateCancleButton))];
    _titleLabel.font = k14Font;
    _titleLabel.text = title;
    _titleLabel.textColor = [UIColor grayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_datePickerView addSubview:_titleLabel];
    //头部分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, MaxY(dateCancleButton), GETWIDTH(self), kLineHeight)];
    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [_datePickerView addSubview:lineView];
    //pickrView
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, MaxY(lineView) , GETWIDTH(lineView), GETHEIGHT(self)-MaxY(lineView))];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [_pickerView setShowsSelectionIndicator:YES];
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
    [_datePickerView addSubview:_pickerView];
    //初始化pickerview date
    [self initDate:post];
}
//初始化pickerview date
- (void)initDate:(NSDate *)selecteddate{
    cal=[[XWCalendarUtil alloc]initWithYearStart:YEAR_START end:YEAR_END  selectedDate:selecteddate];
    //初始化年份数组
    [self _setYears];
    //初始化月份数组
    [self _setMonthsInYear:[cal.year intValue]];
    //初始化日期数组
    [self _setDaysInMonth:cal.month  year:[cal.year intValue]];
    //当前时间的年月日
    NSArray *arr=[XWCalendarUtil backYearMonthDay:[NSDate date]];
    //默认最大、最小年份（当前年份）
    _MIN_YEAR=_MAX_YEAR=[arr[0] integerValue];
    //默认最大、最小月份（当前月份）
    _MIN_MONTH= _MAX_MONTH=[arr[1] integerValue];
    //默认最大、最小日期 （当前日期）
    _MIN_DAY=_MAX_DAY=[arr[2] integerValue];
    //默认日期限制模式
    _limitType=LimitNo;
    //刷新pickerView
    [_pickerView reloadAllComponents];
    //默认选中
    [_pickerView selectRow:[years indexOfObject:cal.year] inComponent:0 animated:YES];
    [_pickerView selectRow:[months indexOfObject:cal.month] inComponent:1 animated:YES];
    [_pickerView selectRow:[days indexOfObject:cal.day] inComponent:2 animated:YES];
}

#pragma mark -pickerView Delegate
//列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.xianshiType==NoDay) {
        return 2;
    }
    return 3;
}
//每一列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return years.count;
            break;
        case 1:
            return months.count;
            break;
        case 2:
            return days.count;
            break;
        default:
            return 0;
            break;
    }
}
//每一行的视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myCom=[[UILabel alloc]init];
    myCom.textAlignment=NSTextAlignmentCenter;
    myCom.backgroundColor=[UIColor clearColor];
    myCom.font=[UIFont systemFontOfSize:kTitleFont];
    switch (component) {
        case 0:
        {
            NSString *year=[years objectAtIndex:row];
            myCom.text=year;
            if (_limitType==LimitNo) {
                myCom.textColor=kCanSelectColor;
            }else if (_limitType==LimitMax){
                if ([year intValue]>self.MAX_YEAR) {
                    myCom.textColor=KCannotUseColor;
                }else{
                    myCom.textColor=kCanSelectColor;
                }
            }else if (_limitType== LimitMin){
                if ([year intValue]<self.MIN_YEAR) {
                    myCom.textColor=KCannotUseColor;
                }else{
                    myCom.textColor=kCanSelectColor;
                }
            }
            break;
        }
            
        case 1:
        {
            NSString *month=[months objectAtIndex:row];
            myCom.text=[NSString stringWithFormat:@"%@月",month];
            if (_limitType==LimitNo) {
                myCom.textColor=kCanSelectColor;
            }else if (_limitType==LimitMax){
                if ([cal.year integerValue]<self.MAX_YEAR) {
                    myCom.textColor=kCanSelectColor;
                }else{
                    if ([month intValue]>self.MAX_MONTH) {
                        myCom.textColor=KCannotUseColor;
                    }else{
                        myCom.textColor=kCanSelectColor;
                    }
                }
            }else if (_limitType== LimitMin){
                if ([cal.year integerValue]>self.MIN_YEAR) {
                    myCom.textColor=kCanSelectColor;
                }else{
                    if ([month intValue]<self.MIN_MONTH) {
                        myCom.textColor=KCannotUseColor;
                    }else{
                        myCom.textColor=kCanSelectColor;
                    }
                }
            }
            break;
        }
            
        case 2:
           {
               int day=[[days objectAtIndex:row] intValue];
               int weekday=[XWCalendarUtil weekDayWithYear:[cal.year integerValue] month:[cal.month integerValue] day:day];
               myCom.text=[NSString stringWithFormat:@"%d  %@",day,[cal.weekdays objectAtIndex:weekday]];
               if (_limitType==LimitNo) {
                       myCom.textColor=kCanSelectColor;
               }else if (_limitType==LimitMax){
                   if ([cal.year integerValue]<self.MAX_YEAR||([cal.year integerValue]==self.MAX_YEAR &&[cal.month integerValue]<self.MAX_MONTH)) {
                       myCom.textColor=kCanSelectColor;
                   }else{
                       if (day>self.MAX_DAY) {
                           myCom.textColor=KCannotUseColor;
                       }else{
                           myCom.textColor=kCanSelectColor;
                       }
                   }
               }else if (_limitType== LimitMin){
                   if ([cal.year integerValue]>self.MIN_YEAR||([cal.year integerValue]==self.MIN_YEAR &&[cal.month integerValue]>self.MIN_MONTH)) {
                       myCom.textColor=kCanSelectColor;
                   }else{
                       if (day<self.MIN_DAY) {
                           myCom.textColor=KCannotUseColor;
                       }else{
                           myCom.textColor=kCanSelectColor;
                       }
                   }
               }
            break;
        }
        default:
            break;
    }
    return myCom;
}
//每一列的宽度
//- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    switch (component) {
//        case 0:
//            return 90;
//            break;
//        case 1:
//            return 50;
//            break;
//        case 2:
//            return 70;
//            break;
//        default:
//            return 90;
//            break;
//    }
//}
//每一列的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 37;
}
//滑动滚轮
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)componen{
    switch (componen) {
        case 0:{
            NSString *year=[years objectAtIndex:row];
            if (_limitType==LimitNo) {
                cal.year=year;
            }else if (_limitType==LimitMax){
                if ([year intValue]>=self.MAX_YEAR) {
                    cal.year=[NSString  stringWithFormat:@"%d",(int)self.MAX_YEAR];
                    [pickerView reloadComponent:0];
                    [pickerView selectRow:[years indexOfObject:cal.year] inComponent:0 animated:YES];
                    
                    if ([cal.month integerValue]>self.MAX_MONTH) {
                        cal.month=[NSString  stringWithFormat:@"%d",(int)self.MAX_MONTH];
                        [pickerView reloadComponent:1];
                        [pickerView selectRow:[months indexOfObject:cal.month] inComponent:1 animated:YES];
                    }
                    if ([cal.day integerValue]>self.MAX_DAY) {
                        cal.day=[NSString  stringWithFormat:@"%d",(int)self.MAX_DAY];
                        [pickerView reloadComponent:2];
                        [pickerView selectRow:[days indexOfObject:cal.day] inComponent:2 animated:YES];
                    }
                }else{
                    cal.year=year;
                }
            }else if (_limitType== LimitMin){
                if ([year intValue]<=self.MIN_YEAR) {
                    cal.year=[NSString  stringWithFormat:@"%d",(int)self.MIN_YEAR];
                    [pickerView reloadComponent:0];
                    [pickerView selectRow:[years indexOfObject:cal.year] inComponent:0 animated:YES];
                    
                    if ([cal.month integerValue]<self.MIN_MONTH) {
                        cal.month=[NSString  stringWithFormat:@"%d",(int)self.MIN_MONTH];
                        [pickerView reloadComponent:1];
                        [pickerView selectRow:[months indexOfObject:cal.month] inComponent:1 animated:YES];
                    }
                    if ([cal.day integerValue]<self.MIN_DAY) {
                        cal.day=[NSString  stringWithFormat:@"%d",(int)self.MIN_DAY];
                        [pickerView reloadComponent:2];
                        [pickerView selectRow:[days indexOfObject:cal.day] inComponent:2 animated:YES];
                    }
                }else{
                    cal.year=year;
                }
            }
            //因为公历的每年都是12个月，所以当年份变化的时候，只需要后面的天数联动
            [self changeDays];
            break;
        }
        case 1:{
            NSString *oldMonth=[cal.month copy];
            NSString *month=[months objectAtIndex:row];
            if (_limitType==LimitNo) {
                cal.month=month;
            }else if (_limitType==LimitMax){
                if ([cal.year integerValue]<self.MAX_YEAR) {
                    cal.month=month;
                }else{
                    if ([month intValue]>=self.MAX_MONTH) {
                        cal.month=[NSString  stringWithFormat:@"%d",(int)self.MAX_MONTH];
                        [pickerView reloadComponent:1];
                        [pickerView selectRow:[months indexOfObject:cal.month] inComponent:1 animated:YES];
                        
                        if ([cal.day integerValue]>self.MAX_DAY) {
                            cal.day=[NSString  stringWithFormat:@"%d",(int)self.MAX_DAY];
                            [pickerView reloadComponent:2];
                            [pickerView selectRow:[days indexOfObject:cal.day] inComponent:2 animated:YES];
                        }
                    }else{
                        cal.month=month;
                    }
                }
            }else if (_limitType== LimitMin){
                if ([cal.year integerValue]>self.MIN_YEAR) {
                    cal.month=month;
                }else{
                    if ([month intValue]<=self.MIN_MONTH) {
                        cal.month=[NSString  stringWithFormat:@"%d",(int)self.MIN_MONTH];
                        [pickerView reloadComponent:1];
                        [pickerView selectRow:[months indexOfObject:cal.month] inComponent:1 animated:YES];
                        
//                        if ([cal.day integerValue] >= self.MIN_DAY) {
                            cal.day=[NSString  stringWithFormat:@"%d",(int)self.MIN_DAY];
                            [pickerView reloadComponent:2];
                            [pickerView selectRow:[days indexOfObject:cal.day] inComponent:2 animated:YES];
//                        }
                    }else{
                        cal.month=month;
                    }
                }

            }
            if (![oldMonth isEqualToString:cal.month]) {
                [self changeDays];
            }
            break;
        }
        case 2:{
            NSString *day=[days objectAtIndex:row];
            if (_limitType==LimitNo) {
                cal.day=day;
            }else if (_limitType==LimitMax){
                if ([cal.year integerValue]<self.MAX_YEAR||([cal.year integerValue]==self.MAX_YEAR &&[cal.month integerValue]<self.MAX_MONTH)) {
                    cal.day=day;
                }else{
                    if ([day intValue]>self.MAX_DAY) {
                        cal.day=[NSString  stringWithFormat:@"%d",(int)self.MAX_DAY];
                        [pickerView reloadComponent:2];
                        [pickerView selectRow:[days indexOfObject:cal.day] inComponent:2 animated:YES];
                    }else{
                        cal.day=day;
                    }
                }
            }else if (_limitType== LimitMin){
                if ([cal.year integerValue]>self.MIN_YEAR||([cal.year integerValue]==self.MIN_YEAR &&[cal.month integerValue]>self.MIN_MONTH)) {
                    cal.day=day;
                }else{
                    if ([day intValue]<self.MIN_DAY) {
                        cal.day=[NSString  stringWithFormat:@"%d",(int)self.MIN_DAY];
                        [pickerView reloadComponent:2];
                        [pickerView selectRow:[days indexOfObject:cal.day] inComponent:2 animated:YES];
                    }else{
                        cal.day=day;
                    }
                }
            }
            [self changeDays];
            break;
        }
        default:
            break;
    }
    cal.weekday=[NSString stringWithFormat:@"%d",[XWCalendarUtil weekDayWithYear:[cal.year integerValue] month:[cal.month integerValue] day:[cal.day intValue]]];
    
}
//动态改变日期列表
- (void)changeDays{
    if (self.xianshiType==NoDay) {
        return;
    }
    [self _setDaysInMonth:cal.month year:[cal.year integerValue]];
    [_pickerView reloadComponent:2];
    int index=(int)[days indexOfObject:cal.day];
    if (index==NSNotFound||index==-1) {
        index=0;
        cal.day=[days objectAtIndex:index];
    }
    [_pickerView selectRow:index inComponent:2 animated:YES];
}

#pragma mark 数据加载
//填充年份
- (void)_setYears{
    years=[NSMutableArray array];
    years=[cal yearsInRange];
}

//填充月份
- (void)_setMonthsInYear:(NSUInteger)_year{
    months=[NSMutableArray array];
    months=[cal monthsInYear:_year];
}

//填充天数
- (void)_setDaysInMonth:(NSString *)_month year:(NSUInteger)_year{
    days=[NSMutableArray array];
    days=[cal daysInMonth:_month year:_year];
}


//显示
- (void)show{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self addAnimation];
};

//隐藏
- (void)hide{
    [self removeAnimation];
}


- (void)addAnimation{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_datePickerView setFrame:CGRectMake(0, self.frame.size.height - _datePickerView.frame.size.height, kScreenWidth, _datePickerView.frame.size.height)];
    } completion:nil];
}

- (void)removeAnimation{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [_datePickerView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

//确定选择
-(void)dateConfirmClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customCalendarPickerView:notifyNewCalendar:)]) {
        [self.delegate customCalendarPickerView:self notifyNewCalendar:cal];
    }
    //[self removeAnimation];
}


//取消选择
-(void)dateCancleClick{
    //[self removeAnimation];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtomClicked)]) {
        [self.delegate cancelButtomClicked];
    }
}



@end
