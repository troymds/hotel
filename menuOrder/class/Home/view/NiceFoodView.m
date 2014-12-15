//
//  NiceFoodView.m
//  menuOrder
//  招牌美食View
//  Created by promo on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "NiceFoodView.h"
#import "NiceFoodModel.h"
#import "AdaptationSize.h"

#define KStartX 4
#define KStartY 4
#define KFoodImgW 130
#define KFoodImgH  92
#define KFoodNameoffsetXAfterFoodImg  20
#define KFoodNameoffsetY    10
#define KFoodNameW    100
#define KStartImgRightX  10 //图片在右边的左边距
#define KStartImgRightY  15 //图片在右边的上边距
#define KTodayPriceW 60
#define KPrice    40
#define KFontH 20
#define KIconY 7

@interface NiceFoodView(){
    NiceFoodViewClickedBlock _clickedBlock;
}

@property (nonatomic, strong) UIImageView *foodImg;
@property (nonatomic, strong) UILabel *foodName;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *todayprice;
@property (nonatomic, strong) UIImageView *smallImg;
@property (nonatomic, strong) UIImageView *starImg;
@end

@implementation NiceFoodView

- (id) initWithBlock:(NiceFoodViewClickedBlock)block
{
    self = [super init];
    if (self) {
        _clickedBlock = block;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 4;
        self.backgroundColor = HexRGB(0xffffff);
        
        //1 美食图片
        UIImageView *foodimg = [[UIImageView alloc] init];
        foodimg.frame = CGRectZero;
        [self addSubview:foodimg];
        foodimg.image = LOADPNGIMAGE(@"home_banner");
        foodimg.layer.cornerRadius = 4;
        foodimg.layer.masksToBounds = YES;
        _foodImg = foodimg;
        
        //2 菜名
        UILabel *foodName = [[UILabel alloc] init];
        foodName.frame = CGRectZero;
        foodName.font = [UIFont systemFontOfSize:PxFont(20)];
        foodName.textColor = HexRGB(0x605e5f);
        foodName.backgroundColor = [UIColor clearColor];
        foodName.text = @"鸡汁煮干丝";
        [self addSubview:foodName];
        _foodName = foodName;
        
        //3 今天价
        UILabel *todayPrice = [[UILabel alloc] init];
        todayPrice.frame = CGRectZero;
        todayPrice.font = [UIFont systemFontOfSize:PxFont(16)];
        todayPrice.textColor = HexRGB(0x605e5f);
        todayPrice.text = @"今天价：";
        todayPrice.backgroundColor = [UIColor clearColor];
        [self addSubview:todayPrice];
        _todayprice = todayPrice;
        
        //4 价格
        UILabel *price =  [[UILabel alloc] init];
        price.frame = CGRectZero;
        price.font = [UIFont systemFontOfSize:PxFont(24)];
        price.textColor = HexRGB(0x3b7800);
        price.backgroundColor = [UIColor clearColor];
        price.text = @"299元";
        [self addSubview:price];
        _price = price;
        
        //5 小图标
        UIImageView * icon = [[UIImageView alloc] init];
        icon.frame = CGRectZero;
        [self addSubview:icon];
        _smallImg = icon;
        
        //6 星级评价
        UIImageView *starImg = [[UIImageView alloc] init];
        starImg.frame = CGRectZero;
        [self addSubview:starImg];
        _starImg = starImg;
    }
    
    return self;
}

#pragma mark 设置显示模式
-(void)setType:(int)type
{
    _type = type;
}

#pragma mark 刷新数据
- (void)setData:(NiceFoodModel *)data
{
    if (_type == 0) {// 图片显示在左边
        //1 美食图片
        _foodImg.frame = Rect(KStartX, KStartY, KFoodImgW, KFoodImgH);
        
        //2 菜名

        CGFloat foodNameX = CGRectGetMaxX(_foodImg.frame) + KFoodNameoffsetXAfterFoodImg;
        CGFloat foodNameY = KFoodNameoffsetY;
        _foodName.frame = Rect(foodNameX, foodNameY, KFoodNameW, KFontH);
        
        //3 今天价
        CGFloat todayPriceY = CGRectGetMaxY(_foodName.frame) + 10;
        _todayprice.frame = Rect(foodNameX, todayPriceY, KTodayPriceW, KFontH);
        
        //4 价格
        _price.frame = Rect(CGRectGetMaxX(_todayprice.frame) - 15, todayPriceY, KTodayPriceW, KFontH);
        
        //5 小图标
        _smallImg.frame = Rect(self.frame.size.width - 30 , KIconY, 30, 30);
        _smallImg.image = LOADPNGIMAGE(@"招牌美食");
        
        //6 星级评价
        
        _starImg.frame = Rect(foodNameX, CGRectGetMaxY(_todayprice.frame) + 10, 20, 20);
        _starImg.image = LOADPNGIMAGE(@"star");
    }else
    {
        CGFloat startX = KStartImgRightX;
        CGFloat startY = KStartImgRightY;
        
        
        //1 美食图片
        _foodImg.frame = Rect(self.frame.size.width - KStartX - KFoodImgW, KStartX, KFoodImgW, KFoodImgH);
        
        //2 菜名
        CGFloat foodNameX = startX;
        CGFloat foodNameY = startY;
        _foodName.frame = Rect(foodNameX, foodNameY, KFoodNameW, KFontH);
        //3 今天价
        CGFloat todayPriceY = CGRectGetMaxY(_foodName.frame) + 10;
        _todayprice.frame = Rect(foodNameX, todayPriceY, KTodayPriceW, KFontH);
        //4 价格
        _price.frame = Rect(CGRectGetMaxX(_todayprice.frame) - 15, todayPriceY, KTodayPriceW, KFontH);
        
        //5 小图标
        _smallImg.frame = Rect(self.frame.size.width - 60 - KFoodImgW , KIconY, 30, 30);
        _smallImg.image = LOADPNGIMAGE(@"招牌美食");
        //6 星级评价
        
        _starImg.frame = Rect(foodNameX, CGRectGetMaxY(_todayprice.frame) + 10, 20, 20);
        _starImg.image = LOADPNGIMAGE(@"star");
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _clickedBlock(1);
}

@end
