//
//  MenuModel.h
//  menuOrder
//
//  Created by promo on 14-12-12.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property (nonatomic, strong) UIImageView *foodImg;//美食图片
@property (nonatomic, strong) NSString *price; //价格
@property (nonatomic, strong) NSString *foodName; //食品名称
@property (nonatomic, strong) NSString *starCount; //几颗星
@property (nonatomic, strong) NSString *count; //菜的数量

- (void) initWithDic:(NSDictionary *)dic;
@end
