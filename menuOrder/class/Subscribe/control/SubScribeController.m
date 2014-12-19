//
//  SubScribeController.m
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "SubScribeController.h"
#import "EditView.h"


#define KEditViewOffMenuBar 10
#define KRightOffset        20
#define KMenuStart 100
#define Menu1 100
#define Menu2 101
#define Menu3 102
#define KMenuItemW  kWidth/3
#define KMenuH      30
#define KBackScroolViewH KAppHeight - 44 - KMenuH

@interface SubScribeController ()<EditViewDelegate,UIScrollViewDelegate>
{
    UIButton *_selectedBtn;//选中的菜单栏按钮
    UIView *_orangLin;
    UITextField *_selectedField;//当前被编辑的UITextField
    EditView *_selectedEditView;//当前被点中的
    UIScrollView *_backScroll; //最底层的ScrollView
    UIView *_menuBack;//菜单栏背景viewEditView
    UIScrollView *_menu1Scrool;//亲临渔府Scrool
    UIScrollView *_menu2Scrool;//外带取餐Scrool
    UIScrollView *_menu3Scrool;//外卖服务Scrool
    UIScrollView *_currentScroll;//当前的Scrool；
    CGFloat keyBoardH;//键盘高度
    CGFloat _menu1ScrollViewContentH;//亲临渔府scroll的内容高度
    CGFloat _menu2ScrollViewContentH;//外带取餐scroll的内容高度
    CGFloat _menu3ScrollViewContentH;//外卖服务scroll的内容高度
}

-(void)buileEditView:(NSArray *)placeHolds icons:(NSArray *)icons pageNum:(int)pageIndex scrollView:(UIScrollView *)scroll;
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
    
    // 利用通知中心监听键盘的变化（打开、关闭、中英文切换）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    [self buildUI];
}

#pragma mark 画UI
-(void)buildUI
{
    //1 顶部菜单栏
    UIView *menuBack = [[UIView alloc] initWithFrame:Rect(0, 0, kWidth, 30)];
    menuBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menuBack];
    _menuBack = menuBack;
    
    CGFloat btnX = 0;
    CGFloat btnH = KMenuH;
    NSArray *btnTitle = @[@"亲临渔府",@"外带取餐",@"外卖服务"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = KMenuItemW;
        btnX = btnW * i;
        btn.frame = Rect(btnX, 0, btnW, btnH);
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        [menuBack addSubview:btn];
        btn.tag = i;
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
    
    //3 填写资料view
    //3.1 view 的底部ScrollView
    CGFloat editStartY = btnH + KEditViewOffMenuBar;
    CGFloat backScroolH = KAppHeight - 44 - btnH;
    UIScrollView *backScroll = [[UIScrollView alloc] initWithFrame:Rect(0, editStartY, kWidth, backScroolH)];
    [self.view addSubview:backScroll];
    _backScroll = backScroll;
    backScroll.showsHorizontalScrollIndicator = NO;
    backScroll.showsVerticalScrollIndicator = NO;
    backScroll.pagingEnabled = YES;
    backScroll.bounces = NO;
    backScroll.scrollEnabled = YES;
    backScroll.userInteractionEnabled = YES;
    backScroll.delegate = self;
    backScroll.tag = 9999;
    backScroll.contentSize = CGSizeMake(kWidth * 3, backScroolH);
    //3.2 每一个菜单下的父视图ScrollView
    for (int i = 0; i < 3; i++) {
        CGFloat scrollX = kWidth * i;
        UIScrollView *scrol =[[UIScrollView alloc] initWithFrame:Rect(scrollX, 0, kWidth, backScroolH)];
        scrol.showsHorizontalScrollIndicator = NO;
        scrol.showsVerticalScrollIndicator = NO;
        scrol.pagingEnabled = NO;
        scrol.bounces = NO;
        scrol.scrollEnabled = YES;
        scrol.userInteractionEnabled = YES;
        scrol.delegate = self;
        scrol.contentSize = CGSizeMake(kWidth, backScroolH);
        if (i == 0) {
            _menu1Scrool = scrol;
            scrol.tag = 301;
            [_backScroll addSubview:scrol];
            _currentScroll = scrol;
        } else if(i == 1) {
             _menu2Scrool = scrol;
            scrol.tag = 302;
            [_backScroll addSubview:scrol];
        }else{
            _menu3Scrool = scrol;
            scrol.tag = 303;
            [_backScroll addSubview:scrol];
        }
    }
    
    [self buildMenu1UI];
    [self buildMenu2UI];
    [self buildMenu3UI];
}

