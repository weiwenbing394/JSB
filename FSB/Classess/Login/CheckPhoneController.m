//
//  CheckPhoneController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "CheckPhoneController.h"
#import "CodeView.h"
#import "MeModel.h"

@interface CheckPhoneController (){
    UITextField *field;
    UITextField * codeField;
    UIButton    *codeButtom;
    UIButton    *checkCode;
}

@property (nonatomic, copy)   NSString *guid;

@property (nonatomic, strong) JCAlertView *alertView;

@end

@implementation CheckPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"绑定手机号"];
    [self addLeftButton];
    [self addtopLine];
    [self initUI];
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


//初始化ui
- (void)initUI{
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"#fafafa"];
    
    UIView *WhiteView=[[UIView alloc]init];
    WhiteView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:WhiteView];
    [WhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(60);
    }];
    
    //输入框
    field=[[UITextField alloc]init];
    field.placeholder=@"请输入绑定手机号";
    field.textColor=[UIColor colorWithHexString:@"#444444"];
    field.font=font16;
    field.keyboardType=UIKeyboardTypeNumberPad;
    field.clearButtonMode=UITextFieldViewModeWhileEditing;
    [field addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [WhiteView addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-121);
        make.height.mas_equalTo(60);
    }];
    
    //获取验证码按钮
    codeButtom=[[UIButton alloc]init];
    [codeButtom setTitle:@"获取验证码" forState:0];
    [codeButtom setTitleColor:[UIColor colorWithHexString:@"#1fa2ed"] forState:0];
    [codeButtom setTitleColor:[UIColor colorWithHexString:@"#babbbb"] forState:UIControlStateDisabled];
    [codeButtom.titleLabel setFont:font15];
    [codeButtom addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    codeButtom.tag=100;
    [WhiteView addSubview:codeButtom];
    [codeButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(60);
        make.top.mas_equalTo(0);
    }];
    
    UIView *codeLine=[[UIView alloc]init];
    codeLine.backgroundColor=[UIColor colorWithHexString:@"f2f4f7"];
    [WhiteView addSubview:codeLine];
    [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(codeButtom.mas_left);
        make.centerY.mas_equalTo(codeButtom.mas_centerY);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(24);
    }];
    
    UILabel *line1=[[UILabel alloc]init];
    line1.backgroundColor=[UIColor colorWithHexString:@"F2F5F7"];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(WhiteView.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    UIView *middleView=[[UIView alloc]init];
    middleView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(line1.mas_bottom);
    }];
    
    
    
    
    //输入框
    codeField=[[UITextField alloc]init];
    codeField.placeholder=@"请输入短信验证码";
    codeField.textColor=[UIColor colorWithHexString:@"#282828"];
    codeField.font=font15;
    codeField.keyboardType=UIKeyboardTypeNumberPad;
    codeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [codeField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [middleView addSubview:codeField];
    [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(60);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
    }];
    
   
    
    
    UILabel *line2=[[UILabel alloc]init];
    line2.backgroundColor=[UIColor colorWithHexString:@"F2F5F7"];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(middleView.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    //开始验证
    checkCode=[UIButton buttonWithTitle:@"绑定" titleColor:[UIColor colorWithHexString:@"#888888"] font:font17 target:self action:@selector(checkCode:)];
    checkCode.tag=101;
    checkCode.tag=101;
    checkCode.layer.cornerRadius=10;
    checkCode.layer.shadowColor=[[UIColor blackColor] CGColor];
    checkCode.layer.shadowOffset=CGSizeMake(0, 0);
    checkCode.layer.shadowRadius=10;
    checkCode.layer.shadowOpacity=0.08;
    [checkCode setBackgroundColor:[UIColor whiteColor]];
    checkCode.enabled=NO;
    [self.view addSubview:checkCode];
    [checkCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).offset(30);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(50);
    }];
    
}

//获取短信验证码
- (void)getCode:(UIButton *)sender{
    [self.view endEditing:YES];
    if (![numberBOOL checkTelNumber:field.text]) {
        [MBProgressHUD ToastInformation:@"请输入正确的手机号"];
        return;
    }
    if (0==self.guid.length) {
        //获取sid
        [self getSid:sender];
    }else{
        [self getSnsCode:self.guid];
    }
}

