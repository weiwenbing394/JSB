//
//  MeVC.m
//  FSB
//
//  Created by 大家保 on 2017/7/31.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "MeVC.h"
#import "MeCell.h"
#import "ZhongjiCareBuyView.h"
#import "MyInfoVC.h"
#import "EditUserInfo.h"

@interface MeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView    *myTableView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

static NSString * const meCell=@"meCell";

@implementation MeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self addBottomView];
    [self.myTableView reloadData];
}

//添加版本号
- (void)addBottomView{
    UILabel *label=[[UILabel alloc]init];
    label.text=[NSString stringWithFormat:@"Version %@",VERSION];
    label.textColor=[UIColor colorWithHexString:@"#888888"];
    label.font=font14;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
    }];
}

//获取登录通知
- (void)haveLogin{
    [self.myTableView reloadData];
}

//获取退出通知
- (void)haveLogout{
    [self.myTableView reloadData];
}

//购买成功
- (void)haveBuySuccess{
    [self.myTableView reloadData];
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeCell  *cell=[tableView dequeueReusableCellWithIdentifier:meCell];
    NSArray *array=self.dataArray[indexPath.row];
    cell.headImageView.image=[UIImage imageNamed:array[0]];
    cell.titleLabel.text=array[1];
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        MyInfoVC *info=[[MyInfoVC alloc]init];
        [self.navigationController pushViewController:info animated:YES];
    }else if (indexPath.row==1){
    }else if (indexPath.row==2){
        [[ToolsManager share] shareImageUrl:@"pic-2" shareUrl:@"http://www.baidu.com" title:@"计时保" subTitle:@"好东西" shareType:5];
    }else if (indexPath.row==3){
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 105)];
    footView.backgroundColor=[UIColor clearColor];
    
    UIButton *btn=[[UIButton alloc]init];
    [btn setTitleColor:[UIColor colorWithHexString:@"#444444"] forState:0];
    [btn.titleLabel setFont:font16];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.layer.cornerRadius=10;
    btn.layer.shadowColor=[[UIColor blackColor] CGColor];
    btn.layer.shadowOffset=CGSizeMake(0, 0);
    btn.layer.shadowRadius=10;
    btn.layer.shadowOpacity=0.08;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    if ([[ToolsManager share] isLogin]) {
        [btn setTitle:@"退出登录" forState:0];
    }else{
        [btn setTitle:@"立即登录" forState:0];
    }
    [footView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(49);
        make.height.mas_equalTo(52);
    }];
    
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

//注册、登录事件
- (void)click:(UIButton *)sender{
    if ([[ToolsManager share] isLogin]) {
        [[ToolsManager share] loginOut];
    }else{
        [self toLoginVC];
    }
}


#pragma mark 懒加载tableView
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor=[UIColor clearColor];
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.sectionHeaderHeight=0.0001;
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_myTableView registerNib:[UINib nibWithNibName:@"MeCell" bundle:nil] forCellReuseIdentifier:meCell];
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-55);
            make.top.mas_equalTo(10);
        }];
        
    }
    return _myTableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray arrayWithObjects:@[@"icon-6",@"我的资料"],@[@"icon-7",@"我的订单"],@[@"icon-8",@"分享他人"],@[@"icon-9",@"关于我们"], nil];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
