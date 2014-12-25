//
//  NiceFoodModel.m
//  menuOrder
//
//  Created by promo on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "NiceFoodModel.h"

@implementation NiceFoodModel

- (instancetype) initWithDic:(NSDictionary *)dic
{
    if (self == [super init]) {
        self.star =dic[@"star"];
        self.name =dic[@"name"];
        self.price =dic[@"new_price"];
        self.oldPrice =dic[@"old_price"];
        self.cover = dic[@"cover"];
        self.ID =dic[@"id"];
    }
    return self;
}
@end
