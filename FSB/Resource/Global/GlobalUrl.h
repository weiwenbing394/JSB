//
//  GlobalUrl.h
//  FSB
//
//  Created by 大家保 on 2017/7/31.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#ifndef GlobalUrl_h
#define GlobalUrl_h

//友盟分享
#define UMENG_APPKEY      @"58f4304bf29d98036d000d61"
#define weChatId          @"wx2cb63a03944301c6"
#define weChatScreat      @"519a67c3b5a4148400fa872a4b9f1b1a"

//短信服务器地址
//#define codeUrl         @"http://service.yulin.dev.dajiabao.com"
#define codeUrl           @"http://mapi.pre.dajiabao.com"
//#define codeUrl         @"http://mapi.dajiabao.com"


//玉林服务器地址
//#define   APPHOSTURL    @"http://sns.api.yulin.dev.dajiabao.com"
//测试环境
//#define     APPHOSTURL  @"http://api.qqb.test02.arrill.com"
//pre服务器地址
#define     APPHOSTURL    @"http://api.qqb.pre.arrill.com"
//正式服务器地址
//#define     APPHOSTURL  @"http://api.qqb.arrill.com"

//h5地址域名
//#define   H5HOSTURL     @"http://sns.wap.yulin.dev.dajiabao.com"
//#define     H5HOSTURL   @"http://qqb.test02.arrill.com"
#define   H5HOSTURL       @"http://qqb.pre.arrill.com"
//#define   H5HOSTURL     @"http://qqb.arrill.com"

//用户登录
#define toLogin           @"/login"
//主页更新用户数据
#define refreshUserData   @"/refreshUserData"
//主页产品列表
#define getHomeProducts   @"/getHomeProducts"
//购买重疾险
#define buyZhongjiCare    @"/buyZhongjiCare"
//购买意外险
#define buyYiwaiCare      @"/buyYiwaiCare"
//查询重疾险数据
#define zhongjiCareValue  @"/zhongjiCareValue"
//查询意外险数据
#define yiwaiCareValue    @"/yiwaiCareValue"
//获取产品
#define getProducts       @"/getProducts"
//筛选产品
#define filterProducts    @"/filterProducts"
//我的资料
#define userInfos         @"/userInfos"
//更改昵称
#define changeNickName    @"/changeNickName"
//添加或者修改地区
#define changeAddress     @"/address"
//身份证
#define getIdCard         @"/idCard"
//绑定微信
#define addWechat         @"/addWechat"
//获取搜索条件
#define getsearchFilter   @"/getsearchFilter"
//搜索
#define getSearch            @"/search"
//验证是否已绑定微信
#define checkWechat       @"/checkWechat"

//本地保存的user
#define TOKENID           @"token"
//本地保存的user
#define ME                @"Me"
//登录的通知名称
#define LOGINNOTIFIC      @"loginNotific"
//退出登录的通知名称
#define LOGOUTNOTIFIC     @"logoutNotific"
//购买成功的通知名称
#define BUYSUCCESS        @"buySuccess"

#endif
