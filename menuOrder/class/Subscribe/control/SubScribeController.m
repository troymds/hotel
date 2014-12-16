//
//  SubScribeController.m
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "SubScribeController.h"

@interface SubScribeController ()
{
    UIButton *_selectedBtn;//选中的菜单栏按钮
    UIView *_orangLin;
}
@end

@implementation SubScribeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"预约";
    self.view.backgroundColor = HexRGB(0xeeeeee);
    
    [self buildUI];
}

#pragma mark 画UI
-(void)buildUI
{
    //1 顶部菜单栏
    UIView *menuBack = [[UIView alloc] initWithFrame:Rect(0, 0, kWidth, 30)];
    menuBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menuBack];
    
    CGFloat btnX = 0;
    CGFloat btnH = 30;
    NSArray *btnTitle = @[@"亲临渔府",@"外带取餐",@"外卖服务"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = kWidth/3;
        btnX = btnW * i;
        btn.frame = Rect(btnX, 0, btnW, btnH);
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        [menuBack addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:PxFont(22)];
        [btn setTitleColor:HexRGB(0x605e5f) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
            _selectedBtn = btn;
        }
    }
    //2 加顶部菜单栏底部的划线
    _orangLin =[[UIView alloc]init];
    [self.view addSubview:_orangLin];
    _orangLin.frame =CGRectMake(0, btnH - 1 , kWidth/3, 1);
    _orangLin.backgroundColor =HexRGB(0x488f05);
    
}

#pragma mark 菜单栏按钮点击事件
-(void)btnClicked:(UIButton *)btn
{
    //1 改变按钮状态
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    
    //2 改变底部划线位置
    CGFloat lineX = btn.frame.origin.x;
    [UIView animateWithDuration:0.3 animations:^{
        _orangLin.frame = CGRectMake(lineX, btn.frame.size.height - 1, btn.frame.size.width, 1);
    }];
    
    
}
@end
