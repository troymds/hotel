//
//  suggestTool.m
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "suggestTool.h"

@implementation suggestTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success uid_ID:(NSString *)uid_id contentStr:(NSString *)content failure:(StatusFailureBlock)failure{
   
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uid_id,@"uid" ,nil];
    [HttpTool postWithPath:@"addSuggest" params:dic success:^(id JSON) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
      
    } failure:^(NSError *error) {
        
    }];

}
@end
