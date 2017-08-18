//
//  ZhongjiCareBuyView.m
//  testLineView
//
//  Created by 大家保 on 2017/8/14.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "ZhongjiCareBuyView.h"
#import "XWCustomCalendarPickerView.h"
#define showHeightPoint (SCREEN_HEIGHT-150-64)
#define hideHeightPoint (SCREEN_HEIGHT-54)

@interface ZhongjiCareBuyView ()<XWCustomCalendarPickerViewDelegate>{
    //重疾险购买人性别
    int   selectedSex;
    //重疾险性别选中按钮
    UIButton  *selectedSexButtom;
    //重疾险开始日期
    NSDate    *zhongjiStartDate;
    //当前时间
    NSDate    *currentDate;
    //开始保障
    UIButton *startCare;
}

//重疾险购买视图
@property(nonatomic,strong) UIView    *buyzhongjiView;
//出生日期
@property (nonatomic,strong) UIButton *zhongjiStartTimeBtn;
//重疾险价格
@property (nonatomic,strong) UILabel  *zhongjiPrice;
//重疾险保额
@property (nonatomic,strong) UILabel  *zhongjiBaoe;
//日期选择层
@property (nonatomic,strong) JCAlertView  *alertView;

@end

@implementation ZhongjiCareBuyView

//单例
+ (instancetype)share{
    static ZhongjiCareBuyView *careView=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        careView=[[ZhongjiCareBuyView alloc]init];
        [careView initUI];
    });
    return careView;
};

