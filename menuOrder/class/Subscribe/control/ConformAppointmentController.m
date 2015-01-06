//
//  ConformAppointmentController.m
//  menuOrder
//
//  Created by promo on 15-1-4.
//  Copyright (c) 2015年 promo. All rights reserved.
//

#import "ConformAppointmentController.h"
#import "orderModel.h"
#import "CarTool.h"
#import "MenuModel.h"
#import "AdaptationSize.h"
#import "subscribeHttpTool.h"
#import "SystemConfig.h"

#define  YYBORDERW 9

#define YYBORDERWw 20
#define YYBORDERY 15
#define YYBOURERyy 25

@interface ConformAppointmentController ()<UIScrollViewDelegate>{
    NSMutableArray * _orderCategoryArray;
    CGFloat viewH;
    NSString *_totalPrice;
    UIScrollView *_backScroll;
}

@end

@implementation ConformAppointmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认预约";
    self.view.backgroundColor =HexRGB(0xcccccc);
    viewH = 0;
    _orderCategoryArray = [NSMutableArray array];
    [self addUIView];
}

-(void)addUIView
{
    
    UIScrollView *backScroll = [[UIScrollView alloc] initWithFrame:Rect(0, 0, kWidth, KAppHeight - 44)];
    [self.view addSubview:backScroll];
    _backScroll = backScroll;
    backScroll.showsHorizontalScrollIndicator = NO;
    backScroll.showsVerticalScrollIndicator = NO;
    backScroll.pagingEnabled = NO;
    backScroll.bounces = NO;
    backScroll.scrollEnabled = YES;
    backScroll.userInteractionEnabled = YES;
    backScroll.delegate = self;
    //        backScroll.tag = 9999;
    backScroll.contentSize = CGSizeMake(kWidth, [UIScreen mainScreen].applicationFrame.size.height);

    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(YYBORDERW, YYBORDERW, kWidth-YYBORDERW*2, 350)];
    backView.backgroundColor =[UIColor whiteColor];
    [backScroll addSubview:backView];
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

    NSMutableArray *array = [CarTool sharedCarTool].totalCarMenu;
    NSUInteger count = array.count;
    NSString *show = [NSString string];
    int price = 0;
    for (int i = 0; i < count; i++) {
        MenuModel * menu = array[i];
        NSString * name = menu.name;
        int num = menu.foodCount;
        NSString *total;
        if (num == 1) {
            total   = [NSString stringWithFormat:@""];
        }else
        {
            total  = [NSString stringWithFormat:@" *%d",num];
        }
        price += num * [menu.price intValue];
        show = [NSString stringWithFormat:@"%@%@",name,total];
        [_orderCategoryArray addObject:show];
    }
    
    
    NSString * contact = _data.contact;
    NSString *peopleNum = _data.people_num;
    NSString *useTime = _data.use_time;
    
    NSString *pricer = [NSString stringWithFormat:@"%d",price];
    NSArray *orderArr =@[@"  订单金额:                 元",[NSString stringWithFormat:@"  联系人:%@",contact],[NSString stringWithFormat:@"  就餐人数:%@",peopleNum],[NSString stringWithFormat:@"  就餐时间:%@",useTime]];
    
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
    orderLabel.text= pricer;
    _totalPrice = pricer;
    
    NSUInteger number = _orderCategoryArray.count;
    for (int l=0; l<number;l++) {
        
        UILabel *orderCategory =[[UILabel alloc]initWithFrame:CGRectMake(YYBORDERW+l%2*(kWidth-YYBORDERWw*6-YYBORDERW*6), YYBORDERWw+230+l/2*(YYBORDERY+20), (kWidth-YYBORDERWw*2-YYBORDERW*2)/2, 20 )];
        [backView addSubview:orderCategory];
        orderCategory.backgroundColor =[UIColor clearColor];
        orderCategory.font =[UIFont systemFontOfSize:PxFont(20)];
        orderCategory.textColor=HexRGB(0x605e5f);
        orderCategory.textAlignment=NSTextAlignmentCenter;
        orderCategory.text=_orderCategoryArray[l];
        
        if (l == _orderCategoryArray.count - 1) {
            viewH = CGRectGetMaxY(orderCategory.frame) + 10;
        }
    }
    
    UILabel *warning = [[UILabel alloc] init];
    warning.textColor=HexRGB(0x605e5f);
    warning.font =[UIFont systemFontOfSize:PxFont(20)];
    [backView addSubview:warning];
    warning.text = @"温馨提示：为了您的方便，请在预定的时间内到达，若超过10分钟未到达，我们将另行安排";
    CGFloat detailH = [AdaptationSize getSizeFromString:warning.text Font:[UIFont systemFontOfSize:PxFont(20)] withHight: CGFLOAT_MAX withWidth:kWidth-YYBORDERWw*2-YYBORDERW*2].height;
    warning.frame  = Rect(YYBORDERW, viewH, kWidth-YYBORDERWw*2-YYBORDERW*2, detailH);
    warning.numberOfLines = 0;
    warning.backgroundColor =[UIColor clearColor];
    warning.textColor=HexRGB(0x605e5f);
    
    viewH = CGRectGetMaxY(warning.frame) + 10;
    
    CGRect backF = backView.frame;
    backF.size.height = viewH;
    backView.frame = backF;
    
    UIButton *conform = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat conformY = CGRectGetMaxY(backView.frame) + 20;
    conform.frame = Rect(YYBORDERW, conformY, backView.frame.size.width, 30);
    [conform setBackgroundImage:LOADPNGIMAGE(@"home_ok") forState:UIControlStateNormal];
    [conform addTarget:self action:@selector(conform) forControlEvents:UIControlEventTouchUpInside];
    [backScroll addSubview:conform];
    
    //重新设置backScroll内容高度
    CGFloat scroH = CGRectGetMaxY(conform.frame) + 30;
    backScroll.contentSize = CGSizeMake(kWidth, scroH);
}

-(void)conform
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    //时间转时间戳
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:_data.use_time];
    
    _data.use_time = [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970]];
    
    [subscribeHttpTool postOrderWithSuccess:^(NSArray *data, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"预约成功，欢迎光临啊啊啊啊啊啊啊" location:MIDDLE];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } uid:uid addressID:_data.address_id addressContent:_data.address_content contact:_data.contact tel:_data.tel type:_data.type usetime:_data.use_time peopleNum:_data.people_num remark:_data.remark price:_totalPrice products:_data.products withFailure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }];
}
@end
