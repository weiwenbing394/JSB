//
//  ToolsManager.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/5/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ToolsManager.h"
#import "WXApi.h"
#import "BaseNavigationController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "BaseWebViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MeModel.h"

@implementation ToolsManager

//单例
+ (ToolsManager *)share{
    static ToolsManager *tool=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool=[[ToolsManager alloc]init];
    });
    return tool;
};

//字符串转图片
- (UIImage *)imageFromString:(NSString *)string{
    // NSString --> NSData
    NSData *data=[[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    // NSData --> UIImage
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

//图片转字符串
- (NSString *)imageToString:(UIImage *)image{
    // UIImage --> NSData
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    // NSData --> NSString
    NSString *imageDataString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return imageDataString;
}

//将图片转换为jpg再转换成字符串
- (NSString *)imageToJpgString:(UIImage *)image andScale:(CGFloat)imageScale{
    // 图片经过等比压缩后得到的二进制文件
    NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:image], imageScale ?: 1.f);
    // NSData --> NSString
    NSString *imageDataString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return imageDataString;
};

- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


//  去除字符串空格
- (NSString *)clearSpace:(NSString *)str{
    return 0==str.length?@"":[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//计算剩余天数
- (NSString *)dateTimeDifferenceWithStartTime:(long long)lostTime{
    long long value= lostTime;
    long long second = value % 60;//秒
    long long minute = value / 60 % 60;
    long long house =value / 3600 % 24;
    long long day = value / ( 24 * 3600 );
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%lld天%lld小时%lld分%lld秒",day,house,minute,second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"%lld小时%lld分%lld秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%lld分%lld秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"%lld秒",second];
    }
    return str;
}

//将毫秒数转换为字符串
- (NSString *)timeToString:(long long) miaoshu formatterType:(NSString *)format{
    NSDate *date =[[NSDate alloc]initWithTimeIntervalSince1970:miaoshu/1000.0];
    NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:format];
    return  [dateFormat stringFromDate:localeDate];
    
}

//计算当前天的后一天
- (NSDate *)addOneDay:(NSDate *)currentDate{
    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:currentDate];
    return nextDate;
};

//计算当前天的后一天
- (NSDate *)decolearOneDay:(NSDate *)currentDate{
    NSDate *lastDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:currentDate];
    return lastDate;
};


//计算两个时间是否大于一天
- (BOOL)thanNextDay:(NSDate *)oneDate twoDate:(NSDate *)twoDate{
    NSTimeInterval time = [twoDate timeIntervalSinceDate:oneDate];
    if (time>0) {
        return true;
    }else{
        return false;
    }
};

//nsdate转为nsstring
- (NSString *)dateToString:(NSDate *)changeDate andFormat:(NSString *)format{
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:format];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:changeDate];
    NSLog(@"%@",currentDateString);
    return currentDateString;
};

//nsstring转为nsdate
- (NSDate *)stringToDate:(NSString *)changeString andFormat:(NSString *)format{
    //需要转换的字符串
    NSString *dateString = changeString;
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    return date;
};

//将nsdate转换为毫秒数
-(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    long long totalMilliseconds = interval*1000 ;
    return totalMilliseconds;
}


