//
//  CarModel.h
//  menuOrder
//  购物车model
//  Created by promo on 14-12-24.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MenuModel;

@interface CarModel : NSObject
@property (nonatomic, strong) MenuModel *menu;
@property (nonatomic, strong) NSString *foodNum;//每份菜的数量
@end
