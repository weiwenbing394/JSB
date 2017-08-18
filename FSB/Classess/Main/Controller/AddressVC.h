//
//  AddressVC.h
//  FSB
//
//  Created by 大家保 on 2017/8/16.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfo.h"

@interface AddressVC : BaseViewController

@property (nonatomic,strong)UserInfo *user;

@property (nonatomic,copy) void(^SuccessBlock)(UserInfo *user);

@end
