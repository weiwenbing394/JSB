//
//  MBProgressHUD+ADD.m
//  XW_MB_AF_MANAGER
//
//  Created by 大家保 on 2016/10/19.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "MBProgressHUD+ADD.h"
#define offSety GetHeight(30)

@implementation MBProgressHUD (ADD)

/**
 *  信息提示
 *  @param information 提示文字
 */
+ (MBProgressHUD *)ToastInformation:(NSString *)information{
    
    return [self showInformation:information toView:nil andAfterDelay:1.5];
};

/**
 *  弹出提示
 *  @param information 提示文字
 */
+ (MBProgressHUD *)ToastInformation:(NSString *)information toView:(UIView *)view{
    return [self showInformation:information toView:view andAfterDelay:1.5];
};


/**
 *  信息提示
 *  @param information 提示文字
 *  @param view        HUD展示的view
 *  @param afterDelay  展示的时间
 */
+ (MBProgressHUD *)showInformation:(NSString *)information toView:(UIView *)view andAfterDelay:(float)afterDelay{
    
    if (view==nil) {
        
        UIWindow *backgroundWindow= [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backgroundWindow.windowLevel = UIWindowLevelStatusBar + 1;
        
        UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
        if (keywindow != backgroundWindow) {
            backgroundWindow = [UIApplication sharedApplication].keyWindow;
        }
        backgroundWindow.frame = [UIScreen mainScreen].bounds;
        [backgroundWindow makeKeyAndVisible];
        
        view=backgroundWindow;
    }
    
    [self hideHUDForView:view animated:NO];
    
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:NO];
    
    hud.mode=MBProgressHUDModeText;
    
    hud.label.text=information;
    
    hud.label.font=[UIFont systemFontOfSize:GetWidth(16)];
    
    hud.contentColor=[UIColor whiteColor];
    
    hud.margin=GetWidth(17);
    
    hud.offset=CGPointMake(hud.offset.x, hud.offset.y-offSety);
    
    hud.bezelView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    hud.userInteractionEnabled = NO;
    
    [hud setRemoveFromSuperViewOnHide:YES];
    
    [hud hideAnimated:NO afterDelay:afterDelay];
    
    return hud;
};


/**
 *  显示
 */
+ (MBProgressHUD *)showHUDWithTitle:(NSString *)title;{
    return [self showDefalutTypeToView:nil withType:0 withTitle:title];
};

/**
 *  显示菊花
 */
+ (MBProgressHUD *)showHUDWithTitle:(NSString *)title toView:(UIView *)view{
    return [self showDefalutTypeToView:view withType:0 withTitle:title];
};

/**
 *  显示默认的样式
 */
+ (MBProgressHUD *)showDefalutTypeToView:(UIView *)view withType:(MBProgressHUDMode)mode withTitle:(NSString *)title{
    
    if (view==nil) {
        
        view=[[UIApplication sharedApplication].delegate window];
        
    }
    
    [self hideHUDForView:view animated:NO];
    
    if (mode==0) {
        
        mode=MBProgressHUDModeIndeterminate;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:NO];
    
    hud.mode=mode;
    
    if (0<title.length) {
        
        hud.label.text=@" ";
        
        hud.label.font=[UIFont systemFontOfSize:GetWidth(1)];
        
        hud.detailsLabel.text=title;
        
        hud.detailsLabel.font=[UIFont systemFontOfSize:GetWidth(16)];
    }
    
    hud.bezelView.backgroundColor=RGBA(0, 0, 0, 0.6);
    
    hud.contentColor=[UIColor whiteColor];
    
    hud.margin=GetWidth(14);
    
    hud.userInteractionEnabled = YES;
    
    hud.offset=CGPointMake(hud.offset.x, hud.offset.y-offSety);
    
    [hud setRemoveFromSuperViewOnHide:YES];
    
    return hud;
};


/**
 *  隐藏窗口 HUD
 */
