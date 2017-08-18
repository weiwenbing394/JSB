//
//  QMYBWebViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/20.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BaseWebViewController.h"
#import <WebKit/WebKit.h>
#import "WeakScriptMessageDelegate.h"
#define changeTotalTime 2.0
#define changeTotalCount 8.0

@interface BaseWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
//浏览器
@property (nonatomic,strong) WKWebView *myWebView;
//WKWebViewConfiguration
@property (nonatomic,strong) WKWebViewConfiguration *config;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //电池栏
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    //关闭自动下滑
    self.automaticallyAdjustsScrollViewInsets=NO;
    //封装请求参数
    if (0<self.urlStr.length) {
        if ([self.urlStr containsString:@"?"]) {
            self.urlStr=[self.urlStr stringByAppendingString:[NSString stringWithFormat:@"&sid=%@",[UserDefaults objectForKey:TOKENID]]];
        }else{
            self.urlStr=[self.urlStr stringByAppendingString:[NSString stringWithFormat:@"?sid=%@",[UserDefaults objectForKey:TOKENID]]];
        }
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.myWebView loadRequest:request];
    NSLog(@"请求地址：%@",self.urlStr);
}


//懒加载
- (WKWebView *)myWebView{
    if (!_myWebView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *newAgent;
        if ([oldAgent containsString:@"djb_app_ios"]) {
            newAgent=oldAgent;
        }else{
            newAgent = [NSString stringWithFormat:@"%@ %@ %@", oldAgent, @"djb_app_ios",[UserDefaults objectForKey:TOKENID]];
        }
        // 设置global User-Agent
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //创建一个webview的配置项
        self.config=[[WKWebViewConfiguration alloc]init];
        // 设置偏好设置
        self.config.preferences=[[WKPreferences alloc]init];
        // 默认为0
        self.config.preferences.minimumFontSize = 5;
        // 默认认为YES
        self.config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        self.config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        //打开h5上的video
        self.config.allowsInlineMediaPlayback=YES;
#define js调用oc方法
        //注入js对象(js通过window.webkit.messageHandlers.JSMethod.postMessage({body: '传数据'});
        self.config.userContentController = [[WKUserContentController alloc]init];
        //分享
        [self.config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"share"];
        //保存字符串图片
        [self.config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"saveimg"];
        //查看图片
        [self.config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"lookImages"];
        //保存url图片
        [self.config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"saveImageWithUrl"];
        //提现成功
        [self.config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"drawMoney"];
        //被踢下线
        [self.config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"loginOut"];
        //退回根视图
        [self.config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"toRootVC"];
        //打开微信
        [self.config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openWechat"];
        //保存图片并复制文件
        [self.config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"copyTextAndImg"];
        //mywebview
        _myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)  configuration:self.config];
        [self.view insertSubview:_myWebView atIndex:0];
        _myWebView.navigationDelegate = self;
        _myWebView.UIDelegate=self;
        _myWebView.allowsBackForwardNavigationGestures = YES;
        [self addObservers];
    }
    return _myWebView;
}


#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.myWebView) {
            if ([XWNetworking isHaveNetwork]) {
                self.jinduProgress.progress=self.myWebView.estimatedProgress>=1?0:self.myWebView.estimatedProgress;
                self.jinduProgress.hidden=self.myWebView.estimatedProgress>=1?YES:NO;
            }else{
                [self autoChangeProgress];
            }
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.myWebView) {
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"canGoBack"]){
        if (object == self.myWebView) {
            self.closeButton.hidden=!self.myWebView.canGoBack;
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"loading"]){
        if (object == self.myWebView) {
           
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    #define oc调用js方法
    // 加载完成
//    if (!self.myWebView.loading) {
//        // 手动调用JS代码
//        // 每次页面完成都弹出来，大家可以在测试时再打开
//        NSString *js = @"window.alert('测试')";
//        [self.myWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//            NSLog(@"response: %@ error: %@", response, error);
//        }];
//    }
}

#pragma mark 没有网络时做个假的进度条
- (void)autoChangeProgress{
    WeakSelf;
    __block float count=0.1;
    //验证码倒计时
    __block float timeout=changeTotalTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),changeTotalTime/changeTotalCount*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.jinduProgress.progress=0.9;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                count+=0.1;
                weakSelf.jinduProgress.progress=count;
            });
            timeout-=changeTotalTime/changeTotalCount;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark WKNavigationDelegate
