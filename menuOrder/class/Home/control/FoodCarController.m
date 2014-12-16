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

#define KDelX        5

@interface FoodCarController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FoodCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"点餐车";
    self.view.backgroundColor = HexRGB(0xe0e0e0);
    
    //1 tableview
    CGFloat tableX = KDelX;
    CGFloat tableY = KDelX;
    CGFloat tableH = KAppHeight - 44 - tableY - 60;
    UITableView *table = [[UITableView alloc] initWithFrame: CGRectMake(tableX, tableY, kWidth - KDelX * 2, tableH) style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    table.backgroundColor =[UIColor whiteColor];
    table.showsVerticalScrollIndicator = NO;
    table.delegate =self;
    table.dataSource = self;
    
    //2 底边工具栏
    CGFloat toolViewH = 60;
    CGFloat toolViewY = KAppHeight - toolViewH - 44;
    CarOrderToolBar *toolBar = [[CarOrderToolBar alloc] initWithFrame:Rect(0, toolViewY, kWidth, toolViewH)];
    toolBar.backgroundColor = HexRGB(0xf5f5f5);
    NiceFoodModel *data = [[NiceFoodModel alloc] init];
    toolBar.data = data;
    [self.view addSubview:toolBar];
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
//    MenuModel *data = [[MenuModel alloc] init];
//    cell.data = data;
//    [cell.addBun addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.plusBtn addTarget:self action:@selector(plusBtnClieked:) forControlEvents:UIControlEventTouchUpInside];
//    cell.indexPath = indexPath.row;
    return cell;
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

@end
