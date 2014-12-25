//
//  ProductDetailModel.m
//  menuOrder
//
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "ProductDetailModel.h"

@implementation ProductDetailModel
- (instancetype) initWithDic:(NSDictionary *)dic
{
    if (self == [super init]) {
        self.star =dic[@"star"];
        self.name =dic[@"name"];
        self.price =dic[@"new_price"];
        self.oldPrice =dic[@"old_price"];
        self.cover = dic[@"cover"];
        self.ID =dic[@"id"];
        self.categoryId =dic[@"category_id"];
        self.Description =dic[@"description"];
        self.isHot =dic[@"is_hot"];
        self.isShow = dic[@"is_show"];
    }
    return self;
}
@end
