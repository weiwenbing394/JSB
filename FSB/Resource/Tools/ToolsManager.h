//
//  ToolsManager.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/5/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MeModel;


@interface ToolsManager : NSObject

//单例
+ (ToolsManager *)share;

//提示
- (void)toastMessage:(NSString *)toastMessage;

//判断和获取相机权限
- (void)CameraPermissionSuceess:(void (^)()) successBlock Failed:(void (^)()) faild;

//判断相册使用权限
- (void)PhotoLibararyPermissionSuceess:(void (^)()) successBlock Failed:(void (^)()) faild;

//字符串转图片
- (UIImage *)imageFromString:(NSString *)string;

//图片转字符串
- (NSString *)imageToString:(UIImage *)image;

//将图片转换为jpg再转换成字符串
- (NSString *)imageToJpgString:(UIImage *)image andScale:(CGFloat)scale;

//去除字符串空格
- (NSString *)clearSpace:(NSString *)str;

//计算剩余天数
- (NSString *)dateTimeDifferenceWithStartTime:(long long)lostTime;

//用*代替电话数字
- (NSString *)placeNumber:(NSString *)str;

//将毫秒数转换为时间字符串
- (NSString *)timeToString:(long long) miaoshu formatterType:(NSString *)format;

//计算当前天的后一天
- (NSDate *)addOneDay:(NSDate *)currentDate;

//计算当前天的后一天
- (NSDate *)decolearOneDay:(NSDate *)currentDate;

//计算两个时间是否大于一天
- (BOOL)thanNextDay:(NSDate *)oneDate twoDate:(NSDate *)twoDate;

//nsdate转为nsstring
- (NSString *)dateToString:(NSDate *)changeDate andFormat:(NSString *)format;

//nsstring转为nsdate
- (NSDate *)stringToDate:(NSString *)changeString andFormat:(NSString *)format;

//将nsdate转换为毫秒数
-(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime;

//本周的所有日期
- (NSMutableArray *)weekArray:(NSDate*)date;

//本月的所有日期
- (NSMutableArray *)monthArray:(NSDate*)date;

//上半年的所有日期
- (NSMutableArray *)halfYearArray:(NSDate*)date;

//本年所有日期
- (NSMutableArray *)yearArray:(NSDate*)date;

//获取今天是本周第几天
- (NSInteger)getNowWeekday:(NSDate*)date;

//获取今天是本月第几天
- (NSInteger)getNowMonthday:(NSDate*)date;

//获取今天是半年的第几天
- (NSInteger)getNowHalfYearday:(NSDate *)date;

//获取今天是本年的第几天
- (NSInteger)getNowYearday:(NSDate*)date;

//获取今年的总天数
- (int)getCurrentAllDays:(NSDate *)currentDate;

//获取近6个月的总天数
- (int)getSixMonthDays:(NSDate *)currentDate;

//获取本月有多少天
- (int)getCurrentMobthDays:(NSDate *)currentDate;

//获取本周周一是今年的第几天
- (int)getCurrntWeekFirstDayInThisYear:(NSDate *)currentDate;

//获取本月第一天是今年的第几天
- (int)getCurrntMonthFirstDayInThisYear:(NSDate *)currentDate;

//获取近6个月的第一天是本年的第几天
- (int)getSixMonthFirstDayInThisYear:(NSDate *)currentDate;

//获取指定日期到当前前的第一天的天数
- (int)getBetweenNextYearAndCurrentYearFirst:(NSDate *)currentDate nextYearDate:(NSDate *)nextYearDay;

//是否大于今年的最后一天
- (BOOL)thanCurrentYearLastDay:(NSDate *)currentDate andNextDay:(NSDate *)nextDate;


//计算多行文本高度
-(CGFloat)changeStationWidth:(NSString *)string anWidthTxtt:(CGFloat)widthText anfont:(CGFloat)fontSize;


//获取当前的uiviewController
- (UIViewController *)getTopViewController:(UIViewController *)viewController;

// 分享到朋友圈  (type{0 : 网页 , 1 ： 分享图片(url) , 2: //分享图片(base64) , 3 : //分享文本  , 4 : 复制图片，分享链接,5,分享图片，图片名数据})
- (void)shareImageUrl:(NSString *)shareImageUrl  shareUrl:(NSString *)shareUrl  title:(NSString *)shareTile subTitle:(NSString *)subTitle shareType:(NSInteger )type;

//保存图片(url)
- (void)saveImageWithUrl:(NSString *)urlStr;

//保存图片(url)
- (void)saveImageWithUrl:(NSString *)urlStr  Success:(void (^) ()) successBlock Faild:(void (^) (int  type)) faileBlock;

//保存图片(base64)
- (void)saveImageWithBase64:(NSString *)base64String;

//保存图片(nsdata)
- (void)saveImageWithImageData:(NSData *)imageData;

//发送邮件
- (void)sentMail:(NSString *)mailAddress;

//打开微信
- (void)openWechat;

//pragma mark 拨打电话
- (void)toCall:(NSString *)phoneNum;

//是否是正式环境
- (BOOL)isProd;

//获取本地保存的用户信息
- (MeModel *)getMeModelMessage;

//保存用户信息
- (void)saveMeModelMessage:(id)userData;

//退出登录
- (void)loginOut;

//登录
- (void)login:(id)object;

//购买成功
- (void)buySuccess;

//用户是否已登录
- (BOOL)isLogin;

//用户是否已经购买了重疾险
- (BOOL)haveBuyZhongjiCare;

//用户是否已经购买了意外险
- (BOOL)haveBuyYiwaiCare;

//图片方向处理
- (UIImage *)fixOrientation:(UIImage *)aImage;

//设置银行卡号样式
- (NSString *)BankNum:(NSString *)bankID;




@end
