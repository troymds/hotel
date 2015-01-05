//
//  uidTool.m
//  menuOrder
//
//  Created by YY on 14-12-24.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "uidTool.h"
#import "SystemConfig.h"
@implementation uidTool
+ (void)statusesWithSuccessUid:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure{
    [HttpTool postWithPath:@"getId" params:nil success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSString * data = dict[@"response"][@"data"];
        success(data);
    } failure:^(NSError *error) {
        
    }];
}
@end