//本周的所有日期
- (NSMutableArray *)weekArray:(NSDate*)date{
    
    NSMutableArray *weekArray=[NSMutableArray array];
    NSDate *nowDate;
    if (date==nil) {
        nowDate= [NSDate date];
    }else{
        nowDate=date;
    }
    //获取本周第一天和最后一天
    NSArray *weekFAndLArray=[self getFirstAndLastDayOfThisWeek:nowDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM.dd"];
    NSString *firstDay = [formatter stringFromDate:[weekFAndLArray firstObject]];
    NSString *lastDay = [formatter stringFromDate:[weekFAndLArray lastObject]];
    NSDate   *nextDay=[[weekFAndLArray firstObject] dateByAddingDays:3];
    NSString *nextDayStr=[formatter stringFromDate:nextDay];
    
    [weekArray addObject:firstDay];
    [weekArray addObject:nextDayStr];
    [weekArray addObject:lastDay];
    
    return weekArray;
};

//本月的所有日期
- (NSMutableArray *)monthArray:(NSDate*)date{
    
    NSMutableArray *monthArray=[NSMutableArray array];
    NSDate *currentDay;
    if (date==nil) {
        currentDay= [NSDate date];
    }else{
        currentDay=date;
    }
    //本月第一天和最后一天
    NSArray *monthFLArray=[self getFirstAndLastDayOfThisMonth:currentDay];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设定周一为周首日
    [calendar setFirstWeekday:2];
    //月中
    NSRange     range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDay];
    NSUInteger   addHalfOfMonth;
    if (range.length%2==0) {
        addHalfOfMonth=range.length/2-1;
    }else{
        addHalfOfMonth=floor(range.length/2.0) ;
    }
    NSDate   *halfMonthDay=[[monthFLArray firstObject] dateByAddingDays:addHalfOfMonth];
    //转换规则
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"MM.dd"];
    //第一天
    NSString *beginString = [myDateFormatter stringFromDate:[monthFLArray firstObject]];
    //中间一天
    NSString *halfMonthString=[myDateFormatter stringFromDate:halfMonthDay];
    //最后一天
    NSString *endString = [myDateFormatter stringFromDate:[monthFLArray lastObject]];
    //添加到数组
    [monthArray addObject:beginString];
    [monthArray addObject:halfMonthString];
    [monthArray addObject:endString];
    
    return monthArray;
};

//上半年的所有日期
- (NSMutableArray *)halfYearArray:(NSDate*)date{

    NSMutableArray *halfYearArray=[NSMutableArray array];
    //当前日期
    NSDate *currentDay;
    if (date==nil) {
        currentDay= [NSDate date];
    }else{
        currentDay=date;
    }
    //后三个月
    NSDate *afterThreeMonthDay=[currentDay dateByAddingMonths:3];
    //前三个月
    NSDate *beforeThreeMonthDay=[currentDay dateBySubtractingMonths:3];
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSString *before60DayString=[myDateFormatter stringFromDate:beforeThreeMonthDay];
    NSString *currentDayString=[myDateFormatter stringFromDate:currentDay];
    NSString *after60DayString=[myDateFormatter stringFromDate:afterThreeMonthDay];
    
    [halfYearArray addObject:before60DayString];
    [halfYearArray addObject:currentDayString];
    [halfYearArray addObject:after60DayString];
    
    return halfYearArray;
};

//本年所有日期
- (NSMutableArray *)yearArray:(NSDate*)date{
    
    NSMutableArray *yearArray=[NSMutableArray array];
    
    NSDate *currentDay;
    if (date==nil) {
        currentDay= [NSDate date];
    }else{
        currentDay=date;
    }
    
    //获取本年的第一天和最后一天
    NSArray *yearFlArray=[self getFirstAndLastDayOfThisYear:currentDay];
    //本年相聚天数
    NSInteger count=[self getNumberBetweenTwoDate:[yearFlArray firstObject] afterDate:[yearFlArray lastObject]];
    
    NSUInteger   addHalfOfYear;
    if (count%2==0) {
        addHalfOfYear=count/2-1;
    }else{
        addHalfOfYear=floor(count/2.0) ;
    }
    NSDate     *halfYearDay=[[yearFlArray firstObject] dateByAddingDays:addHalfOfYear];
    //转换规则
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy.MM.dd"];
    //第一天
    NSString *beginString = [myDateFormatter stringFromDate:[yearFlArray firstObject]];
    //中间一天
    NSString *halfYearString=[myDateFormatter stringFromDate:halfYearDay];
    //最后一天
    NSString *endString = [myDateFormatter stringFromDate:[yearFlArray lastObject]];
    //添加到数组
    [yearArray addObject:beginString];
    [yearArray addObject:halfYearString];
    [yearArray addObject:endString];
    return yearArray;
};

