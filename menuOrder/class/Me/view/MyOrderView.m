//
//  MyOrderView.m
//  menuOrder
//
//  Created by YY on 14-12-12.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MyOrderView.h"
#import "MyOrderCell.h"
@interface MyOrderView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_sectionTitleArray;
}


@end

@implementation MyOrderView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的点餐";
    self.view.backgroundColor=HexRGB(0xeeeeee);
    _sectionTitleArray=[NSArray array];
    _sectionTitleArray=@[@"   未到期预约",@"   已过期预约"];
    [self addTableView];
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.hidden = NO;
    _tableView.backgroundColor =HexRGB(0xeeeeee);
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionTitleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndexfider =@"cell";
    MyOrderCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
    if (!cell) {
        cell=[[MyOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=HexRGB(0xeeeeee);
    }
    cell.MeOrderTitle.text=@"123333333";
    [cell.MeOrderImage setImageWithURL:[NSURL URLWithString:nil] placeholderImage:[UIImage imageNamed:@"header"]];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sectionTitleArray objectAtIndex:section];
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    headerView.backgroundColor=HexRGB(0xeeeeee);
    
    UIButton *sectionLabel =[UIButton buttonWithType:UIButtonTypeCustom];
    [sectionLabel setTitle:[_sectionTitleArray objectAtIndex:section] forState:UIControlStateNormal];
    [headerView addSubview:sectionLabel];
    sectionLabel.titleLabel.font=[UIFont systemFontOfSize:PxFont(22)];
    [sectionLabel setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
    [sectionLabel setImage:[UIImage imageNamed:@"MyOrder_image"] forState:UIControlStateNormal];
    
    sectionLabel.frame=CGRectMake(30, 0, 150, 40);
    return headerView;
}
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return _sectionTitleArray;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
