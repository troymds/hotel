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


#define KLeftXYDistence  10 //左上边距
#define KFoodImgH        120 //菜品展示图片高度
#define KFrameOffset     4
#define KDetailH         120 //菜品详情高度

@interface DetailFoodController ()<DetailFoodShowViewDelegate>
{
    DetailFoodShowView * _detailView; //菜单展示详情
    UIView *_detailFoodBackView;//菜单详情展示背景
}
@end

@implementation DetailFoodController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    NSLog(@"-------%@----",_detailFoodIndex);
    
    self.title = @"菜品详情";
    self.view.backgroundColor = HexRGB(0xeeeeee);
    
    [self buildUI];
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
    foodImg.image = LOADPNGIMAGE(@"home_banner");
//    foodImg.contentMode = UIViewContentModeScaleAspectFit;
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
    [detail.addBun addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [detail.plusBtn addTarget:self action:@selector(plusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    detail.delegate = self;
    [detailFoodBackView addSubview:detail];
    _detailView = detail;
    NiceFoodModel *data = [[NiceFoodModel alloc] init];
    detail.data = data;
    
    // 3 分享美食
    UIButton *shareBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat sharreBtnY = CGRectGetMaxY(detailFoodBackView.frame) + 40;
    shareBtn.frame = Rect(KLeftXYDistence, sharreBtnY, kWidth - KLeftXYDistence * 2, 40);
    [self.view addSubview:shareBtn];
    [shareBtn setBackgroundImage:LOADPNGIMAGE(@"home_share") forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:LOADPNGIMAGE(@"home_share_pre") forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(sharefood) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 加餐
-(void)addBtnClicked
{
    NSInteger count = [_detailView.foodConnt.text integerValue];
    count++;
    if (count > 0) {
        //减号按钮显示
        _detailView.plusBtn.hidden = NO;
    }
    _detailView.foodConnt.text = [NSString stringWithFormat:@"%ld",(long)count];
}

#pragma mark 减餐
-(void)plusBtnClicked
{
    NSInteger count = [_detailView.foodConnt.text integerValue];
    count--;
    if (count == 0) {
        //隐藏减号按钮
        _detailView.plusBtn.hidden = YES;
    }else
    {
        _detailView.plusBtn.hidden = NO;
    }
    _detailView.foodConnt.text = [NSString stringWithFormat:@"%ld",(long)count];
}

#pragma mark 分享
-(void)sharefood
{
    
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
}
@end
