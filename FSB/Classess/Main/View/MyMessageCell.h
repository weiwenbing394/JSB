//
//  MyMessageCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleStr;

@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthContens;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContents;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContents;

@property (weak, nonatomic) IBOutlet UILabel *line;

@end