//获取今天是本周第几天
- (NSInteger)getNowWeekday:(NSDate*)date{
    
    NSDate *currentDay;
    if (date==nil) {
        currentDay= [NSDate date];
    }else{
        currentDay=date;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:currentDay];
    
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    switch (weekDay) {
        case 0:
            return 5;
            break;
        case 1:
            return 6;
            break;
        case 2:
            return 0;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 2;
            break;
        case 5:
            return 3;
            break;
        case 6:
            return 4;
            break;
        default:
            break;
    }
    return 0;
}

//获取今天是本月第几天
- (NSInteger)getNowMonthday:(NSDate*)date;{
    NSDate *currentDay;
    if (date==nil) {
        currentDay= [NSDate date];
    }else{
        currentDay=date;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:currentDay];
    // 获取今天是是本月第几天
    NSInteger weekDay = [comp day]-1;
    return weekDay;
}

//获取今天是半年的第几天
- (NSInteger)getNowHalfYearday:(NSDate *)date{
    NSDate *currentDay;
    if (date==nil) {
        currentDay= [NSDate date];
    }else{
        currentDay=date;
    }
    //计算三个月前的日期
    NSDate *beforeThreeMonthDay=[currentDay dateBySubtractingMonths:3];
    
    //计算两者之间差值
    NSTimeInterval time=[currentDay timeIntervalSinceDate:beforeThreeMonthDay];
    
    return ((int)time)/(3600*24);
};

//获取今天是本年的第几天
- (NSInteger)getNowYearday:(NSDate*)date{
    NSDate *currentDay;
    if (date==nil) {
        currentDay= [NSDate date];
    }else{
        currentDay=date;
    }
    
    double interval = 0;
    NSDate *beginDate = nil;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设定周一为周首日
    [calendar setFirstWeekday:2];
    [calendar rangeOfUnit:NSCalendarUnitYear startDate:&beginDate interval:&interval forDate:currentDay];
    
    //计算两者之间差值
    NSTimeInterval time=[currentDay timeIntervalSinceDate:beginDate];
    
    return ((int)time)/(3600*24);
};


//获取今年的总天数
- (int)getCurrentAllDays:(NSDate *)date{
    NSDate *currentDay;
    if (date==nil) {
        currentDay= [NSDate date];
    }else{
        currentDay=date;
    }
    
    //获取本年的第一天和最后一天
    NSArray *yearFlArray=[self getFirstAndLastDayOfThisYear:currentDay];
    //本年相聚天数
    NSInteger count=[self getNumberBetweenTwoDate:[yearFlArray firstObject] afterDate:[yearFlArray lastObject]];
    
    return (int)count+1;
};

//获取近6个月的总天数
- (int)getSixMonthDays:(NSDate *)date{
    NSDate *currentDay;
    if (date==nil) {
        currentDay= [NSDate date];
    }else{
        currentDay=date;
    }
    //计算三个月前的日期
    NSDate *beforeThreeMonthDay=[currentDay dateBySubtractingMonths:3];
    //后三个月
    NSDate *afterThreeMonthDay=[currentDay dateByAddingMonths:3];
    //计算两者之间差值
    return (int)[self getNumberBetweenTwoDate:beforeThreeMonthDay afterDate:afterThreeMonthDay]+1;
    
};

//获取本月有多少天
- (int)getCurrentMobthDays:(NSDate *)date{
    NSDate *currentDay;
    if (date==nil) {
        currentDay= [NSDate date];
    }else{
        currentDay=date;
    }
    NSArray *monthFLa=[self getFirstAndLastDayOfThisMonth:currentDay];
    return (int)[self getNumberBetweenTwoDate:[monthFLa firstObject] afterDate:[monthFLa lastObject]]+1;
};

