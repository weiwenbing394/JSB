//
//  XWPNetworking.h
//  XW_MB_AF_MANAGER
//
//  Created by 大家保 on 2016/10/19.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>

/**
 *  手机网络状态
 */
typedef enum{
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
}NetworkStatu;

/**
 *  请求方式 GET OR POST
 */
typedef enum HttpMethod {
    /** 设置请求方式 GET*/
    GET,
    /** 设置请求方式 POST*/
    POST
} httpMethod;

/**
 *  服务器返回数据 JSON OR DATA
 */
typedef enum ResponseType {
    /** 设置响应数据为JSON格式*/
    JSON,
    /** 设置响应数据为二进制格式*/
    DATA
} responseType;

/*
 *
 请求成功的Block 
 */
typedef void( ^ XWResponseSuccess)(id response);
/*
 * 
 请求失败的Block 
 */
typedef void( ^ XWResponseFail)(NSError *error);
/** 
 缓存的Block 
 */
typedef void(^XWHttpRequestCache)(id responseCache);
/**
 上传的进度
 */
typedef void( ^ XWUploadProgress)(int64_t bytesProgress,int64_t totalBytesProgress);
/**
 下载的进度
 */
typedef void( ^ XWDownloadProgress)(int64_t bytesProgress,int64_t totalBytesProgress);
/**
 网络状态的Block
 */
typedef void(^XWNetworkStatus)(NetworkStatu status);

@interface XWNetworking : NSObject

@property (nonatomic,assign)NetworkStatu networkStats;

/**
 *  单例
 */
+ (XWNetworking *)sharedXWNetworking;

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(XWNetworkStatus)networkStatus;

/**
 *  是否有网络连接
 */
+ (BOOL) isHaveNetwork;

/**
 取消所有HTTP请求
 */
+ (void)cancelAllRequest;

/**
 取消指定URL的HTTP请求
 */
+ (void)cancelRequestWithURL:(NSString *)URL;

#pragma mark 无缓存请求
/**
 *  Get请求,返回json,无缓存
 */
+ (__kindof NSURLSessionTask *)getJsonWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;


/**
 *  POST请求,返回json,无缓存
 */
+ (__kindof NSURLSessionTask *)postJsonWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;

/**
 *  Get请求,返回data,无缓存
 */
+ (__kindof NSURLSessionTask *)getDataWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;


/**
 *  POST请求,返回data,无缓存
 */
+ (__kindof NSURLSessionTask *)postDataWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;


#pragma mark 有缓存请求
/**
 *  Get请求,返回json,有缓存
 */
+ (__kindof NSURLSessionTask *)getJsonWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;


/**
 *  POST请求,返回json,有缓存
 */
+ (__kindof NSURLSessionTask *)postJsonWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;

/**
 *  Get请求,返回data,有缓存
 */
+ (__kindof NSURLSessionTask *)getDataWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;


/**
 *  POST请求,返回data,有缓存
 */
+ (__kindof NSURLSessionTask *)postDataWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;

/**
 *  上传文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       文件对应服务器上的字段
 *  @param filePath   文件本地的沙盒路径
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                                      parameters:(NSDictionary *)parameters
                                            name:(NSString *)name
                                        filePath:(NSString *)filePath
                                        progress:(XWUploadProgress)progress
                                         success:(XWResponseSuccess)success
                                         failure:(XWResponseFail)failure
                                         showHUD:(BOOL)showHUD;


/**
 *  上传单/多张图片
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param names      图片对应服务器上的字段
 *  @param images     图片数组
 *  @param fileNames  图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 *  @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
 *  @param imageType  图片文件的类型,例:png、jpg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(NSDictionary *)parameters
                                     name:(NSArray<NSString *> *)names
                                   images:(NSArray<UIImage *> *)images
                                fileNames:(NSArray<NSString *> *)fileNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(XWUploadProgress)progress
                                  success:(XWResponseSuccess)success
                                  failure:(XWResponseFail)failure
                                  showHUD:(BOOL)showHUD;

/**
 *  下载文件方法
 *  @param url           下载地址
 *  @param saveToPath    文件保存的路径,如果不传则保存到Documents目录下，以文件本来的名字命名
 *  @param progressBlock 下载进度回调
 *  @param success       下载完成
 *  @param fail          失败
 *  @param showHUD       是否显示HUD
 *  @return              返回请求任务对象，便于操作
 */
+ (__kindof NSURLSessionTask *)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath  progress:(XWDownloadProgress )progressBlock  success:(XWResponseSuccess )success failure:(XWResponseFail )fail showHUD:(BOOL)showHUD;



@end
