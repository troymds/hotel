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

#define KMenuItemCount  9
#define KLeftMenuW   80
#define KDelX        5

@interface MenuController ()<MenuItemDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MenuItem *_selectedItem;
}
@end

@implementation MenuController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"飘香菜单";
    self.view.backgroundColor = HexRGB(0xe0e0e0);
    
    UIButton *foodcar = [UIButton buttonWithType:UIButtonTypeCustom];
    foodcar.frame = Rect(0, 0, 30, 30);
    [foodcar addTarget:self action:@selector(orderFood) forControlEvents:UIControlEventTouchUpInside];
    [foodcar setBackgroundImage:LOADPNGIMAGE(@"cart3") forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:foodcar];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self addLeftMenuBar];

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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell =[[MenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(8,94, 222, 1)];
        lineView.backgroundColor = HexRGB(0xd5d5d5);
        [cell.contentView addSubview:lineView];
    }
    MenuModel *data = [[MenuModel alloc] init];
    cell.data = data;
    [cell.addBun addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.plusBtn addTarget:self action:@selector(plusBtnClieked:) forControlEvents:UIControlEventTouchUpInside];
    cell.indexPath = indexPath.row;
    return cell;
}

-(void)orderFood
{
    FoodCarController *car = [[FoodCarController alloc] init];
    [self.navigationController pushViewController:car animated:YES];
}

#pragma mark 添加按钮点击事件
- (void) addBtnClicked:(UIButton *)addBtn
{
    NSLog( @"addBtnClicked--%ld",(long)addBtn.tag);
}

#pragma mark 减少按钮点击事件
- (void) plusBtnClieked:(UIButton *)plusBtn
{
    NSLog( @"plusBtnClicked--%ld",(long)plusBtn.tag);
}

#pragma mark tableview cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

#pragma mark tableview 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    for (int i = 0; i < KMenuItemCount; i++) {
        CGFloat y = startY + itemH * i;
        MenuItem * item = [[MenuItem alloc] initWithFrame:Rect(startX, y, itemW, itemH)];
        item.delegate = self;
        [leftView addSubview:item];
        if (i == 0) {
            _selectedItem = item;
            _selectedItem.isSelected = YES;
        }
    }
}

#pragma mark 飘香菜单栏代理
- (void)menuItemClieked:(MenuItem *)item
{
    _selectedItem.isSelected = NO;
    item.isSelected = YES;
    _selectedItem = item;
    
}
@end
