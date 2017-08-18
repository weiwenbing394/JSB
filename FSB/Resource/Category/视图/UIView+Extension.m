//
//  UIView+Extension.m
//  01-黑酷
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (void)addTarget:(id)target action:(SEL)action;{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target
                                                                         action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}


- (BOOL)isShowingOnKeyWindow{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

+ (instancetype)viewFromXib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    // 栅格化 - 提高性能
    // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
    self.layer.rasterizationScale = UIScreen.ff_scale;
    self.layer.shouldRasterize = YES;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void) distributeSpacingHorizontallyWith:(NSArray*)views{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    for ( int i = 0 ; i < views.count+1 ; ++i ){
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    UIView *v0 = spaces[0];
    __weak __typeof(&*self)ws = self;
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left);
        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
    }];
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i ){
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastSpace.mas_right);
        }];
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.mas_right);
            make.centerY.equalTo(obj.mas_centerY);
            make.width.equalTo(v0);
        }];
        lastSpace = space;
    }
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right);
    }];
}

- (void) distributeSpacingVerticallyWith:(NSArray*)views{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    for ( int i = 0 ; i < views.count+1 ; ++i ){
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    UIView *v0 = spaces[0];
    __weak __typeof(&*self)ws = self;
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_top);
        make.centerX.equalTo(((UIView*)views[0]).mas_centerX);
    }];
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i ){
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastSpace.mas_bottom);
        }];
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(obj.mas_bottom);
            make.centerX.equalTo(obj.mas_centerX);
            make.height.equalTo(v0);
        }];
        lastSpace = space;
    }
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.mas_bottom);
    }];
}

@end
