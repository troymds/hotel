//
//  FoodOrderCell.h
//  menuOrder
//
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//
@class MenuModel;

#import <UIKit/UIKit.h>
#import "CarClickedDelegate.h"

@interface FoodOrderCell : UITableViewCell
@property (nonatomic, strong) UIButton *selectedBtn;//选中按钮
@property (nonatomic, strong) UILabel *foodName; // 菜名
@property (nonatomic, strong) UILabel *price;//价格
@property (nonatomic, strong) UIButton *plusBtn;//减号按钮
@property (nonatomic, strong) UIButton *addBun;//加号按钮
@property (nonatomic, strong) UILabel *foodConnt;//数量
@property (nonatomic, strong) UILabel *dollarIcon;//美元
@property (nonatomic, strong) UILabel *yuan;//元
@property (nonatomic, strong) UIImageView *foodImg;//菜品图片
@property (nonatomic, strong) MenuModel *data;
@property (nonatomic, assign) int count;
@property (nonatomic, assign)NSInteger indexPath; //哪一个cell
@property (nonatomic, assign)BOOL isSelected; //是否被选中
@property (nonatomic, weak) id<CarClickedDelegate> delegate;
@end
