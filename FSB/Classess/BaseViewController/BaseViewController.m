//
//  QMYBBaseViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController (){
    UILabel *titleLabel;
    IQKeyboardReturnKeyHandler *returnKeyHandler;
    
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initNavBar];
}

//添加监听
- (instancetype)init{
    if (self=[super init]) {
        //添加登录的监听
        [NotiCenter addObserver:self selector:@selector(haveLogin) name:LOGINNOTIFIC object:nil];
        //添加退出的监听
        [NotiCenter addObserver:self selector:@selector(haveLogout) name:LOGOUTNOTIFIC object:nil];
        //添加购买成功监听
        [NotiCenter addObserver:self selector:@selector(haveBuySuccess) name:BUYSUCCESS object:nil];
    }
    return self;
}

//移除监听
- (void)dealloc{
    [NotiCenter removeObserver:self];
}

/**
 *  导航栏初始化
 */
- (void)initNavBar{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
}

/**
 *  添加返回按钮
 */
- (void)addLeftButton{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [leftButton setImage:[UIImage imageNamed:@"icon-11"] forState:0];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
};

/**
 *  添加左边按钮
 *
 */
- (void)addLeftBarButton:(NSString *)imageName{
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 20, 45, 44)];
    leftButton.tag=20000;
    [leftButton setImage:[UIImage imageNamed:imageName] forState:0];
    [leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
};

/**
 *  添加右边按钮
 *
 *  @param rightStr 右边按钮标题
 */
- (void)addRightButton:(NSString *)rightStr{
    CGSize rightStrSzie=[rightStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SystemFont(16),NSFontAttributeName, nil]];
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25-rightStrSzie.width, 20, rightStrSzie.width+20, 44)];
    rightButton.tag=10000;
    [rightButton.titleLabel setFont:SystemFont(16)];
    [rightButton setTitle:rightStr forState:0];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:0];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [rightButton addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
};

/**
 *  添加右边按钮（图片）
 */
- (void)addRightButtonWithImageName:(NSString *)imageName{
    UIButton *RightButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-45, 20, 45, 44)];
    RightButton.tag=10000;
    [RightButton setImage:[UIImage imageNamed:imageName] forState:0];
    [RightButton addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RightButton];
}

/**
 *  添加标题
 *
 *  @param title 基类标题
 */
- (void)addTitle:(NSString *)title{
    if (titleLabel == nil) { //在某些页面需要修改title，所以就修改了一下
        
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH-120, 43.5)];
        titleLabel.textColor=[UIColor colorWithHexString:@"#444444"];;
        titleLabel.font=font18;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    titleLabel.text=title;
    [self.view addSubview:titleLabel];
//    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
//    line.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
//    [self.view addSubview:line];
    
};

/**
 *  左按钮返回事件
 */
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  leftBarButton点击事件 ,子类重写
 *
 */

- (void)leftClick:(UIButton *)btn{
    
}

/**
 *  登录事件 ,子类重写
 *
 */
- (void)haveLogin{
    
};

/**
 *  登出事件 ,子类重写
 *
 */
- (void)haveLogout{
    
};

/**
 *  购买成功
 *
 */
- (void)haveBuySuccess{
    
};

/**
 *  去登录
 *
 */
- (void)toLoginVC{
    LoginController *login=[[LoginController alloc]init];
    BaseNavigationController *nav=[[BaseNavigationController alloc]initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  右边按钮事件：子类重写
 *
 *  @param button 触发按钮
 */
- (void)forward:(UIButton *)button{
    
}

/**
 *  去除字符串空格
 *
 *  @param str 去处空格前的字符
 *
 *  @return 去处空格后的字符
 */
- (NSString *)clearSpace:(NSString *)str{
    return 0==str.length?@"":[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}


/**
 *  网络是否可用
 *
 *  @return 网络是否可用
 */
-(BOOL)isNetworkRunning{
    return [XWNetworking isHaveNetwork];
};


#pragma mark - 右侧滑动到某个控制器
/** 右侧滑动到第几个视图控制器  从0开始计算 */
- (void)rightSlideToViewControllerIndex:(NSInteger)index {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    if (array.count <= index+2) {
        return;
    }
    while(array.count > index+2) {
        [array removeObjectAtIndex:index+1];
    }
    [self.navigationController setViewControllers: array];
}


/** 右侧滑动到根部视图控制器 */
- (void)rightSlideToRootController {
    [self rightSlideToViewControllerIndex:0];
}

/** 设置IQKeyBorderManager */
- (void)setIQKeyBorderManager{
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc]initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType =UIReturnKeyDone;
};


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
