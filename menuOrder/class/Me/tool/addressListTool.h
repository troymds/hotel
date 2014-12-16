//
//  addressListTool.h
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface addressListTool : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success uid_ID:(NSString *)uid_id failure:(StatusFailureBlock)failure;

+ (void)statusesWithSuccessDelete:(StatusSuccessBlock)success address_Id:(NSString *)address_id failure:(StatusFailureBlock)failure;

@end
