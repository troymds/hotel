//
//  subscribeModel.h
//  menuOrder
//
//  Created by YY on 14-12-17.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface subscribeModel : NSObject
@property(nonatomic,copy)NSString *cover;//图片
@property(nonatomic,copy)NSString *subscribeID;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *use_time;
@property(nonatomic,copy)NSString *people_num;
- (instancetype)initWithDictionaryForSubscribe:(NSDictionary *)dict;
@end
