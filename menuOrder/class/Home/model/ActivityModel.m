//
//  ActivityModel.m
//  menuOrder
//
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

- (instancetype) initWithDic:(NSDictionary *)dic
{
    if (self == [super init]) {
        self.isDelete =dic[@"is_delete"];
        self.title =dic[@"title"];
        self.content =dic[@"content"];
        self.createTime =dic[@"create_time"];
        self.cover = dic[@"cover"];
        self.ID =dic[@"id"];
        self.endDate =dic[@"end_date"];
        self.readNum = dic[@"read_num"];
        self.startDate =dic[@"start_date"];
    }
    return self;
}
@end
