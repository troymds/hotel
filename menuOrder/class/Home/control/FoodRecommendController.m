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

@interface FoodRecommendController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FoodRecommendController


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
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
    
    [self buildUI];
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
    MenuModel *data = [[MenuModel alloc] init];
    cell.data = data;
    [cell.addBun addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.plusBtn addTarget:self action:@selector(plusBtnCliek:) forControlEvents:UIControlEventTouchUpInside];
    cell.indexPath = indexPath.row;
    return cell;
}

#pragma mark 添加按钮点击事件
- (void) addBtnClick:(UIButton *)addBtn
{
    NSLog( @"addBtnClicked--%ld",(long)addBtn.tag);
}

#pragma mark 减少按钮点击事件
- (void) plusBtnCliek:(UIButton *)plusBtn
{
    NSLog( @"plusBtnClicked--%ld",(long)plusBtn.tag);
}

#pragma mark tableview cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 334;
}

#pragma mark tableview 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

@end
