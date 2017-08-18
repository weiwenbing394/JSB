//
//  EditUserInfo.m
//  FSB
//
//  Created by 大家保 on 2017/8/16.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "EditUserInfo.h"

@interface EditUserInfo ()<UITextFieldDelegate>{
    UITextField *nameFiled;
    UITextField *IDCardFiled;
    UIButton *loginButton;
}

@end

@implementation EditUserInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self addTitle:@"身份信息"];
    [self addtopLine];
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [nameFiled becomeFirstResponder];
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
    
    //姓名
    UILabel *peopleName=[[UILabel alloc]init];
    peopleName.textColor=[UIColor colorWithHexString:@"#444444"];
    peopleName.font=font15;
    peopleName.text=@"姓名:";
    [middleView addSubview:peopleName];
    [peopleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(65);
    }];
    
    nameFiled=[[UITextField alloc]init];
    nameFiled.placeholder=@"请输入真实姓名";
    nameFiled.text=0==self.user.nickName.length?@"":self.user.nickName;
    [nameFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    nameFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    nameFiled.textColor=[UIColor colorWithHexString:@"#888888"];
    nameFiled.font=font15;
    nameFiled.text=0==self.user.nickName.length?@"":self.user.nickName;
    nameFiled.delegate=self;
    [middleView addSubview:nameFiled];
    [nameFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.top.bottom.mas_equalTo(peopleName);
        make.right.mas_equalTo(-15);
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
    
    
    UILabel *IDCardNumber=[[UILabel alloc]init];
    IDCardNumber.textColor=[UIColor colorWithHexString:@"#444444"];
    IDCardNumber.font=font15;
    IDCardNumber.text=@"身份证:";
    [middleView addSubview:IDCardNumber];
    [IDCardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(65);
    }];
    
    IDCardFiled=[[UITextField alloc]init];
    IDCardFiled.placeholder=@"请输入身份证号";
    IDCardFiled.textColor=[UIColor colorWithHexString:@"#888888"];
    IDCardFiled.font=font15;
    IDCardFiled.delegate=self;
    IDCardFiled.text=self.user.idCard.length?@"":self.user.idCard;
    IDCardFiled.text=0==self.user.idCard.length?@"":self.user.idCard;
    [IDCardFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    IDCardFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    [middleView addSubview:IDCardFiled];
    [IDCardFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.top.bottom.mas_equalTo(IDCardNumber);
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
    
    
    loginButton=[UIButton buttonWithTitle:@"保存" titleColor:[UIColor colorWithHexString:@"#888888"] font:font17 target:self action:@selector(save:)];
    loginButton.tag=101;
    loginButton.layer.cornerRadius=10;
    loginButton.layer.shadowColor=[[UIColor blackColor] CGColor];
    loginButton.layer.shadowOffset=CGSizeMake(0, 0);
    loginButton.layer.shadowRadius=10;
    loginButton.layer.shadowOpacity=0.08;
    [loginButton setBackgroundColor:[UIColor whiteColor]];
    loginButton.enabled=NO;
    [contentView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleView.mas_bottom).offset(30);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(50);
    }];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(loginButton.mas_bottom);
    }];
}

//保存资料
- (void)save:(UIButton *)sender{
    if (0==[self clearSpace:nameFiled.text].length) {
        [MBProgressHUD ToastInformation:@"姓名不能为空"];
        return;
    }
    if ([numberBOOL checkUserIdCard:[self clearSpace:IDCardFiled.text]]==NO) {
        [MBProgressHUD ToastInformation:@"请输入有效的身份证号"];
        return;
    }
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getIdCard];
    NSDictionary *dic=@{@"name":[self clearSpace:nameFiled.text],@"idCard":[self clearSpace:IDCardFiled.text]};
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

/** 输入框内容发生改变 */
- (void)textFieldChanged:(UITextField *)textField {
    if (nameFiled == textField || IDCardFiled == textField) {
        loginButton.enabled = (0<nameFiled.text.length && 0<IDCardFiled.text.length);
        if (loginButton.enabled) {
            loginButton.layer.shadowColor=[[UIColor colorWithHexString:@"#009af2"] CGColor];
            [loginButton setBackgroundColor:[UIColor colorWithHexString:@"#1fa2ed"]];
            [loginButton setTitleColor:[UIColor whiteColor] forState:0];
            loginButton.layer.shadowOpacity=0.4;
        }else{
            loginButton.layer.shadowColor=[[UIColor blackColor] CGColor];
            [loginButton setBackgroundColor:[UIColor whiteColor]];
            [loginButton setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:0];
            loginButton.layer.shadowOpacity=0.08;
        }
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(IDCardFiled == textField) {
        if (range.location==18) {
            return NO;
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789Xx"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
        return YES;
    }else if(nameFiled == textField){
        if (range.location==20) {
            return NO;
        }
        return YES;
    }else{
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
