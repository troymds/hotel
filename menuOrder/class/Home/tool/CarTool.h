//
//  CarTool.h
//  menuOrder
//  购物车工具,存放数据
//  Created by promo on 14-12-24.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@class MenuModel,CarModel;
@interface CarTool : NSObject
singleton_interface(CarTool)
@property (nonatomic, strong) NSMutableArray *totalCarMenu; // 所有的购物车里的数据

-(void)addMenu:(MenuModel *) menu;
-(void)plusMenu:(MenuModel *) menu;
@end
