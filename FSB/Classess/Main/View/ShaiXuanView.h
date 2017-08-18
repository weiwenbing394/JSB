//
//  ShaiXuanView.h
//  FSB
//
//  Created by 大家保 on 2017/8/7.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShaiXuanView : UIView

//确定block
@property (nonatomic,copy) void (^okBlock) (NSMutableArray *array);

//已选中的数据
@property (nonatomic,strong) NSMutableArray *selectedArray;

//开始显示
- (void)show:(UIView *)view;

//开始隐藏
- (void)hide;

//加载数据
- (void)reloadDtaWithType:(int)careType;


@end
