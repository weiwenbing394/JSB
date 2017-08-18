//
//  YiwaiCareView.m
//  FSB
//
//  Created by 大家保 on 2017/8/14.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "YiwaiCareView.h"
#import "XWCustomCalendarPickerView.h"
#define showYiwaiHeightPoint (SCREEN_HEIGHT-200-64)
#define hideYiwaiHeightPoint (SCREEN_HEIGHT-54)
#define dayButtonWidth  ((SCREEN_WIDTH-60)/5.0)

@interface YiwaiCareView ()<XWCustomCalendarPickerViewDelegate>{
    //意外险购买视图
    UIView        *buyyiwaiView;
    //意外险开始日期按钮
    UIButton      *yiwaiStartTimeBtn;
    //意外开始日期
    NSDate        *yiwaiStartDate;
    //意外险保障天数label
    UILabel      *careDay;
    //意外险保障天数选中按钮
    UIButton      *selectedYiwaiDayButtom;
    //意外险价格
    UILabel       *yiwaiPrice;
    //意外险保额
    UILabel       *yiwaiBaoe;
    //意外险开始保障
    UIButton      *yiwaiStartCare;
    //意外险保障天数
    int           yiwaiCareDayNumber;
    //当前时间
    NSDate        *currentDate;
}

//日期选择层
@property (nonatomic,strong) JCAlertView  *alertView;

@end

@implementation YiwaiCareView

//单例
+ (instancetype)share{
    static YiwaiCareView *careView=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        careView=[[YiwaiCareView alloc]init];
        [careView initUI];
     });
    return careView;
};

