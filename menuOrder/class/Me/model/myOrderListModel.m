//
//  myOrderListModel.m
//  menuOrder
//
//  Created by YY on 14-12-18.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "myOrderListModel.h"

@implementation myOrderListModel
@synthesize cover,orderId,name,create_time;

-(instancetype)initWithForOrderList:(NSDictionary *)dict;
{
    if ([super self]) {
        self.cover =dict[@"cover"];
        self.create_time =dict[@"create_time"];
        self.name =dict[@"name"];
        self.orderId =dict[@"id"];

    }
    return self;
}
@end
@implementation myOrderListTimeModel
@synthesize time;
-(instancetype)initWithForOrderListTime:(NSDictionary *)dict{
    if ([super self]) {
        _timeArray =[[NSMutableArray alloc]init];
        self.time =dict[@"time"];
        for (NSDictionary *dict in self.time) {
            myOrderListModel *orderModel =[[myOrderListModel alloc]initWithForOrderList:dict];
            [_timeArray addObject:orderModel];
        }
        
    }
    return self;
}

//- (instancetype)initWithDictionaryForSubscribeList:(NSDictionary *)dict;
//{
//    if ([super self ])
//    {
//        _normalModelArray = [[NSMutableArray alloc] init];
//        _overdueModelArray = [[NSMutableArray alloc] init];
//        _allModelArray = [[NSMutableArray alloc] init];
//        
//        
//        self.normal =dict[@"normal"];
//        for (NSDictionary *dict in self.normal)
//        {
//            subscribeModel *subSModel = [[subscribeModel alloc] initWithDictionaryForSubscribe:dict];
//            [_normalModelArray addObject:subSModel];
//        }
//        
//        
//        
//        
//        self.overdue =dict[@"overdue"];
//        for (NSDictionary *dict in self.overdue)
//        {
//            subscribeModel *subSModel = [[subscribeModel alloc] initWithDictionaryForSubscribe:dict];
//            [_overdueModelArray addObject:subSModel];
//        }
//        
//        [_allModelArray addObject:_normalModelArray];
//        [_allModelArray addObject:_overdueModelArray];
//        
//        
//    }
//    return self;
//}

@end