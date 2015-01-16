//
//  MenuCell.m
//  menuOrder
//  飘香菜单cell
//  Created by promo on 14-12-12.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MenuCell.h"
#import "MenuModel.h"
#import "CarTool.h"

#define KBigImgStartX   8
#define KBigImgStartY  6
#define KBigImgW       85
#define KRataio         1.3
#define KBigImgH       KBigImgW/KRataio
#define KSpaceBetweenBigImgAndFoodName  10
#define KFoodNameStartY (KBigImgStartY + 2)
#define KFoodNameStartX (KBigImgStartX + KBigImgW + KSpaceBetweenBigImgAndFoodName - 3)
#define KFooNameW   120
#define KFontBigH     25
#define KFontSmallH   20
#define KStarH       20
#define KPriceW      80
#define KBUttonW     30
#define KBUttonH     30
#define KDefaultSpace   30

@implementation MenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.count = 0;
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
        
        //4 美国money的图标
        UILabel *dollarIcon = [[UILabel alloc] init];
        [self.contentView addSubview:dollarIcon];
        _dollarIcon = dollarIcon;
        dollarIcon.font = [UIFont systemFontOfSize:PxFont(22)];
        dollarIcon.textColor = HexRGB(0x605e5f);
        dollarIcon.backgroundColor = [UIColor clearColor];
        dollarIcon.text = @"￥";
        dollarIcon.textAlignment = NSTextAlignmentCenter;
        
        //5 价格
        UILabel *price =  [[UILabel alloc] init];
        price.frame = CGRectZero;
        price.font = [UIFont systemFontOfSize:PxFont(18)];
        price.textColor = HexRGB(0x305d05);
        price.backgroundColor = [UIColor clearColor];
        price.text = @"299/例";
        [self.contentView addSubview:price];
        _price = price;
        
        //6 减号按钮
        UIButton * plusbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        plusbtn.frame = CGRectZero;
        [self.contentView addSubview:plusbtn];
        [plusbtn setBackgroundImage:LOADPNGIMAGE(@"reduce") forState:UIControlStateNormal];
        [plusbtn addTarget:self action:@selector(reduceBtn:) forControlEvents:UIControlEventTouchUpInside];
        plusbtn.backgroundColor = [UIColor clearColor];
        _plusBtn = plusbtn;

        //7 数量
        UILabel *count =  [[UILabel alloc] init];
        count.frame = CGRectZero;
        count.font = [UIFont systemFontOfSize:PxFont(20)];
        count.textColor = HexRGB(0x3b7800);
        count.backgroundColor = [UIColor clearColor];
        count.textAlignment = NSTextAlignmentCenter;
        [self foodCount];

        count.text = [NSString stringWithFormat:@"%d",self.count];
        [self.contentView addSubview:count];
        _foodConnt = count;
        if ([count.text intValue] == 0) {
             plusbtn.hidden = YES;
        }else
        {
             plusbtn.hidden = NO;
        }
        
        //8 加号按钮
        UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addbtn.frame = CGRectZero;
        [self.contentView addSubview:addbtn];
        [addbtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
        addbtn.backgroundColor = [UIColor clearColor];
        [addbtn setBackgroundImage:LOADPNGIMAGE(@"plus") forState:UIControlStateNormal];
        _addBun = addbtn;
        
        //9 线条
        UIView *line = [[UIView alloc] init];
//        line.frame = CGRectZero;
        line.backgroundColor = HexRGB(0xd5d5d5);
        [self.contentView addSubview:line];
        line.frame = Rect(KBigImgStartX, 87 - 1, 222, 1);
        _line = line;
    }
    return  self;
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
        [_delegate CarClickedWithData:_data buttonType:kButtonAdd];
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
        [_delegate CarClickedWithData:_data buttonType:kButtonReduce];
    }
    
    if (count == 0) {
        _foodConnt.text = [NSString stringWithFormat:@""];
    }else{
        _foodConnt.text = [NSString stringWithFormat:@"%ld",(long)count];
    }
}


#pragma mark 刷新数据和UI
- (void)setData:(MenuModel *)data
{
    _data = data;
    //1 美食图片
    _foodImg.frame = Rect(KBigImgStartX, KBigImgStartY, KBigImgW, KBigImgH);
    __weak UIImageView *foodImg = _foodImg;
    [_foodImg setImageWithURL:[NSURL URLWithString:data.cover] placeholderImage:placeHoderImage3 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        CGRect rect =  CGRectMake(90, 90, 300, 300/1.3);
        CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
        foodImg.image = [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);
    }];
    //2 菜名
    _foodName.frame = Rect(KFoodNameStartX, KFoodNameStartY, KFooNameW, KFontBigH);
    _foodName.text = data.name;
    
    //判断是否有星级别
    //3 星级评价
    CGFloat starY;
    CGFloat dollarY;
    int starCount = [data.star intValue];
    if (starCount > 0) {
        starY = CGRectGetMaxY(_foodName.frame);
        for (int i = 0; i < starCount; i ++) {
            //画star
            CGFloat x = KFoodNameStartX + 20 * i;
            UIImageView *starimg = [[UIImageView alloc] initWithImage:LOADPNGIMAGE(@"star")];
            starimg.frame = Rect(x, starY, 20, 20);
            [self addSubview:starimg];
        }
        
        dollarY = starY + 20;
    }
    else
    {
        dollarY = CGRectGetMaxY(_foodName.frame);
    }

    //4 美国money的图标
    _dollarIcon.frame = Rect(KFoodNameStartX - 3, dollarY + KSpaceBetweenBigImgAndFoodName - 5, KStarH, KStarH);
    
    //5 价格
    _price.frame = Rect(CGRectGetMaxX(_dollarIcon.frame) - 4, _dollarIcon.frame.origin.y - 2, KPriceW, KFontSmallH);
    _price.text = [NSString stringWithFormat:@"%@/例",data.price];
    
    //6 减号按钮
    CGFloat buttonY = CGRectGetMaxY(_foodName.frame) + KStarH;
    CGFloat buttonX = CGRectGetMaxX(_price.frame) - KDefaultSpace * 1.5 + 5;
//    CGFloat buttonY = CGRectGetMaxY(_foodName.frame) + KStarH;;
//    CGFloat buttonX = self.frame.size.width - KBigImgStartX - KBUttonW *2 - 18;
    _plusBtn.frame = Rect(buttonX, buttonY, KBUttonW, KBUttonH);
    
    //7 数量
    _foodConnt.frame = Rect(CGRectGetMaxX(_plusBtn.frame), buttonY, 18, KBUttonH);
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
    _addBun.frame = Rect(CGRectGetMaxX(_foodConnt.frame), buttonY, KBUttonW, KBUttonH);

}

- (void)setIndexPath:(NSInteger)indexPath
{
    _indexPath = indexPath;
    _addBun.tag = indexPath;
    _plusBtn.tag = indexPath;
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
