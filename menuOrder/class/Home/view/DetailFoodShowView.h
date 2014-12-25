//
//  DetailFoodShowView.h
//  menuOrder
//
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarClickedDelegate.h"

@class ProductDetailModel;
@class DetailFoodShowView;


@protocol  DetailFoodShowViewDelegate <NSObject>

@optional
- (void)detailFoodViewHeight:(CGFloat)height;//计算得到view的高度

@end

@interface DetailFoodShowView : UIView

@property (nonatomic, strong) UIImageView *foodImg;//菜图像
@property (nonatomic, strong) UILabel *foodName; //菜名
@property (nonatomic, strong) UILabel *price;//价格
@property (nonatomic, strong) UIButton *plusBtn;//减号按钮
@property (nonatomic, strong) UIButton *addBun;//加号按钮
@property (nonatomic, strong) UIImageView *starImg;//星星
@property (nonatomic, strong) UILabel *foodConnt;//数量
@property (nonatomic, strong) UILabel *comment;//品论
@property (nonatomic, strong) UILabel *todayPrice;//品论
@property (nonatomic, assign) int count;
@property (nonatomic, strong) ProductDetailModel *data;
@property (nonatomic, weak) id<DetailFoodShowViewDelegate> delegate;
@property (nonatomic, weak)id<CarClickedDelegate> cardelegate;
@end
