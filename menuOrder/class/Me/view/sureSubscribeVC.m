//
//  sureSubscribeVC.m
//  menuOrder
//
//  Created by YY on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "sureSubscribeVC.h"
#import "MysubscribeTool.h"
#import "myOrderDetailModel.h"
#define  YYBORDERW 9
#define YYBORDERWw 20
#define YYBORDERY 15
#define YYBOURERyy 25
@interface sureSubscribeVC ()
{
    NSMutableArray *_orderCategoryArray;
    myOrderDetailModel *orderModel ;
}
@end

@implementation sureSubscribeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"预约详情";
    self.view.backgroundColor =HexRGB(0xcccccc);
    _orderCategoryArray =[NSMutableArray array];
    [self addUIView];
    [self addLoadStatus];

}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark ---加载数据
-(void)addLoadStatus{
    [MysubscribeTool getOrderDetailId:_subcribeIndex statusesWithSuccess:^(NSArray *statues) {
        NSDictionary *dict =[statues objectAtIndex:0];
        orderModel =[[myOrderDetailModel alloc  ]init];
        orderModel.price =[dict objectForKey:@"price"];
        orderModel.contact =[dict objectForKey:@"contact"];
        orderModel.people_num =[dict objectForKey:@"people_num"];
        orderModel.use_time =[dict objectForKey:@"create_time"];
        orderModel.type =[dict objectForKey:@"type"];
//        if (![orderModel.products isEqualToString:@" "]) {
//            orderModel.products =[[dict objectForKey:@"products"]objectForKey:@"name"];
//
//        }else{
//
//        }
        orderModel.address =[dict objectForKey:@"address"];

        
        
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)addUIView
{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(YYBORDERW, YYBORDERW, kWidth-YYBORDERW*2, 350)];
    backView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:backView];
    backView.layer.cornerRadius=8;
    backView.layer.masksToBounds=YES;
    
    NSArray *titleArr =@[@"  订单详情",@"  已选菜品"];
    for (int i =0; i<2; i++) {
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [backView addSubview:titleBtn ];
        [titleBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sureSubscri_img%d",i]] forState:UIControlStateNormal];
        [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:HexRGB(0x605e5f) forState:UIControlStateNormal];
        titleBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        titleBtn.frame =CGRectMake(0, YYBORDERWw+i%2*185, 130, 30);
        
    }
    NSArray *orderArr =@[@"  订单金额:           元",[NSString stringWithFormat:@"  联系人:%@",orderModel.contact],[NSString stringWithFormat:@"  就餐人数:%@",orderModel.people_num],[NSString stringWithFormat:@"  就餐时间:%@",orderModel.use_time]];
    for (int p=0; p<4; p++) {
        UILabel *orderLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBORDERW, YYBORDERWw+40+p%4*(YYBORDERY+20), kWidth-YYBORDERWw*2-YYBORDERW*2, 20 )];
        [backView addSubview:orderLabel];
        orderLabel.backgroundColor =[UIColor clearColor];
        orderLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        orderLabel.textColor=HexRGB(0x605e5f);
        orderLabel.text=orderArr[p];
        
    }
    
    UILabel *orderLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBORDERW+80, YYBORDERWw+36, kWidth-YYBORDERWw*2-YYBORDERW*2, 30 )];
    [backView addSubview:orderLabel];
    orderLabel.backgroundColor =[UIColor clearColor];
    orderLabel.font =[UIFont systemFontOfSize:PxFont(26)];
    orderLabel.textColor=HexRGB(0x899c02);
    orderLabel.text=@"450";
    
    [_orderCategoryArray addObject:@"dddd"];
    [_orderCategoryArray addObject:@"sssssss"];
    [_orderCategoryArray addObject:@"sssssss"];
    [_orderCategoryArray addObject:@"sssssss"];

    for (int l=0; l<_orderCategoryArray.count; l++) {
    
        UILabel *orderCategory =[[UILabel alloc]initWithFrame:CGRectMake(YYBORDERW+l%2*(kWidth-YYBORDERWw*6-YYBORDERW*6), YYBORDERWw+230+l/2*(YYBORDERY+20), (kWidth-YYBORDERWw*2-YYBORDERW*2)/2, 20 )];
        [backView addSubview:orderCategory];
        orderCategory.backgroundColor =[UIColor clearColor];
        orderCategory.font =[UIFont systemFontOfSize:PxFont(20)];
        orderCategory.textColor=HexRGB(0x605e5f);
        orderCategory.textAlignment=NSTextAlignmentCenter;
        orderCategory.text=_orderCategoryArray[l];
    }

    
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
