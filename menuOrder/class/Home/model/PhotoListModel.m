//
//  PhotoListModel.m
//  menuOrder
//  图片列表
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "PhotoListModel.h"

@implementation PhotoListModel

- (instancetype) initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.img = dic[@""];
    }
    return self;
}
@end
