//
//  MyInfoVC.m
//  FSB
//
//  Created by 大家保 on 2017/8/16.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "MyInfoVC.h"
#import "MyMessageCell.h"
#import "UserInfo.h"
#import "AddressVC.h"
#import "EditUserInfo.h"

@interface MyInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong)UserInfo *userInfo;

@end

static NSString *const myInfoCell=@"myInfoCell";

@implementation MyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"我的资料"];
    [self addLeftButton];
    [self addtopLine];
    [self.myTableView reloadData];
    [self getData];
}

- (void)addtopLine{
    UILabel *line=[[UILabel alloc]init];
    line.backgroundColor=[UIColor colorWithHexString:@"F2F5F7"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(63);
        make.height.mas_equalTo(1);
    }];
}

//获取数据
- (void)getData{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,userInfos];
    [XWNetworking getJsonWithUrl:url params:nil responseCache:^(id responseCache) {
        
    } success:^(id response) {
        
    } fail:^(NSError *error) {
        
        self.userInfo=[[UserInfo alloc]init];
        self.userInfo.mobile=@"18767655432";
        self.userInfo.isWechatAuthor=YES;
        self.userInfo.province=@"北京市";
        self.userInfo.city=@"北京市";
        self.userInfo.area=@"宣武区";
        self.userInfo.address=@"公主坟";
        self.userInfo.nickName=@"测试";
        self.userInfo.idCard=@"430524199010244076";
        
        [self.myTableView reloadData];
        
    } showHud:YES];
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:myInfoCell];
    cell.titleStr.text=self.dataSourceArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            if(0==self.userInfo.nickName.length){
                cell.subTitle.text=@"去填写";
            }else{
                cell.subTitle.text=self.userInfo.nickName;
            }
        }
            break;
        case 1:
        {
            if(0==self.userInfo.province.length){
                cell.subTitle.text=@"去填写";
            }else{
                cell.subTitle.text=[NSString stringWithFormat:@"%@%@%@",self.userInfo.province,self.userInfo.city,self.userInfo.area];
            }
        }
            break;
        case 2:
        {
            cell.subTitle.text=self.userInfo.mobile;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.widthContens.constant=0;
            cell.heightContents.constant=0;
            cell.rightContents.constant=0;
        }
            break;
        case 3:
        {
            if(self.userInfo.isWechatAuthor==NO){
                cell.subTitle.text=@"去绑定";
                cell.widthContens.constant=10;
                cell.heightContents.constant=19;
                cell.rightContents.constant=10;
            }else{
                cell.subTitle.text=@"已绑定";
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.widthContens.constant=0;
                cell.heightContents.constant=0;
                cell.rightContents.constant=0;
            }
        }
            break;
            
        default:
            break;
    }
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            EditUserInfo *edit=[[EditUserInfo alloc]init];
            edit.user=self.userInfo;
            WeakSelf;
            [edit setSuccessBlock:^(UserInfo *info){
                weakSelf.userInfo=info;
                [weakSelf.myTableView reloadData];
            }];
            [self.navigationController pushViewController:edit animated:YES];

        }
            break;
        case 1:
        {
            AddressVC *address=[[AddressVC alloc]init];
            address.user=self.userInfo;
            WeakSelf;
            [address setSuccessBlock:^(UserInfo *info){
                weakSelf.userInfo=info;
                [weakSelf.myTableView reloadData];
            }];
            [self.navigationController pushViewController:address animated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            if(self.userInfo.isWechatAuthor==NO){
                [self bangdingWechat];
            }
        }
            break;
            
        default:
            break;
    }
}

//绑定微信
- (void)bangdingWechat{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
        } else {
            UMSocialUserInfoResponse *resp = result;
            NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,addWechat];
            NSDictionary *dic=@{@"wxToken":resp.uid,@"wxName":resp.name,@"wximage":resp.iconurl};
            [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
                if (response) {
                    NSInteger statusCode=[response integerForKey:@"code"];
                    if (statusCode==0) {
                        NSString *errorMsg=[response stringForKey:@"message"];
                        [MBProgressHUD ToastInformation:errorMsg];
                    }else{
                        WeakSelf;
                        [weakSelf.myTableView reloadData];
                    }
                }
            } fail:^(NSError *error) {
                if ([XWNetworking isHaveNetwork]) {
                    [MBProgressHUD ToastInformation:@"服务器开小差了"];
                }else{
                    [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
                }
            } showHud:YES];
        }
    }];
}



#pragma mark 懒加载
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.backgroundColor=[UIColor clearColor];
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyMessageCell class]) bundle:nil] forCellReuseIdentifier:myInfoCell];
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(64);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _myTableView;
}


- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray=[[NSMutableArray alloc]initWithObjects:@"身份信息",@"地址",@"手机号码",@"微信绑定", nil];
    }
    return _dataSourceArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/**
 *  友盟统计页面打开开始时间
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的资料"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的资料"];
}



@end
