//
//  SearchHeadView.m
//  FSB
//
//  Created by 大家保 on 2017/8/3.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "SearchHeadView.h"

@implementation SearchHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)delete:(id)sender {
    self.deleteBlock?self.deleteBlock():nil;
}

@end
