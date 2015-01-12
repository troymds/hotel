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
//@implementation myOrderListTimeModel
//
//-(instancetype)initWithForOrderListTime:(NSArray *)array
//{
//    if ([super self])
//    {
//        
//        for (NSDictionary *dict in array)
//        {
//            
//            if (![_timeTitle isEqualToString:[dict objectForKey:@"create_time"]])
//            {
//                _timeArray =[[NSMutableArray alloc] initWithCapacity:0];
//                NSMutableArray *currentArr =[[NSMutableArray alloc] initWithCapacity:0];
//                myOrderListModel *orderModel =[[myOrderListModel alloc]initWithForOrderList:dict];
//                [currentArr addObject:orderModel];
//                [_timeArray addObject:currentArr];
//                
//                _timeTitle = [[dict objectForKey:@"create_time"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//                _currentArray = currentArr;
//            }
//            else
//            {
//                myOrderListModel *orderModel =[[myOrderListModel alloc]initWithForOrderList:dict];
//                [_currentArray addObject:orderModel];
//            }
//            
//            
//            
//        }
//        
//        
//        
//
//    }
//    return self;
//}
//
//@end