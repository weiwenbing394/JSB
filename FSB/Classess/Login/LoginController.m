//
//  LoginController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "LoginController.h"
#import "CodeView.h"
#import "MeModel.h"
#import "WXApi.h"
#import "CheckPhoneController.h"
#import "BaseWebViewController.h"

#define getHeight(ll)          (SCREEN_HEIGHT==480?ll*568/667.0:ll*SCREEN_HEIGHT/667.0)

#define getWidth(ll)           (ll*SCREEN_WIDTH/375.0)

@interface LoginController ()<UITextFieldDelegate>{
    UITextField *userNameFiled;
    UITextField *passwordFiled;
    UIButton *loginButton;
    UIButton *getCodeButton;
    UIButton *wechtLogin;
    
}

@property (nonatomic, copy)   NSString *guid;

@property (nonatomic, strong) JCAlertView *alertView;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self initUI];
    [self addTitle:@"登录注册"];
    [self addLeftBarButton:@"icon-1"];
}

//关闭
- (void)leftClick:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//界面布局
- (void)initUI{
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"#fafafa"];
    
    UIScrollView *myScrollerView=[[UIScrollView alloc]init];
    myScrollerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myScrollerView];
    [myScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(-getHeight(30)-35);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIView *contentView=[[UIView alloc]init];
    contentView.backgroundColor=[UIColor clearColor];
    [myScrollerView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(myScrollerView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIImageView *logo=[[UIImageView alloc]init];
    logo.image=[UIImage imageNamed:@"logo"];
    logo.backgroundColor=[UIColor blueColor];
    [contentView addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(contentView.mas_top).offset(SCREEN_WIDTH/375.0*30);;
        make.width.height.mas_equalTo(SCREEN_WIDTH/375.0*80);
    }];
    
    
    UIView *userNameView=[[UIView alloc]init];
    [userNameView setBackgroundColor:[UIColor whiteColor]];
    userNameView.layer.cornerRadius=10;
    userNameView.layer.shadowColor=[[UIColor blackColor] CGColor];
    userNameView.layer.shadowOffset=CGSizeMake(0, 0);
    userNameView.layer.shadowRadius=10;
    userNameView.layer.shadowOpacity=0.08;
    [contentView addSubview:userNameView];
    [userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(35));
        make.right.mas_equalTo(getWidth(-35));
        make.top.mas_equalTo(logo.mas_bottom).offset(getHeight(40));
        make.height.mas_equalTo(getHeight(50));
    }];
    
    userNameFiled=[[UITextField alloc]init];
    userNameFiled.font=font15;
    userNameFiled.textColor=[UIColor colorWithHexString:@"#444444"];
    userNameFiled.delegate=self;
    userNameFiled.placeholder = @"请输入您的手机号码";
    userNameFiled.keyboardType=UIKeyboardTypeNumberPad;
    userNameFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    [userNameFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [userNameView addSubview:userNameFiled];
    [userNameFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20));
        make.right.mas_equalTo(-getWidth(20));
        make.top.bottom.mas_equalTo(userNameView);
    }];
    
    
    
    UIView *passwordView=[[UIView alloc]init];
    [passwordView setBackgroundColor:[UIColor whiteColor]];
    passwordView.layer.cornerRadius=10;
    passwordView.layer.shadowColor=[[UIColor blackColor] CGColor];
    passwordView.layer.shadowOffset=CGSizeMake(0, 0);
    passwordView.layer.shadowRadius=10;
    passwordView.layer.shadowOpacity=0.08;
    [contentView addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(userNameView);
        make.top.mas_equalTo(userNameView.mas_bottom).offset(getHeight(25));
        make.height.mas_equalTo(userNameView);
    }];
    
    getCodeButton=[[UIButton alloc]init];
    getCodeButton.tag=100;
    [getCodeButton setTitle:@"获取验证码" forState:0];
    [getCodeButton setTitleColor:[UIColor colorWithHexString:@"#1fa2ed"] forState:0];
    [getCodeButton setTitleColor:[UIColor colorWithHexString:@"#babbbb"] forState:UIControlStateDisabled];
    [getCodeButton.titleLabel setFont:font15];
    [getCodeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [passwordView addSubview:getCodeButton];
    [getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(102);
        make.right.mas_equalTo(passwordView);
        make.top.mas_equalTo(passwordView);
        make.bottom.mas_equalTo(passwordView);
    }];
    
    UIView *codeLine=[[UIView alloc]init];
    codeLine.backgroundColor=[UIColor colorWithHexString:@"f2f4f7"];
    [passwordView addSubview:codeLine];
    [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getCodeButton.mas_left);
        make.centerY.mas_equalTo(getCodeButton.mas_centerY);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(getHeight(24));
    }];
    
    
    
    passwordFiled=[[UITextField alloc]init];
    passwordFiled.font=font15;
    passwordFiled.keyboardType=UIKeyboardTypeNumberPad;
    passwordFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordFiled.delegate=self;
    passwordFiled.placeholder = @"输入短信验证码";
    passwordFiled.textColor=[UIColor colorWithHexString:@"#444444"];
    [passwordFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [passwordView addSubview:passwordFiled];
    [passwordFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20));
        make.top.mas_equalTo(passwordView);
        make.right.mas_equalTo(codeLine.mas_left).offset(-getWidth(5));
        make.bottom.mas_equalTo(passwordView);
    }];
    
   
    UIButton *xieyiButtom=[[UIButton alloc]init];
    [xieyiButtom.titleLabel setFont:font12];
    NSString *xieyiContent=@"登录注册即代表同意《用户服务协议》";
    NSMutableAttributedString *xieyiattr=[[NSMutableAttributedString alloc]initWithString:xieyiContent];
    [xieyiattr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1fa2ed"] range:NSMakeRange(xieyiContent.length-8,8)];
    [xieyiattr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#888888"] range:NSMakeRange(0,xieyiContent.length-8)];
    [xieyiButtom setAttributedTitle:xieyiattr forState:0];
    [xieyiButtom setImage:[UIImage imageNamed:@"icon-2"] forState:0];
    [xieyiButtom setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [xieyiButtom setTitleEdgeInsets:UIEdgeInsetsMake(0,5, 0, 0)];
    [xieyiButtom addTarget:self action:@selector(xieyi:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:xieyiButtom];
    [xieyiButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passwordView.mas_bottom).mas_offset(SCREEN_WIDTH/375.0*15);
        make.left.mas_equalTo(userNameView).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(250);
    }];
    
    
    loginButton=[UIButton buttonWithTitle:@"快速登录" titleColor:[UIColor colorWithHexString:@"#888888"] font:font17 target:self action:@selector(login:)];
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
        make.top.mas_equalTo(xieyiButtom.mas_bottom).offset(SCREEN_WIDTH/375.0*30);
        make.left.right.mas_equalTo(passwordView);
        make.height.mas_equalTo(getHeight(50));
    }];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(loginButton.mas_bottom);
    }];
    
    [self setIQKeyBorderManager];
    
    wechtLogin=[UIButton buttonWithTitle:@"" titleColor:[UIColor clearColor] font:font13 target:self action:@selector(bangdingWechat)];
    [wechtLogin setImage:[UIImage imageNamed:@"weixin"] forState:0];
    [self.view addSubview:wechtLogin];
    [wechtLogin mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-getHeight(15));
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(283);
    }];
    
