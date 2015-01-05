//
//  CarOrderToolBar.h
//  menuOrder
//
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NiceFoodModel;

@interface CarOrderToolBar : UIView
@property (nonatomic, strong) UILabel * money; //总价
@property (nonatomic, strong) UILabel *numOfFood;//合计多少份
@property (nonatomic, strong) UIButton *allSelectedBtn;//全选按钮
@property (nonatomic, strong) UIButton *nextBtn;//下一步
@property (nonatomic, strong) UILabel *allname;//全选
@property (nonatomic, strong) UILabel *dollar;
@property (nonatomic, strong) NiceFoodModel *data;
@end
