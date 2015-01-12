//
//  foodRecommendCell.h
//  menuOrder
//
//  Created by promo on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//
@class MenuModel;

#import <UIKit/UIKit.h>
#import "CarClickedDelegate.h"

@interface foodRecommendCell : UITableViewCell
@property (nonatomic, strong) MenuModel *data;
@property (nonatomic, strong) UIImageView *foodImg;//菜图像
@property (nonatomic, strong) UILabel *foodName; //菜名
@property (nonatomic, strong) UILabel *price;//价格
@property (nonatomic, strong) UIButton *plusBtn;//减号按钮
@property (nonatomic, strong) UIButton *addBun;//加号按钮
@property (nonatomic, strong) UIImageView *starImg;//星星
@property (nonatomic, strong) UILabel *foodConnt;//数量
@property (nonatomic, strong) UIImageView *dollarIcon;//星星
@property (nonatomic, strong) UIView *line;//星星
@property (nonatomic, strong) UILabel *todayPrice;
@property (nonatomic, strong) UILabel *yuan;
@property (nonatomic, assign) BOOL hasStar;
@property (nonatomic, assign) int count;
@property (nonatomic, weak)id<CarClickedDelegate> delegate;
@property (nonatomic, assign)NSInteger indexPath; //哪一个cell
@end
