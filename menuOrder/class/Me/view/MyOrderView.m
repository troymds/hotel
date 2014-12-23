//
//  MyOrderView.m
//  menuOrder
//
//  Created by YY on 14-12-12.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MyOrderView.h"
#import "MyOrderCell.h"
#import "MyOrderTool.h"
#import "myOrderListModel.h"
@interface MyOrderView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_sectionTitleArray;
    UIImageView *noStatusImg;
    NSMutableArray *_orderArray;
}


@end

@implementation MyOrderView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"我的点餐";
    self.view.backgroundColor=HexRGB(0xeeeeee);
    _sectionTitleArray=[NSMutableArray array];
//    _sectionTitleArray=@[@"   未到期预约",@"   未到期预约",@"   已过期预约"];
    [self addTableView];
    [self addLoadStatus];
    [self addNoStatusImage];
    [self addMBprogressView];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
//没有数据时的状态
-(void)addNoStatusImage{
    noStatusImg =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-230)/2, ((kHeight-100)/8)*5, 230, 100)];
    [self.view addSubview:noStatusImg];
    noStatusImg.image =[UIImage imageNamed:@"noOrder_img"];
    noStatusImg.hidden =YES;
}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    
}
#pragma mark ---加载数据
-(void)addLoadStatus{
    [MyOrderTool myOrderUid:@"uid" statusesWithSuccess:^(NSArray *statues) {
        myOrderListTimeModel *ordeTimeModel =[[myOrderListTimeModel alloc]init];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        for (NSDictionary *dict in statues) {
        
        }
        

        if (statues.count>0) {
            _tableView.hidden =YES;
            noStatusImg.hidden =NO;
        }
        else{
            _tableView.hidden =YES;
            noStatusImg.hidden =NO;
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误！" location:MIDDLE];
    }];
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
    return _sectionTitleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndexfider =@"cell";
    MyOrderCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
    if (!cell) {
        cell=[[MyOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=HexRGB(0xeeeeee);
    }
    if (_sectionTitleArray.count==1) {
        cell.backImage.image=[UIImage imageNamed:@""];
    }else{
        if (indexPath.row==0) {
            cell.backImage.image =[UIImage imageNamed:@"up"];
        }else if (indexPath.row ==_sectionTitleArray.count-1) {
            cell.backImage.image =[UIImage imageNamed:@"down"];
            
        }else{
            cell.backImage.image =[UIImage imageNamed:@"center"];
            
        }
    }
    
    myOrderListModel *orderModel =[_sectionTitleArray objectAtIndex:indexPath.row];
//    cell.MeOrderTitle.text=orderModel.name;
    cell.MeOrderImage.image=[UIImage imageNamed:@"header"];
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
    
    sectionLabel.frame=CGRectMake(30, -5, 150, 40);
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
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
