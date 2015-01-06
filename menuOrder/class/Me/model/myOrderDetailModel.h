//
//  myOrderDetailModel.h
//  menuOrder
//
//  Created by YY on 14-12-18.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myOrderDetailModel : NSObject
@property(nonatomic,copy)NSString *orderDetailId;

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *address_id;
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *people_num;
@property(nonatomic,copy)NSString *price;

@property(nonatomic,copy)NSArray *products;
@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *use_time;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *category_id;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *uid;

@end
