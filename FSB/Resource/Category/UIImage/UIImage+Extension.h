//
//  UIImage+Extension.h
//  JYJ微博
//
//  Created by JYJ on 15/3/11.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  返回拉伸图片
 */
+ (UIImage *)resizedImage:(NSString *)name;
/**
 *  用颜色返回一张图片
 */
+ (UIImage *)createImageWithColor:(UIColor*) color;
/**
 *  带边框的图片
 *
 *  @param name        图片
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


/**
 *  使用图像名创建图像视图
 *
 *  @param imageName 图像名称
 *
 *  @return UIImageView
 */
+ (instancetype)imageViewWithImageName:(NSString *)imageName;

/**
 * 圆形图片
 */
- (UIImage *)circleImage;

/**
 *  获取屏幕截图
 *
 *  @return 屏幕截图图像
 */
+ (UIImage *)screenShot;
/**
 *  动态发布图片压缩
 *
 *  @param source_image 原图image
 *  @param maxsize      限定的图片大小
 *
 *  @return 返回处理后的图片
 */
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image  maxSize:(CGFloat)maxsize;



@end
