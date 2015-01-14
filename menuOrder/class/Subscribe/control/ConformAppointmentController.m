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
#import "MysubscribeView.h"

#define  YYBORDERW 9

#define YYBORDERWw 20
#define YYBORDERY 15
#define YYBOURERyy 25
#define KSpace 8
@interface ConformAppointmentController ()<UIScrollViewDelegate>{
    NSMutableArray * _orderCategoryArray;
    CGFloat viewH;
    NSString *_totalPrice;
    UIScrollView *_backScroll;
    UIView *_backView;
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
    backScroll.contentSize = CGSizeMake(kWidth, [UIScreen mainScreen].applicationFrame.size.height);

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(YYBORDERW, YYBORDERW, kWidth-YYBORDERW*2, 350)];
    backView.backgroundColor =[UIColor whiteColor];
    [backScroll addSubview:backView];
    backView.layer.cornerRadius=8;
    backView.layer.masksToBounds=YES;
    _backView = backView;
    
    //订单详情按钮
    UIButton *orderBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:orderBtn ];
    [orderBtn setImage:LOADPNGIMAGE(@"sureSubscri_img0") forState:UIControlStateNormal];
    [orderBtn setTitle:@"  订单详情" forState:UIControlStateNormal];
    [orderBtn setTitleColor:HexRGB(0x605e5f) forState:UIControlStateNormal];
    orderBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
    orderBtn.frame =CGRectMake(0, YYBORDERWw, 130, 30);
//    orderBtn.enabled = NO;
    
    [self calculate];
    _type = [SystemConfig sharedInstance].menuType;
    //根据type判断显示的label
    if (_type == 0) {
        //亲临鱼府
       //判断有没有点餐，控制订单金额label显示与否
        if ([_totalPrice intValue] != 0) {
            NSArray *titles = @[ [NSString stringWithFormat:@"订单金额:  %@ 元",_totalPrice], [NSString stringWithFormat:@"联系人：%@",_data.contact], [NSString stringWithFormat:@"电话：%@",_data.tel],[NSString stringWithFormat:@"就餐人数：%@",_data.people_num],[NSString stringWithFormat:@"就餐时间：%@",_data.use_time],[NSString stringWithFormat:@"其他就餐要求：%@",_data.remark] ];
            [self buildWithData:titles];
        }else
        {
            NSArray *titles = @[[NSString stringWithFormat:@"联系人：%@",_data.contact], [NSString stringWithFormat:@"电话：%@",_data.tel],[NSString stringWithFormat:@"就餐人数：%@",_data.people_num],[NSString stringWithFormat:@"就餐时间：%@",_data.use_time],[NSString stringWithFormat:@"其他就餐要求：%@",_data.remark] ];
            [self buildWithData:titles];
        }
        
    }else if (_type == 1)
    {
        //外带取餐
        NSArray *titles = @[ [NSString stringWithFormat:@"订单金额:  %@ 元",_totalPrice], [NSString stringWithFormat:@"联系人：%@",_data.contact], [NSString stringWithFormat:@"电话：%@",_data.tel],[NSString stringWithFormat:@"取餐时间：%@",_data.use_time],[NSString stringWithFormat:@"其他就餐要求：%@",_data.remark] ];
        [self buildWithData:titles];
    }else
    {
        //外卖服务
        NSArray *titles = @[ [NSString stringWithFormat:@"订单金额:  %@ 元",_totalPrice], [NSString stringWithFormat:@"联系人：%@",_data.contact], [NSString stringWithFormat:@"电话：%@",_data.tel],[NSString stringWithFormat:@"地址：%@",_data.address_content],[NSString stringWithFormat:@"送达时间：%@",_data.use_time],[NSString stringWithFormat:@"其他就餐要求：%@",_data.remark] ];
        [self buildWithData:titles];
    }
}

