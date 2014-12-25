//
//  ProductDetailModel.h
//  menuOrder
//
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductDetailModel : NSObject
@property (nonatomic, strong) NSString *price; //今天价格
@property (nonatomic, strong) NSString *oldPrice; //旧价格
@property (nonatomic, strong) NSString *name; //食品名称
@property (nonatomic, strong) NSString *star; //几颗星
@property (nonatomic, strong) NSString *cover; //美食图片
@property (nonatomic, strong) NSString *ID; //id
@property (nonatomic, strong) NSString *categoryId;//categoryId
@property (nonatomic, strong) NSString *Description; //description
@property (nonatomic, strong) NSString *isHot; //is_hot
@property (nonatomic, strong) NSString *isShow;//is_show
- (instancetype) initWithDic:(NSDictionary *)dic;
@end