#pragma mark 编辑页面代码重构
-(void)buileEditView:(NSArray *)placeHolds icons:(NSArray *)icons pageNum:(int)pageIndex scrollView:(UIScrollView *)scroll
{
    CGFloat editW = kWidth - KRightOffset;
    CGFloat editH = 50;
    CGFloat h = 0.0;
    NSUInteger count = [placeHolds count];
    for (int i = 0; i < count; i++) {
        
        //1.1 编辑框
        CGFloat editY = (editH + 10)* i;
        EditView * edit = [[EditView alloc] initWithFrame:Rect(0, editY, editW, editH)];
        [edit addEditView:i+1 placeHoldString:placeHolds[i] editIcon:icons[i]];
        edit.delegate = self;
        edit.editTag = KEditStartTag + i + 1;
        [scroll addSubview:edit];
        //1.2 线框
        CGFloat lineFrameX = KEditLeftX * 2 + KEditCircleW;
        CGFloat lineFrameW = kWidth - lineFrameX - KRightOffset;
        CGFloat lineFrameY = editY + (editH + 10);
        UIImageView *lineFrame = [[UIImageView alloc] initWithFrame:Rect(0 + lineFrameX, lineFrameY, lineFrameW, 4)];
        lineFrame.image = LOADPNGIMAGE(@"enter_pre");
        [scroll addSubview:lineFrame];
        if (i == (count - 1)) {
            h  = CGRectGetMaxY(lineFrame.frame);
        }
    }
    //3 提交订单
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.tag = 300;
    [submit setBackgroundImage:LOADPNGIMAGE(@"submit_ok_pre") forState:UIControlStateHighlighted];
    [submit setBackgroundImage:LOADPNGIMAGE(@"submit_ok") forState:UIControlStateNormal];
    submit.frame = Rect(KRightOffset + 5, h + 30, kWidth - KRightOffset * 2, 40);
    [scroll addSubview:submit];
    [submit addTarget:self action:@selector(summitDeal) forControlEvents:UIControlEventTouchUpInside];
    CGFloat backScroolH = CGRectGetMaxY(submit.frame) + 70;
    scroll.contentSize = CGSizeMake(kWidth, backScroolH);
    //记录下每个menu下的scrollview的content height
    if (pageIndex == 0) {
        _menu1ScrollViewContentH = backScroolH;
    }else if (pageIndex == 1){
        _menu2ScrollViewContentH = backScroolH;
    }else{
        _menu3ScrollViewContentH = backScroolH;
    }
}

#pragma mark 亲临渔府
-(void)buildMenu1UI
{
    NSArray *placeHolds = @[@"斯大林",@"联系电话",@"就餐人数",@"就餐时间",@"其他就餐要求(选填)"];
    NSArray *icons = @[@"home_contacts_icon",@"home_phone_icon",@"home_address_icon",@"home_time_icom",@"home_remark_icon"];
    
    [self buileEditView:placeHolds icons:icons pageNum:0 scrollView:_menu1Scrool];
    
}

#pragma mark 外带取餐
-(void)buildMenu2UI
{
    NSArray *placeHolds = @[@"斯大林",@"联系电话",@"就餐时间",@"其他就餐要求(选填)"];
    NSArray *icons = @[@"home_contacts_icon",@"home_phone_icon",@"home_time_icom",@"home_remark_icon"];
    [self buileEditView:placeHolds icons:icons pageNum:1 scrollView:_menu2Scrool];

}

#pragma mark 外卖服务
-(void)buildMenu3UI
{
    NSArray *placeHolds = @[@"斯大林",@"联系电话",@"就餐人数",@"就餐时间",@"其他就餐要求(选填)"];
    NSArray *icons = @[@"home_contacts_icon",@"home_phone_icon",@"home_address_icon",@"home_time_icom",@"home_remark_icon"];
    [self buileEditView:placeHolds icons:icons pageNum:2 scrollView:_menu3Scrool];

}

#pragma mark提交预约
-(void)summitDeal
{
    
}

#pragma mark 菜单栏按钮点击事件
-(void)btnClicked:(UIButton *)btn
{
    //1 如果键盘打开，关闭
    [_selectedField resignFirstResponder];
    
    //2 改变按钮状态
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    
    //3 改变底部划线位置,滑动页面
    CGFloat lineX = btn.frame.origin.x;
    [UIView animateWithDuration:0.3 animations:^{
        _orangLin.frame = CGRectMake(lineX, btn.frame.size.height - 1, btn.frame.size.width, 1);
        [_backScroll setContentOffset:CGPointMake(_selectedBtn.tag * kWidth, 0)];
    }];
}