#pragma mark 画UI
-(void)buildWithData:(NSArray *)array
{
    //订单详情
    NSUInteger count = array.count;
    for (int p = 0; p < count; p++) {
        
        BOOL hasOther  = YES;
        NSString *other = _data.remark;
        if (other.length == 0) {
            hasOther = NO;
        }
        UILabel *orderLabel;
        if (p < count - 1) {
             orderLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBORDERW + KSpace, YYBORDERWw+40+p%count*(YYBORDERY+20), kWidth-YYBORDERWw*2-YYBORDERW*2, 20 )];
            [_backView addSubview:orderLabel];
            orderLabel.backgroundColor =[UIColor clearColor];
            orderLabel.font =[UIFont systemFontOfSize:PxFont(20)];
            orderLabel.textColor=HexRGB(0x605e5f);
            orderLabel.textAlignment = NSTextAlignmentLeft;
            orderLabel.text=array[p];
        }
        
        if (p == count - 2) {//判断有没有其他就餐要求
            if (!hasOther) {
               viewH = CGRectGetMaxY(orderLabel.frame)  + 15;
            }
        }
        if (p == count - 1) {
            if (hasOther) {
                UILabel *orderLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBORDERW + KSpace, YYBORDERWw+40+p%count*(YYBORDERY+20), kWidth-YYBORDERWw*2-YYBORDERW*2, 20 )];
                [_backView addSubview:orderLabel];
                orderLabel.backgroundColor =[UIColor clearColor];
                orderLabel.font =[UIFont systemFontOfSize:PxFont(20)];
                orderLabel.textColor=HexRGB(0x605e5f);
                orderLabel.textAlignment = NSTextAlignmentLeft;
                orderLabel.text=array[p];
                viewH = CGRectGetMaxY(orderLabel.frame)  + 15;
            }
        }
    }
    
    if ([_totalPrice intValue] != 0) {
        
        //已选菜品按钮
        UIButton *foodBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_backView addSubview:foodBtn ];
        [foodBtn setImage:LOADPNGIMAGE(@"sureSubscri_img1") forState:UIControlStateNormal];
        [foodBtn setTitle:@"  已选菜品" forState:UIControlStateNormal];
        [foodBtn setTitleColor:HexRGB(0x605e5f) forState:UIControlStateNormal];
        foodBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        CGFloat foodBtnY = viewH;
        foodBtn.frame =CGRectMake(0, foodBtnY, 130, 30);
        //    foodBtn.enabled = NO;
        
        //已选菜品
        NSUInteger number = _orderCategoryArray.count;
        CGFloat startY = CGRectGetMaxY(foodBtn.frame);
        for (int l=0; l<number;l++) {
            
            UILabel *orderCategory =[[UILabel alloc]initWithFrame:CGRectMake(YYBORDERW+l%2*(kWidth-YYBORDERWw*6-YYBORDERW*6) + KSpace, startY + l/2*(YYBORDERY+20), (kWidth-YYBORDERWw*2-YYBORDERW*2)/2, 20 )];
            [_backView addSubview:orderCategory];
            orderCategory.backgroundColor =[UIColor clearColor];
            orderCategory.font =[UIFont systemFontOfSize:PxFont(20)];
            orderCategory.textColor=HexRGB(0x605e5f);
            orderCategory.textAlignment = NSTextAlignmentLeft;
            orderCategory.text=_orderCategoryArray[l];
            
            if (l == _orderCategoryArray.count - 1) {
                viewH = CGRectGetMaxY(orderCategory.frame) + 10;
            }
        }
        
        UILabel *warning = [[UILabel alloc] init];
        warning.textColor=HexRGB(0x605e5f);
        warning.font =[UIFont systemFontOfSize:PxFont(20)];
        [_backView addSubview:warning];
        warning.text = @"温馨提示：为了您的方便，请在预定的时间内到达，若超过10分钟未到达，我们将另行安排";
        CGFloat detailH = [AdaptationSize getSizeFromString:warning.text Font:[UIFont systemFontOfSize:PxFont(20)] withHight: CGFLOAT_MAX withWidth:kWidth-YYBORDERWw*2-YYBORDERW*2].height;
        warning.frame  = Rect(YYBORDERW + KSpace, viewH, kWidth - YYBORDERW*4, detailH);
        warning.numberOfLines = 0;
        warning.backgroundColor =[UIColor clearColor];
        warning.textColor=HexRGB(0x605e5f);
        
        viewH = CGRectGetMaxY(warning.frame) + 10;
        
        CGRect backF = _backView.frame;
        backF.size.height = viewH;
        _backView.frame = backF;
        
        UIButton *conform = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat conformY = CGRectGetMaxY(_backView.frame) + 20;
        conform.frame = Rect(YYBORDERW, conformY, _backView.frame.size.width, 40);
        [conform setBackgroundImage:LOADPNGIMAGE(@"submit_ok") forState:UIControlStateNormal];
        [conform addTarget:self action:@selector(conform) forControlEvents:UIControlEventTouchUpInside];
        [_backScroll addSubview:conform];
        
        viewH = CGRectGetMaxY(conform.frame) + 10;
        _backScroll.contentSize = CGSizeMake(kWidth, viewH);
        
    }else
    {
        UILabel *warning = [[UILabel alloc] init];
        warning.textColor=HexRGB(0x605e5f);
        warning.font =[UIFont systemFontOfSize:PxFont(20)];
        [_backView addSubview:warning];
        warning.text = @"温馨提示：为了您的方便，请在预定的时间内到达，若超过10分钟未到达，我们将另行安排";
        CGFloat detailH = [AdaptationSize getSizeFromString:warning.text Font:[UIFont systemFontOfSize:PxFont(20)] withHight: CGFLOAT_MAX withWidth:kWidth-YYBORDERWw*2-YYBORDERW*2].height;
        warning.frame  = Rect(YYBORDERW + KSpace, viewH, kWidth - YYBORDERW*4, detailH);
        warning.numberOfLines = 0;
        warning.backgroundColor =[UIColor clearColor];
        warning.textColor=HexRGB(0x605e5f);
        
        viewH = CGRectGetMaxY(warning.frame) + 10;
        
        CGRect backF = _backView.frame;
        backF.size.height = viewH;
        _backView.frame = backF;
        
        UIButton *conform = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat conformY = CGRectGetMaxY(_backView.frame) + 20;
        conform.frame = Rect(YYBORDERW, conformY, _backView.frame.size.width, 40);
        [conform setBackgroundImage:LOADPNGIMAGE(@"submit_ok") forState:UIControlStateNormal];
        [conform addTarget:self action:@selector(conform) forControlEvents:UIControlEventTouchUpInside];
        [_backScroll addSubview:conform];
        viewH = CGRectGetMaxY(conform.frame) + 10;
        _backScroll.contentSize = CGSizeMake(kWidth, viewH);
    }
}