#pragma mark 验证码倒计时
- (void)autoCodeDecler{
    //验证码倒计时
    __block float timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [codeButtom setTitle:@"获取验证码" forState:0];
                codeButtom.enabled=YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [codeButtom setTitle:[NSString stringWithFormat:@"%.0fs",timeout] forState:0];
                codeButtom.enabled=NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


//获取sid
- (void)getSid:(UIButton *)btn{
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",codeUrl,@"/verify/sid?"];
    [XWNetworking getJsonWithUrl:urlStr params:nil success:^(id response) {
        NSDictionary *dic=response;
        NSInteger code=[dic integerForKey:@"code"];
        if (code==1) {
            NSDictionary *dataDic=[dic objectForKey:@"data"];
            NSString *sidStr=[dataDic objectForKey:@"sid"];
            self.guid=sidStr;
            if(btn.tag==100){
                [self getSnsCode:sidStr];
            }else if(btn.tag==101){
                [self checkPhoneCode:sidStr];
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


#pragma mark 有sid * 获取短信验证码 *
- (void)getSnsCode:(NSString *)sid{
    NSString *urlStr=[NSString stringWithFormat:@"%@/verify/sms",codeUrl];
    NSDictionary *dic=@{@"code":@"",@"phone":[self clearSpace:field.text],@"smsCode":@"QQB_YZM",@"sid":sid};
    [XWNetworking postJsonWithUrl:urlStr params:dic success:^(id response) {
        NSDictionary *dic=response;
        NSInteger code=[dic integerForKey:@"code"];
        if (code == -1) {
            //弹出图片输入框
            [self getImageCode:sid];
        } else if (code == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"短信已发送"];
                //手机验证码发送成功
                [self autoCodeDecler];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *errorMsg=[dic objectForKey:@"message"];
                [MBProgressHUD ToastInformation:errorMsg];
            });
        }
    } fail:^(NSError *error) {
        if ([XWNetworking isHaveNetwork]) {
            [MBProgressHUD ToastInformation:@"服务器开小差了"];
        }else{
            [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        }
    } showHud:YES];
}

/**
 *  需要图片验证码，弹出图片验证码
 */
- (void)getImageCode:(NSString *)sid{
    CodeView *codeView=[[CodeView alloc]init];
    [codeView initWithPhoneNumber:[self clearSpace:field.text] PostId:sid okBlock:^(NSString *str, NSString *imageCode) {
        [self.alertView dismissWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"短信已发送"];
                [self autoCodeDecler];
            });
        }];
    } cancelBlock:^{
        [self.alertView dismissWithCompletion:^{
        }];
    }];
    self.alertView=[[JCAlertView alloc]initWithCustomView:codeView dismissWhenTouchedBackground:NO];
    [self.alertView show];
    
}

/**
 *  验证手机短信验证码
 */
- (void)checkPhoneCode:(NSString *)sid{
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",codeUrl,@"/verify/checksmscode"];
    NSDictionary *dic=@{@"code":[self clearSpace:codeField.text],@"phone":[self clearSpace:field.text],@"sid":sid};
    [XWNetworking postJsonWithUrl:urlStr params:dic success:^(id response) {
        NSDictionary *dic=response;
        NSInteger code=[dic integerForKey:@"code"];
        if (code==1) {
            [self beginLogin:sid];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString  *errMessage=[dic objectForKey:@"message"];
                [MBProgressHUD ToastInformation:errMessage];
            });
        }
    } fail:^(NSError *error) {
        if ([XWNetworking isHaveNetwork]) {
            [MBProgressHUD ToastInformation:@"服务器开小差了"];
        }else{
            [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        }
    } showHud:YES];
}


//校验验证码
- (void)checkCode:(UIButton *)sender{
    NSLog(@"开始登录");
    [self.view endEditing:YES];
    if (![numberBOOL checkTelNumber:field.text]) {
        [MBProgressHUD ToastInformation:@"请输入正确的手机号"];
        return;
    }
    if (0==codeField.text.length) {
        [MBProgressHUD ToastInformation:@"请输入正确的验证码"];
        return;
    }
    if (0==self.guid.length){
        [self getSid:sender];
    }else{
        [self checkPhoneCode:self.guid];
    }
}

//短信验证码验证成功开始登录
- (void)beginLogin:(NSString *)sid{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,addWechat];
    NSDictionary *dic=@{@"wxToken":self.wechatId,@"wxName":self.wxName,@"wxImage":self.wximage,@"verifySid":self.guid,@"mobilePhone":[self clearSpace:field.text],@"systemType":[NSNumber numberWithInt:0]};
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"statusCode"];
            if (statusCode==400) {
                NSString *errorMsg=[response stringForKey:@"msg"];
                [MBProgressHUD ToastInformation:errorMsg];
            }else{
                NSString *tokenID=response[@"data"][@"token"];
                MeModel *me=[MeModel mj_objectWithKeyValues:response[@"data"]];
                [UserDefaults setObject:tokenID forKey:TOKENID ];
                [[ToolsManager share] saveMeModelMessage:me];
                
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



#pragma mark - 输入框改变事件
/** 输入框内容发生改变 */
- (void)textFieldChanged:(UITextField *)textField {
    if (field == textField || codeField == textField) {
        checkCode.enabled = (0<field.text.length &&0<codeField.text.length);
        if (checkCode.enabled) {
            checkCode.layer.shadowColor=[[UIColor colorWithHexString:@"#009af2"] CGColor];
            [checkCode setBackgroundColor:[UIColor colorWithHexString:@"#1fa2ed"]];
            [checkCode setTitleColor:[UIColor whiteColor] forState:0];
            checkCode.layer.shadowOpacity=0.4;
        }else{
            checkCode.layer.shadowColor=[[UIColor blackColor] CGColor];
            [checkCode setBackgroundColor:[UIColor whiteColor]];
            [checkCode setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:0];
            checkCode.layer.shadowOpacity=0.08;
        }
    }
    //  限制输入框的输入长度为11
    if (field == textField&&textField.text.length >= 11 && textField.markedTextRange==nil ) {
        textField.text = [textField.text substringToIndex:11];
    }
    //  限制输入框的输入长度为11
    if (codeField == textField  && textField.text.length >=6 && textField.markedTextRange==nil ) {
        textField.text = [textField.text substringToIndex:6];
    }
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
    [MobClick beginLogPageView:@"微信登录绑定手机号"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"微信登录绑定手机号"];
}



@end
