//
//  PromotionCell.h
//  menuOrder
//
//  Created by promo on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//
@class ActivityModel;

#import <UIKit/UIKit.h>

@interface PromotionCell : UITableViewCell
@property (nonatomic, strong) ActivityModel *data;
@property (nonatomic, strong) UIImageView *foodImg;//菜图像
@property (nonatomic, strong) UILabel *title; //标题
@property (nonatomic, strong) UILabel *detail;//细节
@end
