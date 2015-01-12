//
//  MyOrderTool.m
//  menuOrder
//
//  Created by YY on 14-12-17.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MyOrderTool.h"
#import "myOrderListModel.h"
@implementation MyOrderTool
+ (void)myOrderUid:(NSString *)uid statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure{
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    [HttpTool postWithPath:@"getFoodList" params:dict success:^(id JSON) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *dict1 =dic[@"response"][@"data"];
        
        NSLog(@"%@",dict1);
        NSMutableArray *timeModelArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        if (![dict1 isKindOfClass:[NSNull class]])
        {
            NSArray *current = dict1[@"time"];
            
            NSString *_timeTitle = nil;
            NSMutableArray *_currentArray;
            
            
            for (NSDictionary *dict in current)
            {
                
                if (![_timeTitle isEqualToString:[dict objectForKey:@"create_time"]])
                {
//                    _timeArray =[[NSMutableArray alloc] initWithCapacity:0];
                    NSMutableArray *currentArr =[[NSMutableArray alloc] initWithCapacity:0];
                    myOrderListModel *orderModel =[[myOrderListModel alloc]initWithForOrderList:dict];
 
                    orderModel.createTime = [[dict objectForKey:@"create_time"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                    
                    [currentArr addObject:orderModel];
                    [timeModelArray addObject:currentArr];
                    
                    _timeTitle = [dict objectForKey:@"create_time"];
                    _currentArray = currentArr;
    
                }
                else
                {
                    myOrderListModel *orderModel =[[myOrderListModel alloc]initWithForOrderList:dict];
                    orderModel.createTime = [[dict objectForKey:@"create_time"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                    [_currentArray addObject:orderModel];
                }

                
            }
            
//            myOrderListTimeModel *mysubModel = [[myOrderListTimeModel alloc] initWithForOrderListTime:current];
            
            
            
            success(timeModelArray);
        }
        else
        {
            success(nil);
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
