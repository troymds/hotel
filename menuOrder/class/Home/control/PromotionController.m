//
//  PromotionController.m
//  menuOrder
//  优惠活动
//  Created by promo on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "PromotionController.h"
#import "PromotionCell.h"
#import "ActivityModel.h"
#import "UIImageView+WebCache.h"
#import "GetIndexHttpTool.h"
#import "DetailActivityController.h"
#import "CarTool.h"
#import "BBBadgeBarButtonItem.h"
#import "MenuModel.h"
#import "FoodCarController.h"

@interface PromotionController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_table;
    NSArray *_dataList;
    int _totaNum;
}
@end

@implementation PromotionController


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    //2 计算购物车数量
    if (self.navigationItem.rightBarButtonItem) {
        BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
        barButton.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self totalCarNum] ];
    }
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"优惠活动";
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
    barButton.badgeTextColor = HexRGB(0x899c02);
    barButton.badgeFont = [UIFont systemFontOfSize:11.5];
    barButton.badgeOriginX = 20;
    barButton.badgeOriginY = 0;
    barButton.shouldAnimateBadge = YES;
    self.navigationItem.rightBarButtonItem = barButton;
    
    [self loadActivityData];
}

-(void)ordeFood
{
    FoodCarController *car = [[FoodCarController alloc] init];
    [self.navigationController pushViewController:car animated:YES];
}

#pragma mark 获取活动数据
-(void)loadActivityData
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    [GetIndexHttpTool GetActivitiesWithSuccess:^(NSArray *data, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (data.count > 0) {
            //成功得到数据
            NSMutableArray *array = [NSMutableArray arrayWithArray:data];
            _dataList = array;
            [_table reloadData];
        }else
        {
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }

    } withFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }];
}

#pragma mark tableview cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    PromotionCell *cell = (PromotionCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell =[[PromotionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ActivityModel *data = _dataList[indexPath.row];
    cell.data = data;
    return cell;
}


#pragma mark tableview cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

#pragma mark tableview 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel *data = _dataList[indexPath.row];
    DetailActivityController *ctl = [[DetailActivityController alloc] init];
    ctl.ID = data.ID;
    [self.navigationController pushViewController:ctl animated:YES];
}
@end