//获取本周周一是今年的第几天
- (int)getCurrntWeekFirstDayInThisYear:(NSDate *)date{
    NSDate *nowDate;
    if (date==nil) {
        nowDate= [NSDate date];
    }else{
        nowDate=date;
    }
    //获取本周周一的日期
    NSArray *weekArray=[self getFirstAndLastDayOfThisWeek:nowDate];
    //获取本年的第一天
    NSArray *yearWeek=[self getFirstAndLastDayOfThisYear:nowDate];
    return (int)[self getNumberBetweenTwoDate:[yearWeek firstObject] afterDate:[weekArray firstObject]];
};

//获取本月第一天是今年的第几天
- (int)getCurrntMonthFirstDayInThisYear:(NSDate *)date{
    NSDate *nowDate;
    if (date==nil) {
        nowDate= [NSDate date];
    }else{
        nowDate=date;
    }
    //获取本月第一天日期
    NSArray *monthArray=[self getFirstAndLastDayOfThisMonth:nowDate];
    //获取本年的第一天
    NSArray *yearWeek=[self getFirstAndLastDayOfThisYear:nowDate];
    return (int)[self getNumberBetweenTwoDate:[yearWeek firstObject] afterDate:[monthArray firstObject]];
};

//获取近6个月的第一天是本年的第几天
- (int)getSixMonthFirstDayInThisYear:(NSDate *)date{
    NSDate *nowDate;
    if (date==nil) {
        nowDate= [NSDate date];
    }else{
        nowDate=date;
    }
    //前三个月的第一天
    NSDate *beforeThreeMonthDay=[nowDate dateBySubtractingMonths:3];
    //获取本年的第一天
    NSArray *yearWeek=[self getFirstAndLastDayOfThisYear:nowDate];
    return (int)[self getNumberBetweenTwoDate:[yearWeek firstObject] afterDate:beforeThreeMonthDay];
};

//获取指定日期到当前前的第一天的天数
- (int)getBetweenNextYearAndCurrentYearFirst:(NSDate *)currentDate nextYearDate:(NSDate *)nextYearDay{
    NSDate *nowDate;
    if (currentDate==nil) {
        nowDate= [NSDate date];
    }else{
        nowDate=currentDate;
    }
    NSArray *yearFLArray=[self getFirstAndLastDayOfThisYear:nowDate];
    int days=(int)[self getNumberBetweenTwoDate:[yearFLArray firstObject] afterDate:nextYearDay];
    return days;
};

//是否大于今年的最后一天
- (BOOL)thanCurrentYearLastDay:(NSDate *)currentDate andNextDay:(NSDate *)nextDate{
    NSDate *nowDate;
    if (currentDate==nil) {
        nowDate= [NSDate date];
    }else{
        nowDate=currentDate;
    }
    NSArray *yearFLArray=[self getFirstAndLastDayOfThisYear:nowDate];
    //今年的最后一天
    NSDate  *yearLastDate=[yearFLArray lastObject];
    return [nextDate isLaterThan:yearLastDate];
};


//获取今年的第一天和最后一天
-(NSArray *)getFirstAndLastDayOfThisYear:(NSDate *)date{
    //通过2月天数的改变，来确定全年天数
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    dateStr = [dateStr stringByAppendingString:@"-02-14"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *aDayOfFebruary = [formatter dateFromString:dateStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
    [calendar rangeOfUnit:NSCalendarUnitYear startDate:&firstDay interval:nil forDate:date];
    NSDateComponents *lastDateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay fromDate:firstDay];
    NSUInteger dayNumberOfFebruary = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:aDayOfFebruary].length;
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+337+dayNumberOfFebruary-1];
    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    
    return [NSArray arrayWithObjects:firstDay,lastDay, nil];
}

