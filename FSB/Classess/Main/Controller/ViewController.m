//
//  ViewController.m
//  FSB
//
//  Created by 大家保 on 2017/7/29.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "ViewController.h"
#import "MainVC.h"
#import "FindVC.h"
#import "MeVC.h"
#import "SearchVC.h"
#define itemWidth (73*SCREEN_WIDTH/375.0)

@implementation ViewController

//初始化
- (instancetype)init{
    if (self=[super init]) {
        self = [[ViewController alloc] initWithViewControllerClasses:[self ViewControllerClasses] andTheirTitles:[self titles]];
        self.menuViewStyle=WMMenuViewStyleLine;
        self.menuBGColor=[UIColor whiteColor];
        self.menuHeight=44;
        self.progressHeight=2;
        self.titleSizeNormal=16;
        self.titleSizeSelected=18;
        self.progressViewCornerRadius=0;
        self.progressViewIsNaughty=YES;
        self.titleColorSelected=[UIColor colorWithHexString:@"#1fa2ed"];
        self.titleColorNormal=[UIColor colorWithHexString:@"#444444"];
        self.itemsWidths=@[@(itemWidth),@(itemWidth),@(itemWidth)];
        self.progressViewWidths=@[@(20),@(20),@(20)];
        self.itemsMargins=@[@(0),@(0),@(0),@(SCREEN_WIDTH-3*itemWidth)];
        self.viewFrame=CGRectMake(0,20, SCREEN_WIDTH, SCREEN_HEIGHT-20);
    }
    return self;
};

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  initUI];
    
}

// 存响应的控制器
- (NSArray *)ViewControllerClasses {
    return @[[MainVC class],[FindVC class],[MeVC class]];
}

//储存响应的标题
- (NSArray *)titles{
    return @[@"首页",@"发现",@"我的"];
}

//初始化视图
- (void)initUI{
    UIButton *searchButtom=[[UIButton alloc]init];
    [searchButtom addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [searchButtom setBackgroundColor:[UIColor whiteColor]];
    searchButtom.layer.cornerRadius=3;
    searchButtom.clipsToBounds=YES;
    [searchButtom setImage:[UIImage imageNamed:@"sousuo"] forState:0];
    [self.view addSubview:searchButtom];
    [searchButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(44);
    }];
};

//搜索
- (void)search:(UIButton *)sender{
    SearchVC *search=[[SearchVC alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark 电池栏白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return  UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//当前选中的控制器
//- (void)pageController:(WMPageController * _Nonnull)pageController didEnterViewController:(__kindof UIViewController * _Nonnull)viewController withInfo:(NSDictionary * _Nonnull)info{
//    NSInteger index=[[self viewControllerClasses] indexOfObject:[viewController class]];
//};

@end
