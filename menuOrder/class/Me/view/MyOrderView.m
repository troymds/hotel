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
}


@end

@implementation MyOrderView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"我的点餐";
    self.view.backgroundColor=HexRGB(0xeeeeee);
    _sectionTitleArray=[[NSMutableArray alloc] initWithCapacity:0];
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
        [RemindView showViewWithTitle:@"网络错误！" location:MIDDLE];
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
    myOrderListTimeModel *timeModel =[_sectionTitleArray objectAtIndex:section];
    
    if (timeModel.timeArray.count % 2 == 1)
    {
        return timeModel.timeArray.count / 2 + 1;
    }
    
    return timeModel.timeArray.count / 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndexfider =@"cell";
    MyOrderCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
    if (!cell) {
        cell=[[MyOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=HexRGB(0xeeeeee);
    }
    
    if (_sectionTitleArray.count < 3)
    {
        cell.backImage.image=[UIImage imageNamed:@""];
    }
    else if(_sectionTitleArray.count == 4)
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
        }else if (indexPath.row ==_sectionTitleArray.count-1)
        {
            cell.backImage.image =[UIImage imageNamed:@"down"];
            
        }else{
            cell.backImage.image =[UIImage imageNamed:@"center"];
            
        }
    }
    
    if (_sectionTitleArray.count != 0)
    {
        myOrderListTimeModel *timeModel =[_sectionTitleArray objectAtIndex:indexPath.section];
        myOrderListModel *orderListModel = nil;
        
        for (int i = 0; i<timeModel.timeArray.count; i++)
        {
            
            orderListModel = [timeModel.timeArray objectAtIndex:i];
            if (i%2==0)
            {
                [cell.firMeOrderImage setImageWithURL:[NSURL URLWithString:orderListModel.cover] placeholderImage:placeHoderImage2];
                cell.firMeOrderTitle.text = orderListModel.name;
                UITapGestureRecognizer *firTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firTapClick:)];
                [cell.firMeOrderImage addGestureRecognizer:firTap];
                cell.firMeOrderImage.tag =100;
                self.orderIndex1 =orderListModel.orderId;
            }
            else
            {
                [cell.secMeOrderImage setImageWithURL:[NSURL URLWithString:orderListModel.cover] placeholderImage:placeHoderImage2];
                cell.secMeOrderTitle.text = orderListModel.name;
                UITapGestureRecognizer *secTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secTapClick:)];
                [cell.secMeOrderImage addGestureRecognizer:secTap];
                cell.firMeOrderImage.tag =101;

                self.orderIndex2 =orderListModel.orderId;
            }
        }
 
    }
    
    
    
    return cell;
}

-(void)firTapClick:(UITapGestureRecognizer *)img{
   
    DetailFoodController *detailVC=[[DetailFoodController alloc]init];
    detailVC.detailFoodIndex =self.orderIndex1;
    [self.navigationController pushViewController:detailVC animated:YES];

}
-(void)secTapClick:(UITapGestureRecognizer *)img{
    
    DetailFoodController *detailVC=[[DetailFoodController alloc]init];
    detailVC.detailFoodIndex =self.orderIndex2;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    headerView.backgroundColor=HexRGB(0xeeeeee);
    
    myOrderListTimeModel *timeModel = [_sectionTitleArray objectAtIndex:section];
    
    
    UIButton *sectionLabel =[UIButton buttonWithType:UIButtonTypeCustom];
    [sectionLabel setTitle:timeModel.timeTitle forState:UIControlStateNormal];
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
