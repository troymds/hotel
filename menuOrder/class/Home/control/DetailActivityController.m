//
//  DetailActivityController.m
//  menuOrder
//
//  Created by promo on 14-12-31.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "DetailActivityController.h"
#import "GetIndexHttpTool.h"
#import "ActivityDetailModel.h"
#define KLeftXYDistence  10 //左上边距
#define KContentBackH        320 //内容背景高度
#define KFrameOffset     4
#define KDetailH         120 //菜品详情高度
#import "AdaptationSize.h"
#import "ShareView.h"
@interface DetailActivityController ()
{
    ActivityDetailModel *_model;
}

@end

@implementation DetailActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"活动详情";
    self.view.backgroundColor = HexRGB(0xe0e0e0);
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = Rect(0, 0, 33, 33);
    [rightBtn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:LOADPNGIMAGE(@"nav_activity") forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:LOADPNGIMAGE(@"nav_activity_pre") forState:UIControlStateHighlighted];
    
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self loadDetailData];
    [self detailActivityStatus];
    
}

#pragma mark====加载数据
-(void)detailActivityStatus{
    
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    [GetIndexHttpTool GetDetailID:_ID GetActivitiesDetailWithSuccess:^(NSArray *data, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        _model=[[ActivityDetailModel alloc]init];
        NSDictionary *dict=[data objectAtIndex:0    ];
        _model.content =[dict objectForKey:@"content"];
        _model.cover =[dict objectForKey:@"cover"];
        _model.end_date =[dict objectForKey:@"end_date"];
        _model.start_date =[dict objectForKey:@"start_date"];
        _model.title =[dict objectForKey:@"title"];

        
        [self buildUI];
// self.navigationItem.rightBarButtonItem =[UIBarButtonItem itemWithIcon:@"nav_activity" highlightedIcon:@"nav_activity_pre" target:self action:@selector(shareClick)];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:MIDDLE];

    }];
}
#pragma mark---分享
//-(void)shareClick{
//    [ShareView showViewWithTitle:_model.content content:_model.content  description:_model.content  url:_model.content  delegate:self];
//}
-(void)buildUI
{
    UIScrollView *backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [self.view addSubview:backScrollView];
    backScrollView .backgroundColor =HexRGB(0xe0e0e0);
    backScrollView.showsHorizontalScrollIndicator=YES;
    backScrollView.showsVerticalScrollIndicator=YES;
    
    // 1.1 内容背景view
    UIView *contentBackView = [[UIView alloc] init];
    contentBackView.frame = Rect(KLeftXYDistence, KLeftXYDistence, kWidth - KLeftXYDistence * 2, backScrollView.contentSize.height-90);
    contentBackView.backgroundColor = [UIColor whiteColor];
    contentBackView.layer.cornerRadius = 4;
    [backScrollView addSubview:contentBackView];
    // 1.2 展示图片
    UIImageView *foodImg  = [[UIImageView alloc] init];
    
    [foodImg setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:placeHoderImage3];
    foodImg.layer.cornerRadius = 4;
    foodImg.layer.masksToBounds = YES;
    CGFloat imgW = contentBackView.frame.size.width - KFrameOffset * 2;
    CGFloat imgH = imgW / 2;
    foodImg.frame = Rect(KFrameOffset, KFrameOffset, imgW, imgH);
    [contentBackView addSubview:foodImg];
    //1.3 title
    UILabel *title = [[UILabel alloc] init];
    CGFloat titleX = foodImg.frame.origin.x + 10;
    CGFloat titleY  = CGRectGetMaxY(foodImg.frame) + 10;
    CGFloat titleW = 150;
    CGFloat titleH = 30;
    title.frame = Rect(titleX, titleY, titleW, titleH);
    title.font = [UIFont systemFontOfSize:PxFont(24)];
    title.textColor = HexRGB(0x605e5f);
    title.backgroundColor = [UIColor clearColor];
    title.text = _model.title;
    [contentBackView addSubview:title];
    
    //1.4.0 时间
    UILabel *star_date = [[UILabel alloc] init];
    CGFloat dateW = kWidth-KLeftXYDistence*2;
    CGFloat dateX = foodImg.frame.origin.x + 10;
    CGFloat dateY  = titleY+20;
    CGFloat dateH = 27;
    star_date.frame = Rect(dateX, dateY, dateW, dateH);
    star_date.font = [UIFont systemFontOfSize:PxFont(22)];
    star_date.textColor = HexRGB(0x605e5f);
    star_date.backgroundColor = [UIColor clearColor];
    star_date.text = [NSString stringWithFormat:@"活动时间：%@至%@",_model.start_date,_model.end_date];
    [contentBackView addSubview:star_date];
    
    
    //1.5 detail
    UILabel *detail = [[UILabel alloc] init];
    detail.numberOfLines = 0;
    detail.text = _model.content;
    CGFloat detailW = contentBackView.frame.size.width - KFrameOffset * 10;
    CGFloat detailX = titleX + 10;
    CGFloat detailY  = titleY + 50;
    CGFloat detailH = [AdaptationSize getSizeFromString:detail.text Font:[UIFont systemFontOfSize:PxFont(16)] withHight: CGFLOAT_MAX withWidth:detailW].height;
    detail.frame = Rect(detailX, detailY, detailW, detailH);
    detail.font = [UIFont systemFontOfSize:PxFont(16)];
    detail.textColor = HexRGB(0x605e5f);
    detail.backgroundColor = [UIColor clearColor];
    [contentBackView addSubview:detail];
    backScrollView .contentSize=CGSizeMake(kWidth, detailY+detailH+100);
    contentBackView.frame = Rect(KLeftXYDistence, KLeftXYDistence, kWidth - KLeftXYDistence * 2, backScrollView.contentSize.height-90);

}
#pragma mark 获得详情活动
-(void)loadDetailData
{
    
}

-(void)rightBtn
{
    [ShareView showViewWithTitle:_model.content content:_model.content  description:_model.content  url:_model.content  delegate:self];
}

@end
