//
//  SearchModel.h
//  FSB
//
//  Created by 大家保 on 2017/8/7.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchContentModel.h"

@interface SearchModel : NSObject
//搜索的分类标题
@property (nonatomic,copy) NSString *filterTilte;
//搜索的分类标签
@property (nonatomic,strong) NSMutableArray<SearchContentModel *> *filterContents;
//搜索分类的类型
@property (nonatomic,assign) NSInteger filterType;
//搜索分类的id
@property (nonatomic,assign) NSInteger filterId;

@end