//获取本月的最后一天和第一天
-(NSArray *)getFirstAndLastDayOfThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDay interval:nil forDate:date];
    NSDateComponents *lastDateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitDay fromDate:firstDay];
    NSUInteger dayNumberOfMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+dayNumberOfMonth-1];
    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    return [NSArray arrayWithObjects:firstDay,lastDay, nil];
}

//获得本周的最后一天和第一天
-(NSArray *)getFirstAndLastDayOfThisWeek:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger weekday = [dateComponents weekday];   //第几天(从sunday开始)
    NSInteger firstDiff,lastDiff;
    if (weekday == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }else {
        firstDiff =  - weekday + 2;
        lastDiff = 8 - weekday;
    }
    NSInteger day = [dateComponents day];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    [firstComponents setDay:day+firstDiff];
    NSDate *firstDay = [calendar dateFromComponents:firstComponents];
    
    NSDateComponents *lastComponents =[calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    [lastComponents setDay:day+lastDiff];
    NSDate *lastDay = [calendar dateFromComponents:lastComponents];
    return [NSArray arrayWithObjects:firstDay,lastDay, nil];
}

//获取两个日期相隔天数
-(NSInteger)getNumberBetweenTwoDate:(NSDate *)beforDate afterDate:(NSDate *)toDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:beforDate toDate:toDate options:0];
    return dayComponents.day;
}

//用*代替电话数字
- (NSString *)placeNumber:(NSString *)str{
    if (7>str.length) {
        return str;
    }
    NSMutableString *cardIdStr=[[NSMutableString alloc]initWithString:str];
    for (int i=3; i<cardIdStr.length-4; i++) {
        [cardIdStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    return cardIdStr;
}


//提示
- (void)toastMessage:(NSString *)toastMessage{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提醒" message:toastMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


//判断和获取相机权限
- (void)CameraPermissionSuceess:(void (^)()) successBlock Failed:(void (^)()) faild{
    //判断相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self toastMessage:@"请在iphone的“设置-隐私-相机”选项中，允许圈圈保使用您的相机"];
            faild?faild():nil;
        });
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock?successBlock():nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self toastMessage:@"请在iphone的“设置-隐私-相机”选项中，允许圈圈保使用您的相机"];
                    faild?faild():nil;
                });
            }
        }];
    }else if(authStatus == AVAuthorizationStatusAuthorized){
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock?successBlock():nil;
        });
    }
};


//判断相册使用权限
- (void)PhotoLibararyPermissionSuceess:(void (^)()) successBlock Failed:(void (^)()) faild{
    WeakSelf;
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf toastMessage:@"请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
            faild?faild():nil;
        });
    }else if(author == ALAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf toastMessage:@"请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
                    faild?faild():nil;
                });
            }else if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock?successBlock():nil;
                });
            }
        }];
    }else if(author == ALAuthorizationStatusAuthorized){
        successBlock?successBlock():nil;
    }
};


//获取当前的uiviewController
- (UIViewController *)getTopViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self getTopViewController:[(UITabBarController *)viewController selectedViewController]];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self getTopViewController:[(UINavigationController *)viewController topViewController]];
    } else if (viewController.presentedViewController) {
        return [self getTopViewController:viewController.presentedViewController];
    } else {
        return viewController;
    }
    
}



#pragma mark 分享到朋友圈
- (void)shareImageUrl:(NSString *)shareImageUrl  shareUrl:(NSString *)shareUrl  title:(NSString *)shareTile subTitle:(NSString *)subTitle shareType:(NSInteger )type{
    if (type==4) {
        if (0<subTitle.length) {
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = subTitle;
            [MBProgressHUD ToastInformation:@"文本已复制，请在微信中手动粘贴"];
        }
    }
    WeakSelf;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareWebPageToPlatformType:platformType ImageUrl:shareImageUrl shareUrl:shareUrl title:shareTile subTitle:subTitle shareType:type] ;
    }];
}

