//
//  mapTool.m
//  menuOrder
//
//  Created by YY on 14-12-22.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "mapTool.h"

@implementation mapTool
+ (void)mapStatusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure{
    [HttpTool postWithPath:@"getMapPosition" params:nil success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        
        success(JSON);
        
    } failure:^(NSError *error) {
        
    }];

}

@end
