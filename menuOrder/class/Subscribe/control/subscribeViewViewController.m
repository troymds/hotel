//
//  subscribeViewViewController.m
//  menuOrder
//
//  Created by promo on 14-12-29.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "subscribeViewViewController.h"
#import "menu1EditView.h"
#import "menu2EditView.h"
#import "menu3EditView.h"
#import "EditView.h"
#import "subscribeHttpTool.h"
#import "CarTool.h"
#import "MenuModel.h"
#import "ZHPickView.h"
#import "chooseAddressVC.h"
#import "BBBadgeBarButtonItem.h"
#import "FoodCarController.h"
#import "addressListModel.h"
#import "ConformAppointmentController.h"
#import "orderModel.h"
#import "SystemConfig.h"
#define KEditViewOffMenuBar 10
#define KRightOffset        20
#define KMenuStart 100
#define Menu1 100
#define Menu2 101
#define Menu3 102
#define KMenuItemW  kWidth/3


@interface subscribeViewViewController ()<EditViewDelegate,UIScrollViewDelegate,ZHPickViewDelegate,chooseAddressDelegate,menu1Delegate,menu2Delegate,menu3Delegate>
{
    UIButton *_selectedBtn;//选中的菜单栏按钮
    UIView *_orangLin;
    UITextField *_selectedField;//当前被编辑的UITextField
//    menu1EditView *_selectedEditView;//当前被点中的
    menu1EditView *_menu1;
    menu2EditView *_menu2;
    menu3EditView *_menu3;
    UIScrollView *_backScroll; //最底层的ScrollView
    UIView *_menuBack;//菜单栏背景viewEditView
    UIScrollView *_currentScroll;//当前的Scrool；
    CGFloat keyBoardH;//键盘高度
    int _totaNum;
}
@property(nonatomic,strong)ZHPickView *pickview;

@end

@implementation subscribeViewViewController

- (void)viewWillAppear:(BOOL)animated
{
    //1 计算购物车数量
    if (self.navigationItem.rightBarButtonItem) {
        BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
        barButton.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self totalCarNum] ];
    }
    //2 如果是已经提交订单成功后返回，如果当前不是亲临鱼府，要滚动到亲临鱼府
    if (_backScroll) {
        if ([SystemConfig sharedInstance].menuType != 0) {
            CGPoint p = _backScroll.contentOffset;
            p.x = 0;
            [_backScroll setContentOffset:p];
            //线条
            _orangLin.frame = CGRectMake(0, KMenuH - 1, KMenuItemW, 1);
           //选中的菜单
            for (UIView *subView in _menuBack.subviews){
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton * btn = (UIButton *)subView;
                    if (btn.tag + KMenuStart == Menu1) {
                        _selectedBtn = btn;
                        _selectedBtn.selected = YES;
                    }else{
                        btn.selected = NO;
                    }
                }
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"预约";
    self.view.backgroundColor = HexRGB(0xeeeeee);
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submit:) name:@"submit" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addsdress) name:@"address" object:nil];
    // 利用通知中心监听键盘的变化（打开、关闭、中英文切换）
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _totaNum = 0;
    //先获取购物车总数量
    [self totalCarNum];
    UIButton *foodcar = [UIButton buttonWithType:UIButtonTypeCustom];
    foodcar.frame = Rect(0, 0, 30, 30);
    [foodcar addTarget:self action:@selector(ordeFood) forControlEvents:UIControlEventTouchUpInside];
    [foodcar setBackgroundImage:LOADPNGIMAGE(@"cart2") forState:UIControlStateNormal];
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomView:foodcar];
    
    barButton.badgeValue = [NSString stringWithFormat:@"%d",_totaNum];
    barButton.badgeBGColor = [UIColor whiteColor];
    barButton.badgeTextColor = HexRGB(0x899c02);
    barButton.badgeFont = [UIFont systemFontOfSize:11.5];
    barButton.badgeOriginX = 20;
    barButton.badgeOriginY = 0;
    barButton.shouldAnimateBadge = YES;
    self.navigationItem.rightBarButtonItem = barButton;
    
    [self buildUI];
}

-(void)ordeFood
{
    FoodCarController *car = [[FoodCarController alloc] init];
    [self.navigationController pushViewController:car animated:YES];
}

#pragma mark 计算badgeNum
-(int)totalCarNum
{
    NSUInteger count = [CarTool sharedCarTool].totalCarMenu.count;
    int total = 0;
    for (int i = 0; i < count; i++) {
        MenuModel *data = [CarTool sharedCarTool].totalCarMenu[i];
        total += data.foodCount;
    }
    _totaNum = total;
    return _totaNum;
}

