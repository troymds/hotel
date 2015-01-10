//
//  MenuModel.m
//  menuOrder
//  飘香菜单cell model
//  Created by promo on 14-12-12.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

- (instancetype) initWithDic:(NSDictionary *)dic
{
    if (self == [super init]) {
        self.star =dic[@"star"];
        self.name =dic[@"name"];
        self.price =dic[@"new_price"];
        self.oldPrice =dic[@"old_price"];
        self.cover = dic[@"cover"];
        self.ID =dic[@"id"];
        self.isChosen = YES;
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_star forKey:@"_star"];
    [encoder encodeObject:_name forKey:@"_name"];
    [encoder encodeObject:_price forKey:@"_price"];
    [encoder encodeObject:_oldPrice forKey:@"_oldPrice"];
    [encoder encodeObject:_cover forKey:@"_cover"];
    [encoder encodeObject:_ID forKey:@"_ID"];
    [encoder encodeInt:_foodCount forKey:@"_foodCount"];
    [encoder encodeBool:_isChosen forKey:@"_isChosen"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.star = [decoder decodeObjectForKey:@"_star"];
        self.name = [decoder decodeObjectForKey:@"_name"];
        self.price = [decoder decodeObjectForKey:@"_price"];
        self.oldPrice = [decoder decodeObjectForKey:@"_oldPrice"];
        self.cover = [decoder decodeObjectForKey:@"_cover"];
        self.ID = [decoder decodeObjectForKey:@"_ID"];
        self.foodCount = [decoder decodeIntForKey:@"_foodCount"];
        self.isChosen = [decoder decodeBoolForKey:@"_isChosen"];
    }
    return self;
}

@end