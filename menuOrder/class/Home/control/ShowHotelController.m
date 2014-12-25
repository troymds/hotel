//
//  ShowHotelController.m
//  menuOrder
//  渔府风采
//  Created by promo on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "ShowHotelController.h"
#import "GetIndexHttpTool.h"
#import "UIImageView+WebCache.h"
#import "PhotoListModel.h"

@interface ShowHotelController ()
@property (nonatomic, strong) NSArray *photoList;//图片地址列表
@end

@implementation ShowHotelController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"渔府风采";
    self.view.backgroundColor = HexRGB(0xe0e0e0);
    
//    _photoList = [NSArray array];
    [self loadData];
}

#pragma mark 加载数据
-(void)loadData
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [GetIndexHttpTool GetgetPhotoListWithSuccess:^(NSArray *data, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (data.count > 0) {
            //成功得到数据
            _photoList = [NSMutableArray arrayWithArray:data];
            [self buildUI];
        }else
        {
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }

    } withFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }];
}
#pragma mark 画UI
- (void)buildUI
{
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = Rect(0, 0, kWidth, kWidth/1.25);
    [img setImageWithURL:[NSURL URLWithString:_photoList[0]] placeholderImage:placeHoderloading];
    [self.view addSubview:img];

}

@end