//界面初始化
- (void)initUI{
    //初始化数据
    currentDate=[[NSDate date] dateByAddingDays:1];
    zhongjiStartDate=[currentDate dateBySubtractingYears:25];
    selectedSex=0;
    
    self.frame=CGRectMake(0, hideHeightPoint, SCREEN_WIDTH, 150);
    
    self.buyzhongjiView=[[UIView alloc]initWithFrame:self.bounds];
    self.buyzhongjiView.backgroundColor=[UIColor whiteColor];
    self.buyzhongjiView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.buyzhongjiView.layer.shadowOffset=CGSizeMake(0, 0);
    self.buyzhongjiView.layer.shadowRadius=15;
    self.buyzhongjiView.layer.shadowOpacity=0.1;
    self.buyzhongjiView.layer.cornerRadius=0;
    [self addSubview:self.buyzhongjiView];
    
    UILabel *sex=[[UILabel alloc]init];
    sex.textColor=[UIColor colorWithHexString:@"#444444"];
    sex.text=@"被保人性别";
    sex.font=font14;
    sex.textAlignment=NSTextAlignmentLeft;
    [self.buyzhongjiView addSubview:sex];
    [sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(49.5);
    }];
    
    UIButton *woMan=[[UIButton alloc]init];
    [woMan setTitle:@"女" forState:0];
    [woMan setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:0];
    [woMan setTitleColor:[UIColor colorWithHexString:@"#1fa2ed"] forState:UIControlStateDisabled];
    [woMan setBackgroundImage:[UIImage imageNamed:@"button-2"] forState:0];
    [woMan setBackgroundImage:[UIImage imageNamed:@"button-1"] forState:UIControlStateDisabled];
    [woMan.titleLabel setFont:font14];
    [woMan setTag:100001];
    [woMan addTarget:self action:@selector(selectedSex:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyzhongjiView addSubview:woMan];
    [woMan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(60);
        make.centerY.mas_equalTo(sex);
    }];
    
    UIButton *man=[[UIButton alloc]init];
    [man setTitle:@"男" forState:0];
    [man setEnabled:NO];
    [man setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:0];
    [man setTitleColor:[UIColor colorWithHexString:@"#1fa2ed"] forState:UIControlStateDisabled];
    [man setBackgroundImage:[UIImage imageNamed:@"button-2"] forState:0];
    [man setBackgroundImage:[UIImage imageNamed:@"button-1"] forState:UIControlStateDisabled];
    [man setTag:100000];
    [man addTarget:self action:@selector(selectedSex:) forControlEvents:UIControlEventTouchUpInside];
    [man.titleLabel setFont:font14];
    selectedSexButtom=man;
    [self.buyzhongjiView addSubview:man];
    [man mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.mas_equalTo(woMan);
        make.right.mas_equalTo(woMan.mas_left).offset(-20);
    }];
    
    UIView *separate1=[[UIView alloc] init];
    separate1.backgroundColor=RGB(239, 242, 245);
    [self.buyzhongjiView addSubview:separate1];
    [separate1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sex.mas_bottom);
        make.left.mas_equalTo(sex);
        make.right.mas_equalTo(woMan);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *borthDay=[[UILabel alloc]init];
    borthDay.textColor=[UIColor colorWithHexString:@"#444444"];;
    borthDay.text=@"出生日期";
    borthDay.font=font14;
    borthDay.textAlignment=NSTextAlignmentLeft;
    [self.buyzhongjiView addSubview:borthDay];
    [borthDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(separate1.mas_bottom);
        make.left.mas_equalTo(sex);
        make.height.mas_equalTo(sex);
    }];
    
    UIButton *zhongjiStartTimeRightBtn=[[UIButton alloc]init];
    [zhongjiStartTimeRightBtn setImage:[UIImage imageNamed:@"you-icon"] forState:0];
    [zhongjiStartTimeRightBtn addTarget:self action:@selector(zhongjiStartTimeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyzhongjiView addSubview:zhongjiStartTimeRightBtn];
    [zhongjiStartTimeRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.mas_equalTo(borthDay);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(26);
    }];
    
    self.zhongjiStartTimeBtn=[[UIButton alloc]init];
    [self.zhongjiStartTimeBtn setTitle:[[ToolsManager share] dateToString:zhongjiStartDate andFormat:@"yyyy年MM月dd日"] forState:0];
    [self.zhongjiStartTimeBtn setTitleColor:[UIColor colorWithHexString:@"#1fa2ed"] forState:0];
    [self.zhongjiStartTimeBtn.titleLabel setFont:font14];
    [self.zhongjiStartTimeBtn addTarget:self action:@selector(zhongjiStartTimeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyzhongjiView addSubview:self.zhongjiStartTimeBtn];
    [self.zhongjiStartTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.mas_equalTo(borthDay);
        make.right.mas_equalTo(zhongjiStartTimeRightBtn.mas_left).offset(0);
    }];
    
    
    UIView *separate2=[[UIView alloc] init];
    separate2.backgroundColor=RGB(239, 242, 245);
    [self.buyzhongjiView addSubview:separate2];
    [separate2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(borthDay.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UIView *priceView=[[UIView alloc]init];
    [self.buyzhongjiView addSubview:priceView];
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(separate2.mas_bottom);
        make.height.mas_equalTo(borthDay);
        make.left.mas_equalTo(borthDay);
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
    
    self.zhongjiPrice=[[UILabel alloc]init];
    self.zhongjiPrice.textColor=[UIColor colorWithHexString:@"#ff4444"];;
    self.zhongjiPrice.font=font15;
    self.zhongjiPrice.textAlignment=NSTextAlignmentLeft;
    [priceView addSubview:self.zhongjiPrice];
    [self.zhongjiPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(priceLabel.mas_right);
    }];
    
    UIView *careView=[[UIView alloc]init];
    [self.buyzhongjiView addSubview:careView];
    [careView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(separate2.mas_bottom);
        make.height.mas_equalTo(borthDay);
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
    
    self.zhongjiBaoe=[[UILabel alloc]init];
    self.zhongjiBaoe.textColor=[UIColor colorWithHexString:@"#ff4444"];
    self.zhongjiBaoe.font=font15;
    self.zhongjiBaoe.textAlignment=NSTextAlignmentLeft;
    [careView addSubview:self.zhongjiBaoe];
    [self.zhongjiBaoe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(careLabel.mas_right);
    }];
    
    startCare=[[UIButton alloc]init];
    [self.buyzhongjiView addSubview:startCare];
    [startCare setTitle:@"开始保障" forState:0];
    [startCare setTitleColor:[UIColor whiteColor] forState:0];
    [startCare setBackgroundColor:RGB(231, 231, 232)];
    [startCare setEnabled:NO];
    [startCare.titleLabel setFont:font17];
    [startCare addTarget:self action:@selector(toCareVC:) forControlEvents:UIControlEventTouchUpInside];
    [startCare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(separate2.mas_bottom);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(careView);
    }];
}

