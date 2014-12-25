//
//  uidTool.m
//  menuOrder
//
//  Created by YY on 14-12-24.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "uidTool.h"

@implementation uidTool
+ (void)statusesWithSuccessUid:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure{
    [HttpTool postWithPath:@"getId" params:nil success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        success(JSON);
    } failure:^(NSError *error) {
        
    }];
}
@end
