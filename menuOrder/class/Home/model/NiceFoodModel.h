//
//  NiceFoodModel.h
//  menuOrder
//
//  Created by promo on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NiceFoodModel : NSObject

@property (nonatomic, strong) UIImageView *foodImg;//美食图片
@property (nonatomic, strong) NSString *price; //价格
@property (nonatomic, strong) NSString *foodName; //食品名称
@property (nonatomic, strong) NSString *starCount; //几颗星

- (void) initWithDic:(NSDictionary *)dic;
@end
