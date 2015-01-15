//
//  MenuController.m
//  menuOrder
//  飘香菜单
//  Created by promo on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MenuController.h"
#import "MenuItem.h"
#import "MenuCell.h"
#import "MenuModel.h"
#import "FoodCarController.h"
#import "UIBarButtonItem+MJ.h"
#import "WBNavigationController.h"
#import "MenuCategory.h"
#import "UIImageView+WebCache.h"
#import "GetIndexHttpTool.h"
#import "BBBadgeBarButtonItem.h"
#import "CarTool.h"
#import "ChangeControllerDelegate.h"
#import "MainController.h"
#import "DetailFoodController.h"

#define KMenuItemCount  9
#define KLeftMenuW   80
#define KDelX        5

@interface MenuController ()<MenuItemDelegate,UITableViewDataSource,UITableViewDelegate,CarClickedDelegate,ChangeControllerDelegate>
{
    MenuItem *_selectedItem;
    NSArray *_categoryList;//分类菜单数据
    NSArray *_productsList;//产品列表
    UITableView *_table;
    int _totaNum;
}

@end

@implementation MenuController

-(void)viewWillAppear:(BOOL)animated
{
    //1 隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
    //2 计算购物车数量
    if (self.navigationItem.rightBarButtonItem) {
        BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
        barButton.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self totalCarNum] ];
    }
    //3 刷新表数据
    if (_table) {
        [_table reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"飘香菜单";
    self.view.backgroundColor = HexRGB(0xe0e0e0);
    
    _categoryList = [NSArray array];
    _productsList = [NSArray array];
    _totaNum = 0;
    //先获取购物车总数量
    [self totalCarNum];
    UIButton *foodcar = [UIButton buttonWithType:UIButtonTypeCustom];
    foodcar.frame = Rect(0, 0, 30, 30);
    [foodcar addTarget:self action:@selector(orderFood) forControlEvents:UIControlEventTouchUpInside];
    [foodcar setBackgroundImage:LOADPNGIMAGE(@"cart2") forState:UIControlStateNormal];
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomView:foodcar];

    barButton.badgeValue = [NSString stringWithFormat:@"%d",_totaNum];
    barButton.badgeBGColor = [UIColor whiteColor];
    barButton.badgeFont = [UIFont systemFontOfSize:11.5];
    barButton.badgeOriginX = 20;
    barButton.badgeOriginY = 0;
    barButton.badgeTextColor = HexRGB(0x899c02);
    barButton.shouldAnimateBadge = YES;
    self.navigationItem.rightBarButtonItem = barButton;
    
    //1 获取分类菜单数据
    [self loadCategoryMenuData];

     // 创建tableView
    CGFloat tableX = KLeftMenuW - 1;
    CGFloat tableY = KDelX;
    UITableView *table = [[UITableView alloc] initWithFrame: CGRectMake(tableX, tableY, kWidth - KLeftMenuW - KDelX, KAppHeight - 44 - tableY) style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    table.backgroundColor =[UIColor whiteColor];
    table.showsVerticalScrollIndicator = NO;
    table.delegate =self;
    table.dataSource = self;
    _table = table;
}

#pragma mark 获取分类菜单数据
- (void)loadCategoryMenuData
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [GetIndexHttpTool GetProductCategoryWithSuccess:^(NSArray *data, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (data.count > 0) {
            //成功得到数据
            NSMutableArray *array = [NSMutableArray arrayWithArray:data];
            _categoryList = array;
            [self addLeftMenuBar];
        }else
        {
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell =[[MenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(8,87, 222, 1)];
//        lineView.backgroundColor = HexRGB(0xd5d5d5);
//        [cell.contentView addSubview:lineView];
    }
    MenuModel *data = _productsList[indexPath.row];
    cell.data = data;
    cell.delegate = self;
    cell.indexPath = indexPath.row;
    return cell;
}

-(void)orderFood
{
    BOOL isMenu = NO;
    BOOL isCar = NO;
    
    //判断下，如果导航控制器中已经有飘香菜单且有购物车了，就不进入购物车，而是返回上一个
    for (UIViewController *ctl in self.navigationController.viewControllers) {
        if ([ctl isKindOfClass:[MenuController class]]) {
            isMenu = YES;
            break;
        }
    }
    for (UIViewController *ctl in self.navigationController.viewControllers) {
        if ([ctl isKindOfClass:[FoodCarController class]]) {
            isCar = YES;
            break;
        }
    }
    if (isMenu && isCar) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        FoodCarController *car = [[FoodCarController alloc] init];
        [self.navigationController pushViewController:car animated:YES];
    }
}

#pragma mark 加减按钮点击
- (void)CarClickedWithData:(MenuModel *)data buttonType:(ButtonType)type
{
    //1 carTool更新购物车数据
    if (type == kButtonAdd) {
        [[CarTool sharedCarTool] addMenu:data];
    }else
    {
        [[CarTool sharedCarTool] plusMenu:data];
    }
    //2 购物车动画效果
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    int num = [self totalCarNum];
//    NSLog(@"加减完后的购物车数量%d",num);
    barButton.badgeValue = [NSString stringWithFormat:@"%ld", (long)num ];
//    NSLog(@"ID--%@, count--%@",data.ID,data.foodCount);
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

#pragma mark tableview cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

#pragma mark tableview 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _productsList.count;
}

#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuModel *data = _productsList[indexPath.row];
    //进入菜品详情页面
    DetailFoodController * ctl = [[DetailFoodController alloc] init];
    ctl.detailFoodIndex = data.ID;
    [self.navigationController pushViewController:ctl animated:YES];
}


#pragma mark 添加左侧的menu bar
- (void)addLeftMenuBar
{
    //1 背景view
    CGFloat h = KAppHeight - 44;
    UIView *leftView = [[UIView alloc] initWithFrame:Rect(0, 0, KLeftMenuW, h )];
    [self.view addSubview:leftView];
    leftView.backgroundColor = HexRGB(0xe0e0e0);
    
    //2 菜单栏item
    //2.1 计算item的宽高和起始坐标
    CGFloat itemW = KLeftMenuW - KDelX;
    CGFloat itemH = h / (KMenuItemCount + 1);
    CGFloat startX = KDelX;
    CGFloat startY = KDelX;
    NSUInteger count = _categoryList.count;
    for (int i = 0; i < count; i++) {
        CGFloat y = startY + itemH * i;
        MenuItem * item = [[MenuItem alloc] initWithFrame:Rect(startX, y, itemW, itemH)];
        item.delegate = self;
//        item.backgroundColor = HexRGB(0xe0e0e0);
        MenuCategory *category = _categoryList[i];
        item.contentLabel.text = category.name;
        item.categoryID = category.ID;
        [leftView addSubview:item];
        if (i == 0) {
            _selectedItem = item;
            _selectedItem.isSelected = YES;
        }
    }
    //获取分类产品列表
    [self loadCategoryFoodList];
    
}


#pragma mark //获取分类产品列表
- (void)loadCategoryFoodList
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [GetIndexHttpTool GetProductListWithSuccess:^(NSArray *data, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (_productsList.count > 0) {
            _productsList = nil;
        }
        if (data.count > 0) {
            //成功得到数据
            NSMutableArray *array = [NSMutableArray arrayWithArray:data];
            
            _productsList = array;
            [_table reloadData];
            
        }else
        {
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }

    } category_id:_selectedItem.categoryID  page:@"0" withFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }];
}

#pragma mark 飘香菜单栏代理
- (void)menuItemClieked:(MenuItem *)item
{
    if (item != _selectedItem) {
        _selectedItem.isSelected = NO;
        item.isSelected = YES;
        _selectedItem = item;
        
        //2 请求产品shuju
        [self loadCategoryFoodList];
    }
}
@end
