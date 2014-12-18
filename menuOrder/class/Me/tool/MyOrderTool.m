//
//  MyOrderTool.m
//  menuOrder
//
//  Created by YY on 14-12-17.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MyOrderTool.h"

@implementation MyOrderTool
+ (void)myOrderUid:(NSString *)uid statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure{
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    [HttpTool postWithPath:@"getFoodList" params:dict success:^(id JSON) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil ];
        NSDictionary *array =dic[@"response"];
        NSLog(@"%@",array);
        
    } failure:^(NSError *error) {
        
    }];
}

@end