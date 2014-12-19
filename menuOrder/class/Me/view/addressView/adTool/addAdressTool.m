//
//  addAdressTool.m
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "addAdressTool.h"

@implementation addAdressTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success uid_ID:(NSString *)uid_id ContentStr:(NSString *)content TelStr:(NSString *)tel ContactStr:(NSString *)contact failure:(StatusFailureBlock)failure{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uid_id,@"uid",content,@"content",tel,@"tel",contact,@"contact",nil];
    [HttpTool postWithPath:@"addAddress" params:dic success:^(id JSON) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        
        success(statuses);
    } failure:^(NSError *error) {
        
        failure(error);
    }];

}
+ (void)updateAddressID:(NSString *)id_id ContentStr:(NSString *)content TelStr:(NSString *)tel ContactStr:(NSString *)contact   statusesWithSuccess:(StatusSuccessBlock)success  failure:(StatusFailureBlock)failure{
    NSLog(@"%@---%@---%@",contact,content,tel);
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:id_id,@"id",content,@"content",tel,@"tel",contact,@"contact",nil];
    [HttpTool postWithPath:@"updateAddress" params:dic success:^(id JSON) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        
        success(statuses);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
    


}
@end
