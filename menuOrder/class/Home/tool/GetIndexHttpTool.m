//
//  GetIndexHttpTool.m
//  menuOrder
//  
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "GetIndexHttpTool.h"
#import "httpTool.h"
#import "HomePageDataModel.h"
#import "PhotoListModel.h"
#import "MenuCategory.h"
#import "MenuModel.h"
#import "ProductDetailModel.h"
#import "NiceFoodModel.h"
#import "ActivityModel.h"

@implementation GetIndexHttpTool

#pragma mark 获取首页数据
+ (void) GetIndexDataWithSuccess:(successBlock)success withFailure:(failureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionary];
    [HttpTool postWithPath:@"getIndex" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dict);
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        
        
        if (code == 100) {
            NSDictionary *array = [[dict objectForKey:@"response"] objectForKey:@"data"];
            
            if (![array isKindOfClass:[NSNull class]]) {
                HomePageDataModel *model = [[HomePageDataModel alloc] initWithDic:array];
                [statuses addObject:model];
            }
        }else
        {
            message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        }
        success(statuses, code,message);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
}


#pragma mark 获取图片列表数据（鱼府风采）
+ (void) GetgetPhotoListWithSuccess:(successBlock)success withFailure:(failureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionary];
    [HttpTool postWithPath:@"getPhotoList" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dict);
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        
        
        if (code == 100) {
           statuses = [[dict objectForKey:@"response"] objectForKey:@"data"];

        }else
        {
            message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        }
        success(statuses, code,message);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
}

#pragma mark 获取产品分类（飘香菜单）
+ (void) GetProductCategoryWithSuccess:(successBlock)success withFailure:(failureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionary];
    [HttpTool postWithPath:@"getProductCategory" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dict);
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        
        
        if (code == 100) {
            NSArray *array = [[dict objectForKey:@"response"] objectForKey:@"data"];
            
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *d in array) {
                    MenuCategory *model = [[MenuCategory alloc] initWithDic:d];
                    [statuses addObject:model];
                }
            }
        }else
        {
            message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        }
        success(statuses, code,message);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
}

#pragma mark 获取获取产品列表（飘香菜单）
+ (void) GetProductListWithSuccess:(successBlock)success category_id:(NSString *) categoryId page:(NSString *)page withFailure:(failureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:categoryId,@"category_id",page,@"page",@"10",@"pagesize", nil];
    
    [HttpTool postWithPath:@"getProductList" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = nil;
        if (code == 100) {
            NSDictionary *array = [[dict objectForKey:@"response"] objectForKey:@"data"];
            
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary * d in array) {
                    MenuModel *model = [[MenuModel alloc] initWithDic:d];
                    [statuses addObject:model];
                }
            }
        }else
        {
            message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        }
        success(statuses, code,message);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];

}

#pragma mark 获取产品详情
+ (void) GetProductDetailWithSuccess:(successBlock)success product_id:(NSString *) productId withFailure:(failureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:productId,@"product_id",@"10",@"pagesize", nil];
    
    [HttpTool postWithPath:@"getProductDetail" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = nil;
        if (code == 100) {
            NSDictionary *array = [[dict objectForKey:@"response"] objectForKey:@"data"];
            
            if (![array isKindOfClass:[NSNull class]]) {
                ProductDetailModel *model = [[ProductDetailModel alloc] initWithDic:array];
                [statuses addObject:model];
            }
        }else
        {
            message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        }
        success(statuses, code,message);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];

}

#pragma mark 获取热门产品列表
+ (void) GettHotProductListWithSuccess:(successBlock)success page:(NSString *)page withFailure:(failureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page", @"10",@"pagesize", nil];
    
    [HttpTool postWithPath:@"getHotProductList" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = nil;
        if (code == 100) {
            NSArray *array = [[dict objectForKey:@"response"] objectForKey:@"data"];
            
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *d in array) {
                    MenuModel  *model = [[MenuModel alloc] initWithDic:d];
                    [statuses addObject:model];
                }
            }
        }else
        {
            message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        }
        success(statuses, code,message);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
 
}

#pragma mark获取优惠活动
+ (void) GetActivitiesWithSuccess:(successBlock)success withFailure:(failureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionary];
    
    [HttpTool postWithPath:@"getActivities" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
       
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = nil;
        if (code == 100) {
            NSArray *array = [[dict objectForKey:@"response"] objectForKey:@"data"];
            
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *d in array) {
                    ActivityModel *model = [[ActivityModel alloc] initWithDic:d];
                    [statuses addObject:model];
                }
            }
        }else
        {
            message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        }
        success(statuses, code,message);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
}

+(void)GetDetailID:(NSString *)detailid GetActivitiesDetailWithSuccess:(successBlock)success withFailure:(failureBlock)failure{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:detailid,@"id", nil];
    [HttpTool postWithPath:@"getActivityDetail" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = nil;
        if (code == 100) {
            NSDictionary *array = [[dict objectForKey:@"response"]objectForKey:@"data"] ;
            if (![array isKindOfClass:[NSNull class]]) {
                [statuses addObject:array ];
                

        }else
        {
            message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        }
        }
        success(statuses, code,message);

    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
}

@end
