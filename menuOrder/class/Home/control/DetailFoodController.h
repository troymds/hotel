//
//  DetailFoodController.h
//  menuOrder
//
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductDetailModel;

@interface DetailFoodController : UIViewController
@property (nonatomic, strong) ProductDetailModel *data;
@property(nonatomic,copy)NSString *detailFoodIndex;
@end
