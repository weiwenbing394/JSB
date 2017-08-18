//
//  QMYBWebViewController.h
//  QMYB
//
//  Created by 大家保 on 2017/2/20.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BaseWebViewController : UIViewController
//返回按钮
@property (weak, nonatomic) IBOutlet UIButton *backButton;
//关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
//进度条
@property (weak, nonatomic) IBOutlet UIProgressView *jinduProgress;
//链接地址
@property (nonatomic,copy) NSString *urlStr;

@end
