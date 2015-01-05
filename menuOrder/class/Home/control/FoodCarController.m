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

#define KDelX        5

@interface FoodCarController ()<UITableViewDataSource,UITableViewDelegate,CarClickedDelegate,DockDelegate,ChangeControllerDelegate>
{
    NSArray *_dataList;//购物车数据
    int _totaNum;
    UITableView *_table;
    CarOrderToolBar *_tooBar;
}
@end

@implementation FoodCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"点餐车";
    self.view.backgroundColor = HexRGB(0xe0e0e0);
//    self.delegate = self;
    MainController *main = ((AppDelegate *)[UIApplication sharedApplication].delegate).mainCtl;
    self.delegate = main;
    
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
    
    [self caculate];
}

#pragma mark 计算总份数和总价
-(void)caculate
{
    int totalPrice = 0;
    int totalNum = 0;
    NSUInteger count = _dataList.count;
    for (int i = 0; i < count; i++) {
        NSIndexPath *path =  [NSIndexPath indexPathForRow:i inSection:0];
        FoodOrderCell *cell = (FoodOrderCell *)[_table cellForRowAtIndexPath:path];
        if (cell.selectedBtn.selected) {
            MenuModel *data = _dataList[i];
            totalPrice += (data.foodCount * [data.price intValue]);
            totalNum += data.foodCount;
        }
    }
    _tooBar.money.text = [NSString stringWithFormat:@"%d",totalPrice];
    _tooBar.numOfFood.text = [NSString stringWithFormat:@"合计：%d份",totalNum];
}

#pragma mark 下一步
-(void)nextBtnClicked
{
     //首先购物车里要有东西，没有选中的要从购物车中删除
    if ([_tooBar.money.text intValue] > 0) {
        //重新整理购物车中的数据
        NSUInteger count = _dataList.count;
        for (int i = 0; i < count; i++) {
            NSIndexPath *path =  [NSIndexPath indexPathForRow:i inSection:0];
            FoodOrderCell *cell = (FoodOrderCell *)[_table cellForRowAtIndexPath:path];
            if (!cell.selectedBtn.selected) {
                MenuModel *data = _dataList[i];
                //直接在购物车中删除此数据
                NSMutableArray *car = [CarTool sharedCarTool].totalCarMenu;
                for (int i = 0; i < car.count; i++) {
                    MenuModel *carData = car[i];
                    if ([data.ID isEqualToString:carData.ID]) {
                        [car removeObject:carData];
                        NSLog(@"删除的data id 是%@",carData.ID);
                        break;
                    }
                }
                [NSKeyedArchiver archiveRootObject:[CarTool sharedCarTool].totalCarMenu toFile:kFilePath];
            }
        }
        //到预约页面
        subscribeViewViewController *ctl = [[subscribeViewViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
//        if ([self.delegate respondsToSelector:@selector(changeController)]) {
////
//            [self.delegate changeController];
//        }
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
            NSIndexPath *path =  [NSIndexPath indexPathForRow:i inSection:0];
            FoodOrderCell *cell = (FoodOrderCell *)[_table cellForRowAtIndexPath:path];
            cell.selectedBtn.selected = YES;
        }
        [self caculate];
    }else
    {//全部不选，数据清0
        NSUInteger count = _dataList.count;
        for (int i = 0; i < count; i++) {
            NSIndexPath *path =  [NSIndexPath indexPathForRow:i inSection:0];
            FoodOrderCell *cell = (FoodOrderCell *)[_table cellForRowAtIndexPath:path];
            cell.selectedBtn.selected = NO;
        }
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
    [cell.selectedBtn addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
    MenuModel *data = _dataList[indexPath.row];
    cell.data = data;
    cell.indexPath = indexPath.row;
    return cell;
}

#pragma mark 点击cell选中按钮
-(void)cellSelected:(UIButton *)btn
{
    //取消选中时，
    btn.selected = !btn.selected;
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
