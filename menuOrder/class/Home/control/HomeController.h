//
//  HomeController.h
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kHotrecommended = 1, //热门推荐
    KLatestPrice = 2,   //最新优惠
    KMenu = 3,          //飘香菜单
    KView = 4           //渔府风采
} menuStyle;

@interface HomeController : UIViewController

@end
