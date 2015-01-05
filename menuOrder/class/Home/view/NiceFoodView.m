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
#import "UIImageView+WebCache.h"

#define KStartX 4
#define KStartY 4
#define KFoodImgW 130
#define KFoodImgH  92
#define KFoodNameoffsetXAfterFoodImg  20
#define KFoodNameoffsetY    10
#define KFoodNameW    150
#define KStartImgRightX  10 //图片在右边的左边距
#define KStartImgRightY  15 //图片在右边的上边距
#define KTodayPriceW 60
#define KTodayPriceBigW 80
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
        foodimg.layer.cornerRadius = 4;
        foodimg.layer.masksToBounds = YES;
        _foodImg = foodimg;
        
        //2 菜名
        UILabel *foodName = [[UILabel alloc] init];
        foodName.frame = CGRectZero;
        foodName.font = [UIFont systemFontOfSize:PxFont(20)];
        foodName.textColor = HexRGB(0x605e5f);
        foodName.backgroundColor = [UIColor clearColor];
        foodName.text = @"";
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
        price.text = @"";
        [self addSubview:price];
        _price = price;
        
        //5 小图标
        UIImageView * icon = [[UIImageView alloc] init];
        icon.frame = CGRectZero;
        [self addSubview:icon];
        _smallImg = icon;

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
    _data = data;
    CGFloat starX;// 星星图片起始rect.x
    CGFloat starY;// 星星图片起始rect.y
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
        _price.frame = Rect(CGRectGetMaxX(_todayprice.frame) - 15, todayPriceY, KTodayPriceBigW, KFontH);
        
        //5 小图标
        _smallImg.frame = Rect(self.frame.size.width - 30 , KIconY, 30, 30);
        _smallImg.image = LOADPNGIMAGE(@"招牌美食");
        
        //6 星级评价
        
        starX = foodNameX;
        starY = CGRectGetMaxY(_todayprice.frame) + 10;
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
        _price.frame = Rect(CGRectGetMaxX(_todayprice.frame) - 15, todayPriceY, KTodayPriceBigW, KFontH);
        
        //5 小图标
//        CGFloat smallX = CGRectGetMaxX(_foodName.frame);
        _smallImg.frame = Rect(self.frame.size.width - 30 - KFoodImgW , KIconY, 30, 30);
        _smallImg.image = LOADPNGIMAGE(@"招牌美食");
        //6 星级评价
        
        starX = foodNameX;
        starY = CGRectGetMaxY(_todayprice.frame) + 10;
    }
//    NSLog(@"_foodImg  %@",data.cover);
    [_foodImg setImageWithURL:[NSURL URLWithString:data.cover] placeholderImage:placeHoderloading];
    _foodName.text = data.name;
    _price.text = data.price;
    
    int starCount = [[NSString stringWithFormat:@"%@",data.star] intValue];
    for (int i = 0; i < starCount; i++) {
        //画star
        CGFloat x = starX + 20 * i;
        UIImageView *starimg = [[UIImageView alloc] initWithImage:LOADPNGIMAGE(@"star")];
        starimg.frame = Rect(x, starY, 20, 20);
        [self addSubview:starimg];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_data) {
    _clickedBlock(_data);
    }
}

@end
