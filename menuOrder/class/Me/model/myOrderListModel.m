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
    if ([super self])
    {
        self.cover =dict[@"cover"];
        self.create_time =dict[@"create_time"];
        self.name =dict[@"name"];
        self.orderId =dict[@"id"];

    }
    return self;
}
@end
@implementation myOrderListTimeModel

-(instancetype)initWithForOrderListTime:(NSArray *)array
{
    NSLog(@"array ---%@",array);
    
    if ([super self])
    {
        _timeArray =[[NSMutableArray alloc] initWithCapacity:0];
        _timeTitle = [[(NSDictionary*)[array objectAtIndex:0] objectForKey:@"create_time"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        
        for (NSDictionary *dict in array)
        {
            myOrderListModel *orderModel =[[myOrderListModel alloc]initWithForOrderList:dict];
            [_timeArray addObject:orderModel];
        }

    }
    return self;
}

@end