//界面初始化
- (void)initUI{
    //数据初始化
    currentDate=[[NSDate date] dateByAddingDays:1];
    yiwaiStartDate=currentDate;
    yiwaiCareDayNumber=1;
    
    self.frame=CGRectMake(0, hideYiwaiHeightPoint, SCREEN_WIDTH, 200);
    
    buyyiwaiView=[[UIView alloc]initWithFrame:self.bounds];
    buyyiwaiView.backgroundColor=[UIColor whiteColor];
    buyyiwaiView.layer.shadowColor=[UIColor blackColor].CGColor;
    buyyiwaiView.layer.shadowOffset=CGSizeMake(0, 0);
    buyyiwaiView.layer.shadowRadius=15;
    buyyiwaiView.layer.shadowOpacity=0.1;
    buyyiwaiView.layer.cornerRadius=0;
    [self addSubview:buyyiwaiView];
    
    UILabel *startTimeLabel=[[UILabel alloc]init];
    startTimeLabel.textColor=[UIColor colorWithHexString:@"#444444"];
    startTimeLabel.text=@"保障起期";
    startTimeLabel.font=font14;
    startTimeLabel.textAlignment=NSTextAlignmentLeft;
    [buyyiwaiView addSubview:startTimeLabel];
    [startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(49.5);
    }];
    
    UIButton *startTimeRightBtn=[[UIButton alloc]init];
    [startTimeRightBtn setImage:[UIImage imageNamed:@"you-icon"] forState:0];
    [startTimeRightBtn addTarget:self action:@selector(yiwaiStartTimeSelected:) forControlEvents:UIControlEventTouchUpInside];
    [startTimeRightBtn setTitleColor:[UIColor blueColor] forState:0];
    [buyyiwaiView addSubview:startTimeRightBtn];
    
    [startTimeRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.mas_equalTo(startTimeLabel);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(26);
    }];
    
    yiwaiStartTimeBtn=[[UIButton alloc]init];
    [yiwaiStartTimeBtn setTitle:[[ToolsManager share] dateToString:yiwaiStartDate andFormat:@"yyyy年MM月dd日"] forState:0];
    [yiwaiStartTimeBtn setTitleColor:[UIColor colorWithHexString:@"#1fa2ed"] forState:0];
    [yiwaiStartTimeBtn.titleLabel setFont:font14];
    [yiwaiStartTimeBtn addTarget:self action:@selector(yiwaiStartTimeSelected:) forControlEvents:UIControlEventTouchUpInside];
    [buyyiwaiView addSubview:yiwaiStartTimeBtn];
    [yiwaiStartTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.mas_equalTo(startTimeLabel);
        make.right.mas_equalTo(startTimeRightBtn.mas_left).offset(0);
    }];
    
    UIView *separate1=[[UIView alloc] init];
    separate1.backgroundColor=RGB(239, 242, 245);
    [buyyiwaiView addSubview:separate1];
    [separate1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(startTimeLabel.mas_bottom);
        make.left.mas_equalTo(startTimeLabel);
        make.right.mas_equalTo(startTimeRightBtn);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *careDayLabel=[[UILabel alloc]init];
    careDayLabel.textColor=[UIColor colorWithHexString:@"#444444"];
    careDayLabel.text=@"保障期限";
    careDayLabel.font=font14;
    careDayLabel.textAlignment=NSTextAlignmentLeft;
    [buyyiwaiView addSubview:careDayLabel];
    [careDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(separate1.mas_bottom);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(49.5);
    }];
    
    careDay=[[UILabel alloc]init];
    careDay.text=@"1天";
    careDay.textColor=[UIColor colorWithHexString:@"#1fa2ed"];
    careDay.font=font14;
    [buyyiwaiView addSubview:careDay];
    [careDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(careDayLabel);
        make.right.mas_equalTo(-20);
    }];
    
    NSArray *titleArray=@[@"1天",@"7天",@"15天",@"30天",@"365天"];
    for (int i=0; i<titleArray.count; i++) {
        UIButton *day=[[UIButton alloc]init];
        [day setTitle:titleArray[i] forState:0];
        [day setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:0];
        [day setTitleColor:[UIColor colorWithHexString:@"#1fa2ed"] forState:UIControlStateDisabled];
        [day setBackgroundImage:[UIImage imageNamed:@"button-2"] forState:0];
        [day setBackgroundImage:[UIImage imageNamed:@"button-1"] forState:UIControlStateDisabled];
        [day setTag:i+200000];
        [day addTarget:self action:@selector(selectedDay:) forControlEvents:UIControlEventTouchUpInside];
        [day.titleLabel setFont:font14];
        [buyyiwaiView addSubview:day];
        [day mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*(dayButtonWidth+10)+10);
            make.top.mas_equalTo(careDayLabel.mas_bottom).offset(1);
            make.width.mas_equalTo(dayButtonWidth);
            make.height.mas_equalTo(25);
        }];
        if (i==0) {
            [day setEnabled:NO];
            selectedYiwaiDayButtom=day;
        }
    }
    
    
    UIView *separate2=[[UIView alloc] init];
    separate2.backgroundColor=RGB(239, 242, 245);
    [buyyiwaiView addSubview:separate2];
    [separate2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(careDayLabel.mas_bottom).offset(50);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UIView *priceView=[[UIView alloc]init];
    [buyyiwaiView addSubview:priceView];
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(separate2.mas_bottom);
        make.height.mas_equalTo(startTimeLabel);
        make.left.mas_equalTo(startTimeLabel);
        make.width.mas_equalTo((SCREEN_WIDTH-10)/3.0);
    }];
    
    
    UILabel *priceLabel=[[UILabel alloc]init];
    priceLabel.textColor=[UIColor colorWithHexString:@"#444444"];
    priceLabel.text=@"价格:";
    priceLabel.font=font15;
    priceLabel.textAlignment=NSTextAlignmentLeft;
    [priceView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(0);
    }];
    
    yiwaiPrice=[[UILabel alloc]init];
    yiwaiPrice.textColor=[UIColor colorWithHexString:@"#ff4444"];
    yiwaiPrice.font=font15;
    yiwaiPrice.textAlignment=NSTextAlignmentLeft;
    [priceView addSubview:yiwaiPrice];
    [yiwaiPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(priceLabel.mas_right);
    }];
    
    UIView *careView=[[UIView alloc]init];
    [buyyiwaiView addSubview:careView];
    [careView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(separate2.mas_bottom);
        make.height.mas_equalTo(startTimeLabel);
        make.left.mas_equalTo(priceView.mas_right);
        make.width.mas_equalTo((SCREEN_WIDTH-10)/3.0);
    }];
    
    
    UILabel *careLabel=[[UILabel alloc]init];
    careLabel.textColor=[UIColor colorWithHexString:@"#444444"];
    careLabel.text=@"保额:";
    careLabel.font=font15;
    careLabel.textAlignment=NSTextAlignmentLeft;
    [careView addSubview:careLabel];
    [careLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(0);
    }];
    
    yiwaiBaoe=[[UILabel alloc]init];
    yiwaiBaoe.textColor=[UIColor colorWithHexString:@"#ff4444"];
    yiwaiBaoe.font=font15;
    yiwaiBaoe.textAlignment=NSTextAlignmentLeft;
    [careView addSubview:yiwaiBaoe];
    [yiwaiBaoe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(careLabel.mas_right);
    }];
    
    yiwaiStartCare=[[UIButton alloc]init];
    [buyyiwaiView addSubview:yiwaiStartCare];
    [yiwaiStartCare setTitle:@"开始保障" forState:0];
    [yiwaiStartCare setTitleColor:[UIColor whiteColor] forState:0];
    [yiwaiStartCare setBackgroundColor:RGB(231, 231, 232)];
    [yiwaiStartCare setEnabled:NO];
    [yiwaiStartCare.titleLabel setFont:font17];
    [yiwaiStartCare setTag:30001];
    [yiwaiStartCare addTarget:self action:@selector(toCareVC:) forControlEvents:UIControlEventTouchUpInside];
    [yiwaiStartCare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(separate2.mas_bottom);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(careView);
    }];
}


