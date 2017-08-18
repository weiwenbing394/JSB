//
//  UIView+Extension.h
//  01-黑酷
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;
/**
 *  9.上 < Shortcut for frame.origin.y
 */
@property (nonatomic) CGFloat top;
/**
 *  10.下 < Shortcut for frame.origin.y + frame.size.height
 */
@property (nonatomic) CGFloat bottom;
/**
 *  11.左 < Shortcut for frame.origin.x.
 */
@property (nonatomic) CGFloat left;
/**
 *  12.右 < Shortcut for frame.origin.x + frame.size.width
 */
@property (nonatomic) CGFloat right;
/**
 *  添加动作
 */
- (void)addTarget:(id)target action:(SEL)action;
/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;
/**
 * xib初始化视图
 */
+ (instancetype)viewFromXib;
/**
 *  边线颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
/**
 *  边线宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/**
 *  脚半径
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
/**
 *  横向等间距排列视图
 */
- (void) distributeSpacingHorizontallyWith:(NSArray*)views;
/**
 *  纵向等间距排列视图
 */
- (void) distributeSpacingVerticallyWith:(NSArray*)views;

@end
