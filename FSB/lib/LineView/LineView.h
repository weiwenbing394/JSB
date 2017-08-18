//
//  LineView.h
//  FSB
//
//  Created by 大家保 on 2017/7/29.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView

//数据数组
@property (nonatomic,strong) NSArray *dataArr;

//y坐标刻度数组
@property (nonatomic,strong) NSArray *yArray;

//x坐标刻度数组
@property (nonatomic,strong) NSArray *xArray;

//x轴字体颜色
@property (nonatomic,strong) UIColor *xtitleColor;

//y轴字体颜色
@property (nonatomic,strong) UIColor *ytitleColor;

//x轴线条颜色
@property (nonatomic,strong) UIColor *xlineColor;

//表格的背景颜色
@property (nonatomic,strong) UIColor *tableViewBgColor;

//设置按钮颜色
- (void)setBtnColor:(UIColor *)color atIndex:(NSInteger)index;

//设置按钮连线颜色
@property (nonatomic,strong) UIColor *btnLineColor;

//设置填充颜色
@property (nonatomic,strong)NSArray *fillColorArray;

@end
