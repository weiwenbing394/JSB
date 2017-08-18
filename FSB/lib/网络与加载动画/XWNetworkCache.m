//
//  XWNetworkCache.m
//  QMYB
//
//  Created by 大家保 on 2017/2/21.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "XWNetworkCache.h"
#import "YYCache.h"



@implementation XWNetworkCache

static NSString *const NetworkResponseCache = @"XWNetworkResponseCache";

static YYCache *_dataCache;

+ (void)initialize{
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}

/**
 *  异步缓存网络数据,根据请求的 URL与parameters
 *  做KEY存储数据, 这样就能缓存多级页面的数据
 *
 *  @param httpData   服务器返回的数据
 *  @param URL        请求的URL地址
 *  @param parameters 请求的参数
 */

+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters{
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
}

/**
 *  根据请求的 URL与parameters 异步取出缓存数据
 *
 *  @param URL        请求的URL
 *  @param parameters 请求的参数
 *  @param block      异步回调缓存的数据
 *
 *  block 缓存的服务器数据
 */
+ (void)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters withBlock:(void(^)(id<NSCoding> object))block{
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    [_dataCache objectForKey:cacheKey withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(object);
        });
    }];
}

/**
 *  根据url与params返回缓存的key
 */
+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters{
    if ([[ToolsManager share] isLogin]) {
        MeModel *me=[[ToolsManager share] getMeModelMessage];
        URL=[me.mobile stringByAppendingString:URL];
    }
    if(!parameters){
        return URL;
    };
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    // 将URL与转换好的参数字符串拼接在一起,成为最终存储的KEY值
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",URL,paraString];
    return cacheKey;
}

/**
 *  异步获取网络缓存的总大小bytes(字节)
 */
+ (void)getAllHttpCacheSizeWithBlock:(void(^)(NSInteger totalCost))sizeBlock{
   [_dataCache.diskCache totalCostWithBlock:^(NSInteger totalCost) {
       dispatch_async(dispatch_get_main_queue(), ^{
           sizeBlock(totalCost);
       });
   }];
}

/**
 *  异步删除所有网络缓存,
 */
+ (void)removeAllHttpCacheWithBlock:(void(^)(void))clearCacheEndBlock{
    [_dataCache.diskCache removeAllObjectsWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            clearCacheEndBlock();
        });
    }];
}



@end