#pragma mark 画UI
-(void)buildUI
{
    //1 顶部菜单栏
    UIView *menuBack = [[UIView alloc] initWithFrame:Rect(0, 0, kWidth, KMenuH)];
    menuBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menuBack];
    _menuBack = menuBack;
    UIView *line = [[UIView alloc]init];
    [_menuBack addSubview:line];
    line.frame =CGRectMake(0, menuBack.frame.size.height - 0.5 , kWidth, 0.5);
    line.backgroundColor =HexRGB(0x488f05);
    
    
    CGFloat btnX = 0;
    CGFloat btnH = KMenuH;
    NSArray *btnTitle = @[@"亲临渔府",@"外带取餐",@"外卖服务"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = KMenuItemW;
        btn.titleLabel.font = [UIFont systemFontOfSize:60];
        btnX = btnW * i;
        btn.frame = Rect(btnX, 0, btnW, btnH);
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        [menuBack addSubview:btn];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:PxFont(22)];
        [btn setTitleColor:HexRGB(0x605e5f) forState:UIControlStateNormal];
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
    
    [self buildMenu1];
    [self buildMenu2];
    [self buildMenu3];
}

#pragma mark 亲临渔府
-(void)buildMenu1
{
    menu1EditView *menu1 = [[menu1EditView alloc] initWithFrame:Rect(0, 0, kWidth, KBackScroolViewH)];
    [_backScroll addSubview:menu1];
    _menu1 = menu1;
    menu1.delegate2 = self;
    _currentScroll = menu1.backScroll;
}

#pragma mark 外带取餐
-(void)buildMenu2
{
    menu2EditView *menu2= [[menu2EditView alloc] initWithFrame:Rect(kWidth, 0, kWidth, KBackScroolViewH)];
    [_backScroll addSubview:menu2];
    menu2.delegate2 = self;
    _menu2 = menu2;
}

#pragma mark 外卖服务
-(void)buildMenu3
{
    menu3EditView *menu3= [[menu3EditView alloc] initWithFrame:Rect(kWidth * 2, 0, kWidth, KBackScroolViewH)];
    [_backScroll addSubview:menu3];
    menu3.delegate2 = self;
    _menu3 = menu3;
    
}

#pragma mark menu1提交数据
-(void)menu1EditView:(menu1EditView *)view withArray:(NSArray *)array
{
    [self submit:array];
}

#pragma mark menu1提交数据
-(void)menu2EditView:(menu1EditView *)view withArray:(NSArray *)array
{
    [self submit:array];
}

#pragma mark menu1提交数据
-(void)menu3EditView:(menu1EditView *)view withArray:(NSArray *)array
{
    [self submit:array];
}

#pragma mark 开始提交
-(void)submit:(NSArray *)arr
{
    NSArray *data = arr;
    
    //掉接口，传递数据
    //拼接products字符串 1*3,2*4,6*1
    NSMutableArray *array = [CarTool sharedCarTool].totalCarMenu;
    NSUInteger count = array.count;
    NSMutableString *parm = [NSMutableString string];
    int price;
    for (int i = 0; i < count; i++) {
        MenuModel *data = array[i];
        NSString *ID = data.ID;
        NSString *num  = [NSString stringWithFormat:@"%d",data.foodCount];
        NSString *str = [NSMutableString stringWithFormat:@"%@*%@",ID,num];
        price += [num intValue] * [data.price intValue];
                if (i != count - 1) {
            [parm appendString:str];
            [parm appendString:@","];
        }else
        {
            [parm appendString:str];
        }
    }
//    float x = _backScroll.contentOffset.x/_backScroll.frame.size.width;
    int x = [SystemConfig sharedInstance].menuType;
    //判断参数的传值
    NSString *contact;
    NSString *tel;
    NSString *peopleNum = @"";
    NSString *useTime;
    NSString *remark;
    NSString *type;
    NSString *address = @"";
    if (x == 0) {
        //menu1
        type = @"0";
        contact = data[0];
        tel = data[1];
        peopleNum = data[2];
        useTime = data[3];
        remark = data[4];
    }else if (x == 1)
    {
        //menu2
        type = @"1";
        contact = data[0];
        tel = data[1];
        useTime = data[2];
        remark = data[3];
    }else
    {
        //menu3
        type =@"2";
        contact = data[0];
        tel = data[1];
        address = data[2];
        useTime = data[3];
        remark = data[4];
    }
    
    orderModel *order = [[orderModel alloc] init];
    order.address_content = address;
    order.contact = contact;
    order.tel = tel;
    order.type = type;
    order.use_time = useTime;
    
    order.people_num = peopleNum;
    order.remark = remark;
    order.price = [NSString stringWithFormat:@"%d",price];
    order.products = parm;
    order.address_id = @"";
    ConformAppointmentController *ctl = [[ConformAppointmentController alloc] init];
    ctl.data = order;
    ctl.oldTime = useTime;
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark 开始选择地址
-(void)startChoseAddress
{
    chooseAddressVC *choose = [[chooseAddressVC alloc] init];
    choose.delegate = self;
    [self.navigationController pushViewController:choose animated:YES];
}

#pragma mark 选择地址
- (void)passAddress:(addressListModel *)address
{
    //menu3下更新UI
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:address];
   _delegate = _menu3;
    if ([_delegate respondsToSelector:@selector(upDateAddress:)]) {
        [_delegate upDateAddress:address];
    }
}