#pragma mark 计算总金额和已选菜单
-(void)calculate
{
    NSMutableArray *array = [CarTool sharedCarTool].totalCarMenu;
    NSUInteger count = array.count;
    NSString *show = [NSString string];
    int price = 0;
    for (int i = 0; i < count; i++) {
        MenuModel * menu = array[i];
        NSString * name = menu.name;
        int num = menu.foodCount;
        NSString *total;
//        if (num == 1) {
//            total   = [NSString stringWithFormat:@""];
//        }else
//        {
//            total  = [NSString stringWithFormat:@" *%d",num];
//        }
        total  = [NSString stringWithFormat:@" *%d",num];
        price += num * [menu.price intValue];
        show = [NSString stringWithFormat:@"%@%@",name,total];
        [_orderCategoryArray addObject:show];
    }
    _totalPrice = [NSString stringWithFormat:@"%d",price];
}

-(void)conform
{
    NSMutableArray *array = [CarTool sharedCarTool].totalCarMenu;
    NSUInteger count = array.count;
    //当是从亲临鱼府提交的时候，就算count为0，也是可以提交的
    if (_type != 0) {
        if (count > 0) {
            [self submit];
        }else
        {
            [RemindView showViewWithTitle:@"请重新订餐，亲！" location:MIDDLE];
        }
    }else
    {
        [self submit];
    }
}

#pragma mark提交
-(void)submit
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    //时间转时间戳
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:_data.use_time];
    if (date ==nil) {
       [RemindView showViewWithTitle:@"您的提交信息与上条雷同，请修改后进行提交" location:MIDDLE];
    }else
    {
        // 显示指示器
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
        
        _data.use_time = [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970]];
        
        [subscribeHttpTool postOrderWithSuccess:^(NSArray *data, int code, NSString *msg) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            //删除购物车里的所有数据
            [[CarTool sharedCarTool] clear];
            
            //到预约页面
            MysubscribeView *ctl = [[MysubscribeView alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
            
        } uid:uid addressID:_data.address_id addressContent:_data.address_content contact:_data.contact tel:_data.tel type:_data.type usetime:_data.use_time peopleNum:_data.people_num remark:_data.remark price:_totalPrice products:_data.products withFailure:^(NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [RemindView showViewWithTitle:offline location:MIDDLE];
        }];
    }
}

@end
