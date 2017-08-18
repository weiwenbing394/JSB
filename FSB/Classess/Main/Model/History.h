//
//  History.h
//  QMYB
//
//  Created by 大家保 on 2017/5/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject
//搜索内容的标题
@property (nonatomic,copy) NSString *filterContentTitle;
//搜索的内容id
@property (nonatomic,assign) NSInteger filterContentId;

@end
