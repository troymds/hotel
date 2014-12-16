//
//  MenuCell.m
//  menuOrder
//  飘香菜单cell
//  Created by promo on 14-12-12.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MenuCell.h"

#define KBigImgStartX   8
#define KBigImgStartY  10
#define KBigImgW       75
#define KBigImgH       75
#define KSpaceBetweenBigImgAndFoodName  5
#define KFoodNameStartY (KBigImgStartY + 2)
#define KFoodNameStartX (KBigImgStartX + KBigImgW + KSpaceBetweenBigImgAndFoodName)
#define KFooNameW   120
#define KFontBigH     25
#define KFontSmallH   20
#define KStarH       20
#define KPriceW      80
#define KBUttonW     27
#define KDefaultSpace   30

@implementation MenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //1 美食图片
        UIImageView *foodimg = [[UIImageView alloc] init];
        foodimg.frame = CGRectZero;
        [self.contentView addSubview:foodimg];
        foodimg.image = LOADPNGIMAGE(@"home_banner");
//        foodimg.contentMode = UIViewContentModeScaleAspectFit;
        _foodImg = foodimg;

        //2 菜名
        UILabel *foodName = [[UILabel alloc] init];
        foodName.frame = CGRectZero;
        foodName.font = [UIFont systemFontOfSize:PxFont(20)];
        foodName.textColor = HexRGB(0x605e5f);
        foodName.backgroundColor = [UIColor clearColor];
        foodName.text = @"麻婆豆腐";
        [self.contentView addSubview:foodName];
        _foodName = foodName;
        
        //3 星级评价
        UIImageView *starImg = [[UIImageView alloc] init];
        starImg.frame = CGRectZero;
        [self.contentView addSubview:starImg];
        starImg.image = LOADPNGIMAGE(@"star");
        _starImg = starImg;
        
        //4 美国money的图标
        UIImageView *dollarIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:dollarIcon];
        _dollarIcon = dollarIcon;
        _dollarIcon.image = LOADPNGIMAGE(@"star");
        
        //5 价格
        UILabel *price =  [[UILabel alloc] init];
        price.frame = CGRectZero;
        price.font = [UIFont systemFontOfSize:PxFont(18)];
        price.textColor = HexRGB(0x605e5f);
        price.backgroundColor = [UIColor clearColor];
        price.text = @"299/例";
        [self.contentView addSubview:price];
        _price = price;
        
        //6 减号按钮
        UIButton * plusbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        plusbtn.frame = CGRectZero;
        [self.contentView addSubview:plusbtn];
        [plusbtn setBackgroundImage:LOADPNGIMAGE(@"reduce") forState:UIControlStateNormal];
        plusbtn.backgroundColor = [UIColor clearColor];
        _plusBtn = plusbtn;
        
        //7 数量
        UILabel *count =  [[UILabel alloc] init];
        count.frame = CGRectZero;
        count.font = [UIFont systemFontOfSize:PxFont(20)];
        count.textColor = HexRGB(0x3b7800);
        count.backgroundColor = [UIColor clearColor];
        count.text = @"12";
        [self.contentView addSubview:count];
        _foodConnt = count;
        
        //8 加号按钮
        UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addbtn.frame = CGRectZero;
        [self.contentView addSubview:addbtn];
        addbtn.backgroundColor = [UIColor clearColor];
        [addbtn setBackgroundImage:LOADPNGIMAGE(@"plus") forState:UIControlStateNormal];
        _addBun = addbtn;
        
        //9 线条
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectZero;
        line.backgroundColor = HexRGB(0xd5d5d5);
        [self.contentView addSubview:line];
        line.frame = Rect(KBigImgStartX, 95 - 1, 222, 1);
        _line = line;
        
        _hasStar = YES;
        
    }
    return  self;
}

#pragma mark 刷新数据和UI
- (void)setData:(MenuModel *)data
{
    //1 美食图片
    _foodImg.frame = Rect(KBigImgStartX, KBigImgStartY, KBigImgW, KBigImgH);
    
    //2 菜名
    _foodName.frame = Rect(KFoodNameStartX, KFoodNameStartY, KFooNameW, KFontBigH);
    
    //判断是否有星级别
    //3 星级评价
    CGFloat starY;
    CGFloat dollarY;
    
    if (_hasStar) {
        starY = CGRectGetMaxY(_foodName.frame);
        _starImg.frame = Rect(KFoodNameStartX, starY, KStarH, KStarH);
        _starImg.hidden = NO;
        
        dollarY = CGRectGetMaxY(_starImg.frame);
    }else
    {
        _starImg.hidden = YES;
        dollarY = CGRectGetMaxY(_foodName.frame);
    }

    //4 美国money的图标
    _dollarIcon.frame = Rect(KFoodNameStartX, dollarY + KSpaceBetweenBigImgAndFoodName, KStarH, KStarH);
    
    //5 价格
    _price.frame = Rect(CGRectGetMaxX(_dollarIcon.frame) + 2, _dollarIcon.frame.origin.y, KPriceW, KFontSmallH);
    
    //6 减号按钮
    CGFloat buttonY = CGRectGetMaxY(_foodName.frame) + KStarH;
    CGFloat buttonX = CGRectGetMaxX(_price.frame) - KDefaultSpace;
    _plusBtn.frame = Rect(buttonX, buttonY, KBUttonW, KBUttonW);
    
    //7 数量
    _foodConnt.frame = Rect(CGRectGetMaxX(_plusBtn.frame), buttonY, 18, KBUttonW);
    
    //8 加号按钮
    _addBun.frame = Rect(CGRectGetMaxX(_foodConnt.frame), buttonY, KBUttonW, KBUttonW);
    
    //9 线条
//    CGFloat lineW = CGRectGetMaxX(_addBun.frame) - 10 ;
//    CGFloat lineY = CGRectGetMaxY(_foodImg.frame) + KBigImgStartY;
//    _line.frame = Rect(KBigImgStartX, lineY - 1, lineW, 1);
    
}

- (void)setIndexPath:(NSInteger)indexPath
{
    _indexPath = indexPath;
    _addBun.tag = indexPath;
    _plusBtn.tag = indexPath;
}
@end
