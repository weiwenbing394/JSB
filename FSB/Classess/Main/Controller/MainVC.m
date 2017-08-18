//
//  MainVC.m
//  FSB
//
//  Created by 大家保 on 2017/7/31.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "MainVC.h"
#import "LineView.h"
#import "ProductCell.h"
#import "YiwaiCareView.h"
#import "ZhongjiCareBuyView.h"

#define tableViewHeight ((SCREEN_WIDTH-20)*278/710.0+30)
#define topWidth        (SCREEN_WIDTH-70)
#define topHeight       (15*topWidth/293.0)

@interface MainVC ()<UITableViewDelegate,UITableViewDataSource>{
    //重疾险折线图
    LineView      *groupOneView;
    //意外险折线图
    LineView      *groupTwoView;
    //总的UIScrollView
    UIScrollView  *myScrollerView;
    //内容视图
    UIView        *contentView;
    //重疾险视图
    UIView        *zhongjixianView;
    //一般医疗金
    UIView        *yibanyiliaoView;
    //种牛保险金
    UIView        *zhongliuView;
    //死亡赔偿金
    UIView        *deadView;
    //意外险视图
    UIView        *yiwaiXianView;
    //意外身故视图
    UIView        *yiwaiOneView;
    //意外医疗报销金
    UIView        *yiwaiTwoView;
    //意外住院补偿金
    UIView        *yiwaiThirdView;
    //重疾险副标题前面图片
    UIImageView   *zhongjiDetailImageView;
    //重疾险副标题
    UILabel       *zhongjiDetailLabel;
    //意外险副标题前面图片
    UIImageView   *yiwaiDetailImageView;
    //意外险副标题
    UILabel       *yiwaiDetailLabel;
     //重疾险选中的年月日按钮
    UIButton      *gropOneSelectedBtn;
    //意外险选中的年月日按钮
    UIButton      *gropTwoSelectedBtn;
    //重疾险选中的年月日按钮下表
    NSInteger     gropOneSelectedTimeIndex;
    //意外险选中的年月日下标
    NSInteger     gropTwoSelectedTimeIndex;
    //重疾保额
    UILabel       *zhongjiBaoeMoney;
    //重疾保障天数
    UIButton      *zhongjiCareDay;
    //意外险保额
    UILabel       *yiwaiBaoeMoney;
    //意外险保障天数
    UIButton      *yiwaiCareDay;
    //保障等级分级图
    UIImageView   *jibieImageView;
    //保障等级更新时间
    UILabel       *updateTime;
    //保障等级比例
    UILabel       *bifen;
    //保障等级条状视图
    UIView        *huadongView;
    //保障等级上方小图片
    UIImageView   *colorUpView;
    //颜色图
    UIImageView   *colorView;
    //已购买重疾险图标
    UIImageView   *buyZhongjiCareImageView;
    //已购买意外险图标
    UIImageView   *buyYiwaiCareImageView;
    //重疾险表格未保障图片
    UIImageView   *zhongjiUnCareImageView;
    //意外险表格未保障图片
    UIImageView   *yiwaiUnCareImageView;
    //当前时间
    NSDate        *currentDate;
    //是否是假的重疾险折线图
    BOOL          jiazhongjia;
    //是否是假的意外险折线图
    BOOL          yiwaijia;
}

@property (nonatomic,strong) JCAlertView    *alertView;

@property (nonatomic,strong) UITableView    *myTableView;

@property (nonatomic,strong) NSMutableArray *tableViewArray;

//重疾险假数据数组
@property (nonatomic,strong) NSMutableArray *zhongjiJiaArray;

//意外险假数据数组
@property (nonatomic,strong) NSMutableArray *yiwaiJiaArray;


@end

static NSString * const productCell=@"productCell";

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    //初始化数据
    currentDate=[NSDate date];
    //currentDate=[[ToolsManager share] stringToDate:@"2017.12.31" andFormat:@"yyyy.MM.dd"];
    gropOneSelectedTimeIndex=0;
    gropTwoSelectedTimeIndex=0;
    //初始化视图
    [self initUI];
    //更改状态
    [self refreshStatus];
}

//获取登录通知
- (void)haveLogin{
    [self refreshStatus];
}

//获取退出通知
- (void)haveLogout{
    [self refreshStatus];
}

//购买成功
- (void)haveBuySuccess{
    
}

//更新视图状态
- (void)refreshStatus{
    if ([[ToolsManager share] isLogin]) {
        [MBProgressHUD showHUDWithTitle:@"加载中..."];
        dispatch_group_t group=dispatch_group_create();
        dispatch_group_enter(group);
        //自动登录
        [self autoLogin:^{
            dispatch_group_leave(group);
        }];
        dispatch_group_enter(group);
        //获取首页产品
        [self getProductList:^{
            dispatch_group_leave(group);
        }];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self endFreshAndLoadMore];
            [MBProgressHUD hiddenHUD];
        });
    }else{
        [MBProgressHUD showHUDWithTitle:@"加载中..."];
        //获取产品
        [self getProductList:^{
            [MBProgressHUD hiddenHUD];
        }];
        //初始化未登录
        [self unLoginStatus];
        
    }
}


//刷新用户数据
- (void)autoLogin:(void (^)())block{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,refreshUserData];
    [XWNetworking getJsonWithUrl:url params:nil success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"statusCode"];
            if (statusCode==400) {
                [self alreadyLogin:block];
            }else{
                NSLog(@"主页自动登录返回的个人数据：%@",response);
                NSString *tokenID=response[@"data"][@"sid"];
                MeModel *me=[MeModel mj_objectWithKeyValues:response[@"data"]];
                [UserDefaults setObject:tokenID forKey:TOKENID ];
                [[ToolsManager share] saveMeModelMessage:me];
                [self alreadyLogin:block];
            }
        }
    } fail:^(NSError *error) {
        [self alreadyLogin:block];
    } showHud:NO];
}

//已登录，刷新数据
- (void)alreadyLogin:(void (^)())block{
    //更改已登录数据
    [self loginToChangeStatus];
    dispatch_group_t group=dispatch_group_create();
    
    dispatch_group_enter(group);
    //获取重疾险表格数据
    [self getZhongjiCareValue:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    //获取意外险表格数据
    [self getYiwaiCareValue:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        block?block():nil;
    });
}


//获取主页产品列表
- (void)getProductList:(void (^)())block{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getHomeProducts];
    [XWNetworking getJsonWithUrl:url params:nil success:^(id response) {
        block?block():nil;
        if (response) {
            NSInteger statusCode=[response integerForKey:@"statusCode"];
            if (statusCode==400) {
                
            }else{
                [self.myTableView reloadData];
            }
        }
    } fail:^(NSError *error) {
        block?block():nil;
    } showHud:NO];
}

