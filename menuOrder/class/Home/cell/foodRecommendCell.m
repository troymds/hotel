//
//  foodRecommendCell.m
//  menuOrder
//  菜品推荐cell
//  Created by promo on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "foodRecommendCell.h"

#define KLeftX    5
#define KCellHeight  334
#define KbackViewH   (KCellHeight - KLeftX * 2)
#define KBackViewW   (kWidth - KLeftX * 2)
#define KImgW  105
#define KImgH   (KbackViewH - KLeftX * 2)
#define KChosenBtnW 20
#define KAddBtnW    30
#define KStartX 3
#define KFooNameW   100
#define KFooNameH   30
#define KStarH       20
#define KPriceH     25
#define KAddbtnW    30
#define KImgWHRace   1.25

@implementation foodRecommendCell

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
        whiteBackView.frame = Rect(KLeftX, KLeftX, KBackViewW, KbackViewH);
        [self.contentView addSubview:whiteBackView];
        
        //1 美食图片
        UIImageView *foodimg = [[UIImageView alloc] init];
        foodimg.frame = CGRectZero;
        [whiteBackView addSubview:foodimg];
        foodimg.image = LOADPNGIMAGE(@"home_banner");
        foodimg.layer.masksToBounds = YES;
        foodimg.layer.cornerRadius = 4;
        //foodimg.contentMode = UIViewContentModeScaleAspectFit;
        _foodImg = foodimg;
        
        //2 菜名
        UILabel *foodName = [[UILabel alloc] init];
        foodName.frame = CGRectZero;
        foodName.font = [UIFont systemFontOfSize:PxFont(20)];
        foodName.textColor = HexRGB(0x605e5f);
        foodName.backgroundColor = [UIColor clearColor];
        foodName.text = @"麻婆豆腐";
        [whiteBackView addSubview:foodName];
        _foodName = foodName;
        
        //3 星级评价
        UIImageView *starImg = [[UIImageView alloc] init];
        starImg.frame = CGRectZero;
        [whiteBackView addSubview:starImg];
        starImg.image = LOADPNGIMAGE(@"star");
        _starImg = starImg;
        
        
        //4 今天价
        UILabel *todayPrice = [[UILabel alloc] init];
        todayPrice.frame = CGRectZero;
        todayPrice.font = [UIFont systemFontOfSize:PxFont(16)];
        todayPrice.textColor = HexRGB(0x605e5f);
        todayPrice.text = @"今天价：";
        todayPrice.backgroundColor = [UIColor clearColor];
        [self addSubview:todayPrice];
        _todayPrice = todayPrice;
        
        //5 价格
        UILabel *price =  [[UILabel alloc] init];
        price.frame = CGRectZero;
        price.font = [UIFont systemFontOfSize:PxFont(18)];
        price.textColor = HexRGB(0x605e5f);
        price.backgroundColor = [UIColor clearColor];
        price.text = @"299/例";
        [whiteBackView addSubview:price];
        _price = price;
        
        //6 减号按钮
        UIButton * plusbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        plusbtn.frame = CGRectZero;
        [whiteBackView addSubview:plusbtn];
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
        [whiteBackView addSubview:count];
        _foodConnt = count;
        
        //8 加号按钮
        UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addbtn.frame = CGRectZero;
        [whiteBackView addSubview:addbtn];
        addbtn.backgroundColor = [UIColor clearColor];
        [addbtn setBackgroundImage:LOADPNGIMAGE(@"plus") forState:UIControlStateNormal];
        _addBun = addbtn;
        
        _hasStar = YES;
        
    }
    return  self;
}

#pragma mark 刷新数据和UI
- (void)setData:(MenuModel *)data
{
    //1 美食图片
    CGFloat foodImgX = KStartX;
    CGFloat foodImgY = KStartX;
    CGFloat foodImgW = KBackViewW - KStartX * 2;
    CGFloat foodImgH = foodImgW/KImgWHRace;
    _foodImg.frame = Rect(foodImgX, foodImgY, foodImgW, foodImgH);
    
    //2 菜名
    CGFloat foodNameX = foodImgX + KLeftX;
    CGFloat foodNameY = CGRectGetMaxY(_foodImg.frame) + KStartX;
    _foodName.frame = Rect(foodNameX, foodNameY, KFooNameW, KFooNameH);
    
    //判断是否有星级别
    //3 星级评价
    CGFloat starY;
    CGFloat todayY;
    
    if (_hasStar) {
        starY = CGRectGetMaxY(_foodName.frame);
        _starImg.frame = Rect(foodNameX, starY, KStarH, KStarH);
        _starImg.hidden = NO;
        
        todayY = CGRectGetMaxY(_starImg.frame);
    }else
    {
        _starImg.hidden = YES;
        todayY = CGRectGetMaxY(_foodName.frame);
    }
    
    //4  今天价格
    _todayPrice.frame = Rect(foodNameX + KLeftX, todayY + KLeftX, 60, KStarH);
    
    //5 价格
    _price.frame = Rect(CGRectGetMaxX(_todayPrice.frame) - 15, _todayPrice.frame.origin.y - 8, 80, KPriceH);
    
    //6 减号按钮
    CGFloat buttonY = foodNameY + KLeftX;
    CGFloat buttonX = KBackViewW - KLeftX - KAddbtnW * 2 - 18;
    _plusBtn.frame = Rect(buttonX, buttonY, KAddbtnW, KAddbtnW);
    
    //7 数量
    _foodConnt.frame = Rect(CGRectGetMaxX(_plusBtn.frame), buttonY, 18, KAddbtnW);
    
    //8 加号按钮
    _addBun.frame = Rect(CGRectGetMaxX(_foodConnt.frame), buttonY, KAddbtnW, KAddbtnW);
    NSLog(@"cell h :%f",CGRectGetMaxY(_todayPrice.frame));
}

- (void)setIndexPath:(NSInteger)indexPath
{
    _indexPath = indexPath;
    _addBun.tag = indexPath;
    _plusBtn.tag = indexPath;
}

@end
