//
//  LineView.m
//  FSB
//
//  Created by 大家保 on 2017/7/29.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "LineView.h"
#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

//视图的宽度
#define  selfWidth (self.frame.size.width)

//视图的高度
#define selfHeight (self.frame.size.height)

//y刻度视图所占宽度
#define leftViewWidth (50)

//x刻度视图所占的高度
#define bottomViewHeight (22)

//y刻度所占高度
#define leftViewHeight (selfHeight-bottomViewHeight)

//表格主视图所占宽度
#define tableWidth (selfWidth-leftViewWidth)

//x刻度视图所占的宽度
#define bottomViewWidth (tableWidth)

//表格主视图所占高度
#define tableHeight (selfHeight-bottomViewHeight)

@interface LineView (){
    //线
    CAShapeLayer *shapeLayer;
    //填充域
    CAGradientLayer *gradientLayer;
    //基础域
    CALayer *baseLayer;
    //左边y刻度视图
    UIView *leftView;
    //下边x刻度视图
    UIView *bottomView;
    //每一个小格子的宽度
    CGFloat xWidth;
    //每一个小格的高度
    CGFloat yHeight;
}

//按钮数组
@property (nonatomic,strong) NSMutableArray *btnArray;

//所有坐标点的数组
@property (nonatomic,strong) NSMutableArray *pointArray;

//x坐标label数组
@property (nonatomic,strong) NSMutableArray *xLabelArray;

//y坐标label数组
@property (nonatomic,strong) NSMutableArray *yLabelArray;

//所有的横线数组
@property (nonatomic,strong) NSMutableArray *horiLineArray;

//表格视图
@property (nonatomic,strong) UIView *tableView;

@property (nonatomic,strong) UIColor *btnColor;

@end

@implementation LineView

//初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        //线条颜色
        self.xlineColor=[UIColor clearColor];
        //文字颜色
        self.xtitleColor=[UIColor clearColor];
        self.ytitleColor=[UIColor clearColor];
        //表格的背景颜色
        self.tableViewBgColor=[UIColor clearColor];
        //背景颜色
        self.backgroundColor=[UIColor clearColor];
        //线的颜色
        self.btnColor=[UIColor clearColor];
        self.btnLineColor=[UIColor clearColor];
        //添加区域
        [self tableSview];
    }
    return self;
}

//添加线条
- (void)tableSview{
    //添加表格视图
    self.tableView=[[UIView alloc]initWithFrame:CGRectMake(leftViewWidth, 0,tableWidth , tableHeight)];
    self.tableView.backgroundColor=self.tableViewBgColor;
    [self addSubview:self.tableView];
    //左边y轴刻度视图
    leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, leftViewWidth, leftViewHeight)];
    leftView.backgroundColor=[UIColor clearColor];
    [self addSubview:leftView];
    //下边x轴视图
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(leftViewWidth, leftViewHeight, bottomViewWidth, bottomViewHeight)];
    bottomView.backgroundColor=[UIColor clearColor];
    [self addSubview:bottomView];
}

//设置数据源
- (void)setDataArr:(NSArray *)dataArr{
    if (0==dataArr.count) {
        //移除旧的连线
        [shapeLayer removeFromSuperlayer];
        [baseLayer removeFromSuperlayer];
        //移除旧的按钮
        for (id btn in self.tableView.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                [btn removeFromSuperview];
            }
        }
        return;
    }
    //添加点和按钮
    [self addDataPointWithArr:dataArr];
    //添加连线
    [self addLineBezierPoint:self.tableView];
}


//添加点和按钮
-(void)addDataPointWithArr:(NSArray *)dataArr{
    //计算xwidth
    xWidth=tableWidth/(dataArr.count-1);
    [self.btnArray removeAllObjects];
    [self.pointArray removeAllObjects];
    
    //初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:dataArr];
    for (int i = 0; i<arr.count; i++) {
        CGFloat x=i*xWidth;
        CGFloat y=[arr[i] floatValue]*tableHeight;
        //数组添加点
        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [self.pointArray addObject:point];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 6, 6)];
        btn.backgroundColor = self.btnColor;
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.center=CGPointMake(x, y);
        //数组添加按钮
        [self.btnArray addObject:btn];
    }
}


