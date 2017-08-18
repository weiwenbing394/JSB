//
//  JDFooter.m
//  MJRefresh_Test
//
//  Created by 大家保 on 2016/10/17.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "MJFooter.h"

@interface MJFooter ()

@property (nonatomic,strong)UIActivityIndicatorView *myIndicate;

@property (nonatomic,strong)UILabel *detailLabel;

@property (nonatomic,strong) UILabel *footerLabel;

@end

@implementation MJFooter

- (void)prepare{
    [super prepare];
    
    self.mj_h=50;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    label.textColor=[UIColor colorWithHexString:@"#737f87"];
    label.font=SystemFont(14);
    label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:label];
    self.footerLabel=label;
    
    UILabel *detailLabel=[[UILabel alloc]init];
    detailLabel.textColor=[UIColor colorWithHexString:@"#737f87"];
    detailLabel.font=SystemFont(14);
    detailLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:detailLabel];
    self.detailLabel=detailLabel;
    
    UIActivityIndicatorView *indicate=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicate.hidesWhenStopped=YES;
    [indicate stopAnimating];
    [self addSubview:indicate];
    self.myIndicate=indicate;
}

- (void)placeSubviews{
    [super placeSubviews];
    
    self.footerLabel.center=CGPointMake(self.mj_w/2.0, self.mj_h/2.0);
    
    CGFloat stringWidth=[@"加载中..." boundingRectWithSize:CGSizeMake(MAXFLOAT, self.mj_h) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFont(14)} context:nil].size.width;
    
    self.detailLabel.frame=CGRectMake(SCREEN_WIDTH/2.0-stringWidth/2.0+13, 0, stringWidth, self.mj_h);
    
    self.myIndicate.center=CGPointMake(SCREEN_WIDTH/2.0-32, self.mj_h/2.0);
    
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
}

- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            self.footerLabel.text=@"上拉加载更多...";
            self.footerLabel.hidden=NO;
            self.detailLabel.hidden=YES;
            [self.myIndicate stopAnimating];
            break;
        case MJRefreshStatePulling:
            self.footerLabel.text=@"松开加载更多...";
            self.footerLabel.hidden=NO;
            self.detailLabel.hidden=YES;
            [self.myIndicate stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            self.footerLabel.text=@"";
            self.footerLabel.hidden=YES;
            self.detailLabel.hidden=NO;
            self.detailLabel.text=@"加载中...";
            [self.myIndicate startAnimating];
            break;
        case MJRefreshStateNoMoreData:{
            NSString *str=@"————————  我是有底线的  ————————";
            NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:str];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:0.5] range:NSMakeRange(0, 4)];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:0.5] range:NSMakeRange(str.length-4, 4)];
            self.footerLabel.attributedText=attrStr;
            self.footerLabel.hidden=NO;
            self.detailLabel.hidden=YES;
            [self.myIndicate stopAnimating];
           }
           break;
        default:
            break;
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent{
    [super setPullingPercent:pullingPercent];
}



@end
