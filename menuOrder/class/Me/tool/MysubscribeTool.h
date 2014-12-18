//
//  MysubscribeTool.h
//  menuOrder
//
//  Created by YY on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSMutableArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface MysubscribeTool : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success orderListUid_ID:(NSString *)uid_id failure:(StatusFailureBlock)failure;
+ (void)getOrderDetailId:(NSString *)order_id statusesWithSuccess:(StatusSuccessBlock)success  failure:(StatusFailureBlock)failure;

@end
