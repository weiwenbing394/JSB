//
//  UIViewController+XWModal.h
//  MadelControllerDemo
//
//  Created by 大家保 on 2017/3/23.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//配置参数的结构体
extern const struct XWModalOptionKeys{
    __unsafe_unretained NSString *traverseParentHierarchy; // 遍历父视图的层次结构 boxed BOOL. default is YES.
    __unsafe_unretained NSString *pushParentBack;		   // 父视图是否有后退效果 boxed BOOL. default is YES.
    __unsafe_unretained NSString *animationDuration; // 动画时间 boxed double, in seconds. default is 0.5.
    __unsafe_unretained NSString *parentAlpha;       // 父视图的透明度 boxed float. lower is darker. default is 0.5.
    __unsafe_unretained NSString *parentScale;       // 父视图的缩放数 boxed double default is 0.8
    __unsafe_unretained NSString *shadowOpacity;     // 阴影的透明度 default is 0.8
    __unsafe_unretained NSString *transitionStyle;	 // 切换的样式 boxed NSNumber - one of the KNSemiModalTransitionStyle values.
    __unsafe_unretained NSString *disableCancel;     // 是否禁用点击背景取消 boxed BOOL. default is NO.
    __unsafe_unretained NSString *backgroundView;     //背景视图 UIView, custom background.

}XWModalOptionKeys;

//切换的样式style
typedef NS_ENUM(NSUInteger,XWModalTransitionStyle) {
    XWTransitionStyleSlideUp,
    XWTransitionStyleFadeInOut,
    XWTransitionStyleFadeIn,
    XWTransitionStyleFadeOut
};


//回掉的block

typedef void (^XWTranstionCompletionBlock)(void);

@interface UIViewController (XWModal)
/**
 present一个viewController
 @param vc           弹出的vc
 @param options	     动画的配置文件
 @param completion   动画完成的回调
 @param dismissBlock 取消动画的回调
 */
- (void)presnetXWViewController:(UIViewController *)vc withOptions:(NSDictionary *)options completion:(XWTranstionCompletionBlock)completion dissmissBlock:(XWTranstionCompletionBlock)dismissBlock;

/**
 present一个vc 使用默认的配置
 */
- (void)presnetXWViewController:(UIViewController *)vc;

/**
 present一个viewController
 @param vc           弹出的vc
 @param options	     动画的配置文件
 */
- (void)presnetXWViewController:(UIViewController *)vc withOptions:(NSDictionary *)options;

/**
 present一个view
 @param view           弹出的view
 @param options	     动画的配置文件
 @param completion   动画完成的回调
 */
- (void)presentXWView:(UIView *)view withOptions:(NSDictionary *)options completion:(XWTranstionCompletionBlock)completion;

/**
 present一个view
 @param view           弹出的view,使用默认配置
 */
- (void)presentXWView:(UIView *)view;

/**
 present一个view
 @param view           弹出的view,使用options配置
 */
- (void)presentXWView:(UIView *)view withOptions:(NSDictionary *)options;

/**
 dissmissController
 */
- (void)dismissXWModalView;

/**
 dissmissController
 @param completion   动画完成的回调
 */
- (void)dismissXWModalViewWithCompletion:(XWTranstionCompletionBlock)completion;

@end




@interface NSObject (OptionsAndDefaults)

//配置动画的相关参数
- (void)xw_registerOptions:(NSDictionary *)options defaults:(NSDictionary *)defaults;

//获取配置的相关参数
- (id)xw_optionsOrDefaultForKey:(NSString *)optionKey;

@end



@interface UIView (FindUIViewController)

//查找view的根controller
- (UIViewController *)containingViewController;

//遍历uiviewController的响应链
- (id)traverseResponderChainForUIViewController;

@end
