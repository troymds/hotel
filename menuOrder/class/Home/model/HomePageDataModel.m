//
//  HomePageDataModel.m
//  menuOrder
//
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "HomePageDataModel.h"

@implementation HomePageDataModel

- (instancetype) initWithDic:(NSDictionary *)dic
{
    if (self == [super init]) {
        self.adsImg =dic[@"ads"][@"image"];
        self.hotProductList = dic[@"hotProductList"];
    }
    return self;
}
@end