//页面布局
- (void)initUI{
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    myScrollerView=[[UIScrollView alloc]init];
    myScrollerView.backgroundColor=[UIColor clearColor];
    myScrollerView.showsVerticalScrollIndicator=NO;
    myScrollerView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:myScrollerView];
    [myScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    contentView=[[UIView alloc]init];
    contentView.backgroundColor=[UIColor clearColor];
    [myScrollerView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIImageView *topImageView=[[UIImageView alloc]init];
    topImageView.image=[UIImage imageNamed:@"slogn"];
    topImageView.contentMode=UIViewContentModeScaleAspectFit;
    [contentView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(topHeight);
        make.top.mas_equalTo(25);
    }];
    
    
    //重疾险
    zhongjixianView=[self catogoryView:@"72种重疾医疗险" price:@"￥1.00/天" switchTintColor:[UIColor colorWithHexString:@"d4f6ff"] switchonTintColor:[UIColor whiteColor] switchthumbTintColor:[UIColor colorWithHexString:@"1fa2ed"] enable:NO ison:NO tag:100 andBackGroundColor:@"blue-bg" buttomTitle:@"提高保障" andBtnTag:7000];
    [contentView addSubview:zhongjixianView];
    [zhongjixianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(95);
        make.top.mas_equalTo(topImageView.mas_bottom).offset(25);
    }];
    
    //重疾险已购买图标
    buyZhongjiCareImageView=[[UIImageView alloc]init];
    buyZhongjiCareImageView.image=[UIImage imageNamed:@"blue-tag"];
    buyZhongjiCareImageView.hidden=YES;
    [contentView addSubview:buyZhongjiCareImageView];
    [buyZhongjiCareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(zhongjixianView.mas_left).offset(20);
        make.width.height.mas_equalTo(30);
        make.bottom.mas_equalTo(zhongjixianView.mas_top).offset(15);
    }];
    
    
    //重疾险副标题左侧图片
    zhongjiDetailImageView=[[UIImageView alloc]init];
    zhongjiDetailImageView.image=[UIImage imageNamed:@"blue-clock"];
    zhongjiDetailImageView.contentMode=UIViewContentModeScaleAspectFit;
    [contentView addSubview:zhongjiDetailImageView];
    [zhongjiDetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(zhongjixianView.mas_left).offset(20);
        make.top.mas_equalTo(zhongjixianView.mas_top).offset(55);
        make.width.height.mas_equalTo(0);
    }];
    
    //重疾险副标题
    zhongjiDetailLabel=[[UILabel alloc]init];
    zhongjiDetailLabel.textColor=[UIColor colorWithHexString:@"#def3fd"];
    zhongjiDetailLabel.font=font12;
    [zhongjixianView addSubview:zhongjiDetailLabel];
    [zhongjiDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(zhongjiDetailImageView.mas_right).offset(5);
        make.top.mas_equalTo(53);
    }];
    
    
    //一般医疗保险金
    yibanyiliaoView=[self createOneDetailView:@"一般医疗保险金" detailStr:@"最高100万" andView:contentView andBGColr:[UIColor colorWithHexString:@"#e2f5fc"] tag:200 contentTag:300 contentStr:@"菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单" spaceViewTag:400 hiddenSeperate:NO separateTag:500 viewTag:600 imageViewTag:700];
    [yibanyiliaoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zhongjixianView.mas_bottom).offset(-3);
    }];
    
    //恶性肿瘤医疗保险金
    zhongliuView=[self createOneDetailView:@"恶性肿瘤保险金" detailStr:@"最高100万" andView:contentView andBGColr:[UIColor colorWithHexString:@"#e2f5fc"] tag:201 contentTag:301 contentStr:@"菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单" spaceViewTag:401 hiddenSeperate:NO separateTag:501 viewTag:601 imageViewTag:701];
    [zhongliuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yibanyiliaoView.mas_bottom);
    }];
    
    
    //意外身故及伤残
    deadView=[self createOneDetailView:@"意外身故及伤残" detailStr:@"最高100万" andView:contentView andBGColr:[UIColor colorWithHexString:@"#e2f5fc"] tag:202 contentTag:302 contentStr:@"菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单" spaceViewTag:402 hiddenSeperate:YES separateTag:502 viewTag:602 imageViewTag:702];
    [deadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zhongliuView.mas_bottom);
    }];
    

    //意外险
    yiwaiXianView=[self catogoryView:@"万能意外险" price:@"￥1.00/天" switchTintColor:[UIColor whiteColor] switchonTintColor:[UIColor colorWithHexString:@"fff8e4"] switchthumbTintColor:[UIColor colorWithHexString:@"ffbd4c"] enable:NO ison:NO tag:101 andBackGroundColor:@"yellow-bg" buttomTitle:@"一键续保" andBtnTag:7001];
    
    [contentView addSubview:yiwaiXianView];
    [yiwaiXianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(95);
        make.top.mas_equalTo(deadView.mas_bottom).offset(25);
    }];
    
    //意外险已购买图标
    buyYiwaiCareImageView=[[UIImageView alloc]init];
    buyYiwaiCareImageView.image=[UIImage imageNamed:@"yellow-tag"];
    buyYiwaiCareImageView.hidden=YES;
    [contentView addSubview:buyYiwaiCareImageView];
    [buyYiwaiCareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yiwaiXianView.mas_left).offset(20);
        make.width.height.mas_equalTo(30);
        make.bottom.mas_equalTo(yiwaiXianView.mas_top).offset(15);
    }];
    
    
    //意外险副标题左侧图片
    yiwaiDetailImageView=[[UIImageView alloc]init];
    yiwaiDetailImageView.image=[UIImage  imageNamed:@"yellow-clock"];
    yiwaiDetailImageView.contentMode=UIViewContentModeScaleAspectFit;
    [contentView addSubview:yiwaiDetailImageView];
    [yiwaiDetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yiwaiXianView.mas_left).offset(20);
        make.top.mas_equalTo(yiwaiXianView.mas_top).offset(55);
        make.width.height.mas_equalTo(0);
    }];
    
    //意外险副标题
    yiwaiDetailLabel=[[UILabel alloc]init];
    yiwaiDetailLabel.textColor=[UIColor whiteColor];
    yiwaiDetailLabel.font=font12;
    [yiwaiXianView addSubview:yiwaiDetailLabel];
    [yiwaiDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yiwaiDetailImageView.mas_right).offset(5);
        make.top.mas_equalTo(53);
    }];
    
    
    
    //意外伤害导致的身故、伤残理赔金
    yiwaiOneView=[self createOneDetailView:@"意外伤害导致的身故、伤残理赔金" detailStr:@"最高100万" andView:contentView andBGColr:RGB(254, 247, 231) tag:203 contentTag:303 contentStr:@"菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单" spaceViewTag:403 hiddenSeperate:NO separateTag:503 viewTag:603 imageViewTag:703];
    [yiwaiOneView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yiwaiXianView.mas_bottom).offset(-3);
    }];
    

    
    //意外伤害导致的医疗费用报销金
    yiwaiTwoView=[self createOneDetailView:@"意外伤害导致的医疗费用报销金" detailStr:@"最高100万" andView:contentView andBGColr:RGB(254, 247, 231) tag:204 contentTag:304 contentStr:@"菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单" spaceViewTag:404 hiddenSeperate:NO separateTag:504 viewTag:604 imageViewTag:704];
    [yiwaiTwoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yiwaiOneView.mas_bottom);
    }];
    
    
    //意外伤害导致住院津贴补偿
    yiwaiThirdView=[self createOneDetailView:@"意外伤害导致住院津贴补偿" detailStr:@"最高100万" andView:contentView andBGColr:RGB(254, 247, 231) tag:205 contentTag:305 contentStr:@"菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单菜单" spaceViewTag:405 hiddenSeperate:YES separateTag:505 viewTag:605 imageViewTag:705];
    [yiwaiThirdView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yiwaiTwoView.mas_bottom);
    }];
    
    
    
    //保障图表块
    UIView *baozhangView=[[UIView alloc]init];
    baozhangView.backgroundColor=[UIColor whiteColor];
    baozhangView.layer.shadowColor=[UIColor blackColor].CGColor;
    baozhangView.layer.shadowOffset=CGSizeMake(0, 0);
    baozhangView.layer.shadowRadius=20;
    baozhangView.layer.shadowOpacity=0.08;
    baozhangView.layer.cornerRadius=5;
    [contentView addSubview:baozhangView];
    [baozhangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yiwaiThirdView.mas_bottom).offset(25);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    UIImageView *youCare=[[UIImageView alloc]init];
    youCare.image=[UIImage imageNamed:@"title-baozhang"];
    [baozhangView addSubview:youCare];
    [youCare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(87);
        make.height.mas_equalTo(16);
    }];
    
    UIImageView *blueImageView=[[UIImageView alloc]init];
    blueImageView.backgroundColor=[UIColor colorWithHexString:@"#1fa2ed"];
    blueImageView.layer.cornerRadius=1.5;
    blueImageView.clipsToBounds=YES;
    [baozhangView addSubview:blueImageView];
    [blueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(youCare.mas_bottom).offset(23);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *zhongjiBaoeLabel=[[UILabel alloc]init];
    zhongjiBaoeLabel.textColor=[UIColor colorWithHexString:@"#444444"];
    zhongjiBaoeLabel.font=font15;
    zhongjiBaoeLabel.text=@"重疾保障";
    [baozhangView addSubview:zhongjiBaoeLabel];
    [zhongjiBaoeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blueImageView.mas_top);
        make.left.mas_equalTo(blueImageView.mas_right).offset(8);
        make.height.mas_equalTo(blueImageView);
   }];
    
    zhongjiBaoeMoney=[[UILabel alloc]init];
    zhongjiBaoeMoney.textColor=[UIColor colorWithHexString:@"#2474a0"];
    zhongjiBaoeMoney.font=font15;
    zhongjiBaoeMoney.text=@"";
    [baozhangView addSubview:zhongjiBaoeMoney];
    [zhongjiBaoeMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blueImageView.mas_top);
        make.left.mas_equalTo(zhongjiBaoeLabel.mas_right).offset(17);
        make.height.mas_equalTo(blueImageView);
    }];
    
    zhongjiCareDay=[[UIButton alloc]init];
    [zhongjiCareDay setTitleColor:[UIColor colorWithHexString:@"#1fa2ed"] forState:0];
    [zhongjiCareDay.titleLabel setFont:font15];
    [zhongjiCareDay setTitle:@"" forState:0];
    [zhongjiCareDay setUserInteractionEnabled:NO];
    [zhongjiCareDay addTarget:self action:@selector(testzhongjiCare:) forControlEvents:UIControlEventTouchUpInside];
    [baozhangView addSubview:zhongjiCareDay];
    [zhongjiCareDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blueImageView.mas_top);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(blueImageView);
    }];
    
    UIView *groupOneSeperate0=[self seperateView];
    [baozhangView addSubview:groupOneSeperate0];
    [groupOneSeperate0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(blueImageView.mas_bottom).offset(27);
    }];
    
    UIButton *monthButton=[self createButtom:@"月" andTag:1001];
    [baozhangView addSubview:monthButton];
    [monthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(groupOneSeperate0);
        make.width.mas_equalTo(48);
        make.right.mas_equalTo(groupOneSeperate0.mas_left);
        make.height.mas_equalTo(groupOneSeperate0);
    }];
    
    UIView *groupOneSeperate1=[self seperateView];
    [baozhangView addSubview:groupOneSeperate1];
    [groupOneSeperate1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(groupOneSeperate0);
        make.width.mas_equalTo(groupOneSeperate0);
        make.top.mas_equalTo(groupOneSeperate0);
        make.right.mas_equalTo(monthButton.mas_left);
    }];
    
    UIButton *dayButton=[self createButtom:@"周" andTag:1000];
    dayButton.selected=YES;
    gropOneSelectedBtn=dayButton;
    [baozhangView addSubview:dayButton];
    [dayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(monthButton);
        make.width.mas_equalTo(monthButton);
        make.right.mas_equalTo(groupOneSeperate1.mas_left);
        make.height.mas_equalTo(monthButton);
    }];
    
   
    
    UIButton *halfYearButton=[self createButtom:@"半年" andTag:1002];
    [baozhangView addSubview:halfYearButton];
    [halfYearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(monthButton);
        make.width.mas_equalTo(monthButton);
        make.left.mas_equalTo(groupOneSeperate0.mas_right);
        make.height.mas_equalTo(monthButton);
    }];
    
    UIView *groupOneSeperate2=[self seperateView];
    [baozhangView addSubview:groupOneSeperate2];
    [groupOneSeperate2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(groupOneSeperate0);
        make.width.mas_equalTo(groupOneSeperate0);
        make.top.mas_equalTo(groupOneSeperate0);
        make.left.mas_equalTo(halfYearButton.mas_right);
    }];
    
    UIButton *yearButton=[self createButtom:@"年" andTag:1003];
    [baozhangView addSubview:yearButton];
    [yearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(monthButton);
        make.width.mas_equalTo(monthButton);
        make.left.mas_equalTo(groupOneSeperate2.mas_right);
        make.height.mas_equalTo(monthButton);
    }];
    
    //重疾险折线视图
    groupOneView=[[LineView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 155)];
    [baozhangView addSubview:groupOneView];
    [groupOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(monthButton.mas_bottom).offset(25);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH-40);
        make.height.mas_equalTo(155);
    }];
    
    zhongjiUnCareImageView=[[UIImageView alloc]init];
    zhongjiUnCareImageView.image=[UIImage imageNamed:@"weibaozhang"];
    zhongjiUnCareImageView.hidden=YES;
    [groupOneView addSubview:zhongjiUnCareImageView];
    [zhongjiUnCareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-11);
        make.centerX.mas_equalTo(25);
        make.width.height.mas_equalTo(65);
    }];
    
    
    UIImageView *xuxian=[[UIImageView alloc]init];
    xuxian.image=[UIImage imageNamed:@"biaoge-xuxian"];
    [baozhangView addSubview:xuxian];
    [xuxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(blueImageView);
        make.right.mas_equalTo(zhongjiCareDay.mas_right);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(groupOneView.mas_bottom).offset(30);
    }];
    

    //意外保障
    UIImageView *yellowImageView=[[UIImageView alloc]init];
    yellowImageView.backgroundColor=[UIColor colorWithHexString:@"ffbf54"];
    yellowImageView.layer.cornerRadius=1.5;
    yellowImageView.clipsToBounds=YES;
    [baozhangView addSubview:yellowImageView];
    [yellowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xuxian.mas_bottom).offset(30);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *yiwaiBaoeLabel=[[UILabel alloc]init];
    yiwaiBaoeLabel.textColor=[UIColor colorWithHexString:@"#444444"];
    yiwaiBaoeLabel.font=font15;
    yiwaiBaoeLabel.text=@"意外保障";
    [baozhangView addSubview:yiwaiBaoeLabel];
    [yiwaiBaoeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yellowImageView.mas_top);
        make.left.mas_equalTo(yellowImageView.mas_right).offset(8);
        make.height.mas_equalTo(yellowImageView);
    }];
    
    yiwaiBaoeMoney=[[UILabel alloc]init];
    yiwaiBaoeMoney.textColor=[UIColor colorWithHexString:@"2474a0"];
    yiwaiBaoeMoney.font=font15;
    yiwaiBaoeMoney.text=@"";
    [baozhangView addSubview:yiwaiBaoeMoney];
    [yiwaiBaoeMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yellowImageView.mas_top);
        make.left.mas_equalTo(yiwaiBaoeLabel.mas_right).offset(17);
        make.height.mas_equalTo(yellowImageView);
    }];
    
    yiwaiCareDay=[[UIButton alloc]init];
    [yiwaiCareDay setTitleColor:[UIColor colorWithHexString:@"#1fa2ed"] forState:0];
    [yiwaiCareDay.titleLabel setFont:font15];
    [yiwaiCareDay setTitle:@"" forState:0];
    [yiwaiCareDay setUserInteractionEnabled:NO];
    [yiwaiCareDay addTarget:self action:@selector(testYiwaiCare:) forControlEvents:UIControlEventTouchUpInside];
    [baozhangView addSubview:yiwaiCareDay];
    [yiwaiCareDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yellowImageView.mas_top);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(yellowImageView);
    }];
    
    UIView *groupTwoSeperate0=[self seperateView];
    [baozhangView addSubview:groupTwoSeperate0];
    [groupTwoSeperate0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(yellowImageView.mas_bottom).offset(27);
    }];
    
    UIButton *twoMonthButton=[self createButtom:@"月" andTag:2001];
    [baozhangView addSubview:twoMonthButton];
    [twoMonthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(groupTwoSeperate0);
        make.width.mas_equalTo(48);
        make.right.mas_equalTo(groupTwoSeperate0.mas_left);
        make.height.mas_equalTo(groupTwoSeperate0);
    }];
    
    UIView *groupTwoSeperate1=[self seperateView];
    [baozhangView addSubview:groupTwoSeperate1];
    [groupTwoSeperate1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(groupTwoSeperate0);
        make.width.mas_equalTo(groupTwoSeperate0);
        make.top.mas_equalTo(groupTwoSeperate0);
        make.right.mas_equalTo(twoMonthButton.mas_left);
    }];
    
    UIButton *twoDayButton=[self createButtom:@"周" andTag:2000];
    twoDayButton.selected=YES;
    gropTwoSelectedBtn=twoDayButton;
    [baozhangView addSubview:twoDayButton];
    [twoDayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(twoMonthButton);
        make.width.mas_equalTo(twoMonthButton);
        make.right.mas_equalTo(groupTwoSeperate1.mas_left);
        make.height.mas_equalTo(twoMonthButton);
    }];
    
    
    
    UIButton *twoHalfYearButton=[self createButtom:@"半年" andTag:2002];
    [baozhangView addSubview:twoHalfYearButton];
    [twoHalfYearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(twoMonthButton);
        make.width.mas_equalTo(twoMonthButton);
        make.left.mas_equalTo(groupTwoSeperate0.mas_right);
        make.height.mas_equalTo(twoMonthButton);
    }];
    
    UIView *groupTwoSeperate2=[self seperateView];
    [baozhangView addSubview:groupTwoSeperate2];
    [groupTwoSeperate2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(groupTwoSeperate0);
        make.width.mas_equalTo(groupTwoSeperate0);
        make.top.mas_equalTo(groupTwoSeperate0);
        make.left.mas_equalTo(twoHalfYearButton.mas_right);
    }];
    
    UIButton *twoYearButton=[self createButtom:@"年" andTag:2003];
    [baozhangView addSubview:twoYearButton];
    [twoYearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(twoMonthButton);
        make.width.mas_equalTo(twoMonthButton);
        make.left.mas_equalTo(groupTwoSeperate2.mas_right);
        make.height.mas_equalTo(twoMonthButton);
    }];
    
    //意外险折线视图
    groupTwoView=[[LineView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 155)];
    [baozhangView addSubview:groupTwoView];
    [groupTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(twoMonthButton.mas_bottom).offset(25);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH-40);
        make.height.mas_equalTo(155);
    }];
    
    yiwaiUnCareImageView=[[UIImageView alloc]init];
    yiwaiUnCareImageView.image=[UIImage imageNamed:@"weibaozhang"];
    yiwaiUnCareImageView.hidden=YES;
    [groupTwoView addSubview:yiwaiUnCareImageView];
    [yiwaiUnCareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-16);
        make.centerX.mas_equalTo(25);
        make.width.height.mas_equalTo(70);
    }];
    
    
    [baozhangView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(groupTwoView.mas_bottom).offset(30);
    }];
    
    UIView *dengjiView=[[UIView alloc]init];
    dengjiView.backgroundColor=[UIColor whiteColor];
    dengjiView.layer.shadowColor=[UIColor blackColor].CGColor;
    dengjiView.layer.shadowOffset=CGSizeMake(0, 0);
    dengjiView.layer.shadowRadius=20;
    dengjiView.layer.shadowOpacity=0.08;
    dengjiView.layer.cornerRadius=5;
    [contentView addSubview:dengjiView];
    [dengjiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(baozhangView.mas_bottom).offset(25);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    UIImageView *dengjiImageView=[[UIImageView alloc]init];
    dengjiImageView.image=[UIImage imageNamed:@"title-dengji"];
    [dengjiView addSubview:dengjiImageView];
    [dengjiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(17);
    }];
    
    
    jibieImageView=[[UIImageView alloc]init];
    [dengjiView addSubview:jibieImageView];
    [jibieImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(dengjiImageView.mas_bottom).offset(24);
        make.height.width.mas_equalTo(120);
    }];
    
    bifen=[[UILabel alloc]init];
    bifen.font=font12;
    [jibieImageView addSubview:bifen];
    [bifen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(23);
    }];
    
    updateTime=[[UILabel alloc]init];
    updateTime.text=@"";
    updateTime.font=font13;
    updateTime.textColor=[UIColor colorWithHexString:@"#888888"];
    [dengjiView addSubview:updateTime];
    [updateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jibieImageView.mas_bottom).offset(20);
        make.height.mas_equalTo(12);
        make.centerX.mas_equalTo(0);
    }];
    
    //分级底图
    UIImageView *tiaozhuangView=[[UIImageView alloc]initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH-56, 10)];
    tiaozhuangView.clipsToBounds=YES;
    tiaozhuangView.image=[UIImage imageNamed:@"jindutiao-bg"];
    [dengjiView addSubview:tiaozhuangView];
    [tiaozhuangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(updateTime.mas_bottom).offset(25);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH-56);
        make.centerX.mas_equalTo(0);
    }];
    
    //图片切割的父图
    huadongView=[[UIView alloc]initWithFrame:tiaozhuangView.bounds];
    huadongView.clipsToBounds=YES;
    [tiaozhuangView addSubview:huadongView];
    
    //A,B,C,D的切图
    colorView=[[UIImageView alloc]initWithFrame:tiaozhuangView.bounds];
    [huadongView addSubview:colorView];
    
    //A,B,C,D的切图上方图
    colorUpView=[[UIImageView alloc]init];
    [dengjiView addSubview:colorUpView];
    [colorUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tiaozhuangView);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(24);
        make.left.mas_equalTo(huadongView.width+6);
    }];
    
    
    UIImageView *fenjiImagView=[[UIImageView alloc]init];
    fenjiImagView.image=[UIImage imageNamed:@"ABCD"];
    [dengjiView addSubview:fenjiImagView];
    [fenjiImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(tiaozhuangView.mas_bottom).offset(24);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(74);
    }];
    
    [dengjiView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(fenjiImagView.mas_bottom).offset(15);
    }];
    
    [contentView addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(dengjiView.mas_bottom).offset(15);
        make.height.mas_equalTo(15+(tableViewHeight+15)*self.tableViewArray.count);
    }];
    [self.myTableView reloadData];
    

    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.myTableView.mas_bottom).offset(0);
    }];
    
    //添加下拉刷新
    [self addMJheader];
}

