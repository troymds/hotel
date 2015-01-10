//
//  subscribeModel.m
//  menuOrder
//
//  Created by YY on 14-12-17.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "subscribeModel.h"

@implementation subscribeModel
@synthesize cover,type,use_time,people_num,subscribeID ;
- (instancetype)initWithDictionaryForSubscribe:(NSDictionary *)dict;
{
    if ([super self ])
    {
        self.cover =dict[@"cover"];
        self.type =dict[@"type"];
        self.subscribeID =dict[@"id"];
        self.use_time =[dict[@"use_time"]stringByReplacingOccurrencesOfString:@"-" withString:@"."];

        self.people_num =dict[@"people_num"];
    }
    return self;
}

@end