//    if ([WXApi isWXAppInstalled]==NO) {
//        wechtLogin.hidden=YES;
//    }else{
//        wechtLogin.hidden=NO;
//    }
}

//获取短信验证码
- (void)getCode:(UIButton *)sender{
    [self.view endEditing:YES];
    if (![numberBOOL checkTelNumber:userNameFiled.text]) {
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
                [getCodeButton setTitle:@"获取验证码" forState:0];
                getCodeButton.enabled=YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [getCodeButton setTitle:[NSString stringWithFormat:@"%.0fs",timeout] forState:0];
                getCodeButton.enabled=NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//开始登录
- (void)login:(UIButton *)sender{
    [self.view endEditing:YES];
    if (![numberBOOL checkTelNumber:userNameFiled.text]) {
        [MBProgressHUD ToastInformation:@"请输入正确的手机号"];
        return;
    }
    if (0==passwordFiled.text.length) {
        [MBProgressHUD ToastInformation:@"请输入正确的验证码"];
        return;
    }
    if (0==self.guid.length){
        [self getSid:sender];
    }else{
        [self checkPhoneCode:self.guid];
    }
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
    NSDictionary *dic=@{@"code":@"",@"phone":[self clearSpace:userNameFiled.text],@"smsCode":@"QQB_YZM",@"sid":sid};
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
    [codeView initWithPhoneNumber:[self clearSpace:userNameFiled.text] PostId:sid okBlock:^(NSString *str, NSString *imageCode) {
        [self.alertView dismissWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"短信已发送"];
                [self autoCodeDecler];
            });
        }];
    } cancelBlock:^{
        [self.alertView dismissWithCompletion:nil];
    }];
    self.alertView=[[JCAlertView alloc]initWithCustomView:codeView dismissWhenTouchedBackground:NO];
    [self.alertView show];
}