//分享网页
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType ImageUrl:(NSString *)shareImageUrl  shareUrl:(NSString *)shareUrl  title:(NSString *)shareTile subTitle:(NSString *)subTitle shareType:(NSInteger )type{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (type==0) {
        //分享网页
        NSString* thumbURL=(0==shareImageUrl.length?@"":shareImageUrl);
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:(0==shareTile.length?@" ":shareTile) descr:(0==subTitle.length?@" ":subTitle) thumImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbURL]]];
        shareObject.webpageUrl = (0==shareUrl.length?@"":shareUrl);
        messageObject.shareObject = shareObject;
    }else if (type==1){
        //分享图片(url)
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        NSData  *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:(0==shareImageUrl.length?@"":shareImageUrl)]];
        [shareObject setShareImage:imageData];
        messageObject.shareObject = shareObject;
    }else if (type==3){
        //分享图片(base64)
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        [shareObject setShareImage:[[ToolsManager share] imageFromString:shareImageUrl]];
        messageObject.shareObject = shareObject;
    }else if (type==2){
        //分享文本
        messageObject.text = shareTile;
    }else if(type==4){
        //分享网页
        NSString* thumbURL=(0==shareImageUrl.length?@"":shareImageUrl);
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:(0==shareTile.length?@" ":shareTile) descr:(0==subTitle.length?@" ":subTitle) thumImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbURL]]];
        shareObject.webpageUrl = (0==shareUrl.length?@"":shareUrl);
        messageObject.shareObject = shareObject;
    }else if (type==5) {
        //分享网页
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:(0==shareTile.length?@" ":shareTile) descr:(0==subTitle.length?@" ":subTitle) thumImage:[UIImage imageNamed:shareImageUrl]];
        shareObject.webpageUrl = (0==shareUrl.length?@"":shareUrl);
        messageObject.shareObject = shareObject;
    }
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD ToastInformation:@"分享失败"];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD ToastInformation:@"分享成功"];
            });
        }
    }];
}


//保存图片(url)
- (void)saveImageWithUrl:(NSString *)url{
    [self PhotoLibararyPermissionSuceess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDWithTitle:@"正在保存"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *saveImage=[UIImage imageWithData:imageData];
            if (saveImage) {
                UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD ToastInformation:@"图片错误"];
                });
            }
        });
    } Failed:^{
        
    }];
}

//保存图片(url)
- (void)saveImageWithUrl:(NSString *)urlStr  Success:(void (^) ()) successBlock Faild:(void (^) (int  type)) faileBlock{
    [self PhotoLibararyPermissionSuceess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDWithTitle:@"图片正在保存"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            UIImage *saveImage=[UIImage imageWithData:imageData];
            if (saveImage) {
                UIImageWriteToSavedPhotosAlbum(saveImage, self,  @selector(image:didFinishWithError:contextInfo:), NULL);
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock?successBlock():nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hiddenHUD];
                    faileBlock?faileBlock(0):nil;
                });
            }
        });
    } Failed:^{
         faileBlock?faileBlock(1):nil;
    }];
};


//保存图片(base64)
- (void)saveImageWithBase64:(NSString *)base64String{
    [self PhotoLibararyPermissionSuceess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDWithTitle:@"正在保存"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage  *saveImage=[self imageFromString:base64String];
            if (saveImage) {
                UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD ToastInformation:@"图片格式不正确"];
                });
            }
        });
    } Failed:^{
        
    }];
}

//保存图片(nsdata)
- (void)saveImageWithImageData:(NSData *)imageData{
    [self PhotoLibararyPermissionSuceess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDWithTitle:@"正在保存"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *saveImage=[UIImage imageWithData:imageData];
            if (saveImage) {
                UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD ToastInformation:@"图片格式不正确"];
                });
            }
        });
    } Failed:^{
        
    }];
};


//保存图片回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:@"保存失败"];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:@"图片已保存到相册"];
        });
    }
}

