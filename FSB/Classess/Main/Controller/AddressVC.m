//
//  AddressVC.m
//  FSB
//
//  Created by 大家保 on 2017/8/16.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "AddressVC.h"
#import "FYLCityPickView.h"
#import "TMVerticallyCenteredTextView.h"

@interface AddressVC ()<UITextViewDelegate>{
    TMVerticallyCenteredTextView *detailAddressView;
    UILabel    *placeHolderLabel;
    NSString   *province,*city,*area;
}

@end

@implementation AddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self addTitle:@"我的地址"];
    [self addtopLine];
    province=0==self.user.province.length?@"":self.user.province;
    city=0==self.user.city.length?@"":self.user.city;
    area=0==self.user.area.length?@"":self.user.area;
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [detailAddressView becomeFirstResponder];
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

- (void)initUI{
    UIScrollView *myScrollerView=[[UIScrollView alloc]init];
    myScrollerView.showsVerticalScrollIndicator=NO;
    myScrollerView.showsHorizontalScrollIndicator=NO;
    myScrollerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myScrollerView];
    [myScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];
    
    UIView *contentView=[[UIView alloc]init];
    contentView.backgroundColor=[UIColor clearColor];
    [myScrollerView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    
    UIView *middleView=[[UIView alloc]init];
    middleView.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(GetHeight(120));
        make.top.mas_equalTo(0);
    }];
    
    //所在地区
    UILabel *areaLabel=[[UILabel alloc]init];
    areaLabel.textColor=[UIColor colorWithHexString:@"#444444"];
    areaLabel.font=font16;
    areaLabel.text=@"所在地区:";
    [middleView addSubview:areaLabel];
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(60);
    }];
    
    UIButton *addressButtom=[[UIButton alloc]init];
    NSString *str=[NSString stringWithFormat:@"%@%@%@",province,city,area];
    if (0==str.length) {
        [addressButtom setTitle:@"省，市，区" forState:0];
        [addressButtom setTitleColor:[UIColor colorWithHexString:@"#babbbb"] forState:0];
    }else{
        [addressButtom setTitle:str forState:0];
        [addressButtom setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:0];
    }
    [addressButtom.titleLabel setFont:font16];
    [addressButtom setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [addressButtom addTarget:self action:@selector(selectedArea:) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:addressButtom];
    [addressButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(areaLabel.mas_right).offset(13);
        make.top.bottom.mas_equalTo(areaLabel);
        make.right.mas_equalTo(-15);
    }];
    
    UIImageView *rightArr=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-10"]];
    [addressButtom addSubview:rightArr];
    [rightArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(19);
    }];
    
    UILabel *line1=[[UILabel alloc]init];
    line1.backgroundColor=[UIColor colorWithHexString:@"F2F5F7"];
    [middleView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    
    
    UILabel *detailAddress=[[UILabel alloc]init];
    detailAddress.textColor=[UIColor colorWithHexString:@"#444444"];
    detailAddress.font=font16;
    detailAddress.text=@"详细地址:";
    [middleView addSubview:detailAddress];
    [detailAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
    
    detailAddressView=[[TMVerticallyCenteredTextView alloc]init];
    detailAddressView.delegate=self;
    detailAddressView.textColor=[UIColor colorWithHexString:@"#888888"];
    detailAddressView.font=font15;
    detailAddressView.text=0==self.user.address.length?@"":self.user.address;
    [detailAddress setTextAlignment:NSTextAlignmentLeft];
    [middleView addSubview:detailAddressView];
    [detailAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(detailAddress.mas_right).offset(11);
        make.top.bottom.mas_equalTo(detailAddress);
        make.right.mas_equalTo(-15);
    }];
    
    placeHolderLabel=[[UILabel alloc]init];
    placeHolderLabel.textColor=[UIColor colorWithHexString:@"#babbbb"];
    placeHolderLabel.font=font16;
    placeHolderLabel.hidden=0==self.user.address.length?NO:YES;
    placeHolderLabel.text=@"请填写详细地址";
    [middleView addSubview:placeHolderLabel];
    [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(detailAddress.mas_right).offset(14);
        make.top.bottom.mas_equalTo(detailAddress);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel *line2=[[UILabel alloc]init];
    line2.backgroundColor=[UIColor colorWithHexString:@"F2F5F7"];
    [middleView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    
    
    UIButton *saveButtom=[UIButton buttonWithTitle:@"保存" titleColor:[UIColor whiteColor] font:font17 target:self action:@selector(save:)];
    saveButtom.layer.cornerRadius=10;
    saveButtom.layer.shadowColor=[[UIColor colorWithHexString:@"#009af2"] CGColor];
    saveButtom.layer.shadowOffset=CGSizeMake(0, 0);
    saveButtom.layer.shadowRadius=10;
    [saveButtom setBackgroundColor:[UIColor colorWithHexString:@"#1fa2ed"]];
    [saveButtom setTitleColor:[UIColor whiteColor] forState:0];
    saveButtom.layer.shadowOpacity=0.4;
    [contentView addSubview:saveButtom];
    [saveButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleView.mas_bottom).offset(30);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(50);
    }];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(saveButtom.mas_bottom);
    }];
}

//选择地址
- (void)selectedArea:(UIButton *)btn{
    [detailAddressView resignFirstResponder];
//    [FYLCityPickView showPickViewWithComplete:^(NSArray *arr) {
//        province=arr[0];
//        city=arr[1];
//        area=arr[2];
//        NSString *str = [NSString stringWithFormat:@"%@%@%@",province,city,area];
//        [btn setTitle:str forState:0];
//        [btn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:0];
//    }];
    [FYLCityPickView showPickViewWithDefaultProvince:province city:city area:area complete:^(NSArray *arr) {
        province=arr[0];
        city=arr[1];
        area=arr[2];
        NSString *str = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        [btn setTitle:str forState:0];
        [btn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:0];
    }];
}


//保存地区
- (void)save:(UIButton *)sender{
    if (0==province.length||0==city.length||0==area.length) {
        [MBProgressHUD ToastInformation:@"请先选择省，市，区"];
        return;
    }
    if (0==[self clearSpace:detailAddressView.text].length) {
        [MBProgressHUD ToastInformation:@"详细地址不能为空"];
        return;
    }
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,changeAddress];
    NSDictionary *dic=@{@"province":province,@"city":city,@"area":area,@"address":[self clearSpace:detailAddressView.text]};
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"statusCode"];
            if (statusCode==400) {
                NSString *errorMsg=[response stringForKey:@"msg"];
                [MBProgressHUD ToastInformation:errorMsg];
            }else{
                self.SuccessBlock?self.SuccessBlock(nil):nil;
                [self.navigationController popViewControllerAnimated:YES];
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



//变化
- (void)textViewDidChange:(UITextView *)textView{
    if (0<[self clearSpace:textView.text].length) {
        placeHolderLabel.hidden=YES;
    }else{
        placeHolderLabel.hidden=NO;
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
