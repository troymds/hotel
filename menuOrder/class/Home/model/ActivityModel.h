//
//  ActivityModel.h
//  menuOrder
//
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
@property (nonatomic, strong) NSString *cover; //今天价格
@property (nonatomic, strong) NSString *title; //旧价格
@property (nonatomic, strong) NSString *content; //食品名称
@property (nonatomic, strong) NSString *createTime; //几颗星
@property (nonatomic, strong) NSString *startDate; //美食图片
@property (nonatomic, strong) NSString *ID; //id
@property (nonatomic, strong) NSString *endDate; //几颗星
@property (nonatomic, strong) NSString *readNum; //美食图片
@property (nonatomic, strong) NSString *isDelete; //id
- (instancetype) initWithDic:(NSDictionary *)dic;
@end