//添加连线
- (void)addLineBezierPoint:(UIView *)view{
    //取得起始点
    CGPoint firstPoint = [[self.pointArray objectAtIndex:0] CGPointValue];
    //取得终点
    CGPoint lastPoint;
    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:firstPoint];
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:firstPoint];
    //描绘路径(直线)
    for (int i = 0;i<self.pointArray.count;i++ ) {
        if (i != 0) {
            CGPoint point = [[self.pointArray objectAtIndex:i] CGPointValue];
            [beizer addLineToPoint:point];
            [bezier1 addLineToPoint:point];
            if (i == self.pointArray.count-1) {
                [beizer moveToPoint:point];//添加连线
                lastPoint = point;
            }
        }
    }
    
    
    //描绘路径(曲线)
//    NSMutableArray *points = [self.pointArray mutableCopy];
//    [points insertObject:[points objectAtIndex:0] atIndex:0];
//    [points addObject:[points lastObject]];
//    [beizer moveToPoint:POINT(0)];
//    [bezier1 moveToPoint:POINT(0)];
//    for(NSUInteger index = 1; index < points.count - 2; index++) {
//        CGPoint p0 = POINT(index - 1);
//        CGPoint p1 = POINT(index);
//        CGPoint p2 = POINT(index + 1);
//        CGPoint p3 = POINT(index + 2);
//        for (int i = 1; i < 1000; i++) {
//            float t = (float) i * (1.0f / (float) 1000);
//            float tt = t * t;
//            float ttt = tt * t;
//            CGPoint pi;
//            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
//            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
//            [beizer addLineToPoint:pi];
//            [bezier1 addLineToPoint:pi];
//        }
//        //添加连线
//        [beizer moveToPoint:p2];
//        [bezier1 moveToPoint:p2];
//    }
//    [beizer addLineToPoint:POINT(points.count - 1)];
//    [bezier1 addLineToPoint:POINT(points.count - 1)];
//    lastPoint = POINT(points.count - 1);
    
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    //最后一个点对应的坐标
    CGPoint endPoint = CGPointMake(lastPointX, tableHeight);
    [bezier1 addLineToPoint:endPoint];
    //回到原点
    [bezier1 addLineToPoint:CGPointMake(firstPoint.x,tableHeight)];
    [bezier1 addLineToPoint:firstPoint];
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor redColor].CGColor;
    [view.layer addSublayer:shadeLayer];
    
    //渐变图层
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0, tableHeight);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius =0;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:166/255.0 green:206/255.0 blue:247/255.0 alpha:0.7].CGColor,(__bridge id)[UIColor colorWithRed:237/255.0 green:246/255.0 blue:253/255.0 alpha:0.5].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    [baseLayer removeFromSuperlayer];
    baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    [view.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 1;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2*lastPoint.x, tableHeight)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    //移除旧的连线
    [shapeLayer removeFromSuperlayer];
    //添加新的动画连线
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = self.btnLineColor.CGColor;
    shapeLayer.lineWidth = 1;
    [view.layer addSublayer:shapeLayer];
    
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration = 1;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anmi.autoreverses = NO;
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    //移除旧的按钮
    for (id btn in view.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn removeFromSuperview];
        }
    }
    //添加新的按钮
    for (UIButton *btn in self.btnArray) {
        [view addSubview:btn];
    }
}