//未登录时候的状态
- (void)unLoginStatus{
    
    UISwitch *groupOneSwitch=[zhongjixianView viewWithTag:100];
    
    UISwitch *groupTwoSwitch=[yiwaiXianView viewWithTag:101];
    
    [groupOneSwitch setUserInteractionEnabled:YES];
        
    [groupTwoSwitch setUserInteractionEnabled:YES];
        
    [groupOneSwitch setOn:NO];
    
    [groupTwoSwitch setOn:NO];
    
    [self changeGroupOneStatus:0];
    
    [self changeGroupTwoStatus:0];
    
    [zhongjixianView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(95);
    }];
    
    for (id view in zhongjixianView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *xuxian=(UIImageView *)view;
            [xuxian mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(95);
            }];
        }
    }
    
    [yiwaiXianView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(95);
    }];
    
    for (id view in yiwaiXianView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *xuxian=(UIImageView *)view;
            [xuxian mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(95);
            }];
        }
    }
    
    [zhongjiDetailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(0);
    }];
    
    zhongjiDetailLabel.text=@"每天增加1000元 保额累计达50万";
    
    [zhongjiDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(zhongjiDetailImageView.mas_right).offset(0);
        
    }];
    
    [yiwaiDetailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(0);
    }];
    
    yiwaiDetailLabel.text=@"驾车 运动 旅游 出差 打开就保 安全神器";
    
    [yiwaiDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yiwaiDetailImageView.mas_right).offset(0);
        
    }];
    
    buyZhongjiCareImageView.hidden=YES;
    
    buyYiwaiCareImageView.hidden=YES;
    
    zhongjiBaoeMoney.text=@"保额 0";
    
    [zhongjiCareDay setTitle:@"测试你的重疾保障" forState:0];
    
    [zhongjiCareDay setUserInteractionEnabled:YES];
    
    yiwaiBaoeMoney.text=@"保额 0";
    
    [yiwaiCareDay setTitle:@"测测你得意外保障" forState:0];
    
    [yiwaiCareDay setUserInteractionEnabled:YES];
    
    [self changeDengji:@"D" number:1 textColor:RGB(239, 53, 52) date:currentDate];
    
    [self hideYiwaiView];
    
    [self hideZhongjiView];
    
    [self zhongjiCareUnLogin];
    
    [self yiwaiCareUnLogin];

}

