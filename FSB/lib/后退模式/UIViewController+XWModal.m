//
//  UIViewController+XWModal.m
//  MadelControllerDemo
//
//  Created by 大家保 on 2017/3/23.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "UIViewController+XWModal.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

const struct XWModalOptionKeys XWModalOptionKeys={
    .traverseParentHierarchy = @"XWModalOptionTraverseParentHierarchy",
    .pushParentBack          = @"XWModalOptionPushParentBack",
    .animationDuration       = @"XWModalOptionAnimationDuration",
    .parentAlpha             = @"XWModalOptionParentAlpha",
    .parentScale             = @"XWModalOptionParentScale",
    .shadowOpacity           = @"XWModalOptionShadowOpacity",
    .transitionStyle         = @"XWModalTransitionStyle",
    .disableCancel           = @"XWModalOptionDisableCancel",
    .backgroundView          = @"XWModelOptionBackgroundView",
};

//关联弹出来的controller的key
#define kXWModalViewController           @"PaPQC93kjgzUanz"
//关联dismissBlock的key
#define kXWModalDismissBlock             @"l27h7RU2dzVfPoQ"
//本controller的关联key
#define kXWModalPresentingViewController @"QKWuTQjUkWaO1Xr"
//遮罩层tag
#define kXWModalOverlayTag               10001
//屏幕截图tag
#define kXWModalScreenshotTag            10002
//弹出视图tag
#define kXWModalModalViewTag             10003
//dismiss按钮tag
#define kXWModalDismissButtonTag         10004

@interface UIViewController  (XWModalInternal)

//uiviewcontroller的根视图
- (UIView *)parentTarget;

//动画组
- (CAAnimationGroup *)animationGroupForward:(BOOL)_forward;

@end

@implementation UIViewController  (XWModalInternal)

//uiviewcontroller的根视图
- (UIView *)parentTarget{
    return [self  xw_parentTargetViewController].view;
};

//动画组
- (CAAnimationGroup *)animationGroupForward:(BOOL)_forward{
    CATransform3D t1=CATransform3DIdentity;
    t1.m34=-1.0/900;
    t1=CATransform3DScale(t1, 0.95, 0.95, 1);
    t1=CATransform3DRotate(t1, 15*M_PI/180.0, 1, 0, 0);
    
    CATransform3D t2=CATransform3DIdentity;
    t2.m34=t1.m34;
    CGFloat transLateHeight=[self parentTarget].frame.size.height;
    t2=CATransform3DTranslate(t2, 0, -transLateHeight*0.08, 0);
    CGFloat transScale=[[self xw_optionsOrDefaultForKey:XWModalOptionKeys.parentScale] doubleValue];
    t2=CATransform3DScale(t2, transScale, transScale, 1);
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue=[NSValue valueWithCATransform3D:t1];
    CFTimeInterval duration=[[self xw_optionsOrDefaultForKey:XWModalOptionKeys.animationDuration] doubleValue];
    animation.duration=duration/2.0;
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion=NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.fillMode=kCAFillModeForwards;
    group.duration=animation.duration*2;
    group.removedOnCompletion=NO;
    [group setAnimations:@[animation,animation2]];
    
    return group;
};

//uiviewcontroller的根控制器
- (UIViewController *)xw_parentTargetViewController{
    UIViewController *target=self;
    if ([[self xw_optionsOrDefaultForKey:XWModalOptionKeys.traverseParentHierarchy] boolValue]) {
        while (target.parentViewController!=nil) {
            target=target.parentViewController;
        }
    }
    return target;
}

//设置默认的动画配置
- (void)xw_registerDefaultsAndOptions:(NSDictionary *)options{
    [self xw_registerOptions:options defaults:@{
         XWModalOptionKeys.traverseParentHierarchy:@(YES),
         XWModalOptionKeys.pushParentBack:@(YES),
         XWModalOptionKeys.animationDuration:@(0.5),
         XWModalOptionKeys.parentAlpha:@(0.5),
         XWModalOptionKeys.parentScale:@(0.8),
         XWModalOptionKeys.shadowOpacity:@(0.8),
         XWModalOptionKeys.transitionStyle:@(XWTransitionStyleSlideUp),
         XWModalOptionKeys.disableCancel:@(NO),
    }];
}