#pragma mark EditView Delageta
- (void)textFieldBeganEditting:(UITextField *)textField
{
    _selectedField = textField;
    //拿到选中的editview 计算 frame
    //1.1 找到当前menu下的scrollview
    //1.2 拿到editview,计算高度
    CGFloat backScroolViewX = _backScroll.contentOffset.x;
    if (backScroolViewX == 0) {
        //menu1下
        _currentScroll = _menu1Scrool;
    }else if (backScroolViewX == kWidth){
        //menu2下
        _currentScroll = _menu2Scrool;
    }else{
        //menu3下
        _currentScroll = _menu3Scrool;
    }
    //更新位置，和UI状态
    for (UIView *view in _currentScroll.subviews) {
        if ([view isKindOfClass:[EditView class]]) {
            EditView *editview = (EditView *)view;
            if (editview.editTag == textField.tag) {
                CGFloat editViewY = editview.frame.origin.y;
                [UIView animateWithDuration:0.25 animations:^{
                    if (textField.tag == 201) {
                        [_currentScroll setContentOffset:CGPointMake(0, editViewY) animated:YES];
                    }else{
                        [_currentScroll setContentOffset:CGPointMake(0, editViewY - 30) animated:YES];
                    }
                    [_currentScroll setContentSize:CGSizeMake(kWidth, _menu1ScrollViewContentH + 253)];
                } completion:^(BOOL finished) {
                }];
                break;
            }
        }
    }
}

#pragma mark - 键盘边框大小变化
- (void)keyboardChangeFrame:(NSNotification *)notification
{
    
    // 1. 获取键盘的目标区域
    NSDictionary *info = notification.userInfo;
    CGRect rect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    keyBoardH = rect.size.height;
    // 2. 根据rect的orgion.y可以判断键盘是开启还是关闭
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        // 键盘已经关闭
        [UIView animateWithDuration:duration animations:^{
            [_currentScroll setContentSize:CGSizeMake(kWidth, _menu1ScrollViewContentH - 253)];
            [_currentScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
    } else {
        // 键盘打开
    }
}

- (void)textFieldEndEditting:(UITextField *)textField
{
    
}

#pragma mark 收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_selectedField resignFirstResponder];
}

#pragma mark scrollView  滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    switch (scrollView.tag) {
        case 9999:
        {
            // 1 移动线条
            float x = scrollView.contentOffset.x/scrollView.frame.size.width * KMenuItemW;
            [UIView animateWithDuration:0.3 animations:^{
                _orangLin.frame = CGRectMake(x, KMenuH - 1, KMenuItemW, 1);
                
            }];
            
            // 2 取到顶部菜单栏 点击按钮
            if (scrollView.contentOffset.x == 0) {
                for (UIView *subView in _menuBack.subviews){
                    if ([subView isKindOfClass:[UIButton class]]) {
                        UIButton * btn = (UIButton *)subView;
                        if (btn.tag + KMenuStart == Menu1) {
                            _selectedBtn = btn;
                            _selectedBtn.selected = YES;
                            [UIView animateWithDuration:0.6 animations:^{
                                [_selectedField resignFirstResponder];
                                
                            }];
                        }else{
                            btn.selected = NO;
                        }
                    }
                }
                
            }else if (scrollView.contentOffset.x == kWidth * 1)
            {
                for (UIView *subView in _menuBack.subviews) {
                    if ([subView isKindOfClass:[UIButton class]]) {
                        UIButton * btn = (UIButton *)subView;
                        if (btn.tag + KMenuStart == Menu2) {
                            _selectedBtn = btn;
                            _selectedBtn.selected = YES;
                            [UIView animateWithDuration:0.6 animations:^{
                                [_selectedField resignFirstResponder];
                                
                            }];
                        }else{
                            btn.selected = NO;
                        }
                    }
                }
            }else if (scrollView.contentOffset.x == kWidth * 2)
            {
                for (UIView *subView in _menuBack.subviews) {
                    if ([subView isKindOfClass:[UIButton class]]) {
                        UIButton * btn = (UIButton *)subView;
                        if (btn.tag + KMenuStart  == Menu3) {
                            _selectedBtn = btn;
                            _selectedBtn.selected = YES;
                            [UIView animateWithDuration:0.6 animations:^{
                                [_selectedField resignFirstResponder];
                                
                            }];
                        }else{
                            btn.selected = NO;
                        }
                    }
                }
            }
        }
    }
}

@end
