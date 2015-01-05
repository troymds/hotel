//
//  DetailFoodController.m
//  menuOrder
//  菜品详情页面
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "DetailFoodController.h"
#import "DetailFoodShowView.h"
#import "NiceFoodModel.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailModel.h"
#import "GetIndexHttpTool.h"
#import "FoodCarController.h"
#import "BBBadgeBarButtonItem.h"
#import "CarTool.h"
#import "MenuModel.h"
#import "CarClickedDelegate.h"
#import "ShareView.h"
#define KLeftXYDistence  10 //左上边距
#define KFoodImgH        120 //菜品展示图片高度
#define KFrameOffset     4
#define KDetailH         120 //菜品详情高度

@interface DetailFoodController ()<DetailFoodShowViewDelegate,CarClickedDelegate>
{
    DetailFoodShowView * _detailView; //菜单展示详情
    UIView *_detailFoodBackView;//菜单详情展示背景
    NSArray *_dataList;
    int _totaNum;
    UIButton *_shareBtn;
}
@end

@implementation DetailFoodController

-(void)viewWillAppear:(BOOL)animated
{
    //1 隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
    //2 计算购物车数量
    if (self.navigationItem.rightBarButtonItem) {
        BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
        barButton.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self totalCarNum] ];
    }
    //3 刷新表数据
    if (_dataList) {
        ProductDetailModel *model = _dataList[0];
        _detailView.data = model;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"菜品详情";
    self.view.backgroundColor = HexRGB(0xeeeeee);
    
    _totaNum = 0;
    //先获取购物车总数量
    [self totalCarNum];
    UIButton *foodcar = [UIButton buttonWithType:UIButtonTypeCustom];
    foodcar.frame = Rect(0, 0, 30, 30);
    [foodcar addTarget:self action:@selector(orderFood) forControlEvents:UIControlEventTouchUpInside];
    [foodcar setBackgroundImage:LOADPNGIMAGE(@"cart2") forState:UIControlStateNormal];
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomView:foodcar];
    
    barButton.badgeValue = [NSString stringWithFormat:@"%d",_totaNum];
    barButton.badgeBGColor = [UIColor whiteColor];
    barButton.badgeFont = [UIFont systemFontOfSize:11.5];
    barButton.badgeOriginX = 20;
    barButton.badgeOriginY = 0;
    barButton.shouldAnimateBadge = YES;
    self.navigationItem.rightBarButtonItem = barButton;

    
    [self loadDetailData];
}

-(void)orderFood
{
    FoodCarController *car = [[FoodCarController alloc] init];
    
    [self.navigationController pushViewController:car animated:YES];
}

#pragma mark 计算badgeNum
-(int)totalCarNum
{
    NSUInteger count = [CarTool sharedCarTool].totalCarMenu.count;
    int total = 0;
    for (int i = 0; i < count; i++) {
        MenuModel *data = [CarTool sharedCarTool].totalCarMenu[i];
        total += data.foodCount;
    }
    _totaNum = total;
    return _totaNum;
}

#pragma mark 获取产品详情
- (void)loadDetailData
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    [GetIndexHttpTool GetProductDetailWithSuccess:^(NSArray *data, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (data.count > 0) {
            //成功得到数据
            NSMutableArray *array = [NSMutableArray arrayWithArray:data];
            _dataList = array;
            [self buildUI];
        }else
        {
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }

    } product_id:self.detailFoodIndex withFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }];
}

#pragma mark 画UI
-(void)buildUI
{
     // 1.1 菜品展示图片背景view
    UIView *foodBackView = [[UIView alloc] init];
    foodBackView.frame = Rect(KLeftXYDistence, KLeftXYDistence, kWidth - KLeftXYDistence * 2, KFoodImgH);
    foodBackView.backgroundColor = [UIColor whiteColor];
    foodBackView.layer.cornerRadius = 4;
    [self.view addSubview:foodBackView];
    // 1.2 菜品展示图片
    UIImageView *foodImg  = [[UIImageView alloc] init];

    ProductDetailModel *model = _dataList[0];
    [foodImg setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:placeHoderloading];
//    foodImg.contentMode = UInViewContentModeScaleAspectFit;
    foodImg.layer.cornerRadius = 4;
    foodImg.layer.masksToBounds = YES;
    CGFloat imgW = foodBackView.frame.size.width - KFrameOffset * 2;
    CGFloat imgH = foodBackView.frame.size.height - KFrameOffset * 2;
    foodImg.frame = Rect(KFrameOffset, KFrameOffset, imgW, imgH);
    [foodBackView addSubview:foodImg];
    
    //2.1  菜品详情 背景view
    UIView *detailFoodBackView =[[UIView alloc] init];
    CGFloat detailY = CGRectGetMaxY(foodBackView.frame) + KLeftXYDistence;
    detailFoodBackView.frame = Rect(KLeftXYDistence, detailY, kWidth - KLeftXYDistence * 2, KDetailH);
    detailFoodBackView.backgroundColor = [UIColor whiteColor];
    detailFoodBackView.layer.cornerRadius = 4;
    [self.view addSubview:detailFoodBackView];
    _detailFoodBackView = detailFoodBackView;
    
    //2.2 菜品详情
    DetailFoodShowView *detail = [[DetailFoodShowView alloc] initWithFrame:Rect(0, 0, kWidth - KLeftXYDistence * 2, KDetailH)];
    detail.delegate = self;
    detail.cardelegate = self;
    [detailFoodBackView addSubview:detail];
    _detailView = detail;
    detail.data = model;
    
    // 3 分享美食
    UIButton *shareBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat sharreBtnY = CGRectGetMaxY(detailFoodBackView.frame) + 40;
    shareBtn.frame = Rect(KLeftXYDistence, sharreBtnY, kWidth - KLeftXYDistence * 2, 40);
    [self.view addSubview:shareBtn];
    [shareBtn setBackgroundImage:LOADPNGIMAGE(@"home_share") forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:LOADPNGIMAGE(@"home_share_pre") forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(sharefood) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn = shareBtn;
}

#pragma mark 加减按钮点击
- (void)CarClickedWithData:(MenuModel *)data buttonType:(ButtonType)type
{
    //1 carTool更新购物车数据
    if (type == kButtonAdd) {
        [[CarTool sharedCarTool] addMenu:data];
    }else
    {
        [[CarTool sharedCarTool] plusMenu:data];
    }
    //2 购物车动画效果
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    int num = [self totalCarNum];
    //    NSLog(@"加减完后的购物车数量%d",num);
    barButton.badgeValue = [NSString stringWithFormat:@"%ld", (long)num ];
    //    NSLog(@"ID--%@, count--%@",data.ID,data.foodCount);
}

#pragma mark 分享
-(void)sharefood
{
     ProductDetailModel *model = _dataList[0];
    [ShareView showViewWithTitle:@"分享" content:model.cover description:model.cover url:model.cover delegate:self];
}

#pragma mark 动态变化的高度
- (void)detailFoodViewHeight:(CGFloat)height
{

    //1 detailBackView
    CGRect detailbackViewrect = _detailFoodBackView.frame;
    detailbackViewrect.size.height = height;
    _detailFoodBackView.frame = detailbackViewrect;
    
    //2 detailview
    CGRect detailViewrect = _detailView.frame;
    detailViewrect.size.height = height;
    _detailView.frame = detailViewrect;
    
    CGRect shareBtnRect = _shareBtn.frame;
    shareBtnRect.origin.y = CGRectGetMaxY(_detailFoodBackView.frame) + 40;
    _detailFoodBackView.frame = detailbackViewrect;
}
@end
