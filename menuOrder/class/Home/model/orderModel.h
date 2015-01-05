//
//  orderModel.h
//  menuOrder
//
//  Created by promo on 15-1-4.
//  Copyright (c) 2015年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderModel : NSObject
@property (nonatomic, strong) NSString *address_id; //今天价格
@property (nonatomic, strong) NSString *address_content; //旧价格
@property (nonatomic, strong) NSString *contact; //食品名称
@property (nonatomic, strong) NSString *tel; //几颗星
@property (nonatomic, strong) NSString *type; //美食图片
@property (nonatomic, strong) NSString *use_time; //id
@property (nonatomic, strong) NSString *people_num; //几颗星
@property (nonatomic, strong) NSString *remark; //美食图片
@property (nonatomic, strong) NSString *price; //id
@property (nonatomic, strong) NSString *products; //id
@end
