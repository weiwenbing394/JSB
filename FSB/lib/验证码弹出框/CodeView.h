//
//  CodeView.h
//  tianyi360
//
//  Created by 大家保 on 16/7/8.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OKBlock) (NSString *str,NSString *imageCode);

typedef void (^CancelBlock) ();

@interface CodeView : UIView<UITextFieldDelegate>

@property (nonatomic,copy)NSString *postSid;

@property (nonatomic, copy)OKBlock okBlock;

@property (nonatomic, copy)CancelBlock cancelBlock;

@property (nonatomic, assign)int   connectNumber;

- (void)initWithPostId:(NSString *)postID okBlock:(OKBlock )okBloc cancelBlock:(CancelBlock )cancelBloc;

- (void)initWithPhoneNumber:(NSString *)phoneNumber PostId:(NSString *)postID okBlock:(OKBlock )okBloc cancelBlock:(CancelBlock )cancelBloc;
@end