//登录成功后改变状态
- (void)loginToChangeStatus{
    
    UISwitch *groupOneSwitch=[zhongjixianView viewWithTag:100];
    
    UISwitch *groupTwoSwitch=[yiwaiXianView viewWithTag:101];
    
    //如果用户已经登录
    if ([[ToolsManager share] isLogin]) {
        
        //如果已经购买了重疾险
        if ([[ToolsManager share] haveBuyZhongjiCare]) {
            
            [groupOneSwitch setUserInteractionEnabled:NO];
            
            [groupOneSwitch setOn:YES];
            
            [zhongjixianView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(133);
            }];
            
            for (id view in zhongjixianView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    UIImageView *xuxian=(UIImageView *)view;
                    [xuxian mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(85);
                    }];
                }
            }
            
            buyZhongjiCareImageView.hidden=NO;
            
            [self changeGroupOneStatus:0];
            
            [zhongjiDetailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(12);
            }];
            
            zhongjiDetailLabel.text=[NSString stringWithFormat:@"将于%@终止保障",[[ToolsManager share] timeToString:1000000000000 formatterType:@"yyyy年MM月dd日 HH:mm:ss"]];
            
            [zhongjiDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(zhongjiDetailImageView.mas_right).offset(5);
                
            }];
            
            zhongjiBaoeMoney.text=@"保额 10000";
            
            [zhongjiCareDay setTitle:@"保障你的第8天" forState:0];
            
            [zhongjiCareDay setUserInteractionEnabled:NO];
            
         }else{
            
            [groupOneSwitch setUserInteractionEnabled:YES];
            
            [zhongjixianView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(95);
            }];
             
             for (id view in zhongjixianView.subviews) {
                 if ([view isKindOfClass:[UIImageView class]]) {
                     UIImageView *xuxian=(UIImageView *)view;
                     [xuxian mas_updateConstraints:^(MASConstraintMaker *make) {
                         make.top.mas_equalTo(95);
                     }];
                 }
             }
             
             buyZhongjiCareImageView.hidden=YES;
             
             [zhongjiDetailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.height.width.mas_equalTo(0);
             }];
             
             zhongjiDetailLabel.text=@"每天增加1000元 保额累计达50万";
             
             [zhongjiDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.left.mas_equalTo(zhongjiDetailImageView.mas_right).offset(0);
                 
             }];
             
             zhongjiBaoeMoney.text=@"保额 0";
             
             [zhongjiCareDay setTitle:@"测试你的重疾保障" forState:0];
             
             [zhongjiCareDay setUserInteractionEnabled:YES];
             
       }
        
        //如果已经购买了意外险
        if ([[ToolsManager share] haveBuyYiwaiCare]) {
            
            [groupTwoSwitch setUserInteractionEnabled:NO];
            
            [groupTwoSwitch setOn:YES];
            
            [yiwaiXianView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(133);
            }];
            
            for (id view in yiwaiXianView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    UIImageView *xuxian=(UIImageView *)view;
                    [xuxian mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(85);
                    }];
                }
            }
            
            buyYiwaiCareImageView.hidden=NO;
            
            [self changeGroupTwoStatus:0];
            
            [yiwaiDetailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(12);
            }];
            
            yiwaiDetailLabel.text=[NSString stringWithFormat:@"将于%@终止保障",[[ToolsManager share] timeToString:1000000000000 formatterType:@"yyyy年MM月dd日 HH:mm:ss"]];
            
            [yiwaiDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(yiwaiDetailImageView.mas_right).offset(5);
            }];
            
            yiwaiBaoeMoney.text=@"保额 10000";
            
            [yiwaiCareDay setTitle:@"保障你的第7天" forState:0];
            
            [yiwaiCareDay setUserInteractionEnabled:NO];
            
        }else{
            
            [groupTwoSwitch setUserInteractionEnabled:YES];
            
            [yiwaiXianView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(95);
            }];
            
            for (id view in yiwaiXianView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    UIImageView *xuxian=(UIImageView *)view;
                    [xuxian mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(95);
                    }];
                }
            }
            
            buyYiwaiCareImageView.hidden=YES;
            
            [yiwaiDetailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(0);
            }];
            
            yiwaiDetailLabel.text=@"驾车 运动 旅游 出差 打开就保 安全神器";
            
            [yiwaiDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(yiwaiDetailImageView.mas_right).offset(0);
                
            }];
            
            yiwaiBaoeMoney.text=@"保额 0";
            
            [yiwaiCareDay setTitle:@"测测你得意外保障" forState:0];
            
            [yiwaiCareDay setUserInteractionEnabled:YES];
        }
        
        int i=40;
        
        if (i<=25) {
            
            [self changeDengji:@"D" number:i textColor:RGB(239, 53, 52) date:currentDate];
            
        }else if (i<=50){
            
            [self changeDengji:@"C" number:i textColor:[UIColor colorWithHexString:@"#FF853D"] date:currentDate];
        
        }else if (i<=75){
            
            [self changeDengji:@"B" number:i textColor:[UIColor colorWithHexString:@"#FFD118"] date:currentDate];
            
        }else{
            
            [self changeDengji:@"A" number:i textColor:[UIColor colorWithHexString:@"#91E140"] date:currentDate];
        }
        
     }
    
}

