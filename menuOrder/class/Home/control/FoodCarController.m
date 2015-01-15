//
//  FoodCarController.m
//  menuOrder
//  点餐车
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "FoodCarController.h"
#import "FoodOrderCell.h"
#import "CarOrderToolBar.h"
#import "NiceFoodModel.h"
#import "MenuModel.h"
#import "CarTool.h"
#import "CarClickedDelegate.h"
#import "RemindView.h"
#import "Dock.h"
#import "MainController.h"
#import "AppDelegate.h"
#import "subscribeViewViewController.h"
#import "MenuController.h"

#define KDelX        5
#define KNodataX    40
@interface FoodCarController ()<UITableViewDataSource,UITableViewDelegate,CarClickedDelegate,DockDelegate,ChangeControllerDelegate>
{
    NSArray *_dataList;//购物车数据
    int _totaNum;
    UITableView *_table;
    CarOrderToolBar *_tooBar;
    UIImageView *_noDataView;
}
@end

@implementation FoodCarController

- (void)viewWillAppear:(BOOL)animated
{
    if (_dataList && _dataList.count > 0) {
        _noDataView.hidden = YES;
    }else
    {
        _noDataView.hidden = NO;
    }
    //重新计算,全部全选
    if (_table) {
        [self reCaculate];
    }
}

-(void)reCaculate
{
    int totalPrice = 0;
    int totalNum = 0;
    NSUInteger count = _dataList.count;
    if (count > 0) {
        for (int i = 0; i < count; i++) {
            MenuModel *data = _dataList[i];
            data.isChosen = YES;
            totalPrice += (data.foodCount * [data.price intValue]);
            totalNum += data.foodCount;
        }
        _tooBar.money.text = [NSString stringWithFormat:@"%d",totalPrice];
        _tooBar.numOfFood.text = [NSString stringWithFormat:@"合计：%d份",totalNum];
        _tooBar.allSelectedBtn.selected = YES;
    }else
    {
        _tooBar.money.text = [NSString stringWithFormat:@"%d",totalPrice];
        _tooBar.numOfFood.text = [NSString stringWithFormat:@"合计：%d份",totalNum];
        _tooBar.allSelectedBtn.selected = NO;
    }
    [_table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"点餐车";
    self.view.backgroundColor = HexRGB(0xe0e0e0);
    
    MainController *main = ((AppDelegate *)[UIApplication sharedApplication].delegate).mainCtl;
    self.delegate = main;
    
    UIButton *rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:LOADPNGIMAGE(@"nav_menu") forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:LOADPNGIMAGE(@"nav_menu_pre") forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(goMenu) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = Rect(0, 0, 30, 30);
    UIBarButtonItem *rehtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rehtnItem;
    
    _dataList = [CarTool sharedCarTool].totalCarMenu;
    //1 tableview
    CGFloat tableX = KDelX;
    CGFloat tableY = KDelX;
    CGFloat tableH = KAppHeight - 44 - tableY - 60;
    UITableView *table = [[UITableView alloc] initWithFrame: CGRectMake(tableX, tableY, kWidth - KDelX * 2, tableH) style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    table.backgroundColor =[UIColor clearColor];
    table.showsVerticalScrollIndicator = NO;
    table.delegate =self;
    table.dataSource = self;
    _table = table;
    [_table reloadData];
    
    //2 底边工具栏
    CGFloat toolViewH = 60;
    CGFloat toolViewY = KAppHeight - toolViewH - 44;
    CarOrderToolBar *toolBar = [[CarOrderToolBar alloc] initWithFrame:Rect(0, toolViewY, kWidth, toolViewH)];
    toolBar.backgroundColor = HexRGB(0xf5f5f5);
    [toolBar.nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [toolBar.allSelectedBtn addTarget:self action:@selector(allBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toolBar];
    _tooBar = toolBar;
    
    [self addNoDataView];
    [self caculate];
}

#pragma mark 没有数据时
-(void)addNoDataView
{
    _noDataView = [[UIImageView alloc] initWithFrame:Rect((kWidth-230)/2, (kHeight-100)/2, 230, 100)];
    [self.view addSubview:_noDataView];
    _noDataView.image =[UIImage imageNamed:@"noFood"];
    if (_dataList.count > 0) {
        _noDataView.hidden = YES;
    }else
    {
        _noDataView.hidden = NO;
    }
}

#pragma mark 进入飘香菜单
- (void)goMenu
{
    MenuController *ctl = [[MenuController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark 计算总份数和总价
-(void)caculate
{
    int totalPrice = 0;
    int totalNum = 0;
    bool isAllSelected = YES;
    NSUInteger count = _dataList.count;
    if (count > 0) {
//        _noDataView.hidden = YES;
        for (int i = 0; i < count; i++) {
            //因为不能得到除可视范围内的cell ,所以要根据cell里面的  data来计算数据
            MenuModel *data = _dataList[i];
            if (data.isChosen) {// 被选中的
                totalPrice += (data.foodCount * [data.price intValue]);
                totalNum += data.foodCount;
            }
            else
            {
                isAllSelected = NO;//只要有一个没有选中，则不能全选
            }
        }
    }else
    {
//        _noDataView.hidden = NO;
        isAllSelected = NO;//购物车里没有数据，肯定没有全选
    }
    _tooBar.money.text = [NSString stringWithFormat:@"%d",totalPrice];
    _tooBar.numOfFood.text = [NSString stringWithFormat:@"合计：%d份",totalNum];
    _tooBar.allSelectedBtn.selected = isAllSelected?YES: NO;
}

#pragma mark 下一步
-(void)nextBtnClicked
{
     //首先购物车里要有东西，没有选中的要从购物车中删除
    if ([_tooBar.money.text intValue] > 0) {
        //重新整理购物车中的数据
        NSUInteger count = _dataList.count;
        NSMutableArray *temDeleteArray = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            MenuModel *data = _dataList[i];
            if (!data.isChosen){
                //直接在购物车中删除此数据
                [temDeleteArray addObject:data];
            }
        }
        [[CarTool sharedCarTool] deleteDataWithArray:temDeleteArray];
        //到预约页面
        subscribeViewViewController *ctl = [[subscribeViewViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];

    }else
    {
        [RemindView showViewWithTitle:@"您还没有选择菜单，亲！" location:MIDDLE];
    }
}

#pragma mark 全选:
-(void)allBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    //分全选，还是没有
    if (btn.selected) {
        //全选,遍历所有cell，cell都是选中状态，计算价格
        NSUInteger count = _dataList.count;
        for (int i = 0; i < count; i++) {
            MenuModel *data = _dataList[i];
            data.isChosen = YES;
        }
        [_table reloadData];
        [self caculate];
        
    }else
    {//全部不选，数据清0
        NSUInteger count = _dataList.count;
        for (int i = 0; i < count; i++) {
            MenuModel *data = _dataList[i];
            data.isChosen = NO;
        }
        [_table reloadData];
        _tooBar.money.text = @"0";
        _tooBar.numOfFood.text = [NSString stringWithFormat:@"合计：%d份",0];
        
    }
}

#pragma mark tableview cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    FoodOrderCell *cell = (FoodOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell =[[FoodOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    MenuModel *data = _dataList[indexPath.row];
    cell.data = data;
    cell.indexPath = indexPath.row;
    return cell;
}

#pragma mark cell选中按钮点击事件
- (void)FoodOrderCell:(FoodOrderCell *)cell
{
    [self caculate];
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
    //2 计算
    [self caculate];
}

#pragma mark tableview cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark tableview 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

@end
