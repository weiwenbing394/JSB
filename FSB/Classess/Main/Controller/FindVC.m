//
//  FindVC.m
//  FSB
//
//  Created by 大家保 on 2017/7/31.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "FindVC.h"
#import "ShaiXuanView.h"
#import "FindCell.h"
#import "SearchContentModel.h"


@interface FindVC ()<UITableViewDelegate,UITableViewDataSource>{
    //tableview
    UITableView *myTableView;
    //保险类型选中按钮
    UIButton    *categoryButtom;
    //排序方式选中类型
    UIButton    *shaixuanButtom;
    //保险类型
    int         careType;
    //排序方式
    int         sortType;
    //筛选条件
    NSString   *filterContentId;
    //显示筛选条件
    UILabel    *numberLabel;
    //转换按钮
    UIButton   *emptyBtn;
}

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *shaiXuanSelectedArray;

@end

static NSString * const findCell=@"findCell";

@implementation FindVC

- (void)viewDidLoad {
    NSLog(@"%d天",[[ToolsManager share] getCurrentAllDays:nil])
    [super viewDidLoad];
    self.bgView.hidden=YES;
    careType=0;
    sortType=-1;
    filterContentId=@"";
    [self initUI];
    [self getData];
}

//获取登录通知
- (void)haveLogin{
    
}

//获取退出通知
- (void)haveLogout{
    
}

//购买成功
- (void)haveBuySuccess{
    
}

//页面布局
- (void)initUI{
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(0);
    }];
    
    UIView *sepa=[[UIView alloc]init];
    sepa.backgroundColor=RGB(237, 244, 245);
    [headView addSubview:sepa];
    [sepa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *jiankang=[self createButton:@"健康" andTag:100];
    jiankang.selected=YES;
    [headView addSubview:jiankang];
    [jiankang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo((SCREEN_WIDTH-1.5)/4);
    }];
    categoryButtom=jiankang;
    
    UIView *sepa1=[self creatSeperateView];
    [headView addSubview:sepa1];
    [sepa1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(1);
        make.left.mas_equalTo(jiankang.mas_right);
    }];
    
    UIButton *yiwai=[self createButton:@"意外" andTag:101];
    [headView addSubview:yiwai];
    [yiwai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo((SCREEN_WIDTH-1.5)/4);
        make.left.mas_equalTo(jiankang.mas_right).offset(0.5);
    }];
    
    UIView *sepa2=[self creatSeperateView];
    [headView addSubview:sepa2];
    [sepa2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(1);
        make.left.mas_equalTo(yiwai.mas_right);
    }];

    
    UIButton *lvxing=[self createButton:@"旅行" andTag:102];
    [headView addSubview:lvxing];
    [lvxing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo((SCREEN_WIDTH-1.5)/4);
        make.left.mas_equalTo(yiwai.mas_right).offset(0.5);
    }];
    
    UIView *sepa3=[self creatSeperateView];
    [headView addSubview:sepa3];
    [sepa3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(1);
        make.left.mas_equalTo(lvxing.mas_right);
    }];
    
    UIButton *caichan=[self createButton:@"财产" andTag:103];
    [headView addSubview:caichan];
    [caichan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo((SCREEN_WIDTH-1.5)/4);
        make.left.mas_equalTo(lvxing.mas_right).offset(0.5);
    }];
    
    UIView *sepabottom=[[UIView alloc]init];
    sepabottom.backgroundColor=RGB(237, 244, 245);
    [headView addSubview:sepabottom];
    [sepabottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
    //排序栏
    
    UIView *selectView=[[UIView alloc]init];
    selectView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
    }];
    
    UIButton *price=[self createButton:@"价格最低" andTag:200];
    [selectView addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.width.mas_equalTo((SCREEN_WIDTH-60)/3.0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    
    UIButton *count=[self createButton:@"销量最高" andTag:201];
    [selectView addSubview:count];
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.width.mas_equalTo((SCREEN_WIDTH-60)/3.0);
        make.left.mas_equalTo(price.mas_right).offset(20);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *selct=[self createButton:@"筛选" andTag:202];
    selct.frame=CGRectMake(0, 0, (SCREEN_WIDTH-60)/3.0, 30);
    [selct setImage:[UIImage imageNamed:@"icon-4"] forState:0];
    [selct setImage:[UIImage imageNamed:@"icon-5"] forState:UIControlStateSelected];
    [selct layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:7];
    [selectView addSubview:selct];
    [selct mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.width.mas_equalTo((SCREEN_WIDTH-60)/3.0);
        make.left.mas_equalTo(count.mas_right).offset(20);
        make.height.mas_equalTo(30);
    }];
    
    //空的按钮
    emptyBtn=[[UIButton alloc]initWithFrame:CGRectZero];
    [selectView addSubview:emptyBtn];
    emptyBtn.selected=YES;
    shaixuanButtom=emptyBtn;
    
    
    
    numberLabel=[[UILabel alloc]init];
    numberLabel.textColor=[UIColor whiteColor];
    numberLabel.backgroundColor=[UIColor colorWithHexString:@"#ffbf54"];
    numberLabel.font=font10;
    numberLabel.text=@"0";
    numberLabel.hidden=YES;
    numberLabel.textAlignment=NSTextAlignmentCenter;
    numberLabel.layer.cornerRadius=10;
    numberLabel.clipsToBounds=YES;
    [selectView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(selct);
        make.centerY.mas_equalTo(selct.mas_top);
        make.width.height.mas_equalTo(20);
    }];
    
    myTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.backgroundColor=[UIColor clearColor];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
    myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
    myTableView.sectionHeaderHeight=0.0001;
    myTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [myTableView registerNib:[UINib nibWithNibName:@"FindCell" bundle:nil] forCellReuseIdentifier:findCell];
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(selectView.mas_bottom).offset(10);
    }];
    
    //[self addMJheader];
}

