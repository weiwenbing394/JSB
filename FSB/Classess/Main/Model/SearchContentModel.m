//
//  SearchContentModel.m
//  FSB
//
//  Created by 大家保 on 2017/8/7.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "SearchContentModel.h"

@implementation SearchContentModel


//比较两个对象是否相等需要重写isEqual和hash
- (BOOL)isEqualToModel:(SearchContentModel *)model {
    if (!model) {
        return NO;
    }
    BOOL haveEqualTitle = (!self.filterContentTitle && !model.filterContentTitle) || [self.filterContentTitle isEqualToString:model.filterContentTitle];
    BOOL haveEqualBirthdays = (!self.filterContentId && !model.filterContentId) || (self.filterContentId == model.filterContentId);
    return haveEqualTitle && haveEqualBirthdays;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[SearchContentModel class]]) {
        return NO;
    }
    return [self isEqualToModel:(SearchContentModel *)object];
}

- (NSUInteger)hash {
    return [self.filterContentTitle hash] ^ [@(self.filterContentId) hash];
}

@end
