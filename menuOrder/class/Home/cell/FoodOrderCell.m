//
//  FoodOrderCell.m
//  menuOrder
//  点餐车cell 
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "FoodOrderCell.h"

@implementation FoodOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HexRGB(0xe0e0e0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
@end
