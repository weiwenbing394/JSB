//
//  AppleFresh.m
//  MJRefresh_Test
//
//  Created by 大家保 on 2016/10/17.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "MJHeader.h"

@interface MJHeader ()

@property (nonatomic,strong)UIActivityIndicatorView *myIndicate;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *detailLabel;

@end

@implementation MJHeader

- (void)prepare {
    [super prepare];
    
    self.mj_h=50;
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.textColor=[UIColor colorWithHexString:@"#737f87"];
    titleLabel.font=SystemFont(14);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLabel=titleLabel;
    
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
    
    self.titleLabel.frame=self.bounds;
    
    CGFloat stringWidth=[@"刷新中..." boundingRectWithSize:CGSizeMake(MAXFLOAT, self.mj_h) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFont(14)} context:nil].size.width;
    
    self.detailLabel.frame=CGRectMake(SCREEN_WIDTH/2.0-stringWidth/2.0+13, 0, stringWidth, self.mj_h);
    
    self.myIndicate.center=CGPointMake(SCREEN_WIDTH/2.0-32, self.mj_h/2.0);
    
    
}


- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
}


- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            self.titleLabel.text=@"下拉刷新...";
            self.titleLabel.hidden=NO;
            self.detailLabel.hidden=YES;
            [self.myIndicate stopAnimating];
            break;
        case MJRefreshStatePulling:
            self.titleLabel.text=@"松开刷新...";
            self.titleLabel.hidden=NO;
            self.detailLabel.hidden=YES;
            [self.myIndicate stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            self.titleLabel.hidden=YES;
            self.detailLabel.hidden=NO;
            self.detailLabel.text=@"刷新中...";
           [self.myIndicate startAnimating];
            break;
        default:
            break;
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent{
    [super setPullingPercent:pullingPercent];
}

@end