//获取数据
- (void)getData{
    
    [yiwaiStartCare setBackgroundColor:RGB(231, 231, 232)];
    [yiwaiStartCare setEnabled:NO];
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,buyYiwaiCare];
    NSDictionary *dic=@{@"careDayNum":@(yiwaiCareDayNumber),@"startTime":@([[ToolsManager share] getDateTimeTOMilliSeconds:yiwaiStartDate])};
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"statusCode"];
            if (statusCode==400) {
                
            }else{
                yiwaiPrice.text=@"￥ 1.00";
                yiwaiBaoe.text=@"￥ 3000.0";
                [yiwaiStartCare setBackgroundColor:[UIColor colorWithHexString:@"#ffbf54"]];
                [yiwaiStartCare setEnabled:YES];
            }
        }
    } fail:^(NSError *error) {
        int price=arc4random() % 30000;;
        yiwaiPrice.text=@"￥ 1.00";
        yiwaiBaoe.text=[NSString stringWithFormat:@"￥ %d",price];
        [yiwaiStartCare setBackgroundColor:[UIColor colorWithHexString:@"#ffbf54"]];
        [yiwaiStartCare setEnabled:YES];
        self.vauleBlock?self.vauleBlock(yiwaiStartDate,yiwaiCareDayNumber,price):nil;
    } showHud:NO];
}



//意外选择开始保障时间
- (void)yiwaiStartTimeSelected:(UIButton *)sender{
    [self showCalender:@"开始保障日期" selectedTime:yiwaiStartDate];
}

//添加事件选择器
- (void)showCalender:(NSString *)title selectedTime:(NSDate*)selectedDate{
    XWCustomCalendarPickerView *pickView=[[XWCustomCalendarPickerView alloc]initWithTitle:title selectedDate:selectedDate];
    pickView.delegate=self;
    pickView.limitType=LimitMin;
    pickView.MIN_DATE=currentDate;
    self.alertView=[[JCAlertView alloc]initWithCustomView:pickView dismissWhenTouchedBackground:NO];
    [self.alertView show];
    
}


//时间选择器确定事件
- (void)customCalendarPickerView:(XWCustomCalendarPickerView *)customCalendarPickerView notifyNewCalendar:(XWCalendarUtil *)cal{
    NSString *selectedStr=[NSString stringWithFormat:@"%@年%@月%@日",cal.year,cal.month,cal.day];
    NSDate *selectedDate=[[ToolsManager share] stringToDate:selectedStr andFormat:@"yyyy年MM月dd日"];
    if ([[currentDate dateBySubtractingDays:1] isLaterThan:selectedDate]) {
        [MBProgressHUD ToastInformation:@"请选择正确的保障起期"];
        return;
    }
    
    [self.alertView dismissWithCompletion:^{
        NSString *timeStr=[NSString stringWithFormat:@"%@年%@月%@日",cal.year,cal.month,cal.day];
        yiwaiStartDate=[[ToolsManager share] stringToDate:timeStr andFormat:@"yyyy年MM月dd日"];
        [yiwaiStartTimeBtn setTitle:[[ToolsManager share]dateToString:yiwaiStartDate andFormat:@"yyyy年MM月dd日"] forState:0];
        [self getData];
    }];
};

//时间选择器取消事件
- (void)cancelButtomClicked{
    [self.alertView dismissWithCompletion:nil];
};


//选择保障天数
- (void)selectedDay:(UIButton *)sender{
    [selectedYiwaiDayButtom setEnabled:YES];
    [sender setEnabled:NO];
    selectedYiwaiDayButtom=sender;
    switch (sender.tag) {
        case 200000:
            yiwaiCareDayNumber=1;
            careDay.text=@"1天";
            break;
        case 200001:
            yiwaiCareDayNumber=7;
            careDay.text=@"7天";
            break;
        case 200002:
            yiwaiCareDayNumber=15;
            careDay.text=@"15天";
            break;
        case 200003:
            yiwaiCareDayNumber=30;
            careDay.text=@"30天";
            break;
        case 200004:
            yiwaiCareDayNumber=365;
            careDay.text=@"365天";
            break;
        default:
            break;
    }
    [self getData];
}

//开始保障
- (void)toCareVC:(UIButton *)sender{
    if ([[ToolsManager share] isLogin]) {
        //重疾险开始保障
    }else{
        LoginController *login=[[LoginController alloc]init];
        BaseNavigationController *nav=[[BaseNavigationController alloc]initWithRootViewController:login];
        [[[ToolsManager share] getTopViewController:KeyWindow.rootViewController] presentViewController:nav animated:YES completion:nil];
    }
}


//显示
- (void)showInView:(UIView *)view andCurrentDate:(NSDate *)current{
    currentDate=[current dateByAddingDays:1];
    if (![[ToolsManager share] thanNextDay:current twoDate:yiwaiStartDate]) {
        yiwaiStartDate=currentDate;
        [yiwaiStartTimeBtn setTitle:[[ToolsManager share]dateToString:yiwaiStartDate andFormat:@"yyyy年MM月dd日"] forState:0];
    };

    if (view==nil) {
        view=KeyWindow;
    }
    [view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.y=showYiwaiHeightPoint;
    }completion:^(BOOL finished) {
        [self getData];
    }];
};

//隐藏
- (void)hideInView:(UIView *)view{
    if (view==nil) {
        view=KeyWindow;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.y=hideYiwaiHeightPoint;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
};

@end
