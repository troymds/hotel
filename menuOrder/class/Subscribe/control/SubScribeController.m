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

@interface SubScribeController ()<EditViewDelegate,UIScrollViewDelegate>
{
    UIButton *_selectedBtn;//选中的菜单栏按钮
    UIView *_orangLin;
    UITextField *_selectedField;//当前被编辑的
    UIScrollView *_backScroll; //最底层的ScrollView
    UIView *_menuBack;//菜单栏背景view
}
-(void)buileEditView:(NSArray *)placeHolds icons:(NSArray *)icons pageNum:(int)pageIndex;
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
    backScroll.contentSize = CGSizeMake(kWidth * 3, backScroolH);
    
    [self buildMenu1UI];
    [self buildMenu2UI];
    [self buildMenu3UI];
}

#pragma mark 编辑页面代码重构
-(void)buileEditView:(NSArray *)placeHolds icons:(NSArray *)icons pageNum:(int)pageIndex
{
    
    
    CGFloat editW = kWidth - KRightOffset;
    CGFloat editH = 50;
    CGFloat startX = pageIndex * kWidth;

    CGFloat h = 0.0;
    NSUInteger count = [placeHolds count];
    for (int i = 0; i < count; i++) {
        //1.1 编辑框
        CGFloat editY = (editH + 10)* i;
        EditView * edit = [[EditView alloc] initWithFrame:Rect(startX, editY, editW, editH)];
        [edit addEditView:i+1 placeHoldString:placeHolds[i] editIcon:icons[i]];
        edit.delegate = self;
        [_backScroll addSubview:edit];
        //1.2 线框
        CGFloat lineFrameX = KEditLeftX * 2 + KEditCircleW;
        CGFloat lineFrameW = kWidth - lineFrameX - KRightOffset;
        CGFloat lineFrameY = editY + (editH + 10);
        UIImageView *lineFrame = [[UIImageView alloc] initWithFrame:Rect(startX + lineFrameX, lineFrameY, lineFrameW, 4)];
        lineFrame.image = LOADPNGIMAGE(@"enter_pre");
        [_backScroll addSubview:lineFrame];
        if (i == (count - 1)) {
            h  = CGRectGetMaxY(lineFrame.frame);
        }
    }
    //3 提交订单
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.tag = 300;
    [submit setBackgroundImage:LOADPNGIMAGE(@"submit_ok_pre") forState:UIControlStateHighlighted];
    [submit setBackgroundImage:LOADPNGIMAGE(@"submit_ok") forState:UIControlStateNormal];
    submit.frame = Rect(startX + KRightOffset + 5, h + 30, kWidth - KRightOffset * 2, 40);
    [_backScroll addSubview:submit];
    [submit addTarget:self action:@selector(summitDeal) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 亲临渔府
-(void)buildMenu1UI
{
    NSArray *placeHolds = @[@"斯大林",@"联系电话",@"就餐人数",@"就餐时间",@"其他就餐要求(选填)"];
    NSArray *icons = @[@"home_contacts_icon",@"home_phone_icon",@"home_address_icon",@"home_time_icom",@"home_remark_icon"];
    
    [self buileEditView:placeHolds icons:icons pageNum:0];

}

#pragma mark 外带取餐
-(void)buildMenu2UI
{
    NSArray *placeHolds = @[@"斯大林",@"联系电话",@"就餐时间",@"其他就餐要求(选填)"];
    NSArray *icons = @[@"home_contacts_icon",@"home_phone_icon",@"home_time_icom",@"home_remark_icon"];
    [self buileEditView:placeHolds icons:icons pageNum:1];

}

#pragma mark 外卖服务
-(void)buildMenu3UI
{
    NSArray *placeHolds = @[@"斯大林",@"联系电话",@"就餐人数",@"就餐时间",@"其他就餐要求(选填)"];
    NSArray *icons = @[@"home_contacts_icon",@"home_phone_icon",@"home_address_icon",@"home_time_icom",@"home_remark_icon"];
    [self buileEditView:placeHolds icons:icons pageNum:2];

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
    //更新位置，和UI状态
    switch (textField.tag) {
        case KNameEdit:
            //姓名
            NSLog(@"KNameEdit");
            break;
        case KPhoneEdit:
            //电话号码
            NSLog(@"KPhoneEdit");
            break;
        case KPersonsEdit:
            //顾客人数
            NSLog(@"KPersonsEdit");
            break;
        case KTimeEdit:
            //时间
            NSLog(@"KTimeEdit");
            break;
        case KOthersEdit:
            //其他
            NSLog(@"KOthersEdit");
            break;
        default:
            break;
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
    
    if (scrollView == _backScroll) {

        if (scrollView.contentOffset.x <=0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        if (scrollView.contentOffset.x >= kWidth*2) {
            scrollView.contentOffset = CGPointMake(kWidth*2, 0);
        }
        
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
@end
