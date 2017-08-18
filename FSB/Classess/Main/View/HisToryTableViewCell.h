//
//  HisToryTableViewCell.h
//  QMYB
//
//  Created by 大家保 on 2017/5/23.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HisToryTableViewCell : UITableViewCell

@property (nonatomic,copy) void (^DeleteBlock) (NSInteger index);

@property (nonatomic,assign) NSInteger index;

@property (weak, nonatomic) IBOutlet UILabel *serchName;

@end
