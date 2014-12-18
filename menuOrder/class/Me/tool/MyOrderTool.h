//
//  MyOrderTool.h
//  menuOrder
//
//  Created by YY on 14-12-17.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface MyOrderTool : NSObject

+ (void)myOrderUid:(NSString *)uid statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure;

@end
