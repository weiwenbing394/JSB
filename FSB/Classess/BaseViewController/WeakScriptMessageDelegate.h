//
//  WeakScriptMessageDelegate.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/5/2.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
