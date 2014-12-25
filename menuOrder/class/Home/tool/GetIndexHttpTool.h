//
//  GetIndexHttpTool.h
//  menuOrder
//  首页拉取数据
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetIndexHttpTool : NSObject

typedef void(^successBlock)(NSArray *data, int code, NSString * msg);
typedef void(^failureBlock)(NSError *error);

//获取首页数据
+ (void) GetIndexDataWithSuccess:(successBlock)success withFailure:(failureBlock)failure;

// 获取图片列表数据（鱼府风采）
+ (void) GetgetPhotoListWithSuccess:(successBlock)success withFailure:(failureBlock)failure;

// 获取产品分类（飘香菜单）
+ (void) GetProductCategoryWithSuccess:(successBlock)success withFailure:(failureBlock)failure;

// 获取获取产品列表（飘香菜单）
+ (void) GetProductListWithSuccess:(successBlock)success category_id:(NSString *) categoryId page:(NSString *)page withFailure:(failureBlock)failure;

// 获取产品详情
+ (void) GetProductDetailWithSuccess:(successBlock)success product_id:(NSString *) productId withFailure:(failureBlock)failure;

// 获取热门产品列表
+ (void) GettHotProductListWithSuccess:(successBlock)success page:(NSString *)page withFailure:(failureBlock)failure;

//获取优惠活动
+ (void) GetActivitiesWithSuccess:(successBlock)success withFailure:(failureBlock)failure;

@end