//保存图片回调
- (void)image:(UIImage *)image didFinishWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hiddenHUD];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hiddenHUD];
        });
    }
}


//发送邮件
- (void)sentMail:(NSString *)mailAddress{
    NSString *url = [NSString stringWithFormat:@"mailto://%@",mailAddress];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD ToastInformation:@"您的设备不支持邮件发送"];
            });
        }
    });
};

//打开微信
- (void)openWechat{
    NSURL * wechat_url = [NSURL URLWithString:@"weixin://"];
    if ([[UIApplication sharedApplication] canOpenURL:wechat_url]) {
        
        [[UIApplication sharedApplication] openURL:wechat_url];
    }else{
        [MBProgressHUD ToastInformation:@"微信不可用"];
    }
}

#pragma mark 拨打电话
- (void)toCall:(NSString *)phoneNum{
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNum];
    /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:callPhone]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD ToastInformation:@"您的设备不支持电话拨打"];
            });
        }
    });
}

//是否是正式环境
- (BOOL)isProd{
    MeModel *model=[self getMeModelMessage];
    return model.isProud;
};


//获取本地保存的用户信息
- (MeModel *)getMeModelMessage{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaults valueForKey:ME]];
};

//保存用户信息
- (void)saveMeModelMessage:(id)userData{
    [UserDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:userData] forKey:ME];
    [UserDefaults synchronize];
};

//退出登录
- (void)loginOut{
    [UserDefaults setObject:nil forKey:TOKENID];
    [self saveMeModelMessage:nil];
    [NotiCenter postNotificationName:LOGOUTNOTIFIC object:nil];
}

//购买成功
- (void)buySuccess{
    [NotiCenter postNotificationName:BUYSUCCESS object:nil];
};

//登录
- (void)login:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSString *tokenID=response[@"data"][@"sid"];
        MeModel  *me=[MeModel mj_objectWithKeyValues:response[@"data"]];
        [UserDefaults setObject:tokenID forKey:TOKENID ];
        [self    saveMeModelMessage:me];
        [NotiCenter postNotificationName:LOGINNOTIFIC object:nil];
    }
};

//用户是否已登录
- (BOOL)isLogin{
    NSString *token=[UserDefaults objectForKey:TOKENID];
    if (0<token.length) {
        return YES;
    }
    return NO;
};

//用户是否已经购买了重疾险
- (BOOL)haveBuyZhongjiCare{
    MeModel *model=[self getMeModelMessage];
    return model.haveZhongjiCare;
};

//用户是否已经购买了意外险
- (BOOL)haveBuyYiwaiCare{
    MeModel *model=[self getMeModelMessage];
    return  model.haveYiwaiCare;
};


//计算多行文本高度
-(CGFloat)changeStationWidth:(NSString *)string anWidthTxtt:(CGFloat)widthText anfont:(CGFloat)fontSize{
    
    UIFont * tfont = SystemFont(fontSize);
    
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    
    CGSize size = CGSizeMake(widthText,CGFLOAT_MAX);
    
    //    获取当前文本的属性
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    
    CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    return actualsize.height;
    
}

//设置银行卡号样式
- (NSString *)BankNum:(NSString *)bankID{
    if (0==bankID.length) {
        return @"";
    }
    if (6>=bankID.length) {
        return bankID;
    }
    long long bankCard=[bankID longLongValue];
    NSNumber *number = [NSNumber numberWithLongLong:bankCard];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setGroupingSize:4];
    [formatter setGroupingSeparator:@" "];
    NSMutableString *cardIdStr=[[NSMutableString alloc]initWithString:[formatter stringFromNumber:number]];
    for (int i=0; i<cardIdStr.length-5; i++) {
        NSString *str=[cardIdStr substringWithRange:NSMakeRange(i, 1)];
        if ([str isEqualToString:@" "]==NO) {
            [cardIdStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
    }
    return cardIdStr;
}




@end
