//
//  SearchHeadView.h
//  FSB
//
//  Created by 大家保 on 2017/8/3.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHeadView : UICollectionReusableView
//搜索的内容
@property (weak, nonatomic) IBOutlet UILabel *searchTitleLabel;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
//删除操作
@property (nonatomic,copy) void(^deleteBlock)();

@end