//获取数据
- (void)getData{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getProducts];
    NSDictionary *dic=@{@"careType":@(careType),@"sortType":@(sortType),@"filterContentId":filterContentId};
    [XWNetworking postJsonWithUrl:url params:dic responseCache:^(id responseCache) {
        if (responseCache) {
            [myTableView reloadData];
        }
    } success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"statusCode"];
            if (statusCode==400) {
                [self endFreshAndLoadMore];
            }else{
                [myTableView reloadData];
                [self endFreshAndLoadMore];
            }
        }
    } fail:^(NSError *error) {
        [self endFreshAndLoadMore];
    } showHud:YES];
}

#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    myTableView.mj_header=mjHeader;
}


#pragma mark 关闭mjrefreshing
- (void)endFreshAndLoadMore{
    [myTableView.mj_header endRefreshing];
}

//创建分割线
- (UIView *)creatSeperateView{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=RGB(237, 244, 245);
    return view;
}


//创建按钮
- (UIButton *)createButton:(NSString *)buttomTitle andTag:(NSInteger)tag{
    UIButton *btn=[[UIButton alloc]init];
    [btn setTitle:buttomTitle forState:0];
    [btn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:0];
    [btn setTitleColor:[UIColor colorWithHexString:@"#1fa2ed"] forState:UIControlStateSelected];
    if (tag>=200) {
        [btn setBackgroundImage:[UIImage resizedImage:@"button-3"] forState:0];
        [btn setBackgroundImage:[UIImage resizedImage:@"button-1"] forState:UIControlStateSelected];
    }
    [btn.titleLabel setFont:font15];
    [btn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag=tag;
    return btn;
}

//切换选中条件
- (void)select:(UIButton *)sender{
    //一级筛选条件
    if (sender.tag<200) {
        if (sender==categoryButtom) {
                return;
        }
        categoryButtom.selected=NO;
        sender.selected=YES;
        categoryButtom=sender;
        careType=(int)sender.tag-100;
        
        if (shaixuanButtom.tag==202) {
            shaixuanButtom.selected=NO;
            emptyBtn.selected=YES;
            shaixuanButtom=emptyBtn;
            sortType=-1;
            filterContentId=@"";
            [self.shaiXuanSelectedArray removeAllObjects];
            numberLabel.hidden=YES;
        }
        
        [self getData];
        
    }else{
        //二级筛选条件
        if (sender.tag!=202&&sender==shaixuanButtom) {
            return;
        }
        if (sender.tag==200||sender.tag==201) {
            
            shaixuanButtom.selected=NO;
            sender.selected=YES;
            shaixuanButtom=sender;
            
            sortType=(int)sender.tag-200;
            filterContentId=@"";
            [self.shaiXuanSelectedArray removeAllObjects];
            numberLabel.hidden=YES;
            
            [self getData];
            
        }else if (sender.tag==202) {
            
            ShaiXuanView *shaiXuan=[[ShaiXuanView alloc]init];
            [shaiXuan show:nil];
            shaiXuan.selectedArray=self.shaiXuanSelectedArray;
            [shaiXuan reloadDtaWithType:careType];
            [shaiXuan setOkBlock:^(NSMutableArray *backArray){
                if (0<backArray.count) {
                    
                    shaixuanButtom.selected=NO;
                    sender.selected=YES;
                    shaixuanButtom=sender;
                    
                    sortType=(int)sender.tag-200;
                    numberLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)backArray.count ];
                    numberLabel.hidden=!backArray.count;
                    [self.shaiXuanSelectedArray removeAllObjects];
                    [self.shaiXuanSelectedArray addObjectsFromArray:backArray];
                    
                    NSMutableArray *array=[NSMutableArray array];
                    [array removeAllObjects];
                    for (SearchContentModel *model in backArray) {
                        [array indexOfObject:@(model.filterContentId)];
                    }
                    NSError *error = nil;
                    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
                    if (error!=nil) {
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        filterContentId=jsonString;
                        [self getData];
                    }
                    
                }
                
            }];
        }
    }
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindCell *cell=[tableView dequeueReusableCellWithIdentifier:findCell];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.bgView.backgroundColor=[UIColor whiteColor];
    cell.bgView.layer.cornerRadius=5;
    cell.bgView.layer.shadowRadius=20;
    cell.bgView.layer.shadowColor=[UIColor blackColor].CGColor;
    cell.bgView.layer.shadowOpacity=0.08;
    cell.bgView.layer.shadowOffset=CGSizeMake(0, 0);
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 25;
    }else{
        return 0.001;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

#pragma mark 懒加载
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
        [_dataArray addObject:@"1"];
        [_dataArray addObject:@"2"];
        [_dataArray addObject:@"3"];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSMutableArray *)shaiXuanSelectedArray{
    if (!_shaiXuanSelectedArray) {
        _shaiXuanSelectedArray=[NSMutableArray array];
    }
    return _shaiXuanSelectedArray;
}


@end