//根据比分计算等级
- (void)changeDengji:(NSString *)str number:(int)number textColor:(UIColor *)color date:(NSDate *)date{
    
    jibieImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"dengji-%@",str]];
    
    if (number<=50) {
        bifen.text=[NSString stringWithFormat:@"低于%d%@用户",100-number,@"%"];
    }else{
        bifen.text=[NSString stringWithFormat:@"高于%d%@用户",number,@"%"];
    }
    
    bifen.textColor=color;
    
    updateTime.text=[NSString stringWithFormat:@"更新时间：%@",[[ToolsManager share] dateToString:date andFormat:@"yyyy/MM/dd  HH:mm"]];
    
    huadongView.width=(SCREEN_WIDTH-56)*number/100.0;
    
    colorView.image=[UIImage imageNamed:[NSString stringWithFormat:@"jindutiao-%@",str]];
    
    colorUpView.image=[UIImage imageNamed:[NSString stringWithFormat:@"dun-%@",str]];
    
    [colorUpView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(huadongView.width+6);
    }];
}

//重疾险未登录未购买折线配置
- (void)zhongjiCareUnLogin{
    zhongjiUnCareImageView.hidden=NO;
    switch (gropOneSelectedTimeIndex) {
        case 0:
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] weekArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"10000",@"20000",@"30000",@"40000",@"50000", nil] ValueArray:nil index:[[ToolsManager share] getNowWeekday:currentDate]];
            break;
        case 1:
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] monthArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"10000",@"20000",@"30000",@"40000",@"50000", nil] ValueArray:nil index:[[ToolsManager share] getNowMonthday:currentDate]];
            break;
        case 2:
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] halfYearArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"10000",@"20000",@"30000",@"40000",@"50000", nil] ValueArray:nil index:[[ToolsManager share] getNowHalfYearday:currentDate]];
            break;
        case 3:
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] yearArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"10000",@"20000",@"30000",@"40000",@"50000", nil] ValueArray:nil index:[[ToolsManager share] getNowYearday:currentDate]];
            break;
            
        default:
            break;
    }
}

//重疾险已购买折线配置
- (void)zhongjiCareLogin:(NSMutableArray *)yArray  valueArray:(NSMutableArray *)valueArray{
    switch (gropOneSelectedTimeIndex) {
        case 0:
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] weekArray:currentDate] yArray:yArray ValueArray:valueArray index:[[ToolsManager share] getNowWeekday:currentDate]];
            break;
        case 1:
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] monthArray:currentDate] yArray:yArray ValueArray:valueArray index:[[ToolsManager share] getNowMonthday:currentDate]];
            break;
        case 2:
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] halfYearArray:currentDate] yArray:yArray ValueArray:valueArray index:[[ToolsManager share] getNowHalfYearday:currentDate]];
            break;
        case 3:
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] yearArray:currentDate] yArray:yArray ValueArray:valueArray index:[[ToolsManager share] getNowYearday:currentDate]];
            break;
            
        default:
            break;
    }
}


//重疾险折线图配置
- (void)zhongjiCareZhexianWithXarrar:(NSMutableArray *)xArray yArray:(NSMutableArray *)yArray ValueArray:(NSMutableArray *)valueArray index:(NSInteger)index{
    
    groupOneView.xArray=xArray;
    groupOneView.yArray=yArray;
    groupOneView.dataArr =[self caluleteMultiple:valueArray yArray:yArray];
    groupOneView.xtitleColor=[UIColor colorWithHexString:@"#888888"];
    groupOneView.ytitleColor=[UIColor colorWithHexString:@"#888888"];
    groupOneView.xlineColor=[UIColor colorWithHexString:@"#f5f7fa"];
    groupOneView.tableViewBgColor=[UIColor clearColor];
    groupOneView.btnLineColor=[UIColor colorWithHexString:@"#1fa2ed"];
    [groupOneView setBtnColor:[UIColor colorWithHexString:@"#1fa2ed"] atIndex:index];
    groupOneView.tableViewBgColor=[UIColor clearColor];
    groupOneView.fillColorArray=@[(__bridge id)[[UIColor colorWithHexString:@"#1fa2ed"] colorWithAlphaComponent:0.1].CGColor,(__bridge id)[[UIColor colorWithHexString:@"#1fa2ed"] colorWithAlphaComponent:0].CGColor];
}

//意外险未登录未登录折线配置
- (void)yiwaiCareUnLogin{
    switch (gropTwoSelectedTimeIndex) {
        case 0:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] weekArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"6000",@"12000",@"18000",@"24000",@"30000", nil] ValueArray:nil index:[[ToolsManager share] getNowWeekday:currentDate]];
            break;
        case 1:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] monthArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"6000",@"12000",@"18000",@"24000",@"30000", nil] ValueArray:nil index:[[ToolsManager share] getNowMonthday:currentDate]];
            break;
        case 2:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] halfYearArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"6000",@"12000",@"18000",@"24000",@"30000", nil] ValueArray:nil index:[[ToolsManager share] getNowHalfYearday:currentDate]];
            break;
        case 3:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] yearArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"6000",@"12000",@"18000",@"24000",@"30000", nil] ValueArray:nil index:[[ToolsManager share] getNowYearday:currentDate]];
            break;
        default:
            break;
    }
    yiwaiUnCareImageView.hidden=NO;
}


//意外险已购买折线配置
- (void)yiwaiCareLogin:(NSMutableArray *)yArray  valueArray:(NSMutableArray *)valueArray{
    switch (gropTwoSelectedTimeIndex) {
        case 0:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] weekArray:currentDate] yArray:yArray ValueArray:valueArray index:[[ToolsManager share] getNowWeekday:currentDate]];
            break;
        case 1:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] monthArray:currentDate] yArray:yArray ValueArray:valueArray index:[[ToolsManager share] getNowMonthday:currentDate]];
            break;
        case 2:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] halfYearArray:currentDate] yArray:yArray ValueArray:valueArray index:[[ToolsManager share] getNowHalfYearday:currentDate]];
            break;
        case 3:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] yearArray:currentDate] yArray:yArray ValueArray:valueArray index:[[ToolsManager share] getNowYearday:currentDate]];
            break;
        default:
            break;
    }
}


//意外险折线图配置
- (void)yiwaiCareZhexianWithXarrar:(NSMutableArray *)xArray yArray:(NSMutableArray *)yArray ValueArray:(NSMutableArray *)valueArray index:(NSInteger)index{
    
    groupTwoView.xArray=xArray;
    groupTwoView.yArray=yArray;
    groupTwoView.dataArr =[self caluleteMultiple:valueArray yArray:yArray];
    groupTwoView.xtitleColor=[UIColor colorWithHexString:@"#888888"];
    groupTwoView.ytitleColor=[UIColor colorWithHexString:@"#888888"];
    groupTwoView.xlineColor=[UIColor colorWithHexString:@"#f5f7fa"];
    groupTwoView.tableViewBgColor=[UIColor clearColor];
    groupTwoView.btnLineColor=[UIColor colorWithHexString:@"#ffbf54"];
    [groupTwoView setBtnColor:[UIColor colorWithHexString:@"#ffbf54"] atIndex:index];
    groupTwoView.tableViewBgColor=[UIColor clearColor];
    groupTwoView.fillColorArray=@[(__bridge id)[[UIColor colorWithHexString:@"#ffbf54"] colorWithAlphaComponent:0.1].CGColor,(__bridge id)[[UIColor colorWithHexString:@"#ffbf54"] colorWithAlphaComponent:0].CGColor];
}

//重疾险 更改二级菜单的约束
- (void)changeGroupOneStatus:(NSInteger)height1{
    
    for (int i=600; i<=602; i++) {
        UIView *erjiView=[contentView viewWithTag:i];
        UIView *brotherView;
        if (i>600) {
            brotherView=[contentView viewWithTag:i-1];
        }
        [erjiView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (i==600) {
                make.top.mas_equalTo(zhongjixianView.mas_bottom).offset(-3);
            }else{
                make.top.mas_equalTo(brotherView.mas_bottom);
            }
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(height1);
        }];
        
        for (id view in erjiView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn=(UIButton *)view;
                btn.selected=NO;
                for (id imageView in btn.subviews) {
                    if ([imageView isKindOfClass:[UIImageView class]]) {
                        UIImageView *image=(UIImageView *)imageView;
                        image.highlighted=NO;
                    }
                }
            }
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *sepa=(UILabel *)view;
                if (sepa.tag==erjiView.tag-100) {
                    [sepa mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(15);
                        make.right.mas_equalTo(-15);
                        make.height.mas_equalTo(0.5);
                        make.top.mas_equalTo(erjiView.mas_bottom).offset(-0.5);
                    }];
                }
            }
        }
    }
    
    [super updateViewConstraints];
}

