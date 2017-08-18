//
//  AppDelegate.m
//  FSB
//
//  Created by 大家保 on 2017/7/29.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "BaseNavigationController.h"
#import "VersionManager.h"
#import "SearchContentModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //窗口初始化
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //设置rootVC
    ViewController *root=[[ViewController alloc]init];
    BaseNavigationController *nav=[[BaseNavigationController alloc]initWithRootViewController:root];
    self.window.rootViewController=nav;
    
    //键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = YES;
    manager.toolbarDoneBarButtonItemText=@"完成";
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar=YES;
    manager.shouldShowTextFieldPlaceholder=NO;
    manager.toolbarTintColor=[UIColor darkGrayColor];
    manager.toolbarManageBehaviour =IQAutoToolbarByTag;
    manager.keyboardDistanceFromTextField=60;
    
    //友盟分享
    [self umengShare];
    
    //友盟统计
    [self umengTrack];
    
    //检查更新
    [VersionManager checkVerSion];
    
    //创建本地数据库和通讯录表
    if (![[JQFMDB shareDatabase] jq_isExistTable:@"history"]) {
        BOOL success=[[JQFMDB shareDatabase] jq_createTable:@"history" dicOrModel:[SearchContentModel class]];
        if (success) {
            [[JQFMDB shareDatabase] close];
        }
    }
    
    //窗口设置
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;

}


/**
 *  友盟分享
 */
- (void)umengShare {
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:weChatId appSecret:weChatScreat redirectURL:@"http://www.arrill.com"];
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
}


/**
 *  友盟应用统计
 */
- (void)umengTrack {
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.ePolicy=BATCH;
    [MobClick setAppVersion:VERSION];
    [MobClick startWithConfigure:UMConfigInstance];
}



//分享回掉
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
