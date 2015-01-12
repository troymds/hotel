//
//  DetailFoodShowView.m
//  menuOrder
//  菜品详情中的菜品展示页
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "DetailFoodShowView.h"
#import "AdaptationSize.h"
#import "ProductDetailModel.h"
#import "CarClickedDelegate.h"
#import "CarTool.h"
#import "MenuModel.h"

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
        price.font = [UIFont systemFontOfSize:PxFont(20)];
        price.textColor = HexRGB(0x3b7800);
        price.backgroundColor = [UIColor clearColor];
        price.text = @"299/元";
        [self addSubview:price];
        _price = price;
        
        
        //5 元
        UILabel *yuan =  [[UILabel alloc] init];
        yuan.frame = CGRectZero;
        yuan.font = [UIFont systemFontOfSize:PxFont(14)];
        yuan.textColor = HexRGB(0x605e5f);
        yuan.backgroundColor = [UIColor clearColor];
        yuan.text = @"元";
        [self addSubview:yuan];
        _yuan = yuan;
        
        //5 减号按钮
        UIButton * plusbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        plusbtn.frame = CGRectZero;
        [self addSubview:plusbtn];
        [plusbtn setBackgroundImage:LOADPNGIMAGE(@"reduce") forState:UIControlStateNormal];
        plusbtn.backgroundColor = [UIColor clearColor];
        _plusBtn = plusbtn;
        [plusbtn addTarget:self action:@selector(reduceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //6 数量
        UILabel *count =  [[UILabel alloc] init];
        count.frame = CGRectZero;
        count.font = [UIFont systemFontOfSize:PxFont(20)];
        count.textColor = HexRGB(0x3b7800);
        count.backgroundColor = [UIColor clearColor];
        count.text = @"0";
        count.textAlignment = NSTextAlignmentCenter;
        [self addSubview:count];
        _foodConnt = count;
        [self foodCount];
        
        count.text = [NSString stringWithFormat:@"%d",self.count];
        if ([count.text intValue] == 0) {
            plusbtn.hidden = YES;
        }else
        {
            plusbtn.hidden = NO;
        }
        
        //7 加号按钮
        UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addbtn.frame = CGRectZero;
        [addbtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
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

    }
    return self;
}



-(void)addBtn:(UIButton *)btn
{
    //1 更新数量,按钮的状态
    NSInteger count = [_foodConnt.text integerValue];
    count++;
    if (count > 0) {
        //减号按钮显示
        _plusBtn.hidden = NO;
    }else
    {
        _plusBtn.hidden = YES;
    }
    _foodConnt.text = [NSString stringWithFormat:@"%ld",(long)count];
    
    //2 传递数据
    if ([_delegate respondsToSelector:@selector(CarClickedWithData:buttonType:)]) {
        MenuModel *menu = [[MenuModel alloc] init];
        menu.name = _data.name;
        menu.ID = _data.ID;
        menu.cover = _data.cover;
        menu.foodCount = 0;
        menu.star = _data.star;
        menu.price = _data.price;
        menu.oldPrice = _data.price;
        [_cardelegate CarClickedWithData:menu buttonType:kButtonAdd];
    }
}

- (void)reduceBtn:(UIButton *)btn
{
    //1 更新数量,按钮的状态
    NSInteger count = [_foodConnt.text integerValue];
    count--;
    if (count == 0) {
        //隐藏减号按钮
        _plusBtn.hidden = YES;
    }else
    {
        _plusBtn.hidden = NO;
    }
    
    //2 传递数据
    
    if ([_delegate respondsToSelector:@selector(CarClickedWithData:buttonType:)]) {
        MenuModel *menu = [[MenuModel alloc] init];
        menu.name = _data.name;
        menu.ID = _data.ID;
        menu.cover = _data.cover;
        menu.foodCount = 0;
        menu.star = _data.star;
        menu.price = _data.price;
        menu.oldPrice = _data.price;
        [_cardelegate CarClickedWithData:menu buttonType:kButtonReduce];
    }
    if (count == 0) {
        _foodConnt.text = [NSString stringWithFormat:@""];
    }else{
        _foodConnt.text = [NSString stringWithFormat:@"%ld",(long)count];
    }
}



- (void)setData:(ProductDetailModel *)data
{
    _data = data;
 
    //1 菜名
    _foodName.frame = Rect(KLeftX, KLeftX, 100, KFoodNameH);
    _foodName.text = data.name;
    //判断是否有星级别

    //3 星级评价
    CGFloat starY;
    CGFloat todayPriceY;
    starY = CGRectGetMaxY(_foodName.frame);
    int starCount = [[NSString stringWithFormat:@"%@",data.star] intValue];
    if (starCount > 0) {
        for (int i = 0; i < starCount; i ++) {
            //画star
            CGFloat x = KLeftX + 20 * i;
            UIImageView *starimg = [[UIImageView alloc] initWithImage:LOADPNGIMAGE(@"star")];
            starimg.frame = Rect(x, starY, 20, 20);
            [self addSubview:starimg];
        }
        todayPriceY = starY + 20;
    }else
    {
        todayPriceY = starY;
    }

    //3 今天价格
    _todayPrice.frame = Rect(KLeftX, todayPriceY , 60, KTodayH);
    
    //4 价格
    _price.frame = Rect(CGRectGetMaxX(_todayPrice.frame) - 20, _todayPrice.frame.origin.y-3, 100, KPriceH);
    _price.text = data.price;
    
    CGFloat yuanW ;
    CGFloat w = [_price.text intValue];
    if (w > 99 && w <1000) {
        yuanW = 28;
    }else
    {
        yuanW = 18;
    }
    _yuan.frame = Rect(_price.frame.origin.x + yuanW, _price.frame.origin.y + 1, 40, KPriceH);
    
    //6 减号按钮
    CGFloat buttonY = KLeftX + 5;
    CGFloat buttonX = self.frame.size.width - KImgH * 3 + 1;
    _plusBtn.frame = Rect(buttonX, buttonY, KImgH, KImgH);
    
    //7 数量
    _foodConnt.frame = Rect(CGRectGetMaxX(_plusBtn.frame), buttonY, 25, KImgH);
    [self foodCount];
    
    if (self.count == 0) {
        _foodConnt.text = [NSString stringWithFormat:@""];
    }else{
        _foodConnt.text = [NSString stringWithFormat:@"%d",self.count];
    }
    //     NSLog(@"ID为%@数量%d",_data.ID,self.count);
    if ([_foodConnt.text intValue] == 0) {
        _plusBtn.hidden = YES;
    }else
    {
        _plusBtn.hidden = NO;
    }

    //8 加号按钮
    _addBun.frame = Rect(CGRectGetMaxX(_foodConnt.frame) - 1, buttonY, KImgH, KImgH);
    
    //9 评论
    CGFloat commentW = self.frame.size.width - KLeftX;
    CGFloat commentH = [AdaptationSize getSizeFromString:data.Description Font:[UIFont systemFontOfSize:PxFont(20)] withHight: CGFLOAT_MAX withWidth:commentW].height;
    _comment.text = data.Description;
    _comment.frame = Rect(KLeftX, CGRectGetMaxY(_todayPrice.frame)+5, commentW, commentH);
    //动态得到view的高度
    CGFloat viewHeight = CGRectGetMaxY(_comment.frame) + 10;
    if ([_delegate respondsToSelector:@selector(detailFoodViewHeight:)]) {
        [_delegate detailFoodViewHeight:viewHeight];
    }
}

#pragma mark 计算数量
- (void)foodCount
{
    NSMutableArray *array = [CarTool sharedCarTool].totalCarMenu;
    MenuModel *data;
    BOOL isExist;//是否有数据
    if (array.count > 0) {
        for (int i = 0; i < array.count; i++) {//有数据，赶紧break
            data = array[i];
            if ([data.ID isEqualToString:_data.ID]) {
                self.count = data.foodCount;
                NSLog(@"我的菜品ID是%@",_data.ID);
                isExist = YES;
                break;
            }
        }
        if (!isExist) { //没有数据，当然为0拉拉
            self.count = 0;
        }
    }else//购物车空了 ，肯定为0拉拉
    {
        self.count = 0;
    }
}
@end