//意外险 更改二级菜单的约束
- (void)changeGroupTwoStatus:(NSInteger)height1{
    
    for (int i=603; i<=605; i++) {
        UIView *erjiView=[contentView viewWithTag:i];
        UIView *brotherView;
        if (i>603) {
            brotherView=[contentView viewWithTag:i-1];
        }
        [erjiView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (i==603) {
                make.top.mas_equalTo(yiwaiXianView.mas_bottom).offset(-3);
            }else{
                make.top.mas_equalTo(brotherView.mas_bottom);
            }
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(height1);
        }];
        
        for (id view in erjiView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn=(UIButton *)view;
                btn.selected=NO;
                for (id imageView in btn.subviews) {
                    if ([imageView isKindOfClass:[UIImageView class]]) {
                        UIImageView *image=(UIImageView *)imageView;
                        image.highlighted=NO;
                    }
                }
            }
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *sepa=(UILabel *)view;
                if (sepa.tag==erjiView.tag-100) {
                    [sepa mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(15);
                        make.right.mas_equalTo(-15);
                        make.height.mas_equalTo(0.5);
                        make.top.mas_equalTo(erjiView.mas_bottom).offset(-0.5);
                    }];
                }
            }
        }
    }
    
    [super updateViewConstraints];

}

//测试重疾险
- (void)testzhongjiCare:(UIButton *)sender{
    UISwitch *groupOneSwitch=[zhongjixianView viewWithTag:100];
    [self switchAction2:groupOneSwitch];
}

//测试意外险
- (void)testYiwaiCare:(UIButton *)sender{
    UISwitch *groupTwoSwitch=[yiwaiXianView viewWithTag:101];
    [self switchAction2:groupTwoSwitch];
}

//手动切换
-(void)switchAction2:(UISwitch *)switchButton{
    [switchButton setOn:!switchButton.isOn];
    [self switchAction:switchButton];
}


//切换控制
-(void)switchAction:(UISwitch *)switchButton{
    
    UISwitch *groupOneSwitch=[zhongjixianView viewWithTag:100];
    
    UISwitch *groupTwoSwitch=[yiwaiXianView viewWithTag:101];
    
    //重疾险开关
    if (switchButton.tag==100) {
        
        if (switchButton.isOn) {
            
            [self changeGroupOneStatus:45];
            
            [self showZhongjiView];
            
            //已登录并且已购买意外险
            if ([[ToolsManager share] isLogin]&&[[ToolsManager share] haveBuyYiwaiCare]) {
                
            }else{
                
                if (groupTwoSwitch.isOn) {
                    
                    [groupTwoSwitch setOn:NO];
                    
                    [self hideYiwaiView];
                    
                    if (groupTwoSwitch.isOn) {
                        
                        [self changeGroupTwoStatus:45];
                        
                    }else{
                        
                        [self changeGroupTwoStatus:0];
                        
                    }
                    
                }
                
            }
            
        }else{
            
            [self changeGroupOneStatus:0];
            
            [self hideZhongjiView];
        }
      
    //意外险开关
    }else if (switchButton.tag==101){
        
        if (switchButton.isOn) {
            
            [self changeGroupTwoStatus:45];
            
            [self showYiwaiView];
            
            //已登录并且已购买重疾险
            if ([[ToolsManager share] isLogin]&&[[ToolsManager share] haveBuyZhongjiCare]) {
                
            }else{
                
                if ([groupOneSwitch isOn]) {
                    
                    [groupOneSwitch setOn:NO];
                    
                    [self hideZhongjiView];
                    
                    if (groupOneSwitch.isOn) {
                        
                        [self changeGroupOneStatus:45];
                        
                    }else{
                        
                        [self changeGroupOneStatus:0];
                        
                    }
                    
                }
                
            }
            
        }else{
            
            [self changeGroupTwoStatus:0];
            
            [self hideYiwaiView];
        }
        
    }
}

//打开或者关闭三级菜单
- (void)openOrClose:(UIButton *)sender{
    //二级菜单按钮
    sender.selected=!sender.selected;
    //二级菜单
    UIView *fuView=[sender superview];
    //三级菜单底部填充菜单
    UIView *spaceView=[fuView viewWithTag:sender.tag+200];
    //分割线
    UIView *sepateView=[fuView viewWithTag:sender.tag+300];
    //同级兄弟菜单
    UIView *brotherView=[contentView viewWithTag:fuView.tag-1];
    //图片指示器
    UIImageView *image=[sender viewWithTag:sender.tag+500];
    image.highlighted=sender.selected;
    
    if (sender.selected) {
        [fuView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (sender.tag==200) {
                make.top.mas_equalTo(zhongjixianView.mas_bottom).offset(-3);
            }else if (sender.tag==203){
                make.top.mas_equalTo(yiwaiXianView.mas_bottom).offset(-3);
            }else{
                make.top.mas_equalTo(brotherView.mas_bottom);
            }
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(spaceView.mas_bottom).offset(0.5);
        }];
        [sepateView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(spaceView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
    }else{
        [fuView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (sender.tag==200) {
                make.top.mas_equalTo(zhongjixianView.mas_bottom).offset(-3);
            }else if (sender.tag==203){
                make.top.mas_equalTo(yiwaiXianView.mas_bottom).offset(-3);
            }else{
                make.top.mas_equalTo(brotherView.mas_bottom);
            }
            make.height.mas_equalTo(45);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        [sepateView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(fuView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
    }
}



#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        if ([[ToolsManager share] isLogin]) {
            [self refreshStatus];
        }else{
            //获取产品
            [self getProductList:^{
                [self endFreshAndLoadMore];
            }];
        }
    }];
    myScrollerView.mj_header=mjHeader;
}

#pragma mark 关闭mjrefreshing
- (void)endFreshAndLoadMore{
    [myScrollerView.mj_header endRefreshing];
}