//获取屏幕截图并添加到screenshotContainer上 返回截屏
- (UIImageView *)xw_addOrUpdateParentScreenshotInView:(UIView *)screenshotContainer{
    //获取当前controller的根视图
    UIView *target=[self parentTarget];
    //隐藏将要弹出的view
    UIView *xwView=[target viewWithTag:kXWModalModalViewTag];
    xwView.hidden=YES;
    //隐藏screenshotContainer
    screenshotContainer.hidden=YES;
    //获取屏幕截图
    UIGraphicsBeginImageContextWithOptions(target.frame.size, YES, [[UIScreen mainScreen] scale]);
    if ([target respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [target drawViewHierarchyInRect:target.bounds afterScreenUpdates:NO];
    }else{
        [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //显示xwView screenshotContainer
    xwView.hidden=NO;
    screenshotContainer.hidden=NO;
    //创建图片对象
    UIImageView *screenshot=[screenshotContainer viewWithTag:kXWModalScreenshotTag];
    if (screenshot) {
        screenshot.image=image;
    }else{
        screenshot=[[UIImageView alloc]initWithImage:image];
        screenshot.tag=kXWModalScreenshotTag;
        screenshot.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [screenshotContainer addSubview:screenshot];
    }
    return screenshot;
}

@end

@implementation UIViewController (XWModal)


/**
 present一个viewController
 @param vc           弹出的vc
 @param options	     动画的配置文件
 @param completion   动画完成的回调
 @param dismissBlock 取消动画的回调
 */
- (void)presnetXWViewController:(UIViewController *)vc withOptions:(NSDictionary *)options completion:(XWTranstionCompletionBlock)completion dissmissBlock:(XWTranstionCompletionBlock)dismissBlock{
    [self xw_registerDefaultsAndOptions:options];
    UIViewController *targetParentVC=[self xw_parentTargetViewController];
    [targetParentVC addChildViewController:vc];
    //给操作的controller关联弹出来的controller
    objc_setAssociatedObject(self, kXWModalViewController, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kXWModalDismissBlock,dismissBlock,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //把弹出来的视图添加到当前controller
    [self presentXWView:vc.view withOptions:options completion:^{
        //将弹出的controller添加到根controller上
        [vc didMoveToParentViewController:targetParentVC];
        completion?completion():nil;
    }];
};



/**
 present一个vc 使用默认的配置
 */
- (void)presnetXWViewController:(UIViewController *)vc{
    [self presnetXWViewController:vc withOptions:nil completion:nil dissmissBlock:nil];
};

/**
 present一个viewController
 @param vc           弹出的vc
 @param options	     动画的配置文件
 */
- (void)presnetXWViewController:(UIViewController *)vc withOptions:(NSDictionary *)options{
    [self presnetXWViewController:vc withOptions:options completion:nil dissmissBlock:nil];
};

/**
 present一个view
 @param view           弹出的view
 @param options	     动画的配置文件
 @param completion   动画完成的回调
 */
- (void)presentXWView:(UIView *)view withOptions:(NSDictionary *)options completion:(XWTranstionCompletionBlock)completion{
    [self xw_registerDefaultsAndOptions:options];
    //获取根视图
    UIView *target=[self parentTarget];
    if (![target.subviews containsObject:view]) {
        //给弹出视图关联一个父视图
        objc_setAssociatedObject(view, kXWModalPresentingViewController, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        //转换样式
        NSUInteger transitionStyle=[[self xw_optionsOrDefaultForKey:XWModalOptionKeys.transitionStyle] unsignedIntegerValue];
        //弹出视图的高度
        CGFloat xwViewHeight=view.frame.size.height;
        //根视图frame
        CGRect  vf=target.bounds;
        //添加遮罩层
        UIView *overlay;
        UIView *backgroundView=[self xw_optionsOrDefaultForKey:XWModalOptionKeys.backgroundView];
        if (backgroundView) {
            overlay=backgroundView;
        }else{
            overlay=[[UIView alloc]init];
        }
        overlay.frame=target.bounds;
        overlay.backgroundColor=[UIColor blackColor];
        overlay.userInteractionEnabled=YES;
        overlay.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlay.tag=kXWModalOverlayTag;
        //获取屏幕截图
        UIImageView *ss=[self xw_addOrUpdateParentScreenshotInView:overlay];
        [target addSubview:overlay];
        //是否禁用点击背景dissmiss
        //cancelbuttom的点击区域
        CGRect  overlayFrame=CGRectMake(0, 0, vf.size.width, vf.size.height-xwViewHeight);
        if (![[self xw_optionsOrDefaultForKey:XWModalOptionKeys.disableCancel] boolValue]) {
            UIButton *dismissButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [dismissButton addTarget:self action:@selector(dismissXWModalView) forControlEvents:UIControlEventTouchUpInside];
            dismissButton.backgroundColor=[UIColor clearColor];
            dismissButton.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            dismissButton.frame=overlayFrame;
        }
        //屏幕截图往后退效果
        if ([[self xw_optionsOrDefaultForKey:XWModalOptionKeys.pushParentBack] boolValue]) {
            [ss.layer addAnimation:[self animationGroupForward:YES] forKey:@"pushedBackAnimation"];
        }
        //屏幕截图透明度的变化
        NSTimeInterval duration=[[self xw_optionsOrDefaultForKey:XWModalOptionKeys.animationDuration] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            ss.alpha=[[self xw_optionsOrDefaultForKey:XWModalOptionKeys.parentAlpha] floatValue];
        }];
        //弹出视图动画
        //弹出视图的frame
        CGRect  xwViewFrame=CGRectMake(0, vf.size.height-xwViewHeight, vf.size.width, xwViewHeight);
        view.frame=(transitionStyle==XWTransitionStyleSlideUp?CGRectOffset(xwViewFrame, 0, xwViewHeight):xwViewFrame);
        if (transitionStyle==XWTransitionStyleFadeIn||transitionStyle==XWTransitionStyleFadeInOut) {
            view.alpha=0;
        }
        view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.tag=kXWModalModalViewTag;
        [target addSubview:view];
        view.layer.shadowColor=[UIColor blackColor].CGColor;
        view.layer.shadowOffset=CGSizeMake(0, -2);
        view.layer.shadowRadius=5.0;
        view.layer.shadowOpacity=[[self xw_optionsOrDefaultForKey:XWModalOptionKeys.shadowOpacity] floatValue];
        view.layer.shouldRasterize=YES;
        view.layer.rasterizationScale=[[UIScreen mainScreen]scale];
        
        //弹出视图动画
        [UIView animateWithDuration:duration animations:^{
            if (transitionStyle==XWTransitionStyleSlideUp) {
                view.frame=xwViewFrame;
            }else if (transitionStyle==XWTransitionStyleFadeIn||transitionStyle==XWTransitionStyleFadeInOut){
                view.alpha=1;
            }
        } completion:^(BOOL finished) {
            if (finished) {
                completion?completion():nil;
            }
        }];
    }
};


- (void)dismissSemiModalView{
    
}

/**
 present一个view
 @param view           弹出的view,使用默认配置
 */
- (void)presentXWView:(UIView *)view{
    [self presentXWView:view withOptions:nil completion:nil];
};

/**
 present一个view
 @param view           弹出的view,使用options配置
 */
- (void)presentXWView:(UIView *)view withOptions:(NSDictionary *)options{
    [self presentXWView:view withOptions:options completion:nil];
};

/**
 dissmissController
 */
- (void)dismissXWModalView{
    [self dismissXWModalViewWithCompletion:nil];
};

/**
 dissmissController
 @param completion   动画完成的回调
 */

- (void)dismissXWModalViewWithCompletion:(XWTranstionCompletionBlock)completion{
    UIViewController *selfController=self;
    //获取弹出视图关联的controller
    UIViewController *presentingController=objc_getAssociatedObject(selfController.view, kXWModalPresentingViewController);
    while (presentingController==nil&&selfController.parentViewController!=nil) {
        selfController=selfController.parentViewController;
        presentingController=objc_getAssociatedObject(selfController.view, kXWModalPresentingViewController);
    }
    if (presentingController) {
        objc_setAssociatedObject(presentingController.view, kXWModalPresentingViewController, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [presentingController dismissXWModalViewWithCompletion:completion];
        return;
    }
    //根视图
    UIView *target=[self parentTarget];
    //弹出的视图
    //UIView *modal=[target.subviews objectAtIndex:3];
    UIView *modal=[target viewWithTag:kXWModalModalViewTag];
    //背景视图
    //UIView *overLay=[target.subviews objectAtIndex:2];
    UIView *overLay=[target viewWithTag:kXWModalOverlayTag];
    //弹出样式
    NSUInteger transitionStyle=[[self xw_optionsOrDefaultForKey:XWModalOptionKeys.transitionStyle] unsignedIntegerValue];
    //弹出来的controller
    UIViewController *presentVC = objc_getAssociatedObject(self, kXWModalViewController);
    //弹出来的视图取消的block
    XWTranstionCompletionBlock dismissBlock=objc_getAssociatedObject(self, kXWModalDismissBlock);
    //弹出的视图将要离开主视图
    [presentVC willMoveToParentViewController:self];
    //动画时长
    NSTimeInterval duration=[[self xw_optionsOrDefaultForKey:XWModalOptionKeys.animationDuration] doubleValue];
    //弹出视图开始做取消动画
    [UIView animateWithDuration:duration animations:^{
        if (transitionStyle==XWTransitionStyleSlideUp) {
            modal.frame=CGRectMake((target.bounds.size.width-modal.frame.size.width)/2.0, target.bounds.size.height, modal.frame.size.width, modal.frame.size.height);
        }else if (transitionStyle==XWTransitionStyleFadeOut||transitionStyle==XWTransitionStyleFadeInOut){
            modal.alpha=0;
        }
    } completion:^(BOOL finished) {
        [overLay removeFromSuperview];
        [modal   removeFromSuperview];
        [presentVC removeFromParentViewController];
        dismissBlock?dismissBlock():nil;
        objc_setAssociatedObject(self, kXWModalDismissBlock, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, kXWModalViewController, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
    //屏幕截图开始做取消动画
    UIImageView *ss=[overLay.subviews objectAtIndex:0];
    if ([[self xw_optionsOrDefaultForKey:XWModalOptionKeys.pushParentBack] boolValue]) {
        [ss.layer addAnimation:[self animationGroupForward:NO] forKey:@"bringForwardAnimation"];
    };
    [UIView animateWithDuration:duration animations:^{
        ss.alpha=1;
    } completion:^(BOOL finished) {
        completion?completion():nil;
    }];
    
};



@end

#import <objc/runtime.h>

@implementation NSObject (OptionsAndDefaults)
//option的唯一key
static char const *const StandardOptionsTableName= "StandardOptionsTableName";
//默认配置的唯一key
static char const *const StandardDefaultsTableName= "StandardDefaultsTableName";

//配置动画的相关参数
- (void)xw_registerOptions:(NSDictionary *)options defaults:(NSDictionary *)defaults{
    objc_setAssociatedObject(self, &StandardOptionsTableName, options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &StandardDefaultsTableName, defaults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
};

//获取配置的相关参数
- (id)xw_optionsOrDefaultForKey:(NSString *)optionKey{
    NSDictionary *options=objc_getAssociatedObject(self, &StandardOptionsTableName);
    NSDictionary *defaults=objc_getAssociatedObject(self, &StandardDefaultsTableName);
    return options[optionKey]?options[optionKey]:defaults[optionKey];
};

@end


@implementation UIView (FindUIViewController)

//查找view的根controller
- (UIViewController *)containingViewController{
    UIView *target=self.superview?self.superview:self;
    return (UIViewController *)[target traverseResponderChainForUIViewController];
};

//遍历uiviewController的响应链
- (id)traverseResponderChainForUIViewController{
    id nextResponder= [self nextResponder];
    BOOL isViewController=[nextResponder isKindOfClass:[UIViewController class]];
    BOOL isTabBarController=[nextResponder isKindOfClass:[UITabBarController class]];
    BOOL isView=[nextResponder isKindOfClass:[UIView class]];
    if (isViewController&&!isTabBarController) {
        return nextResponder;
    }else if (isTabBarController){
        UITabBarController *tabbarController=nextResponder;
        return [tabbarController selectedViewController];
    }else if (isView){
        return [nextResponder traverseResponderChainForUIViewController];
    }else{
        return nil;
    }
};

@end
