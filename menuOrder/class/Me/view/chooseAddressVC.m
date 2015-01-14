//
//  chooseAddressVC.m
//  menuOrder
//
//  Created by YY on 14-12-31.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "chooseAddressVC.h"
#import "AddressCell.h"
#import "addressListTool.h"
#import "addressListModel.h"
@interface chooseAddressVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_addressArray;
    UIImageView *noStatusImg;
    addressListModel *addModel;
}


@end

@implementation chooseAddressVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择地址";
    self.view.backgroundColor =HexRGB(0xeeeeee);
    _addressArray=[NSMutableArray array];
    
    [self addTableView];
    [self addMBprogressView];
    [self addNoStatusImage];
    
    
}
#pragma  mark ------显示指示器
-(void)addMBprogressView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
}
-(void)viewWillAppear:(BOOL)animated
{
    [self addLoadStatus];
    self.navigationController.navigationBarHidden = NO;
}
//没有数据时的状态
-(void)addNoStatusImage{
    noStatusImg =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-230)/2, (kHeight-100)/2, 230, 100)];
    [self.view addSubview:noStatusImg];
    noStatusImg.image =[UIImage imageNamed:@"subscib_img"];
    noStatusImg.hidden =YES;
}

#pragma mark ---加载数据
-(void)addLoadStatus
{
    
    [addressListTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (statues.count>0) {
            _tableView.hidden =NO;
            noStatusImg.hidden =YES;
        }
        else{
            _tableView.hidden =YES;
            noStatusImg.hidden =NO;
        }
        
        [_addressArray removeAllObjects];
        
        
        [_addressArray addObjectsFromArray:statues];
        [_tableView reloadData];
    } uid_ID:@"uid" failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:MIDDLE];
        
    }];
    
}


-(void)addTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.hidden = NO;
    _tableView.backgroundColor =HexRGB(0xeeeeee);
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _addressArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndexfider =@"cell";
    AddressCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
    if (!cell) {
        cell=[[AddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=HexRGB(0xeeeeee);
    }
    addressListModel *addressModel =[_addressArray objectAtIndex:indexPath.row];
    cell.numberLabel.text=addressModel.tel;
    cell.nameLabel.text=addressModel.contact;
    cell.addressLabel.text=addressModel.content;
    cell.delegateBtn.hidden =YES;
    cell.lineView .hidden=YES;
    
    
    return cell;
}
-(void)delegateBtnClick:(UIButton *)delete
{
    AddressCell *currentCell = (AddressCell *)[[[delete superview] superview] superview];
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:currentCell];
    addModel =[_addressArray objectAtIndex:indexPath.row];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否删除地址" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    
    [alert show];
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self addMBprogressView];
        [addressListTool statusesWithSuccessDelete:^(id statues) {
            
            [self addLoadStatus];
            
        } address_Id:addModel.addressId failure:^(NSError *error) {
            
            
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [RemindView showViewWithTitle:offline location:MIDDLE];
        }];
        
        
    }else{
        
    }
    
}
- (void)stopHUD:(NSIndexPath *)indexPath
{
    [_addressArray removeObjectAtIndex:indexPath.row];
    
    NSMutableArray *index = [NSMutableArray arrayWithObject:indexPath];
    [_tableView deleteRowsAtIndexPaths:index withRowAnimation:UITableViewRowAnimationLeft];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    addressListModel *addressModel =[_addressArray objectAtIndex:indexPath.row];
    if ([_delegate respondsToSelector:@selector(passAddress:)]) {
        [_delegate passAddress:addressModel];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
