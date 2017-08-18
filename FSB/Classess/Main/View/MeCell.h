//
//  MeCell.h
//  FSB
//
//  Created by 大家保 on 2017/8/10.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCell : UITableViewCell
//左侧图片
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//右侧图片
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@end