//获取数据
- (void)getData{
    [startCare setBackgroundColor:RGB(231, 231, 232)];
    [startCare setEnabled:NO];
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,buyZhongjiCare];
    NSDictionary *dic=@{@"sex":@(selectedSex),@"borthDate":@([[ToolsManager share] getDateTimeTOMilliSeconds:zhongjiStartDate])};
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"statusCode"];
            if (statusCode==400) {
                
            }else{
                self.zhongjiPrice.text=@"￥ 1.00";
                self.zhongjiBaoe.text=@"￥ 3000.0";
                [startCare setBackgroundColor:[UIColor colorWithHexString:@"#ffbf54"]];
                [startCare setEnabled:YES];
            }
        }
    } fail:^(NSError *error) {
        int price=arc4random() % 50000;;
        self.zhongjiPrice.text=@"￥ 1.00";
        self.zhongjiBaoe.text=[NSString stringWithFormat:@"￥ %d",price];
        [startCare setBackgroundColor:[UIColor colorWithHexString:@"#ffbf54"]];
        [startCare setEnabled:YES];
        self.vauleBlock?self.vauleBlock(currentDate,[[ToolsManager share] getCurrentAllDays:currentDate],price):nil;
    } showHud:NO];
}


//选择性别
- (void)selectedSex:(UIButton *)sender{
    [selectedSexButtom setEnabled:YES];
    [sender setEnabled:NO];
    selectedSexButtom=sender;
    switch (sender.tag) {
        case 100000:
            selectedSex=0;
            break;
        case 100001:
            selectedSex=1;
            break;
        default:
            break;
    }
    [self getData];
}

//重疾选择开始保障日期
- (void)zhongjiStartTimeSelect:(UIButton *)sender{
    [self showCalender:@"出生日期" selectedTime:zhongjiStartDate];
};

//添加事件选择器
- (void)showCalender:(NSString *)title selectedTime:(NSDate*)selectedDate{
    XWCustomCalendarPickerView *pickView=[[XWCustomCalendarPickerView alloc]initWithTitle:title selectedDate:selectedDate];
    pickView.delegate=self;
    pickView.limitType=LimitMax;
    pickView.MAX_DATE=[currentDate dateBySubtractingDays:2];
    self.alertView=[[JCAlertView alloc]initWithCustomView:pickView dismissWhenTouchedBackground:NO];
    [self.alertView show];
}


//时间选择器确定事件
- (void)customCalendarPickerView:(XWCustomCalendarPickerView *)customCalendarPickerView notifyNewCalendar:(XWCalendarUtil *)cal{
    NSString *selectedStr=[NSString stringWithFormat:@"%@年%@月%@日",cal.year,cal.month,cal.day];
    NSDate *selectedDate=[[ToolsManager share] stringToDate:selectedStr andFormat:@"yyyy年MM月dd日"];
    if ([selectedDate isLaterThan:[currentDate dateBySubtractingDays:2]]) {
        [MBProgressHUD ToastInformation:@"请选择合适的出生日期"];
        return;
    }
    [self.alertView dismissWithCompletion:^{
        NSString *timeStr=[NSString stringWithFormat:@"%@年%@月%@日",cal.year,cal.month,cal.day];
        zhongjiStartDate=[[ToolsManager share] stringToDate:timeStr andFormat:@"yyyy年MM月dd日"];
        [self.zhongjiStartTimeBtn setTitle:[[ToolsManager share]dateToString:zhongjiStartDate andFormat:@"yyyy年MM月dd日"] forState:0];
        }];
    [self getData];
};

//时间选择器取消事件
- (void)cancelButtomClicked{
    [self.alertView dismissWithCompletion:nil];
};


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
    if ([[ToolsManager share] thanNextDay:current twoDate:zhongjiStartDate]) {
        zhongjiStartDate=currentDate;
        [self.zhongjiStartTimeBtn setTitle:[[ToolsManager share]dateToString:zhongjiStartDate andFormat:@"yyyy年MM月dd日"] forState:0];
    };
    if (view==nil) {
        view=KeyWindow;
    }
    [view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.y=showHeightPoint;
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
        self.y=hideHeightPoint;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
};

@end
