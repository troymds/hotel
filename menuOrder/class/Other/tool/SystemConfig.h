//
//  SystemConfig.h
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemConfig : NSObject

@property (nonatomic,copy) NSString *uuidStr;        //设备uuid
@property (nonatomic,assign) BOOL isUserLogin;       //是否登录
@property (nonatomic,assign) NSString * uid;       //用户uid
@property (nonatomic, assign) int menuType;         //1 亲临鱼府 ，2 外带取餐 3 外卖服务

+ (SystemConfig *)sharedInstance;

@end
