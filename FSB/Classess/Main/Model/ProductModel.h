//
//  ProductModel.h
//  FSB
//
//  Created by 大家保 on 2017/8/8.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

//产品的图片地址
@property (nonatomic,copy) NSString *productImage;
//产品的标题
@property (nonatomic,copy) NSString *productDetail;
//产品的特色
@property (nonatomic,strong) NSArray *productCategory;
//产品的价钱
@property (nonatomic,assign) float productPrice;
//购买地址
@property (nonatomic,copy) NSString *productUrl;


@end
