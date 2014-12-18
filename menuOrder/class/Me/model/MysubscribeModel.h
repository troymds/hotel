//
//  MysubscribeModel.h
//  menuOrder
//
//  Created by YY on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MysubscribeModel : NSObject

@property(nonatomic,copy)NSArray *normal;//未到期
@property(nonatomic,copy)NSArray *overdue;//已过期

@property (nonatomic,copy)NSMutableArray     *normalModelArray;
@property (nonatomic,copy)NSMutableArray     *overdueModelArray;

@property (nonatomic,copy)NSMutableArray     *allModelArray;



- (instancetype)initWithDictionaryForSubscribeList:(NSDictionary *)dict;


@end
