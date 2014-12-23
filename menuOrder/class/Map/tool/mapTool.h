//
//  mapTool.h
//  menuOrder
//
//  Created by YY on 14-12-22.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface mapTool : NSObject

+ (void)mapStatusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure;

@end