//设置底部的刻度
- (void)setXArray:(NSArray *)xArray{
    [self.xLabelArray removeAllObjects];
    for (id view in bottomView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat width=tableWidth/(xArray.count);
    for (int i=0; i<xArray.count; i++) {
        UILabel *bottomLine=[[UILabel alloc]init];
        if (i==0) {
            bottomLine.frame=CGRectMake(i*width,10, width,12);
            bottomLine.textAlignment=NSTextAlignmentLeft;
        }else if (i==xArray.count-1){
            bottomLine.frame=CGRectMake(i*width,10, width,12);
            bottomLine.textAlignment=NSTextAlignmentRight;
        }else{
            CGFloat centerWidth=tableWidth/(xArray.count-1);
            bottomLine.frame=CGRectMake(i*centerWidth-centerWidth/2.0,10, centerWidth,12);
            bottomLine.textAlignment=NSTextAlignmentCenter;
        }
        bottomLine.font=font12;
        bottomLine.textColor=self.xtitleColor;
        bottomLine.text=xArray[i];
        [bottomView addSubview:bottomLine];
        [self.xLabelArray addObject:bottomLine];
    }
}

//设置左边的刻度
- (void)setYArray:(NSArray *)yArray{
    [self.yLabelArray removeAllObjects];
    for (id view in leftView.subviews) {
        [view removeFromSuperview];
    }
    
    yHeight=tableHeight/(yArray.count-1);
    yArray=[[yArray reverseObjectEnumerator] allObjects];
    
    for (int i=0; i<yArray.count; i++) {
        UILabel *leftLine=[[UILabel alloc]init];
        if (i==0) {
            leftLine.frame=CGRectMake(0,i*yHeight, leftViewWidth-10, 10);
        }else if(i==yArray.count-1){
            leftLine.frame=CGRectMake(0,i*yHeight-10, leftViewWidth-10, 10);
        }else{
            leftLine.frame=CGRectMake(0,i*yHeight-5, leftViewWidth-10, 10);
        }
        leftLine.textAlignment=NSTextAlignmentRight;
        leftLine.font=font12;
        leftLine.textColor=self.ytitleColor;
        if ([yArray[i] floatValue]>=10000) {
            leftLine.text=[NSString stringWithFormat:@"%.0fW",[yArray[i] floatValue]/10000.0];
        }else if ([yArray[i] floatValue]>=1000) {
            leftLine.text=[NSString stringWithFormat:@"%.0fK",[yArray[i] floatValue]/1000.0];
        }else{
            leftLine.text=[NSString stringWithFormat:@"%.0f",[yArray[i] floatValue]];
        }
        [leftView addSubview:leftLine];
        [self.yLabelArray addObject:leftLine];
    }
    
    //画横线
    [self drawHoriLine:yArray];
}

//画横线
- (void)drawHoriLine:(NSArray *)lineArray{
    [self.horiLineArray removeAllObjects];
    for (id view in self.tableView.subviews) {
        [view removeFromSuperview];
    }
    //添加横线
    for (int i=0; i<lineArray.count; i++) {
        UILabel *horiLine=[[UILabel alloc]initWithFrame:CGRectMake(0,i*yHeight, tableWidth, 1)];
        horiLine.backgroundColor=self.xlineColor;
        [self.tableView addSubview:horiLine];
        [self.horiLineArray addObject:horiLine];
    }
}


//设置xtitleColor
- (void)setXtitleColor:(UIColor *)xtitleColor{
    for (int i=0; i<self.xLabelArray.count; i++) {
        UILabel *label=self.xLabelArray[i];
        label.textColor=xtitleColor;
    }
 }

//设置ytitleColor
- (void)setYtitleColor:(UIColor *)ytitleColor{
    for (int i=0; i<self.yLabelArray.count; i++) {
        UILabel *label=self.yLabelArray[i];
        label.textColor=ytitleColor;
    }
}


//设置表格的背景颜色
- (void)setTableViewBgColor:(UIColor *)tableViewBgColor{
    self.tableView.backgroundColor=tableViewBgColor;
}

//设置表格横线颜色
- (void)setXlineColor:(UIColor *)xlineColor{
    for (int i=0; i<self.horiLineArray.count; i++) {
        UILabel *horiLine=self.horiLineArray[i];
        horiLine.backgroundColor=xlineColor;
    }
}

//设置按钮颜色
- (void)setBtnColor:(UIColor *)color atIndex:(NSInteger)index;{
    if (index>self.btnArray.count-1) {
        return;
    }
    for (int i=0; i<self.btnArray.count; i++) {
        UIButton *btn=self.btnArray[i];
        if (i==index) {
            btn.backgroundColor=color;
            btn.layer.borderColor =color.CGColor;
        }else{
            btn.backgroundColor=[UIColor clearColor];
            btn.layer.borderColor =[UIColor clearColor].CGColor;
        }
    }
}

//设置连线颜色
- (void)setBtnLineColor:(UIColor *)btnLineColor{
     shapeLayer.strokeColor = btnLineColor.CGColor;
}

//设置填充颜色
- (void)setFillColorArray:(NSArray *)fillColorArray{
    gradientLayer.colors=fillColorArray;
}



#pragma mark数组懒加载
- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray=[NSMutableArray array];
    }
    return _btnArray;
}

- (NSMutableArray *)pointArray{
    if (!_pointArray) {
        _pointArray=[NSMutableArray array];
    }
    return _pointArray;
}

- (NSMutableArray *)xLabelArray{
    if (!_xLabelArray) {
        _xLabelArray=[NSMutableArray array];
    }
    return _xLabelArray;
}

- (NSMutableArray *)yLabelArray{
    if (!_yLabelArray) {
        _yLabelArray=[NSMutableArray array];
    }
    return _yLabelArray;
}

- (NSMutableArray *)horiLineArray{
    if (!_horiLineArray) {
        _horiLineArray=[NSMutableArray array];
    }
    return _horiLineArray;
}

@end
