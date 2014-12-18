//
//  MysubscribeModel.m
//  menuOrder
//
//  Created by YY on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MysubscribeModel.h"
#import "subscribeModel.h"


@implementation MysubscribeModel
@synthesize normal,overdue;

- (instancetype)initWithDictionaryForSubscribeList:(NSDictionary *)dict;
{
    if ([super self ])
    {
        _normalModelArray = [[NSMutableArray alloc] init];
        _overdueModelArray = [[NSMutableArray alloc] init];
        _allModelArray = [[NSMutableArray alloc] init];
        

        self.normal =dict[@"normal"];
        for (NSDictionary *dict in self.normal)
        {
            subscribeModel *subSModel = [[subscribeModel alloc] initWithDictionaryForSubscribe:dict];
            [_normalModelArray addObject:subSModel];
        }
        
        
        
        
        self.overdue =dict[@"overdue"];
        for (NSDictionary *dict in self.overdue)
        {
            subscribeModel *subSModel = [[subscribeModel alloc] initWithDictionaryForSubscribe:dict];
            [_overdueModelArray addObject:subSModel];
        }
        
        [_allModelArray addObject:_normalModelArray];
        [_allModelArray addObject:_overdueModelArray];
        
        
    }
    return self;
}
@end
