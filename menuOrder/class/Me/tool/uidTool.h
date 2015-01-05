//
//  uidTool.h
//  menuOrder
//
//  Created by YY on 14-12-24.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSString *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface uidTool : NSObject

+ (void)statusesWithSuccessUid:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure;
@end
