//
//  HisToryTableViewCell.m
//  QMYB
//
//  Created by 大家保 on 2017/5/23.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "HisToryTableViewCell.h"

@implementation HisToryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//删除历史记录
- (IBAction)deleteHistory:(id)sender {
    self.DeleteBlock?self.DeleteBlock(_index):nil;
}


@end
