//
//  MenuCategory.m
//  menuOrder
//
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MenuCategory.h"

@implementation MenuCategory

- (instancetype) initWithDic:(NSDictionary *)dic
{
    if (self == [super init]) {
        self.name =dic[@"name"];
        self.ID =dic[@"id"];
    }
    return self;
}

@end

