//
//  myOrderListModel.h
//  menuOrder
//
//  Created by YY on 14-12-18.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface myOrderListTimeModel : NSObject

@property(nonatomic,copy)NSString *timeTitle;
@property(nonatomic,copy)NSMutableArray *timeArray;

-(instancetype)initWithForOrderListTime:(NSArray *)array;

@end
@interface myOrderListModel : NSObject
@property(nonatomic,copy)NSString *cover;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *name;

-(instancetype)initWithForOrderList:(NSDictionary *)dict;

@end
