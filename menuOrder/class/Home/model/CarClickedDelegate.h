//
//  CarClickedDelegate.h
//  menuOrder
//
//  Created by promo on 14-12-25.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MenuModel;
@class ProductDetailModel;
@class FoodOrderCell;
typedef enum {
    kButtonAdd = 1,
    kButtonReduce
}ButtonType;

@protocol CarClickedDelegate <NSObject>
//传递菜品的ID和count
@optional
- (void)CarClickedWithData:(MenuModel *)data buttonType:(ButtonType )type;
- (void)FoodOrderCell:(FoodOrderCell *)cell;
//- (void)CarClickedWithDetailData:(ProductDetailModel *)data buttonType:(ButtonType )type;
@end
