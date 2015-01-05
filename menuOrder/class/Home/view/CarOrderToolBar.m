//
//  CarOrderToolBar.m
//  menuOrder
//
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "CarOrderToolBar.h"
#import "CarTool.h"
#import "MenuModel.h"

#define KViewH  60
#define KLeftX 10
#define KAllBtnW 25
#define KAllNameW 30
#define KNextBtnW 60
#define KNextBtnH 30

@implementation CarOrderToolBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //1 全选按钮
        UIButton * allbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allbtn.frame = CGRectZero;
        [self addSubview:allbtn];
        [allbtn setBackgroundImage:LOADPNGIMAGE(@"home_notselected") forState:UIControlStateNormal];
        [allbtn setBackgroundImage:LOADPNGIMAGE(@"selected") forState:UIControlStateSelected];
        allbtn.backgroundColor = [UIColor clearColor];
        _allSelectedBtn = allbtn;
        CGFloat allBtnX = 10;
        CGFloat allBtnY = (KViewH - KAllBtnW)/2;
        _allSelectedBtn.frame = Rect(allBtnX,allBtnY, KAllBtnW, KAllBtnW);
        _allSelectedBtn.selected = YES;//默认是全选的
        //2 全选文字
        UILabel *allName = [[UILabel alloc] init];
        allName.frame = CGRectZero;
        allName.font = [UIFont systemFontOfSize:PxFont(25)];
        allName.textColor = HexRGB(0x3a3a3a);
        allName.backgroundColor = [UIColor clearColor];
        allName.text = @"全选";
        [self addSubview:allName];
        _allname = allName;
        CGFloat allLabelX = CGRectGetMaxX(_allSelectedBtn.frame) + 10;
        _allname.frame = Rect(allLabelX, allBtnY - 3, 40, 30);
        
        //3 总份数
        UILabel *allFoods = [[UILabel alloc] init];
        allFoods.frame = CGRectZero;
        allFoods.font = [UIFont systemFontOfSize:PxFont(20)];
        allFoods.textColor = HexRGB(0x3a3a3a);
        allFoods.backgroundColor = [UIColor clearColor];
        allFoods.text = [NSString stringWithFormat:@"合计：%d份",12];
        [self addSubview:allFoods];
        CGFloat numX = CGRectGetMaxX(_allname.frame) + 50;
        allFoods.frame = Rect(numX, KLeftX, 80, 20);        
        _numOfFood = allFoods;
//        _numOfFood.frame = Rect(numX,KLeftX, 80, 20);
        
        //4 美国money的图标
        UILabel *dollarIcon = [[UILabel alloc] init];
        [self addSubview:dollarIcon];
        _dollar = dollarIcon;
        dollarIcon.font = [UIFont systemFontOfSize:PxFont(26)];
        dollarIcon.textColor = HexRGB(0x605e5f);
        dollarIcon.backgroundColor = [UIColor clearColor];
        dollarIcon.text = @"￥";
        dollarIcon.textAlignment = NSTextAlignmentCenter;
        _dollar = dollarIcon;
        _dollar.frame = Rect(numX - 10, CGRectGetMaxY(_numOfFood.frame) + 5, 20, 20);
        
        //5 总价
        UILabel *totalMoeny = [[UILabel alloc] init];
        totalMoeny.frame = CGRectZero;
        totalMoeny.font = [UIFont systemFontOfSize:PxFont(24)];
        totalMoeny.textColor = HexRGB(0x305d05);
        totalMoeny.backgroundColor = [UIColor clearColor];
        totalMoeny.text = @"1212";
        [self addSubview:totalMoeny];
        _money = totalMoeny;
        _money.frame = Rect(CGRectGetMaxX(_dollar.frame)+3, CGRectGetMaxY(_numOfFood.frame) - 2, 100, KAllNameW);
        
        //6 全选按钮
        UIButton * next = [UIButton buttonWithType:UIButtonTypeCustom];
        next.frame = CGRectZero;
        [self addSubview:next];
        [next setBackgroundImage:LOADPNGIMAGE(@"tab_next_pre") forState:UIControlStateHighlighted];
        [next setBackgroundImage:LOADPNGIMAGE(@"tab_next") forState:UIControlStateNormal];
        next.backgroundColor = [UIColor clearColor];
        _nextBtn = next;
        _nextBtn.frame = Rect(kWidth - KLeftX - KNextBtnW , 15, KNextBtnW, KNextBtnH);
    }
    return self;
}

- (void)setData:(NiceFoodModel *)data
{
//    //1 全选按钮
//    CGFloat allBtnX = 10;
//    CGFloat allBtnY = (KViewH - KAllBtnW)/2;
//    _allSelectedBtn.frame = Rect(allBtnX,allBtnY, KAllBtnW, KAllBtnW);
//    
//    //2 全选
//    CGFloat allLabelX = CGRectGetMaxX(_allSelectedBtn.frame) + 10;
//    _allname.frame = Rect(allLabelX, allBtnY - 3, 40, 30);
//    
//    //3 总份数
//    CGFloat numX = CGRectGetMaxX(_allname.frame) + 50;
//    _numOfFood.frame = Rect(numX,KLeftX, 80, 20);
//    
//    //4   美元符号
//    _dollar.frame = Rect(numX - 10, CGRectGetMaxY(_numOfFood.frame), 20, 20);
//    
//    //5 总价
//    _money.frame = Rect(CGRectGetMaxX(_dollar.frame)+3, CGRectGetMaxY(_numOfFood.frame) - 5, 60, KAllNameW);
//    
//    //6 下一步按钮
//    _nextBtn.frame = Rect(kWidth - KLeftX - KNextBtnW , 15, KNextBtnW, KNextBtnH);
}
@end
