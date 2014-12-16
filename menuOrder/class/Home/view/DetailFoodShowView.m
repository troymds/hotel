//
//  DetailFoodShowView.m
//  menuOrder
//  菜品详情中的菜品展示页
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "DetailFoodShowView.h"
#import "AdaptationSize.h"

#define KLeftX  10
#define KFoodNameH   30
#define KImgH     30
#define KTodayH   20
#define KStarH 20
#define KPriceH 25

@interface DetailFoodShowView ()
{
    BOOL _hasStar;
}

@end
@implementation DetailFoodShowView

- (id) initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor blueColor];
        //1 菜名
        UILabel *foodName = [[UILabel alloc] init];
        foodName.frame = CGRectZero;
        foodName.font = [UIFont systemFontOfSize:PxFont(20)];
        foodName.textColor = HexRGB(0x605e5f);
        foodName.backgroundColor = [UIColor clearColor];
        foodName.text = @"麻婆豆腐";
        [self addSubview:foodName];
        _foodName = foodName;
        
        //2 星级评价
        UIImageView *starImg = [[UIImageView alloc] init];
        starImg.frame = CGRectZero;
        [self addSubview:starImg];
        starImg.image = LOADPNGIMAGE(@"star");
        _starImg = starImg;
        
        //3 今天价格
        UILabel *todayPrice = [[UILabel alloc] init];
        [self addSubview:todayPrice];
        todayPrice.text = @"今天价：";
        todayPrice.font = [UIFont systemFontOfSize:PxFont(16)];
        _todayPrice = todayPrice;
        todayPrice.backgroundColor = [UIColor clearColor];
        
        //4 价格
        UILabel *price =  [[UILabel alloc] init];
        price.frame = CGRectZero;
        price.font = [UIFont systemFontOfSize:PxFont(18)];
        price.textColor = HexRGB(0x605e5f);
        price.backgroundColor = [UIColor clearColor];
        price.text = @"299/元";
        [self addSubview:price];
        _price = price;
        
        //5 减号按钮
        UIButton * plusbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        plusbtn.frame = CGRectZero;
        [self addSubview:plusbtn];
        [plusbtn setBackgroundImage:LOADPNGIMAGE(@"reduce") forState:UIControlStateNormal];
        plusbtn.backgroundColor = [UIColor clearColor];
        _plusBtn = plusbtn;
        
        //6 数量
        UILabel *count =  [[UILabel alloc] init];
        count.frame = CGRectZero;
        count.font = [UIFont systemFontOfSize:PxFont(20)];
        count.textColor = HexRGB(0x3b7800);
        count.backgroundColor = [UIColor clearColor];
        count.text = @"12";
        count.textAlignment = NSTextAlignmentCenter;
        [self addSubview:count];
        _foodConnt = count;
        
        //7 加号按钮
        UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addbtn.frame = CGRectZero;
        [self addSubview:addbtn];
        addbtn.backgroundColor = [UIColor clearColor];
        [addbtn setBackgroundImage:LOADPNGIMAGE(@"plus") forState:UIControlStateNormal];
        _addBun = addbtn;
        
        //8 评论
        UILabel *comment =   [[UILabel alloc] init];
        comment.frame = CGRectZero;
        comment.font = [UIFont systemFontOfSize:PxFont(20)];
        comment.textColor = HexRGB(0x605e5f);
        comment.backgroundColor = [UIColor clearColor];
        comment.numberOfLines = 0;
        comment.text = @"公保鸡丁是我的最爱啊啊啊啊啊啊啊啊啊啊啊啊啊";
        [self addSubview:comment];
        _comment = comment;
        
        _hasStar = YES;
    }
    return self;
}

- (void)setData:(NiceFoodModel *)data
{
    _data = data;
 
    //1 菜名
    _foodName.frame = Rect(KLeftX, KLeftX, 100, KFoodNameH);
    
    //判断是否有星级别
    //2 星级评价
    CGFloat starY;
    CGFloat todayPriceY;
    
    if (_hasStar) {
        starY = CGRectGetMaxY(_foodName.frame);
        _starImg.frame = Rect(KLeftX, starY, KStarH, KStarH);
        _starImg.hidden = NO;
        
        todayPriceY = CGRectGetMaxY(_starImg.frame);
    }else
    {
        _starImg.hidden = YES;
        todayPriceY = CGRectGetMaxY(_foodName.frame);
    }
    
    //3 今天价格
    _todayPrice.frame = Rect(KLeftX, todayPriceY , 60, KTodayH);
    
    //4 价格
    _price.frame = Rect(CGRectGetMaxX(_todayPrice.frame), _todayPrice.frame.origin.y-3, 100, KPriceH);
    
    //6 减号按钮
    CGFloat buttonY = KLeftX + 5;
    CGFloat buttonX = self.frame.size.width - KImgH * 3 + 1;
    _plusBtn.frame = Rect(buttonX, buttonY, KImgH, KImgH);
    
    //7 数量
    _foodConnt.frame = Rect(CGRectGetMaxX(_plusBtn.frame), buttonY, 25, KImgH);
    
    //8 加号按钮
    _addBun.frame = Rect(CGRectGetMaxX(_foodConnt.frame) - 1, buttonY, KImgH, KImgH);
    
    //9 评论
    CGFloat commentW = self.frame.size.width - KLeftX;
    CGFloat commentH = [AdaptationSize getSizeFromString:_comment.text Font:[UIFont systemFontOfSize:PxFont(20)] withHight: CGFLOAT_MAX withWidth:commentW].height;
    _comment.frame = Rect(KLeftX, CGRectGetMaxY(_todayPrice.frame)+5, commentW, commentH);
    //动态得到view的高度
    CGFloat viewHeight = CGRectGetMaxY(_comment.frame) + 10;
    if ([_delegate respondsToSelector:@selector(detailFoodViewHeight:)]) {
        [_delegate detailFoodViewHeight:viewHeight];
    }
}

@end
