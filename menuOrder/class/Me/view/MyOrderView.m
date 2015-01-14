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
#import "DetailFoodController.h"
@interface MyOrderView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_sectionTitleArray;
    UIImageView *noStatusImg;
    NSMutableArray *_orderArray;
    
    NSMutableArray *_firArray;
    NSMutableArray *_secArray;
}


@end

@implementation MyOrderView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"我的点餐";
    self.view.backgroundColor=HexRGB(0xeeeeee);
    _sectionTitleArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _firArray = [[NSMutableArray alloc] initWithCapacity:0];
    _secArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self addTableView];
    [self addLoadStatus];
    [self addNoStatusImage];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
//没有数据时的状态
-(void)addNoStatusImage{
    noStatusImg =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-230)/2, (kHeight-100)/2, 230, 100)];
    [self.view addSubview:noStatusImg];
    noStatusImg.image =[UIImage imageNamed:@"noOrder_img"];
    
    noStatusImg.hidden =YES;
}
#pragma  mark ------显示指示器

#pragma mark ---加载数据
-(void)addLoadStatus
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];

    [MyOrderTool myOrderUid:uid statusesWithSuccess:^(NSMutableArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        
        [_sectionTitleArray addObjectsFromArray:statues];

        
        if (_sectionTitleArray.count>0)
        {
            _tableView.hidden =NO;
            noStatusImg.hidden =YES;
        }
        else
        {
            _tableView.hidden =YES;
            noStatusImg.hidden =NO;
        }
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }];
}
-(void)addTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-70) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.hidden = NO;
    _tableView.backgroundColor =HexRGB(0xeeeeee);
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundColor =[UIColor redColor];

    [self.view addSubview:_tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *timeModelArray =[_sectionTitleArray objectAtIndex:section];

    if (timeModelArray.count % 2 == 1)
    {
        return timeModelArray.count / 2 + 1;
    }
    
    return timeModelArray.count / 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndexfider =@"cell";
    MyOrderCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
    if (!cell) {
        cell=[[MyOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=HexRGB(0xeeeeee);
    }
    
    NSArray *timeModelArray =[_sectionTitleArray objectAtIndex:indexPath.section];
    
    
    if (_sectionTitleArray.count != 0)
    {
        
        [_firArray removeAllObjects];
        [_secArray removeAllObjects];
        
        
        myOrderListModel *orderListModel = nil;
        
        for (int i = 0; i<timeModelArray.count; i++)
        {
            
            orderListModel = [timeModelArray objectAtIndex:i];
            if (i%2==0)
            {
                [_firArray addObject:orderListModel];
            }
            else
            {
                [_secArray addObject:orderListModel];
            }
            
        }
        
        if (_firArray.count < 2)
        {
            cell.backImage.image=[UIImage imageNamed:@""];
        }
        else if(_firArray.count == 2)
        {
            if (indexPath.row==0)
            {
                cell.backImage.image =[UIImage imageNamed:@"up"];
            }else
            {
                cell.backImage.image =[UIImage imageNamed:@"down"];
            }
        }else
        {
            if (indexPath.row==0)
            {
                cell.backImage.image =[UIImage imageNamed:@"up"];
            }else if (indexPath.row < _firArray.count-1)
            {
                cell.backImage.image =[UIImage imageNamed:@"center"];
                
            }else{
                cell.backImage.image =[UIImage imageNamed:@"down"];
            }
        }

        
        myOrderListModel *firOrderModel = [_firArray objectAtIndex:indexPath.row];
        [cell.firMeOrderImage setImageWithURL:[NSURL URLWithString:firOrderModel.cover] placeholderImage:placeHoderImage2];
        cell.firMeOrderTitle.text = firOrderModel.name;
        UITapGestureRecognizer *firTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firTapClick:)];
        [cell.firMeOrderImage addGestureRecognizer:firTap];
        cell.firMeOrderImage.tag =100;
        
        if(_firArray.count == _secArray.count)
        {
            myOrderListModel *secOrderModel = [_secArray objectAtIndex:indexPath.row];
            [cell.secMeOrderImage setImageWithURL:[NSURL URLWithString:secOrderModel.cover] placeholderImage:placeHoderImage2];
            cell.secMeOrderTitle.text = secOrderModel.name;
            UITapGestureRecognizer *secTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firTapClick:)];
            [cell.secMeOrderImage addGestureRecognizer:secTap];
            cell.secMeOrderImage.tag =101;

        }
        else
        {
            if (indexPath.row < _secArray.count)
            {
                myOrderListModel *secOrderModel = [_secArray objectAtIndex:indexPath.row];
                [cell.secMeOrderImage setImageWithURL:[NSURL URLWithString:secOrderModel.cover] placeholderImage:placeHoderImage2];
                cell.secMeOrderTitle.text = secOrderModel.name;
                UITapGestureRecognizer *secTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firTapClick:)];
                [cell.secMeOrderImage addGestureRecognizer:secTap];
                cell.secMeOrderImage.tag =101;
            }
        }
        
        
 
    }
    
    return cell;
}

-(void)firTapClick:(UITapGestureRecognizer *)img
{
    
    MyOrderCell *cell =nil;
    
    if ([[img.view superview] isKindOfClass:[MyOrderCell class]])
    {
        cell = (MyOrderCell *)  [img.view superview];
    }else
    {
        cell = (MyOrderCell *)  [[img.view superview] superview];
    }
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    myOrderListModel *orderModel =nil;
    
    if (img.view.tag ==100)
    {
        orderModel =[_firArray objectAtIndex:indexPath.row];
    }else
    {
        orderModel =[_secArray objectAtIndex:indexPath.row];
    }
    
    DetailFoodController *detailVC=[[DetailFoodController alloc]init];
    detailVC.detailFoodIndex = orderModel.orderId;
    [self.navigationController pushViewController:detailVC animated:YES];

}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    headerView.backgroundColor=HexRGB(0xeeeeee);
    
    NSArray *timeModelArray = [_sectionTitleArray objectAtIndex:section];
    myOrderListModel *orderModel = [timeModelArray objectAtIndex:0];
    
    UIButton *sectionLabel =[UIButton buttonWithType:UIButtonTypeCustom];
    [sectionLabel setTitle:orderModel.createTime forState:UIControlStateNormal];
    [headerView addSubview:sectionLabel];
    sectionLabel.titleLabel.font=[UIFont systemFontOfSize:PxFont(22)];
    sectionLabel.imageEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 25);
    [sectionLabel setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
    [sectionLabel setImage:[UIImage imageNamed:@"MyOrder_image"] forState:UIControlStateNormal];
    
    sectionLabel.frame = CGRectMake(15, 0, 150, 30);
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


- (void)didReceiveMemoryWarning
{
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
