//
//  VerSionManage.m
//  eCarry
//
//  Created by main on 14-8-22.
//  Copyright (c) 2014年 whde. All rights reserved.
//

#import "VersionManager.h"
#import <StoreKit/StoreKit.h>
#import "Alert.h"

static VersionManager *manager = nil;

@interface VersionManager(){
    //跳转更新页面的地址
    NSString *url_;
}

/**
 *  应用内打开Appstore
 */
- (void)openAppWithIdentifier;

@end

@implementation VersionManager

+ (void)checkVerSion {
    if (manager) {
        [manager checkVerSion];
    } else {
        manager = [[VersionManager alloc] init];
        [manager checkVerSion];
    }
}

- (instancetype)init {
    if (manager) {
        return manager;
    } else {
        return self = [super init];
    }
}

/**
 *   showAlert 设置中主动触发版本更新，
 */
- (void)checkVerSion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?bundleId=%@",[infoDictionary objectForKey:@"CFBundleIdentifier"]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                manager = nil;
            } else {
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                NSArray *infoArray = [dic objectForKey:@"results"];
                if ([infoArray isKindOfClass:[NSArray class]] && [infoArray count]>0) {
                    NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                    url_ = [releaseInfo objectForKey:@"trackViewUrl"];
                    NSString *appstoreVersion = [releaseInfo objectForKey:@"version"];
                    NSArray *appstoreVersionAry = [appstoreVersion componentsSeparatedByString:@"."];
                    NSInteger appstoreCount = [appstoreVersionAry count];
                    NSArray *currentVersionAry = [currentVersion componentsSeparatedByString:@"."];
                    NSInteger currentCount = [currentVersionAry count];
                    NSInteger count = currentCount>appstoreCount?appstoreCount:currentCount;
                    for (int i = 0; i<count; i++) {
                        if ([[appstoreVersionAry objectAtIndex:i] intValue]>[[currentVersionAry objectAtIndex:i] intValue]){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSString *versionAppStore=[NSString stringWithFormat:@"检测到新版本v%@",appstoreVersion];
                                Alert *alert = [[Alert alloc] initWithTitle:versionAppStore message:releaseInfo[@"releaseNotes"] delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                                [alert setContentAlignment:NSTextAlignmentLeft];
                                [alert setLineSpacing:5];
                                [alert setClickBlock:^(Alert *alertView, NSInteger buttonIndex) {
                                    if (buttonIndex == 0) {
                                        manager = nil;
                                    } else {
                                        /*更新*/
                                        [self openAppWithIdentifier];
                                    }
                                }];
                                [alert show];
                            });
                            return;
                        }else if ([[appstoreVersionAry objectAtIndex:i] intValue]<[[currentVersionAry objectAtIndex:i] intValue]){
                            /*本地版本号高于Appstore版本号,测试时候出现,不会提示出来*/
                            return;
                        }else{
                            continue;
                        }
                    }
                }
            }
        }];
        [dataTask resume];
    });
}

/**
 *  跳转appstore下载更新
 */
- (void)openAppWithIdentifier{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_]];
    manager = nil;
}

@end
