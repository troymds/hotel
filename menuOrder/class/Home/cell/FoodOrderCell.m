//
//  FoodOrderCell.m
//  menuOrder
//  点餐车cell 
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "FoodOrderCell.h"
#import "UIImageView+WebCache.h"
#import "MenuModel.h"
#import "CarTool.h"

#define KLeftX    5
#define KCellHeight  100
#define KbackViewH   (KCellHeight - KLeftX * 2)
#define KBackViewW   (kWidth - KLeftX * 2)
#define KImgW  105
#define KImgH   (KbackViewH - KLeftX * 2)
#define KChosenBtnW 20
#define KAddBtnW    30

@implementation FoodOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HexRGB(0xe0e0e0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.count = 0;
        _isSelected = YES;
        // 1 白色背景
        UIView *whiteBackView = [[UIView alloc] init];
        whiteBackView.backgroundColor = [UIColor whiteColor];
        whiteBackView.layer.cornerRadius = 4;
        whiteBackView.layer.masksToBounds = YES;
        whiteBackView.frame = Rect(0, KLeftX, KBackViewW, KbackViewH);
        [self.contentView addSubview:whiteBackView];
        
        // 2 选中按钮
        UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [whiteBackView addSubview:selectedBtn];
        selectedBtn.frame = CGRectZero;
        [selectedBtn setBackgroundImage:LOADPNGIMAGE(@"home_notselected") forState:UIControlStateNormal];
        [selectedBtn setBackgroundImage:LOADPNGIMAGE(@"selected") forState:UIControlStateSelected];
        [selectedBtn addTarget:self action:@selector(selectedBtnClieked) forControlEvents:UIControlEventTouchUpInside];
        selectedBtn.selected  = YES;
        _selectedBtn = selectedBtn;
        
        // 3 菜品图片
        UIImageView *foodImg = [[UIImageView alloc] init];
        foodImg.frame = CGRectZero;
        [whiteBackView addSubview:foodImg];
        foodImg.image = LOADPNGIMAGE(@"home_banner");
        foodImg.layer.masksToBounds = YES;
        foodImg.layer.cornerRadius = 4;
        _foodImg = foodImg;
        
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
        UILabel *dollarIcon = [[UILabel alloc] init];
        [whiteBackView addSubview:dollarIcon];
        _dollarIcon = dollarIcon;
        dollarIcon.font = [UIFont systemFontOfSize:PxFont(22)];
        dollarIcon.textColor = HexRGB(0x605e5f);
        dollarIcon.backgroundColor = [UIColor clearColor];
        dollarIcon.text = @"￥";
        dollarIcon.textAlignment = NSTextAlignmentCenter;
        
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
        [plusbtn addTarget:self action:@selector(reduceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //8 数量
        UILabel *count =  [[UILabel alloc] init];
        count.frame = CGRectZero;
        count.font = [UIFont systemFontOfSize:PxFont(20)];
        count.textColor = HexRGB(0x3b7800);
        count.backgroundColor = [UIColor clearColor];
        count.textAlignment = NSTextAlignmentCenter;
        [self foodCount];
        
        count.text = [NSString stringWithFormat:@"%d",self.count];
        [whiteBackView addSubview:count];
        _foodConnt = count;
        if ([count.text intValue] == 0) {
            plusbtn.hidden = YES;
        }else
        {
            plusbtn.hidden = NO;
        }

        
        //9 加号按钮
        UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addbtn.frame = CGRectZero;
        [whiteBackView addSubview:addbtn];
        addbtn.backgroundColor = [UIColor clearColor];
        [addbtn setBackgroundImage:LOADPNGIMAGE(@"plus") forState:UIControlStateNormal];
        _addBun = addbtn;
        [addbtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)selectedBtnClieked
{
    _selectedBtn.selected  = !_selectedBtn.selected;
    _isSelected = _selectedBtn.selected;
    _data.isChosen = _isSelected;
     // 1 不能改变购物车数据，只能改变选中与否的状态
//    if (_data.isChosen) {
//        if ([_delegate respondsToSelector:@selector(CarClickedWithData:buttonType:)]) {
//            [_delegate CarClickedWithData:_data buttonType:kButtonAdd];
//        }
//    }else
//    {
//        if ([_delegate respondsToSelector:@selector(CarClickedWithData:buttonType:)]) {
//            [_delegate CarClickedWithData:_data buttonType:kButtonReduce];
//        }
//    }
    
    // 2选中点击事件，计算数据
    if ([_delegate respondsToSelector:@selector(FoodOrderCell:)]) {
        [_delegate FoodOrderCell:self];
    }
}

-(void)setData:(MenuModel *)data
{
    _data = data;
    // 2 选中按钮
    CGFloat chosenX = KLeftX;
    CGFloat chonseY = (KCellHeight - KChosenBtnW)/2;
    _selectedBtn.frame = Rect(chosenX, chonseY, KChosenBtnW, KChosenBtnW);
    _isSelected = data.isChosen;
    _selectedBtn.selected = data.isChosen;
    //3 菜品图片
    CGFloat foodImgX  = CGRectGetMaxX(_selectedBtn.frame) + 5;
    CGFloat foodImgY = KLeftX;
    _foodImg.frame = Rect(foodImgX, foodImgY, KImgW, KImgH);
    [_foodImg setImageWithURL:[NSURL URLWithString:data.cover] placeholderImage:placeHoderloading];
    
    //4 菜名
    CGFloat foodNameX = CGRectGetMaxX(_foodImg.frame) + 15;
    CGFloat foodNameY = foodImgY + 10;
    _foodName.frame = Rect(foodNameX, foodNameY, 100, 25);
    _foodName.text = data.name;
    //5 美国money的图标
    CGFloat dollarIcomY = CGRectGetMaxY(_foodName.frame) + 10;
    _dollarIcon.frame = Rect(foodNameX, dollarIcomY, 15, 15);
    
    //6 价格
    _price.frame = Rect(CGRectGetMaxX(_dollarIcon.frame) +3 , dollarIcomY - 5, 80, 25);
    _price.text = data.price;
    
    //7 减号按钮
    CGFloat buttonY = chonseY;
    CGFloat buttonX = KBackViewW - KLeftX - KAddBtnW *2 - 18;
    _plusBtn.frame = Rect(buttonX, buttonY, KAddBtnW, KAddBtnW);
    
    //8 数量
    _foodConnt.frame = Rect(CGRectGetMaxX(_plusBtn.frame), buttonY, 18, 30);
    [self foodCount];
    if (self.count == 0) {
        _foodConnt.text = [NSString stringWithFormat:@""];
    }else{
        _foodConnt.text = [NSString stringWithFormat:@"%d",self.count];
    }
    if ([_foodConnt.text intValue] == 0) {
        _plusBtn.hidden = YES;
    }else
    {
        _plusBtn.hidden = NO;
    }

    //9 加号按钮
    _addBun.frame = Rect(CGRectGetMaxX(_foodConnt.frame), buttonY, KAddBtnW, KAddBtnW);
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
        _data.isChosen = NO;
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


- (void)setIndexPath:(NSInteger)indexPath
{
    _indexPath = indexPath;
    _addBun.tag = indexPath;
    _plusBtn.tag = indexPath;
    _selectedBtn.tag = indexPath;
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
//                NSLog(@"我的菜品ID是%@",_data.ID);
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
