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
        
        
        NSMutableArray *timeModelArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        if (![dict1 isKindOfClass:[NSNull class]])
        {
            for (NSString *time in dict1)
            {
                NSArray *current = [dict1 objectForKey:time];
                
                myOrderListTimeModel *mysubModel = [[myOrderListTimeModel alloc] initWithForOrderListTime:current];
                
                [timeModelArray addObject:mysubModel];
            }
            
            
            success(timeModelArray);
        }
        else
        {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
