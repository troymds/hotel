//
//  aboutTool.m
//  menuOrder
//
//  Created by YY on 14-12-17.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "aboutTool.h"

@implementation aboutTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success  failure:(StatusFailureBlock)failure{
    [HttpTool postWithPath:@"getBaseInfo" params:nil success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =dict[@"response"];
        NSLog(@"%@",array);
        if (![array isKindOfClass:[NSNull class]]) {
            [statuses addObject:[array objectForKey:@"data"]];
        }
        else{
            
        }
        success(statuses);
        
    } failure:^(NSError *error) {
    } ];
}

@end
