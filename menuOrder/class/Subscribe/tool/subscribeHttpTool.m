//
//  subscribeHttpTool.m
//  menuOrder
//
//  Created by promo on 14-12-25.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "subscribeHttpTool.h"

@implementation subscribeHttpTool

+ (void) postOrderWithSuccess:(successBlock)success uid:(NSString *) uid addressID:(NSString *)addressID addressContent:(NSString *)addressContent contact:(NSString *)contact tel:(NSString *)tel type:(NSString *)type usetime:(NSString *)useTime peopleNum:(NSString *)peopleNum remark:(NSString *)remark price:(NSString *)price products:(NSString *)products withFailure:(failureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",addressID,@"address_id",addressContent,@"address_content",contact,@"contact",tel,@"tel",type,@"type",useTime,@"use_time",peopleNum,@"people_num",remark,@"remark",price,@"price",products,@"products", nil];
    
    [HttpTool postWithPath:@"getProductList" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = nil;
    
        success(statuses, code,message);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];

}

@end
