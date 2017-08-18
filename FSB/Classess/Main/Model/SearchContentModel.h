//
//  SearchContentModel.h
//  FSB
//
//  Created by 大家保 on 2017/8/7.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchContentModel : NSObject

//搜索内容的标题
@property (nonatomic,copy) NSString *filterContentTitle;

//搜索内容的id
@property (nonatomic,assign) NSInteger filterContentId;

@end
