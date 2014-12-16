//
//  FoodOrderCell.h
//  menuOrder
//
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//
@class MenuModel;

#import <UIKit/UIKit.h>

@interface FoodOrderCell : UITableViewCell
@property (nonatomic, strong) UIButton *selectedBtn;//选中按钮
@property (nonatomic, strong) UILabel *foodName; // 菜名
@property (nonatomic, strong) UILabel *price;//价格
@property (nonatomic, strong) UIButton *plusBtn;//减号按钮
@property (nonatomic, strong) UIButton *addBun;//加号按钮
@property (nonatomic, strong) UILabel *foodConnt;//数量
@property (nonatomic, strong) UIImageView *dollarIcon;//美元

@property (nonatomic, strong) MenuModel *data;

@end
