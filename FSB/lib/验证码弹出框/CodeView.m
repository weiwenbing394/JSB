//
//  CodeView.m
//  tianyi360
//
//  Created by 大家保 on 16/7/8.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "CodeView.h"
#import "PCLockLabel.h"


@interface CodeView ()

@property (nonatomic, copy) NSString *yanzhengtupianphoneNumber;

@end

@implementation CodeView

- (instancetype) initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.layer.cornerRadius=3;
        self.layer.masksToBounds=YES;
        self.backgroundColor=[UIColor whiteColor];
        if (SCREEN_WIDTH>320) {
            self.frame=CGRectMake(0, 0, SCREEN_WIDTH-60, 150);
        }else{
            self.frame=CGRectMake(0, 0, SCREEN_WIDTH-40, 150);
        }
        
    }
    return self;
};

- (void)initWithPhoneNumber:(NSString *)phoneNumber PostId:(NSString *)postID okBlock:(OKBlock )okBloc cancelBlock:(CancelBlock )cancelBloc {
    self.yanzhengtupianphoneNumber = phoneNumber;
    [self initWithPostId:postID okBlock:okBloc cancelBlock:cancelBloc];
}

- (void)initWithPostId:(NSString *)postID okBlock:(OKBlock )okBloc cancelBlock:(CancelBlock )cancelBloc{
    
    self.postSid=postID;
    self.okBlock=okBloc;
    self.cancelBlock=cancelBloc;
    
    PCLockLabel *warm;
    if (SCREEN_WIDTH>320) {
        warm=[[PCLockLabel alloc]initWithFrame:CGRectMake(30,30 ,SCREEN_WIDTH-140 , 12)];
    }else{
        warm=[[PCLockLabel alloc]initWithFrame:CGRectMake(20,20 ,SCREEN_WIDTH-140 , 12)];
    }
    warm.tag=1000;
    warm.text=@"请输入图片验证码";
    warm.font=[UIFont systemFontOfSize:10];
    warm.textAlignment=NSTextAlignmentLeft;
    warm.textColor=[UIColor redColor];
    [self addSubview:warm];
    
    UITextField * imageCodeField=[[UITextField alloc]initWithFrame:CGRectMake(GetViewX(warm), GetViewY(warm)+GetViewHeight(warm)+10, 100, 35)];
    imageCodeField.tag=1001;
    imageCodeField.layer.cornerRadius=2;
    imageCodeField.layer.borderWidth=0.5;
    imageCodeField.textAlignment=NSTextAlignmentCenter;
    imageCodeField.placeholder=@"输入图片验证码";
    imageCodeField.keyboardType=UIKeyboardTypeEmailAddress;
    imageCodeField.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    imageCodeField.layer.masksToBounds=YES;
    imageCodeField.font = [UIFont systemFontOfSize:12];
    imageCodeField.tintColor = [UIColor darkGrayColor];
    imageCodeField.textColor = [UIColor darkGrayColor];
    imageCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    imageCodeField.delegate = self;
    imageCodeField.returnKeyType=UIReturnKeyDone;
    imageCodeField.delegate=self;
    [imageCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:imageCodeField];
    
    
    UIImageView *_captchaView;
    if (SCREEN_WIDTH>320) {
        _captchaView = [[UIImageView alloc] initWithFrame:CGRectMake(GetViewX(warm)+GetViewWidth(imageCodeField)+10, GetViewY(warm)+GetViewHeight(warm)+10, 100, 35)];
    }else{
        _captchaView = [[UIImageView alloc] initWithFrame:CGRectMake(GetViewX(warm)+GetViewWidth(imageCodeField)+10, GetViewY(warm)+GetViewHeight(warm)+10, 90, 35)];
    }
    _captchaView.layer.cornerRadius=2;
    _captchaView.layer.masksToBounds=YES;
    _captchaView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _captchaView.layer.borderWidth=0.5;
    _captchaView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refresh)];
    [_captchaView addGestureRecognizer:tap];
    _captchaView.backgroundColor=[UIColor whiteColor];
    _captchaView.tag=1002;
    [self addSubview:_captchaView];
    
    [self refresh];
    
    UIButton *changeButton=[[UIButton alloc]initWithFrame:CGRectMake(GetViewX(_captchaView)+GetViewWidth(_captchaView)+10, GetViewY(warm)+GetViewHeight(warm)+10, 35, 35)];
    changeButton.layer.cornerRadius=2;
    changeButton.layer.masksToBounds=YES;
    changeButton.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    changeButton.layer.borderWidth=0.5;
    [changeButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [changeButton setImage:[UIImage imageNamed:@"刷新"] forState:0];
    [self addSubview:changeButton];
    
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, GetViewHeight(self)-45, GetViewWidth(self), 0.5)];
    line.backgroundColor=RGBA(231, 231, 232, 1);
    [self addSubview:line];
    
    UILabel *Verticalline=[[UILabel alloc]initWithFrame:CGRectMake(GetViewWidth(self)/2.0, GetViewHeight(self)-45, 0.5, 45)];
    Verticalline.backgroundColor=RGBA(231, 231, 232, 1);
    [self addSubview:Verticalline];
    
    UIButton *cancel=[[UIButton alloc]initWithFrame:CGRectMake(0, GetViewHeight(self)-45, GetViewWidth(self)/2.0, 45)];
    [cancel setTitleColor:RGB(65, 160, 218) forState:0];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [cancel setTitle:@"取消" forState:0];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:cancel];
    
    UIButton *ok=[[UIButton alloc]initWithFrame:CGRectMake(GetViewWidth(self)/2.0, GetViewHeight(self)-45, GetViewWidth(self)/2.0, 45)];
    [ok setTitleColor:RGB(65, 160, 218) forState:0];
    [ok setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [ok addTarget:self action:@selector( determine:) forControlEvents:UIControlEventTouchUpInside];
    [ok setTitle:@"确定" forState:0];
    [ok.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:ok];

}