#pragma mark 布局
//分类标题
- (UIView  *)catogoryView:(NSString *)titleStr price:(NSString *)priceStr switchTintColor:(UIColor *)tColor  switchonTintColor:(UIColor *)onColor switchthumbTintColor:(UIColor *)thumbTintColor enable:(BOOL)enable ison:(BOOL)checked tag:(NSInteger)tag andBackGroundColor:(NSString *)bgColor buttomTitle:(NSString *)btnTitleStr andBtnTag:(NSInteger)btnTag{
    
    UIView *bgView=[[UIView alloc]init];
    bgView.clipsToBounds=YES;
    bgView.layer.contents=(id)[UIImage resizedImage:bgColor].CGImage;
    
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=titleStr;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=font16;
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.left.mas_equalTo(20);
    }];
    
    UILabel *priceLabel=[[UILabel alloc]init];
    priceLabel.text=priceStr;
    priceLabel.textColor=[UIColor colorWithHexString:@"ff7f57"];
    priceLabel.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    priceLabel.font=font14;
    priceLabel.layer.cornerRadius=10;
    priceLabel.clipsToBounds=YES;
    priceLabel.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel);
        make.left.mas_equalTo(titleLabel.mas_right).offset(7);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    UISwitch *switchButtom=[[UISwitch alloc]init];
    switchButtom.tintColor=tColor;
    switchButtom.onTintColor=onColor;
    switchButtom.thumbTintColor=thumbTintColor;
    [switchButtom setUserInteractionEnabled:enable];
    [switchButtom setOn:checked];
    [bgView addSubview:switchButtom];
    switchButtom.tag=tag;
    [switchButtom addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [switchButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(titleLabel);
    }];
    
    UIImageView *whiteSperateView=[[UIImageView alloc]init];
    whiteSperateView.image=[UIImage imageNamed:@"biaoge-xuxian"];
    [bgView addSubview:whiteSperateView];
    [whiteSperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(95);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *caozuoButtom=[self createBuyButtom:btnTitleStr andTag:btnTag];
    [bgView addSubview:caozuoButtom];
    [caozuoButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(whiteSperateView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    return bgView;
}


#pragma mark 二级菜单
//二级菜单
- (UIView *)createOneDetailView:(NSString *)titleStr detailStr:(NSString *)detailStr  andView:(UIView *)view andBGColr:(UIColor*)bgColor tag:(NSInteger)tag contentTag:(NSInteger)contentTag contentStr:(NSString *)contentStr spaceViewTag:(NSInteger)spaceTag hiddenSeperate:(BOOL)hide separateTag:(NSInteger)sepeTag viewTag:(NSInteger)selfTag imageViewTag:(NSInteger)imageTag{
    
    UIView *erjiView=[[UIView alloc]init];
    erjiView.tag=selfTag;
    erjiView.clipsToBounds=YES;
    [view addSubview:erjiView];
    [erjiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=titleStr;
    titleLabel.textColor=[UIColor colorWithHexString:@"#444444"];
    titleLabel.font=font13;
    [erjiView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(44.5);
        make.left.mas_equalTo(15);
    }];
    
    UIButton *clickButtom=[[UIButton alloc]init];
    clickButtom.tag=tag;
    [clickButtom addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
    [clickButtom setTitle:[NSString stringWithFormat:@"%@   ",detailStr] forState:0];
    [clickButtom.titleLabel setFont:font13];
    [clickButtom setTitleColor:[UIColor colorWithHexString:@"#1fa2ed"] forState:0];
    [erjiView addSubview:clickButtom];
    [clickButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(titleLabel);
    }];
    [clickButtom.titleLabel setNeedsUpdateConstraints];
    
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.tag=imageTag;
    imageView.image=[UIImage imageNamed:@"upturning"];
    imageView.highlightedImage=[UIImage imageNamed:@"up"];
    [clickButtom addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(9);
        make.height.mas_equalTo(5);
    }];
    
    UILabel *thirdContentView=[self createThirdView:contentStr andTag:contentTag];
    [erjiView addSubview:thirdContentView];
    [thirdContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(titleLabel.mas_bottom);
    }];
    
    UIView *spaceView=[self thirdSpaceView:spaceTag];
    [erjiView addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(thirdContentView.mas_bottom);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *seperate=[[UILabel alloc]init];
    if (hide) {
        seperate.backgroundColor=[UIColor clearColor];
        if (tag>=203) {
            erjiView.layer.contents=(id)[UIImage resizedImage:@"yellow-bg3"].CGImage;
        }else{
            erjiView.layer.contents=(id)[UIImage resizedImage:@"blue-bg3"].CGImage;
        }
    }else{
        erjiView.backgroundColor=bgColor;
        if (sepeTag>=503) {
            seperate.backgroundColor=[UIColor colorWithHexString:@"#e7e5e1"];
        }else{
            seperate.backgroundColor=[UIColor colorWithHexString:@"#d9e8e8"];
        }
    }
    seperate.tag=sepeTag;
    [erjiView addSubview:seperate];
    [seperate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    return erjiView;
}

//三级菜单
- (UILabel *)createThirdView:(NSString *)content andTag:(NSInteger)tag{
    
    UILabel *thirdTitle=[[UILabel alloc]init];
    thirdTitle.textColor=[UIColor colorWithHexString:@"#7a7a7a"];
    thirdTitle.font=font12;
    thirdTitle.tag=tag;
    thirdTitle.numberOfLines=0;
    thirdTitle.text=content;
    
    return thirdTitle;
}

//三级菜单下空白占位页面
- (UIView *)thirdSpaceView:(NSInteger)tag{
    UIView *view=[[UIView alloc]init];
    view.tag=tag;
    view.backgroundColor=[UIColor clearColor];
    return view;
}

//创建购买按钮
- (UIButton *)createBuyButtom:(NSString *)str andTag:(NSInteger)tag{
    UIButton *button=[[UIButton alloc]init];
    [button setTitle:str forState:0];
    [button.titleLabel setFont:font14];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.tag=tag;
    [button addTarget:self action:@selector(toBuy:) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setNeedsUpdateConstraints];
    return button;
}

//创建周，月，半年，年按钮
- (UIButton *)createButtom:(NSString *)buttomTitle andTag:(NSInteger)tag{
    UIButton *button=[[UIButton alloc]init];
    [button setTitle:buttomTitle forState:0];
    [button.titleLabel setFont:font14];
    [button setTitleColor:[UIColor colorWithHexString:@"#b2b9bf"] forState:0];
    [button setTitleColor:[UIColor colorWithHexString:@"1fa2ed"] forState:UIControlStateSelected];
    button.tag=tag;
    [button addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//年月日中间按钮分割线
- (UIView *)seperateView{
    UIView *seperateView=[[UIView alloc]init];
    seperateView.backgroundColor=[UIColor colorWithHexString:@"#ccd3dc"];
    return seperateView;
}

//懒加载
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor=[UIColor clearColor];
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.backgroundColor=RGB(239, 242, 245);
        _myTableView.sectionHeaderHeight=0.0001;
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_myTableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:productCell];
        _myTableView.scrollEnabled=NO;
        
    }
    return _myTableView;
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductCell *cell=[tableView dequeueReusableCellWithIdentifier:productCell];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableViewHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableViewArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[ToolsManager share] isLogin]) {
        
    }else{
        [self toLoginVC];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    footView.backgroundColor=[UIColor clearColor];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    footView.backgroundColor=[UIColor clearColor];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 15;
    }else{
        return 0.001;
    }
    
}

//计算百分比
- (NSMutableArray *)caluleteMultiple:(NSArray *)arr yArray:(NSArray *)yMaxArray{
    CGFloat maxValue = [[yMaxArray valueForKeyPath:@"@max.floatValue"] floatValue];
    NSMutableArray *endArray=[NSMutableArray array];
    for (id value in arr) {
        CGFloat multipleValue=1.0-[value floatValue]/maxValue;
        multipleValue=multipleValue>=1.0?1.0:multipleValue;
        multipleValue=multipleValue<=0?0:multipleValue;
        
        NSString *stringVlue=[NSString stringWithFormat:@"%f",multipleValue];
        [endArray addObject:stringVlue];
    }
    return endArray;
}

//周，月，半年，年切换
- (void)selectTime:(UIButton *)sender{
    if (sender.tag<2000) {
        if (sender==gropOneSelectedBtn) {
            return;
        }
        gropOneSelectedBtn.selected=NO;
        sender.selected=YES;
        gropOneSelectedBtn=sender;
        gropOneSelectedTimeIndex=sender.tag-1000;
        if ([[ToolsManager share] haveBuyZhongjiCare]) {
             [self getZhongjiCareValue:nil];
        }else if (jiazhongjia) {
            [self zhongjiJiaCareUnLogin];
        }else if (![[ToolsManager share] isLogin]) {
            [self zhongjiCareUnLogin];
        }
    }else{
        if (sender==gropTwoSelectedBtn) {
            return;
        }
        gropTwoSelectedBtn.selected=NO;
        sender.selected=YES;
        gropTwoSelectedBtn=sender;
        gropTwoSelectedTimeIndex=sender.tag-2000;
        if ([[ToolsManager share] haveBuyYiwaiCare]) {
            [self getYiwaiCareValue:nil];
        }else if (yiwaijia) {
            [self yiwaiJiaCareUnLogin];
        }else if (![[ToolsManager share] isLogin]) {
            [self yiwaiCareUnLogin];
        }
        
    }
}

//查询重疾险数据
- (void)getZhongjiCareValue:(void (^)())block{
    if ([[ToolsManager share] haveBuyZhongjiCare]) {
        zhongjiUnCareImageView.hidden=YES;
        NSString     *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,zhongjiCareValue];
        NSDictionary *dic=@{@"type":[NSNumber numberWithInteger:gropOneSelectedTimeIndex]};
        [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
            block?block():nil;
            //更改重疾险折线图
            [self zhongjiCareLogin:nil valueArray:nil];
        } fail:^(NSError *error) {
            block?block():nil;
            [self zhongjiCareLogin:[NSMutableArray arrayWithObjects:@"0",@"10000",@"20000",@"30000",@"40000",@"50000", nil] valueArray:[NSMutableArray arrayWithObjects:@"0",@"10000",@"20000",@"30000",@"20000",@"10000",@"0", nil]];
        } showHud:NO];
    }else{
        [self zhongjiCareUnLogin];
        block?block():nil;
    }
}

//查询意外险数据
- (void)getYiwaiCareValue:(void (^)())block{
    if ([[ToolsManager share] haveBuyYiwaiCare]) {
        yiwaiUnCareImageView.hidden=YES;
        NSString     *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,yiwaiCareValue];
        NSDictionary *dic=@{@"type":[NSNumber numberWithInteger:gropOneSelectedTimeIndex]};
        [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
            block?block():nil;
            //更改意外险折线图
            [self yiwaiCareLogin:nil valueArray:nil];
        } fail:^(NSError *error) {
            block?block():nil;
            [self yiwaiCareLogin:[NSMutableArray arrayWithObjects:@"0",@"10000",@"20000",@"30000",@"40000",@"50000", nil] valueArray:[NSMutableArray arrayWithObjects:@"0",@"20000",@"20000",@"50000",@"40000",@"10000",@"0", nil]];
        } showHud:NO];
    }else{
        [self yiwaiCareUnLogin];
        block?block():nil;
    }
}

//提高保额按钮事件
- (void)toBuy:(UIButton *)sender{
    switch (sender.tag) {
        case 7000:
        {
            NSLog(@"点击了购买重疾险");
        }
            break;
        case 7001:
        {
            NSLog(@"点击了购买意外险");
        }
            break;
        default:
            break;
    }
    
}