+ (void) hiddenHUD{
    [self hiddenHUDToView:nil];
};

/**
 *  隐藏 HUD
 */
+ (void) hiddenHUDToView:(UIView *)showView {
    
    if (showView == nil) {
        
        showView = (UIView*)[[[UIApplication sharedApplication]delegate]window];
        
    }
    
    [self hideHUDForView:showView animated:NO];
    
}



#pragma mark  请自己提供图标（目前全部使用@"Checkmark"）
/**
 *  成功图标弹出
 */
+ (void)showSuccess:(NSString *)success{
    [self showSuccess:success toView:nil];
};
/**
 *  成功图标弹出
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view{
    [self showCustomView:@"绑定成功" andTextString:success toView:view andAfterDelay:1.5];
};
/**
 *  失败图标弹出
 */
+ (void)showError:(NSString *)error{
    [self showError:error toView:nil];
};
/**
 *  失败图标弹出
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self showCustomView:@"绑定失败" andTextString:error toView:view andAfterDelay:1.5];
};



/**
 *  自定义view
 *  @param icon 自定义的图标名称
 *  @param textString 提示文字
 *  @param view       HUD展示的view
 *  @param afterDelay 展示时间
 */
+ (MBProgressHUD *)showCustomView:(NSString *)icon andTextString:(NSString *)textString toView:(UIView *)view andAfterDelay:(float)afterDelay{
    
    if (view==nil) {
        
        view=[UIApplication sharedApplication].delegate.window;
        
    }
    
    [self hideHUDForView:view animated:NO];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:NO];
    
    hud.bezelView.style=MBProgressHUDBackgroundStyleSolidColor;
    
    hud.bezelView.backgroundColor=RGBA(0, 0, 0, 0.6);
    
    hud.label.text=textString;
    
    hud.label.font=[UIFont systemFontOfSize:GetWidth(16)];
    
    hud.contentColor=[UIColor whiteColor];
    
    hud.margin=GetWidth(25);
    
    hud.square=NO;
    
    hud.offset=CGPointMake(hud.offset.x, hud.offset.y-offSety);
    
    hud.userInteractionEnabled = NO;
    
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    
    hud.mode=MBProgressHUDModeCustomView;
    
    [hud setRemoveFromSuperViewOnHide:YES];
    
    [hud hideAnimated:NO afterDelay:afterDelay];
    
    return hud;
    
};

/**
 *  显示动画 HUD
 */
+ (MBProgressHUD *) showHUDWithImageArr:(NSMutableArray *)imageArr{
   return  [self showHUDWithImageArr:imageArr andShowView:nil];
};


/**
 *  显示动画 HUD
 */

+ (MBProgressHUD *) showHUDWithImageArr:(NSMutableArray *)imageArr andShowView:(UIView *)showView{
    
    if (showView == nil) {
        
        showView  = (UIView *)[[UIApplication sharedApplication].delegate window];
    }
    
    [self hideHUDForView:showView animated:NO];
    
    
    if (imageArr == nil) {
        
        return [self showHUDAddedTo:showView animated:YES];
        
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:NO];
        
        hud.mode = MBProgressHUDModeCustomView;
        
        UIImageView *imaegCustomView = [[UIImageView alloc] init];
        
        imaegCustomView.animationImages = imageArr;
        
        [imaegCustomView setAnimationRepeatCount:0];
        
        [imaegCustomView setAnimationDuration:(imageArr.count + 1) * 0.075];
        
        [imaegCustomView startAnimating];
        
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        
        hud.bezelView.color = [UIColor clearColor];
        
        hud.customView = imaegCustomView;
        
        hud.square = NO;
        
        hud.userInteractionEnabled = YES;
        
        hud.offset=CGPointMake(hud.offset.x, hud.offset.y-offSety);
        
        [hud setRemoveFromSuperViewOnHide:YES];
        
        return hud;
        
    }
}




@end
