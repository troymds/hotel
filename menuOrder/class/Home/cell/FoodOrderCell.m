//
//  FoodOrderCell.m
//  menuOrder
//  点餐车cell 
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "FoodOrderCell.h"

#define KLeftX    5
#define KCellHeight  100

@implementation FoodOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HexRGB(0xe0e0e0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 1 白色背景
        UIView *whiteBackView = [[UIView alloc] init];
        whiteBackView.backgroundColor = [UIColor whiteColor];
        whiteBackView.layer.cornerRadius = 4;
        whiteBackView.frame = Rect(KLeftX, KLeftX, kWidth - KLeftX * 2, KCellHeight - KLeftX * 2);
        [self.contentView addSubview:whiteBackView];
        
        // 2 选中按钮
        UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [whiteBackView addSubview:selectedBtn];
        selectedBtn.frame = CGRectZero;
        [selectedBtn setBackgroundImage:LOADPNGIMAGE(@"home_notselected") forState:UIControlStateNormal];
        [selectedBtn setBackgroundImage:LOADPNGIMAGE(@"selected") forState:UIControlStateSelected];
        _selectedBtn = selectedBtn;
        
        // 3 菜品图片
        UIImageView *foodImg = [[UIImageView alloc] init];
        foodImg.frame = CGRectZero;
        [whiteBackView addSubview:foodImg];
        foodImg.image = LOADPNGIMAGE(@"home_banner");
        foodImg.layer.masksToBounds = YES;
        foodImg.layer.cornerRadius = 4;
        
        //4 菜名
        UILabel *foodName = [[UILabel alloc] init];
        foodName.frame = CGRectZero;
        foodName.font = [UIFont systemFontOfSize:PxFont(20)];
        foodName.textColor = HexRGB(0x605e5f);
        foodName.backgroundColor = [UIColor clearColor];
        foodName.text = @"麻婆豆腐";
        [whiteBackView addSubview:foodName];
        _foodName = foodName;
        
        //5 美国money的图标
        UIImageView *dollarIcon = [[UIImageView alloc] init];
        [whiteBackView addSubview:dollarIcon];
        _dollarIcon = dollarIcon;
        _dollarIcon.image = LOADPNGIMAGE(@"star");
        
        //6 价格
        UILabel *price =  [[UILabel alloc] init];
        price.frame = CGRectZero;
        price.font = [UIFont systemFontOfSize:PxFont(18)];
        price.textColor = HexRGB(0x605e5f);
        price.backgroundColor = [UIColor clearColor];
        price.text = @"299/例";
        [whiteBackView addSubview:price];
        _price = price;
        
        //7 减号按钮
        UIButton * plusbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        plusbtn.frame = CGRectZero;
        [whiteBackView addSubview:plusbtn];
        [plusbtn setBackgroundImage:LOADPNGIMAGE(@"reduce") forState:UIControlStateNormal];
        plusbtn.backgroundColor = [UIColor clearColor];
        _plusBtn = plusbtn;
        
        //8 数量
        UILabel *count =  [[UILabel alloc] init];
        count.frame = CGRectZero;
        count.font = [UIFont systemFontOfSize:PxFont(20)];
        count.textColor = HexRGB(0x3b7800);
        count.backgroundColor = [UIColor clearColor];
        count.text = @"12";
        [whiteBackView addSubview:count];
        _foodConnt = count;
        
        //9 加号按钮
        UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addbtn.frame = CGRectZero;
        [whiteBackView addSubview:addbtn];
        addbtn.backgroundColor = [UIColor clearColor];
        [addbtn setBackgroundImage:LOADPNGIMAGE(@"plus") forState:UIControlStateNormal];
        _addBun = addbtn;

    }
    return self;
}

-(void)setData:(MenuModel *)data
{
    _data = data;
    // 2 选中按钮
    CGFloat chosenX = KLeftX * 2;
    
}
@end
