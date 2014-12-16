//
//  UserItem.m
//  XinNet
//
//  Created by tianj on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "UserItem.h"

@implementation UserItem

- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        if (![dic[@"avatar"] isKindOfClass:[NSNull class]]) {
            self.avatar = dic[@"avatar"];
        }else{
            self.avatar = @"";
        }
        if (![dic[@"email"] isKindOfClass:[NSNull class]]) {
            self.email = dic[@"email"];
        }else{
            self.email = @"";
        }
        if (![dic[@"id"] isKindOfClass:[NSNull class]]) {
            self.uid = [NSString stringWithFormat:@"%d",[dic[@"id"] intValue]];
        }else{
            self.uid = @"-1";
        }
        if (![dic[@"mobile"] isKindOfClass:[NSNull class]]) {
            self.mobile = dic[@"mobile"];
        }else{
            self.mobile = @"";
        }
        if (![dic[@"username"] isKindOfClass:[NSNull class]]) {
            self.user_name = dic[@"username"];
        }else{
            self.user_name = @"";
        }
    }
    return self;
}




- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.uid forKey:@"uid"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
    }
    return self;
}


@end
