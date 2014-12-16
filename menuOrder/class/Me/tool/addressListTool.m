
//
//  addressListTool.m
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "addressListTool.h"
#import "addressListModel.h"
@implementation addressListTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success uid_ID:(NSString *)uid_id failure:(StatusFailureBlock)failure{
     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uid_id,@"uid" ,nil];
    [HttpTool postWithPath:@"getAddressList" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[dict[@"response"]objectForKey:@"data"];
        if (array) {
            if ([array isKindOfClass:[NSNull class]])
            {
            }else{
                
                for (NSDictionary *diction in array) {
                    addressListModel *s =[[addressListModel alloc] initWithDictionaryForAddress:diction];
                    [statuses addObject:s];
                }
            }
        }
        success(statuses);
       
    } failure:^(NSError *error) {
        
    }];
}

+ (void)statusesWithSuccessDelete:(StatusSuccessBlock)success address_Id:(NSString *)address_id failure:(StatusFailureBlock)failure{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:address_id,@"uid" ,nil];
    [HttpTool postWithPath:@"deleteAddress" params:dic success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =dict[@"response"];
        if (![array isKindOfClass:[NSNull class]]) {
            [statuses addObject:[array objectForKey:@"data"]];
        }
        else{
            
        }
        success(statuses);
    } failure:^(NSError *error) {
        
    }];

    
}

@end
