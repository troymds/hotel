//
//  MenuItem.h
//  menuOrder
//
//  Created by promo on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuItem;

@protocol MenuItemDelegate <NSObject>

@optional
- (void) menuItemClieked:(MenuItem *)item;

@end

@interface MenuItem : UIView
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, assign) BOOL isSelected; //是否被选中
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, weak) id<MenuItemDelegate> delegate;
@property (nonatomic, strong) UIView *back;
@end
