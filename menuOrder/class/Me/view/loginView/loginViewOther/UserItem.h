//
//  UserItem.h
//  XinNet
//
//  Created by tianj on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserItem : NSObject<NSCoding>

@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,copy) NSString *uid;

- (id)initWithDic:(NSDictionary *)dic;

@end