#pragma mark 菜单栏按钮点击事件
-(void)btnClicked:(UIButton *)btn
{
    //当用户没有点餐 而点击“外带取餐”“外卖服务”时
    
    if ([self totalCarNum] == 0) {
        if (btn.tag == 1 || btn.tag == 2) {
            [RemindView showViewWithTitle:@"请点击右上角的点餐车点菜哦,亲!"
                                 location:MIDDLE];
        }
    }else{
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
}

#pragma mark scrollView  滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //当用户没有点餐 而点击“外带取餐”“外卖服务”时
    if ([self totalCarNum] == 0) {
        [RemindView showViewWithTitle:@"请点击右上角的点餐车点菜哦,亲!"
                                 location:MIDDLE];
        CGPoint p = scrollView.contentOffset;
        p.x = 0;
        [scrollView setContentOffset:p];
    }else
    {
        // 1 移动线条
        float x = scrollView.contentOffset.x/scrollView.frame.size.width * KMenuItemW;
        [UIView animateWithDuration:0.3 animations:^{
            _orangLin.frame = CGRectMake(x, KMenuH - 1, KMenuItemW, 1);
            
        }];
        
        // 2 取到顶部菜单栏 点击按钮
        if (scrollView.contentOffset.x == 0) {
            UITextField *selected;
            for (UIView *view in _backScroll.subviews) {
                if ([view isKindOfClass:[UIScrollView class]]) {
                    UIScrollView *scroll = (UIScrollView *)view;
                    for (UIView *vi in scroll.subviews) {
                        if ([vi isKindOfClass:[EditView class]]) {
                            EditView *edview  = (EditView *)vi;
                            selected = edview.selectedText;
                        }
                    }
                }
            }
            for (UIView *subView in _menuBack.subviews){
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton * btn = (UIButton *)subView;
                    if (btn.tag + KMenuStart == Menu1) {
                        _selectedBtn = btn;
                        _selectedBtn.selected = YES;
                        [UIView animateWithDuration:0.6 animations:^{
                            [selected resignFirstResponder];
                            [_pickview remove];
                            
                        }];
                    }else{
                        btn.selected = NO;
                    }
                }
            }
            
        }else if (scrollView.contentOffset.x == kWidth * 1)
        {
            UITextField *selected;
            for (UIView *view in _backScroll.subviews) {
                if ([view isKindOfClass:[UIScrollView class]]) {
                    UIScrollView *scroll = (UIScrollView *)view;
                    for (UIView *vi in scroll.subviews) {
                        if ([vi isKindOfClass:[EditView class]]) {
                            EditView *edview  = (EditView *)vi;
                            selected = edview.selectedText;
                        }
                    }
                }
            }
            
            
            for (UIView *subView in _menuBack.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton * btn = (UIButton *)subView;
                    if (btn.tag + KMenuStart == Menu2) {
                        _selectedBtn = btn;
                        _selectedBtn.selected = YES;
                        [UIView animateWithDuration:0.6 animations:^{
                            [selected resignFirstResponder];
                            [_pickview remove];
                        }];
                    }else{
                        btn.selected = NO;
                    }
                }
            }
        }else if (scrollView.contentOffset.x == kWidth * 2)
        {
            UITextField *selected;
            for (UIView *view in _backScroll.subviews) {
                if ([view isKindOfClass:[UIScrollView class]]) {
                    UIScrollView *scroll = (UIScrollView *)view;
                    for (UIView *vi in scroll.subviews) {
                        if ([vi isKindOfClass:[EditView class]]) {
                            EditView *edview  = (EditView *)vi;
                            selected = edview.selectedText;
                        }
                    }
                }
            }
            
            for (UIView *subView in _menuBack.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton * btn = (UIButton *)subView;
                    if (btn.tag + KMenuStart  == Menu3) {
                        _selectedBtn = btn;
                        _selectedBtn.selected = YES;
                        [UIView animateWithDuration:0.6 animations:^{
                            [selected resignFirstResponder];
                            [_pickview remove];
                        }];
                    }else{
                        btn.selected = NO;
                    }
                }
            }
        }
    }
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"submit" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"address" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