#pragma mark 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

}

#pragma mark 内容返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
};

#pragma mark 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

#pragma mark 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

//拦截网页操作
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    //拨打电话
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        [[ToolsManager share] toCall:resourceSpecifier];
    //发送邮件
    }else if ([scheme isEqualToString:@"mailto"]){
        NSString *resourceSpecifier = [URL resourceSpecifier];
        [[ToolsManager share] sentMail:resourceSpecifier];
    //支付宝支付
    }else if ([scheme containsString:@"alipay"]) {
        NSString *url = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
        NSInteger subIndex = 23;
        NSString* dataStr=[url substringFromIndex:subIndex];
        //编码
        NSString *encodeString = [self encodeString:dataStr];
        NSMutableString* mString=[[NSMutableString alloc] init];
        [mString appendString:[url substringToIndex:subIndex]];
        [mString appendString:encodeString];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:mString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mString]];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }else if ([scheme containsString:@"weixin"]) {
        NSString *url = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
        NSInteger subIndex = 23;
        NSString* dataStr=[url substringFromIndex:subIndex];
        //编码
        NSString *encodeString = [self encodeString:dataStr];
        NSMutableString* mString=[[NSMutableString alloc] init];
        [mString appendString:[url substringToIndex:subIndex]];
        [mString appendString:encodeString];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:mString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mString]];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

//支付宝支付字符串编码
-(NSString*)encodeString:(NSString*)unencodedString{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)unencodedString,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return encodedString;
}



#pragma mark WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(true);
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(false);
    }];
    [controller addAction:action];
    [controller addAction:cancelAction];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor=[UIColor darkGrayColor];
    }];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(controller.textFields[0].text);
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)webViewDidClose:(WKWebView *)webView{
}

