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
}


@end

@implementation AddressView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"地址管理";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_add" highlightedSearch:@"nav_add" target:(self) action:@selector(categoryBtnClick)];
    _addressArray=[NSMutableArray array];
    [self addTableView];
    [self addLoadStatus];

}
-(void)addLoadStatus{
   
    [addressListTool statusesWithSuccess:^(NSArray *statues) {
        [_addressArray addObjectsFromArray:statues];
        [_tableView reloadData];
    } uid_ID:@"uid" failure:^(NSError *error) {
        
    }];
    
}
-(void)categoryBtnClick{
    address_addView *addVc=[[address_addView alloc]init];
    [self.navigationController pushViewController:addVc animated:YES];
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
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSUInteger row =[indexPath row];
//    [_addressArray removeObjectAtIndex:row];
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    
//}
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
    
    return cell;
}
-(void)delegateBtnClick:(UIButton *)delegate{
    
    AddressCell *currentCell = (AddressCell *)[[[delegate superview] superview] superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:currentCell];
    [_addressArray removeObjectAtIndex:indexPath.row];

    NSArray *index = [NSArray arrayWithObject:indexPath];
    [_tableView deleteRowsAtIndexPaths:index withRowAnimation:UITableViewRowAnimationLeft];
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    modificationAddress *modification =[[modificationAddress alloc]init];
    [self.navigationController pushViewController:modification animated:YES];
   }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
