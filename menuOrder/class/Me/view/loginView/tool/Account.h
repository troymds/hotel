//
//  Account.h
//  新浪微博
//
//  Created by apple on 13-10-30.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *uid;
@end