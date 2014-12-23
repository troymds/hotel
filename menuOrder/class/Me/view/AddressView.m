//
//  AddressView.m
//  menuOrder
//
//  Created by YY on 14-12-12.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "AddressView.h"
#import "AddressCell.h"
#import "address_addView.h"
#import "modificationAddress.h"
#import "addressListTool.h"
#import "addressListModel.h"
@interface AddressView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_addressArray;
    UIImageView *noStatusImg;
}


@end

@implementation AddressView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"地址管理";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_add_pre" highlightedSearch:@"nav_add" target:(self) action:@selector(categoryBtnClick)];
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
    noStatusImg =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-230)/2, ((kHeight-100)/8)*5, 230, 100)];
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
        [RemindView showViewWithTitle:@"网络错误！" location:MIDDLE];
        
    }];
    
}

-(void)categoryBtnClick
{
    address_addView *addVc=[[address_addView alloc]init];
    [self.navigationController pushViewController:addVc animated:YES];
}

-(void)addTableView
{
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
    
    [cell.delegateBtn addTarget:self action:@selector(delegateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegateBtn.tag = 100;
    
    return cell;
}
-(void)delegateBtnClick:(UIButton *)delete
{
    // 根据cell的子视图 去找当前的cell , 在这里为了找到当前的cell 可以使用[[[[delegate superview] superview] ...] class]; 只到 class的类名为：CustomCell的名为止
    
    [self addMBprogressView];
    AddressCell *currentCell = (AddressCell *)[[[delete superview] superview] superview];
    NSLog(@"class For cell %@", [[[delete superview] superview] superview]);
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:currentCell];
    addressListModel *addressModel =[_addressArray objectAtIndex:indexPath.row];
    
    [addressListTool statusesWithSuccessDelete:^(id statues) {
        
        [self addLoadStatus];
        
    } address_Id:addressModel.addressId failure:^(NSError *error) {
        
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误！" location:MIDDLE];
    }];
    
    
    
    
    
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
    
    modificationAddress *modification =[[modificationAddress alloc]init];
    modification.updateIndex=addressModel.addressId;
    modification.updateAddressStr=addressModel.content;
    modification.updateNameStr =addressModel.contact;
    modification.updateTelStr=addressModel.tel;
    [self.navigationController pushViewController:modification animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