#pragma mark WKScriptMessageHandler
#pragma mark js调用oc方法,参数只支持NSNumber, NSString, NSDate, NSArray,NSDictionary, and   NSNull类型
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //分享
    if ([message.name isEqualToString:@"share"]) {
        if ([message.body isKindOfClass:[NSDictionary class]]&&[[message.body allKeys]containsObject:@"body"]) {
            NSDictionary *contentDic=[message.body objectForKey:@"body"];
            if ([[contentDic allKeys] containsObject:@"shareType"]) {
                [[ToolsManager share] shareImageUrl:contentDic[@"shareImageUrl"] shareUrl:contentDic[@"shareUrl"] title:contentDic[@"shareTile"] subTitle:contentDic[@"subTitle"] shareType:[contentDic[@"shareType"] integerValue]];
            }
        }//保存图片(base64)
    }else if ([message.name isEqualToString:@"saveimg"]) {
        if ([message.body isKindOfClass:[NSDictionary class]]&&[[message.body allKeys]containsObject:@"body"]) {
            if ([[message.body objectForKey:@"body"] isKindOfClass:[NSString class]]) {
                NSString *contentStr=[message.body objectForKey:@"body"];
                [[ToolsManager share] saveImageWithBase64:contentStr];
            }
        }//显示图片(url)
    }else if ([message.name isEqualToString:@"saveImageWithUrl"]){
        if ([message.body isKindOfClass:[NSDictionary class]]&&[[message.body allKeys]containsObject:@"body"]) {
            if ([[message.body objectForKey:@"body"] isKindOfClass:[NSString class]]) {
                NSString *urlStr=[message.body objectForKey:@"body"];
                [[ToolsManager share] saveImageWithUrl:urlStr];
            }
        }
        //支付完成
    }else if ([message.name isEqualToString:@"drawMoney"]){
        [[ToolsManager share] buySuccess];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([message.name isEqualToString:@"toRootVC"]){
        //根视图
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([message.name isEqualToString:@"openWechat"]){
        //打开微信
        [[ToolsManager share] openWechat];
    }else if ([message.name isEqualToString:@"copyTextAndImg"]){
        //复制文件图片和打开微信
        if ([message.body isKindOfClass:[NSDictionary class]]&&[[message.body allKeys]containsObject:@"body"]) {
            NSDictionary *contentDic=[message.body objectForKey:@"body"];
            [self openWechatAndSentImageOrText:contentDic];
        }
    }else if ([message.name isEqualToString:@"loginOut"]){
        //复制文件图片和打开微信
        [[ToolsManager share] loginOut];
    }
};


//复制文件图片和打开微信
- (void)openWechatAndSentImageOrText:(NSDictionary *)contentDic{
    
    if ([[contentDic allKeys] containsObject:@"txt"]&&0<[contentDic stringForKey:@"txt"].length) {
        
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = contentDic[@"txt"];
        
        if ([[contentDic allKeys] containsObject:@"img"]&&0<[contentDic stringForKey:@"img"].length) {
            
            [[ToolsManager share] saveImageWithUrl:[contentDic stringForKey:@"img"] Success:^{
                [self openWechatWithTitle:@"文字、图片复制保存成功！" message:@"打开微信朋友圈，可直接粘贴文字并从手机相册选取图片"];
            } Faild:^(int type){
                if (type==0) {
                    [[ToolsManager share] toastMessage:@"文字复制成功、图片保存失败"];
                }else if(type==1){
                    [[ToolsManager share] toastMessage:@"文字复制成功、图片保存失败！请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
                }
            }];
        }else{
            [[ToolsManager share] shareImageUrl:nil shareUrl:nil title:contentDic[@"txt"] subTitle:nil shareType:2];
        }
    }else{
        if ([[contentDic allKeys] containsObject:@"img"]&&0<[contentDic stringForKey:@"img"].length) {
            [[ToolsManager share] shareImageUrl:[contentDic stringForKey:@"img"] shareUrl:nil title:nil subTitle:nil shareType:1];
        }
    }
}

//打开微信
- (void)openWechatWithTitle:(NSString *)titleMsg message:(NSString *)contentMsg{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:titleMsg message:contentMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *openAction=[UIAlertAction actionWithTitle:@"打开微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开微信
        [[ToolsManager share] openWechat];
    }];
    [alert addAction:openAction];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}




#pragma mark 回退
- (IBAction)goBack:(id)sender {
    if ([self.myWebView canGoBack]) {
        [self.myWebView goBack];
    }else{
        [self.myWebView stopLoading];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark 关闭按钮
- (IBAction)goPreViewController:(id)sender {
    [self.myWebView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark wkwebview属性监听
- (void)addObservers {
    [self.myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.myWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.myWebView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [self.myWebView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark 移除wkwebview属性监听
- (void)dealloc {
    NSLog(@"释放了");
    
    [self.config.userContentController removeScriptMessageHandlerForName:@"share"];
    [self.config.userContentController removeScriptMessageHandlerForName:@"saveimg"];
    [self.config.userContentController removeScriptMessageHandlerForName:@"saveImageWithUrl"];
    [self.config.userContentController removeScriptMessageHandlerForName:@"drawMoney"];
    [self.config.userContentController removeScriptMessageHandlerForName:@"loginOut"];
    
    [self.myWebView stopLoading];
    [self.myWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.myWebView removeObserver:self forKeyPath:@"title"];
    [self.myWebView removeObserver:self forKeyPath:@"canGoBack"];
    [self.myWebView removeObserver:self forKeyPath:@"loading"];
    
    [self.myWebView removeFromSuperview];
    self.myWebView=nil;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