/**
 *  验证手机短信验证码
 */
- (void)checkPhoneCode:(NSString *)sid{
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",codeUrl,@"/verify/checksmscode"];
    NSDictionary *dic=@{@"code":[self clearSpace:passwordFiled.text],@"phone":[self clearSpace:userNameFiled.text],@"sid":sid};
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

//短信验证码验证成功开始登录
- (void)beginLogin:(NSString *)sid{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,toLogin];
    NSDictionary *dic=@{@"verifySid":self.guid,@"mobile":[self clearSpace:userNameFiled.text],@"systemType":[NSNumber numberWithInt:0]};
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        [self saveData:response];
    } fail:^(NSError *error) {
        if ([XWNetworking isHaveNetwork]) {
            [MBProgressHUD ToastInformation:@"服务器开小差了"];
        }else{
            [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        }
    } showHud:YES];
}

//登录成功保存个人数据数据
- (void)saveData:(id)response{
    NSLog(@"登录返回数据======%@",response);
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
}


//绑定微信
- (void)bangdingWechat{
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
            } else {
                UMSocialUserInfoResponse *resp = result;
                NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,checkWechat];
                NSDictionary *dic=@{@"wxToken":resp.uid};
                [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
                    if (response) {
                        NSInteger statusCode=[response integerForKey:@"statusCode"];
                        if (statusCode==400) {
                            NSString *errorMsg=[response stringForKey:@"msg"];
                            [MBProgressHUD ToastInformation:errorMsg];
                        }else{
                            if (statusCode==200) {
                                [self saveData:response];
                            }else if(statusCode==201){
                                CheckPhoneController *checkPhone=[[CheckPhoneController alloc]init];
                                checkPhone.wechatId=resp.uid;
                                checkPhone.wxName=resp.name;
                                checkPhone.wximage=resp.iconurl;
                                checkPhone.hidesBottomBarWhenPushed=YES;
                                [self.navigationController pushViewController:checkPhone animated:YES];
                            }
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



#pragma mark - 输入框改变事件
/** 输入框内容发生改变 */
- (void)textFieldChanged:(UITextField *)textField {
    if (userNameFiled == textField || passwordFiled == textField) {
        loginButton.enabled = (0<userNameFiled.text.length && 0<passwordFiled.text.length);
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
    //  限制输入框的输入长度为11
    if (userNameFiled == textField&&textField.text.length >= 11 && textField.markedTextRange==nil ) {
        textField.text = [textField.text substringToIndex:11];
    }
    //  限制输入框的输入长度为11
    if (passwordFiled == textField  && textField.text.length >=6 && textField.markedTextRange==nil ) {
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
    [MobClick beginLogPageView:@"登录"];
//    if ([WXApi isWXAppInstalled]==NO) {
//        wechtLogin.hidden=YES;
//    }else{
//        wechtLogin.hidden=NO;
//    }
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登录"];
}

//注册协议
- (void)xieyi:(UIButton *)sender{
    
    CheckPhoneController *check=[[CheckPhoneController alloc]init];
    [self.navigationController pushViewController:check animated:YES];
    
//    BaseWebViewController *webview=[[BaseWebViewController alloc]init];
//    webview.hidesBottomBarWhenPushed=YES;
//    webview.urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,@""];
//    [self.navigationController pushViewController:webview animated:YES];
}

@end