//显示重疾险购买视图
- (void)showZhongjiView{
    [UIView animateWithDuration:0.25 animations:^{
        [myScrollerView setContentOffset:CGPointMake(0, 60)];
    }];
    
    ZhongjiCareBuyView *careView=[ZhongjiCareBuyView share];
    
    [careView setVauleBlock:^(NSDate *startDate,int careDay,float careMoney){
        
        jiazhongjia=YES;
        [self.zhongjiJiaArray removeAllObjects];
        //如果开始保障的日期不属于今年
        if ([[ToolsManager share] thanCurrentYearLastDay:currentDate andNextDay:startDate]) {
            //获取保障日期到今年年初的天数
            int days=[[ToolsManager share] getBetweenNextYearAndCurrentYearFirst:currentDate nextYearDate:startDate];
            //循环添加数据
            for (int i=0; i<days+93+93; i++) {
                if (i<days+93) {
                    [self.zhongjiJiaArray addObject:@(0)];
                }else if (days+93<=i&&i<=days+93+careDay){
                    [self.zhongjiJiaArray addObject:@(careMoney)];
                }else{
                    [self.zhongjiJiaArray addObject:@(0)];
                }
            }
        }else{
            //获取保障开始日期是本年的第几天
            NSInteger todayInYear=[[ToolsManager share] getNowYearday:startDate];
            //获取今年的总天数
            int yearAllDays=[[ToolsManager share] getCurrentAllDays:startDate];
            //循环添加假数据
            for (int i=0; i<yearAllDays+93+93; i++) {
                
                if (i<todayInYear+93) {
                    [self.zhongjiJiaArray addObject:@(0)];
                }else if (todayInYear+93<=i&&i<=todayInYear+93+careDay){
                    [self.zhongjiJiaArray addObject:@(careMoney)];
                }else{
                    [self.zhongjiJiaArray addObject:@(0)];
                }
            }
        }
        [self zhongjiJiaCareUnLogin];
    }];
    [careView showInView:self.view andCurrentDate:currentDate];
    
    [self hideYiwaiView];
}
//重疾险未登录未购买折线配置
- (void)zhongjiJiaCareUnLogin{
    zhongjiUnCareImageView.hidden=YES;
    switch (gropOneSelectedTimeIndex) {
        case 0:{
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] weekArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"10000",@"20000",@"30000",@"40000",@"50000", nil] ValueArray:(NSMutableArray *)[(NSArray *)self.zhongjiJiaArray subarrayWithRange:NSMakeRange([[ToolsManager share] getCurrntWeekFirstDayInThisYear:currentDate]+93, 7)] index:[[ToolsManager share] getNowWeekday:currentDate]];
        }
            break;
        case 1:{
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] monthArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"10000",@"20000",@"30000",@"40000",@"50000", nil] ValueArray:(NSMutableArray *)[(NSArray *)self.zhongjiJiaArray subarrayWithRange:NSMakeRange([[ToolsManager share] getCurrntMonthFirstDayInThisYear:currentDate]+93, [[ToolsManager share] getCurrentMobthDays:currentDate])] index:[[ToolsManager share] getNowMonthday:currentDate]];
        }
            break;
        case 2:{
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] halfYearArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"10000",@"20000",@"30000",@"40000",@"50000", nil] ValueArray:(NSMutableArray *)[(NSArray *)self.zhongjiJiaArray subarrayWithRange:NSMakeRange([[ToolsManager share] getSixMonthFirstDayInThisYear:currentDate]+93, [[ToolsManager share] getSixMonthDays:currentDate])] index:[[ToolsManager share] getNowHalfYearday:currentDate]];
        }
            break;
        case 3:{
            [self zhongjiCareZhexianWithXarrar:[[ToolsManager share] yearArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"10000",@"20000",@"30000",@"40000",@"50000", nil] ValueArray:(NSMutableArray *)[(NSArray *)self.zhongjiJiaArray subarrayWithRange:NSMakeRange(93, [[ToolsManager share] getCurrentAllDays:currentDate])] index:[[ToolsManager share] getNowYearday:currentDate]];
        }
            break;
            
        default:
            break;
    }
}


//隐藏重疾险购买视图
- (void)hideZhongjiView{
    ZhongjiCareBuyView *careView=[ZhongjiCareBuyView share];
    [careView hideInView:self.view];
    if ([[ToolsManager share] haveBuyZhongjiCare]==NO) {
        [self.zhongjiJiaArray removeAllObjects];
        [self zhongjiCareUnLogin];
        jiazhongjia=NO;
    }
}

//显示意外险购买视图
- (void)showYiwaiView{
    YiwaiCareView *careView=[YiwaiCareView share];
    [careView setVauleBlock:^(NSDate *startDate,int careDay,float careMoney){
        
        yiwaijia=YES;
        [self.yiwaiJiaArray removeAllObjects];
        //如果开始保障的日期不属于今年
        if ([[ToolsManager share] thanCurrentYearLastDay:currentDate andNextDay:startDate]) {
            //获取保障日期到今年年初的天数
            int days=[[ToolsManager share] getBetweenNextYearAndCurrentYearFirst:currentDate nextYearDate:startDate];
            //循环添加数据
            for (int i=0; i<days+93+93; i++) {
                if (i<days+93) {
                    [self.yiwaiJiaArray addObject:@(0)];
                }else if (days+93<=i&&i<=days+93+careDay){
                    [self.yiwaiJiaArray addObject:@(careMoney)];
                }else{
                    [self.yiwaiJiaArray addObject:@(0)];
                }
            }
        }else{
            //获取保障开始日期是本年的第几天
            NSInteger todayInYear=[[ToolsManager share] getNowYearday:startDate];
            //获取今年的总天数
            int yearAllDays=[[ToolsManager share] getCurrentAllDays:startDate];
            //循环添加数据
            for (int i=0; i<yearAllDays+93+93; i++) {
                if (i<todayInYear+93) {
                    [self.yiwaiJiaArray addObject:@(0)];
                }else if (todayInYear+93<=i&&i<=todayInYear+93+careDay){
                    [self.yiwaiJiaArray addObject:@(careMoney)];
                }else{
                    [self.yiwaiJiaArray addObject:@(0)];
                }
            }
        }
        [self yiwaiJiaCareUnLogin];
    }];
    [careView showInView:self.view andCurrentDate:currentDate];
    [UIView animateWithDuration:0.25 animations:^{
        [myScrollerView setContentOffset:CGPointMake(0, 178)];
    }];
    [self hideZhongjiView];
}


//意外险未登录未登录折线配置
- (void)yiwaiJiaCareUnLogin{
    yiwaiUnCareImageView.hidden=YES;
    switch (gropTwoSelectedTimeIndex) {
        case 0:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] weekArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"6000",@"12000",@"18000",@"24000",@"30000", nil] ValueArray:(NSMutableArray *)[(NSArray *)self.yiwaiJiaArray subarrayWithRange:NSMakeRange([[ToolsManager share] getCurrntWeekFirstDayInThisYear:currentDate]+93, 7)] index:[[ToolsManager share] getNowWeekday:currentDate]];
            break;
        case 1:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] monthArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"6000",@"12000",@"18000",@"24000",@"30000", nil] ValueArray:(NSMutableArray *)[(NSArray *)self.yiwaiJiaArray subarrayWithRange:NSMakeRange([[ToolsManager share] getCurrntMonthFirstDayInThisYear:currentDate]+93, [[ToolsManager share] getCurrentMobthDays:currentDate])] index:[[ToolsManager share] getNowMonthday:currentDate]];
            break;
        case 2:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] halfYearArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"6000",@"12000",@"18000",@"24000",@"30000", nil] ValueArray:(NSMutableArray *)[(NSArray *)self.yiwaiJiaArray subarrayWithRange:NSMakeRange([[ToolsManager share] getSixMonthFirstDayInThisYear:currentDate]+93, [[ToolsManager share] getSixMonthDays:currentDate])] index:[[ToolsManager share] getNowHalfYearday:currentDate]];
            break;
        case 3:
            [self yiwaiCareZhexianWithXarrar:[[ToolsManager share] yearArray:currentDate] yArray:[NSMutableArray arrayWithObjects:@"0",@"6000",@"12000",@"18000",@"24000",@"30000", nil] ValueArray:(NSMutableArray *)[(NSArray *)self.yiwaiJiaArray subarrayWithRange:NSMakeRange(93, [[ToolsManager share] getCurrentAllDays:currentDate])] index:[[ToolsManager share] getNowYearday:currentDate]];
            break;
        default:
            break;
    }
}


//隐藏意外险购买视图
- (void)hideYiwaiView{
    YiwaiCareView *careView=[YiwaiCareView share];
    [careView hideInView:self.view];
    if ([[ToolsManager share] haveBuyYiwaiCare]==NO) {
        yiwaijia=NO;
        [self.yiwaiJiaArray removeAllObjects];
        [self yiwaiCareUnLogin];
    }
}

//产品数组
- (NSMutableArray *)tableViewArray{
    if (!_tableViewArray) {
        _tableViewArray=[NSMutableArray array];
        for (int i=0; i<3; i++) {
            [_tableViewArray addObject:@"i"];
        }
    }
    return _tableViewArray;
}

//重疾险假数据数组
- (NSMutableArray *)zhongjiJiaArray{
    if (!_zhongjiJiaArray) {
        _zhongjiJiaArray=[NSMutableArray array];
    }
    return _zhongjiJiaArray;
}


//意外险假数据数据
- (NSMutableArray *)yiwaiJiaArray{
    if (!_yiwaiJiaArray) {
        _yiwaiJiaArray=[NSMutableArray array];
    }
    return _yiwaiJiaArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
