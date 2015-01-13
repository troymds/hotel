//
//  MysubscribeTool.m
//  menuOrder
//
//  Created by YY on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MysubscribeTool.h"
#import "MysubscribeModel.h"

@implementation MysubscribeTool
#pragma mark ---我的预约
+ (void)statusesWithSuccess:(StatusSuccessBlock)success orderListUid_ID:(NSString *)uid_id failure:(StatusFailureBlock)failure{
   
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:uid_id,@"uid", nil];
    [HttpTool postWithPath:@"getOrderList" params:dict success:^(id JSON) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *dict1 =[dic[@"response"] objectForKey:@"data"];
        NSLog(@"%@",dic);
        
        if (![dict1 isKindOfClass:[NSNull class]])
        {
            MysubscribeModel *mysubModel = [[MysubscribeModel alloc] initWithDictionaryForSubscribeList:dict1];
            
             success(mysubModel.allModelArray);
            
        }
        else
        {
            success(nil);
        }
       

        
    } failure:^(NSError *error) {
        
    } ];
}
#pragma mark ---获取预约详情
+ (void)getOrderDetailId:(NSString *)order_id statusesWithSuccess:(StatusSuccessBlock)success  failure:(StatusFailureBlock)failure{
    NSLog(@"=========%@",order_id);
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:order_id,@"order_id", nil];
    [HttpTool postWithPath:@"getOrderDetail" params:dict success:^(id JSON) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =dic[@"response"];
        NSLog(@"vvvvsssssssvvvvv%@",array);
        if (![array isKindOfClass:[NSNull class]]) {
            [statuses addObject:[array objectForKey:@"data"]];
        }
        else{
            success(nil);
        }
        success(statuses);
        
        
    } failure:^(NSError *error) {
        
    } ];
}

@end
