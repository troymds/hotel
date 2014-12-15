//
//  SinaTool.m
//  menuOrder
//
//  Created by YY on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "SinaTool.h"

#import "AFNetworking.h"
#import "AccountTool.h"
@implementation SinaTool
+ (void)requestWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure method:(NSString *)method
{
    // 1.创建post请求
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"https://api.weibo.com"]];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    // 拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
    }
    
    // 拼接token参数
    NSString *token = [AccountTool sharedAccountTool].account.accessToken;
    if (token) {
        [allParams setObject:token forKey:@"access_token"];
    }
    
    NSURLRequest *post = [client requestWithMethod:method path:path parameters:allParams];
    
    // 2.创建AFJSONRequestOperation对象
    NSOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:post
          success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
              if (success == nil) return;
              success(JSON);
          }
         failure : ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
             if (failure == nil) return;
             failure(error);
         }];
    
    // 3.发送请求
    [op start];
    
    
    
}

+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [self requestWithPath:path params:params success:success failure:failure method:@"POST"];
}

@end