/**
 *  刷新
 */
- (void)refresh{
    NSString *urlStr=[NSString stringWithFormat:@"%@%@sid=%@",codeUrl,@"/verify/img?",self.postSid];
    [XWNetworking getDataWithUrl:urlStr params:nil success:^(id response) {
        if (response) {
            UIImageView *captView=[self viewWithTag:1002];
            captView.image=[[UIImage alloc]initWithData:response];
        }
    } fail:^(NSError *error) {
        PCLockLabel  *warmingLabel=[self viewWithTag:1000];
        [warmingLabel showWarnMsgAndShake:@"系统繁忙，请刷新"];
    } showHud:NO];
}


#pragma mark - 按钮事件


/**
 *  确定按钮
 */
- (void)determine:(UIButton *)btn{
    UITextField *imageCodeField=[self viewWithTag:1001];
    [imageCodeField resignFirstResponder];
    PCLockLabel  *warmingLabel=[self viewWithTag:1000];
    if ([imageCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
        [warmingLabel showWarnMsgAndShake:@"请输入验证码"];
        [self refresh];
        return;
    }
    [self yanzhengPhoneCode];
    
}
/**
 *  取消
 */
- (void)cancel:(UIButton *)btn{
    UITextField *imageCodeField=[self viewWithTag:1001];
    [imageCodeField resignFirstResponder];
    self.cancelBlock();
}


/**
 *  验证验证码是否正确
 */
- (void)yanzhengPhoneCode{
     UITextField *imageCodeField=[self viewWithTag:1001];
     PCLockLabel  *warmingLabel=[self viewWithTag:1000];
     NSString *urlStr=[NSString stringWithFormat:@"%@/verify/sms",codeUrl];
    NSDictionary *dic=@{@"code":[imageCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],@"phone":self.yanzhengtupianphoneNumber,@"smsCode":@"QQB_YZM",@"sid":self.postSid};
    [XWNetworking postJsonWithUrl:urlStr params:dic success:^(id response) {
        NSDictionary *dic=response;
        NSInteger code=[dic integerForKey:@"code"];
        if (code==1) {
            self.okBlock(self.postSid,imageCodeField.text);
        }else if(code==0){
            [warmingLabel showWarnMsgAndShake:@"验证码错误,请重新输入"];
            imageCodeField.text=@"";
            [self refresh];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *errorMsg=[dic objectForKey:@"message"];
                [MBProgressHUD ToastInformation:errorMsg];
                [imageCodeField resignFirstResponder];
                self.cancelBlock();
            });
        }
    } fail:^(NSError *error) {
        if ([XWNetworking isHaveNetwork]) {
            [MBProgressHUD ToastInformation:@"服务器开小差了"];
        }else{
            [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        }
    } showHud:NO];
}



#pragma mark -  输入框限制
/**
 *  限制输入框的长度
 *
 *  @param textField 输入框
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    UITextField *imageCodeField=[self viewWithTag:1001];
    if (textField==imageCodeField){
        if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length >4&&textField.markedTextRange==nil) {
            textField.text = [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] substringToIndex:4];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UITextField *imageCodeField=[self viewWithTag:1001];
    [imageCodeField resignFirstResponder];
    return YES;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


@end
