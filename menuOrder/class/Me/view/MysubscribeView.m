//
//  MysubscribeView.m
//  menuOrder
//
//  Created by YY on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MysubscribeView.h"
#import "subscribeCell.h"
#import "sureSubscribeVC.h"
#import "MysubscribeTool.h"
#import "MysubscribeModel.h"
#import "MysubscribeTool.h"
#import "subscribeModel.h"
@interface MysubscribeView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_sectionTitleArray;
    NSMutableArray *_normalArray;
    NSMutableArray *_overdueArray;
    UIImageView *noStatusImg;
    
}
@end

@implementation MysubscribeView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"我的预约";
    self.view.backgroundColor=HexRGB(0xeeeeee);
    _sectionTitleArray=[NSArray array];

    _sectionTitleArray=@[@"   未到期预约",@"   已过期预约"];
    
    
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
    noStatusImg.image =[UIImage imageNamed:@"noSubscribe_img"];
    noStatusImg.hidden =YES;
}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    
}

#pragma mark ---加载数据
-(void)addLoadStatus
{
  [MysubscribeTool statusesWithSuccess:^(NSMutableArray *statues) {
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

      if (statues.count>0) {
          _tableView.hidden =NO;
          noStatusImg.hidden =YES;
      }
      else{
          _tableView.hidden =YES;
          noStatusImg.hidden =NO;
      }
      _normalArray = [statues objectAtIndex:0];
      _overdueArray = [statues objectAtIndex:1];
      
      [_tableView reloadData];
  } orderListUid_ID:@"uid" failure:^(NSError *error) {
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      [RemindView showViewWithTitle:@"网络错误！" location:MIDDLE];

  }];
}
-(void)addTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.hidden = YES;
    _tableView.backgroundColor =HexRGB(0xeeeeee);
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_normalArray.count==0) {
        _tableView.frame =CGRectMake(0, -20, kWidth, kHeight-44);
    }else{
        _tableView.frame =CGRectMake(0, 0, kWidth, kHeight);
        
    }
    
    [self.view addSubview:_tableView];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionTitleArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0)
    {
        return _normalArray.count;
    }
    else
    {
        return _overdueArray.count;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndexfider =@"cell";
    subscribeCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
    if (!cell) {
        cell=[[subscribeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=HexRGB(0xeeeeee);
    }
   
    subscribeModel *subModel;
    if (indexPath.section == 0)
    {
        subModel = [_normalArray objectAtIndex:indexPath.row];
    }
    else
    {
        subModel = [_overdueArray objectAtIndex:indexPath.row];
    }
    
    
    cell.MeSubscribeTimeLabel.text=[NSString stringWithFormat:@"时间：%@",subModel.use_time] ;
    cell.MeSubscribeCategoryLabel.text=[NSString stringWithFormat:@"类型：%@",subModel.type];
    cell.MeSubscribeNumLabel.text=[NSString stringWithFormat:@"就餐人数：%@",subModel.people_num];
    [cell.MeSubscribeImage setImageWithURL:[NSURL URLWithString:subModel.cover] placeholderImage:placeHoderImage2];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    subscribeModel *subModel;
    if (indexPath.section == 0)
    {
        subModel = [_normalArray objectAtIndex:indexPath.row];
    }
    else
    {
        subModel = [_overdueArray objectAtIndex:indexPath.row];
    }
    sureSubscribeVC *sureVc=[[sureSubscribeVC alloc]init];
    sureVc.subcribeIndex =subModel.subscribeID;
    
    [self.navigationController pushViewController:sureVc animated:YES];
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
    [sectionLabel setImage:[UIImage imageNamed:[NSString stringWithFormat:@"meSubscribe_Image%ld",(long)section]] forState:UIControlStateNormal];
    
    if (_normalArray.count>0) {
        if (section==0) {
            sectionLabel.hidden =NO;
        }else{
            sectionLabel.hidden = YES;
        }
    }if (_overdueArray.count>0) {
        if (section==1) {
            sectionLabel.hidden =NO;
        }else{
            sectionLabel.hidden = YES;
        }
    }

    sectionLabel.frame=CGRectMake(30, -5, 150, 40);
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
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
