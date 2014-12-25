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

@interface PromotionController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_table;
    NSArray *_dataList;
}
@end

@implementation PromotionController


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
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
    
    [self loadActivityData];
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
    return 114;
}

#pragma mark tableview 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}


@end
