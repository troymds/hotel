//
//  FoodRecommendController.m
//  menuOrder
//  菜品推荐 
//  Created by promo on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "FoodRecommendController.h"
#import "foodRecommendCell.h"
#import "MenuModel.h"
#import "UIImageView+WebCache.h"
#import "GetIndexHttpTool.h"
#import "FoodCarController.h"
#import "CarTool.h"
#import "BBBadgeBarButtonItem.h"
#import "DetailFoodController.h"

@interface FoodRecommendController ()<UITableViewDataSource,UITableViewDelegate,CarClickedDelegate>
{
    NSArray *_dataList;
    UITableView *_table;
    int _totaNum;
}
@end

@implementation FoodRecommendController


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
    
    self.title = @"菜品推荐";
    self.view.backgroundColor = HexRGB(0xe0e0e0);
    
    //1 tableview
    UITableView *table = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, kWidth, KAppHeight - 44) style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    table.backgroundColor =[UIColor clearColor];
    table.showsVerticalScrollIndicator = NO;
    table.delegate =self;
    table.dataSource = self;
    _table = table;
    
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
    barButton.badgeFont = [UIFont systemFontOfSize:11.5];
    barButton.badgeOriginX = 20;
    barButton.badgeOriginY = 0;
    barButton.shouldAnimateBadge = YES;
    self.navigationItem.rightBarButtonItem = barButton;
    
    [self loadHotData];
    [self buildUI];
}


-(void)ordeFood
{
    FoodCarController *car = [[FoodCarController alloc] init];
    
    [self.navigationController pushViewController:car animated:YES];
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


#pragma mark 获取热门推荐
-(void)loadHotData
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    [GetIndexHttpTool GettHotProductListWithSuccess:^(NSArray *data, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (data.count > 0) {
            //成功得到数据
            NSMutableArray *array = [NSMutableArray arrayWithArray:data];
            _dataList = array;
            [_table reloadData];
            [self buildUI];
        }else
        {
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }

    } page:@"1" withFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }];
}
-(void)buildUI
{

}

#pragma mark tableview cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    foodRecommendCell *cell = (foodRecommendCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell =[[foodRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MenuModel *data = _dataList[indexPath.row];
    cell.data = data;
    cell.delegate = self;
    cell.indexPath = indexPath.row;
    return cell;
}

#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MenuModel *data = _dataList[indexPath.row];
    //进入菜品详情页面
    DetailFoodController * ctl = [[DetailFoodController alloc] init];
    ctl.detailFoodIndex = data.ID;
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark tableview cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

#pragma mark tableview 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

@end
