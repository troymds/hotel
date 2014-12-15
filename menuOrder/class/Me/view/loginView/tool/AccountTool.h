//
//  AccountTool.h
//  新浪微博
//
//  Created by apple on 13-10-30.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  管理账号信息

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "Account.h"

@interface AccountTool : NSObject

single_interface(AccountTool)

- (void)saveAccount:(Account *)account;

// 获得当前账号
@property (nonatomic, readonly) Account *account;
@end