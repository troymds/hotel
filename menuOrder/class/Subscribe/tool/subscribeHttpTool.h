//
//  subscribeHttpTool.h
//  menuOrder
//
//  Created by promo on 14-12-25.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(NSArray *data, int code, NSString * msg);
typedef void(^failureBlock)(NSError *error);

@interface subscribeHttpTool : NSObject

// 提交订单（预约）
+ (void) postOrderWithSuccess:(successBlock)success uid:(NSString *) uid addressID:(NSString *)addressID addressContent:(NSString *)addressContent contact:(NSString *)contact tel:(NSString *)tel type:(NSString *)type usetime:(NSString *)useTime peopleNum:(NSString *)peopleNum remark:(NSString *)remark price:(NSString *)price products:(NSString *)products withFailure:(failureBlock)failure;

@end
