//
//  ShowHotelController.m
//  menuOrder
//  渔府风采
//  Created by promo on 14-12-16.
//  Copyright (c) KStartImgTag4年 promo. All rights reserved.
//

#import "ShowHotelController.h"
#import "GetIndexHttpTool.h"
#import "UIImageView+WebCache.h"
#import "PhotoListModel.h"

#define KStartImgTag 200
#define KSuration 1.1
#define KWHRatiao 0.8
@interface ShowHotelController ()
{
    UIImageView *_view1;
    UIImageView *_view2;
    UIImageView *_view3;
    UIView *_contentView;
    NSInteger currentTag;
    UIButton *_addBtn;
    UIButton *_plusBtn;
    NSMutableArray *_imgArray;
}
@property (nonatomic, strong) NSArray *photoList;//图片地址列表
@end

@implementation ShowHotelController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"渔府风采";
    self.view.backgroundColor = HexRGB(0x141414);
    
    //加左右滑动
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setNumberOfTouchesRequired:1];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setNumberOfTouchesRequired:1];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];

    
    _imgArray = [NSMutableArray array];
    currentTag = KStartImgTag;

    [self loadData];
}


//识别侧滑
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self add];
    }
    else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self plus];
    }
}

#pragma mark 加载数据
-(void)loadData
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    [GetIndexHttpTool GetgetPhotoListWithSuccess:^(NSArray *data, int code, NSString *msg) {
        if (data.count > 0) {
            //成功得到数据
            _photoList = [NSMutableArray arrayWithArray:data];
            //拿到所有的图片
            NSUInteger count = _photoList.count;
            __block int num = 0;
            for (int i = 0; i < count; i++) {
                UIImageView *tmp = [[UIImageView alloc] init];
                [self.view addSubview:tmp];
        
                [tmp setImageWithURL:[NSURL URLWithString:_photoList[i]] placeholderImage:placeHoderloading completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    num++;
                    UIImage *_img = image;
                    if (_img == nil) {
                        _img = LOADPNGIMAGE(@"home_banner");
                    }
                    [_imgArray addObject:_img];
                    if (num == count) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [self buildUI];
                    }
                }];
            }
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
    UIView *contentView  = [[UIView alloc] init];
    [self.view addSubview:contentView];
    CGFloat viewH = kWidth / KWHRatiao;
    contentView.frame = Rect(0, 0, kWidth, viewH);
    CGFloat x = kWidth / 2;
    CGFloat y = KAppHeight / 2;
    contentView.center = CGPointMake(x, y);
    _contentView = contentView;
    
    //1 拿到所有图片view
    NSUInteger count = _imgArray.count;
    for (int i = 0; i < count; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        UIImageView *img = [[UIImageView alloc] init];
        [img addGestureRecognizer:tap];
        [img setUserInteractionEnabled:YES];
        img.frame = Rect(0, 0, kWidth, viewH);
        img.tag = KStartImgTag + i;
        img.image = _imgArray[i];
        [contentView addSubview:img];
    }
    
    //2 把第一张图片放在最上层
    UIImageView *firstView = (UIImageView *)[contentView viewWithTag:KStartImgTag];
    [_contentView bringSubviewToFront:firstView];

}

#pragma mark 点击图片返回上页
-(void)handleTap:(UITapGestureRecognizer *)tap
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 下一页
-(void)add
{
    //判断，如果当前页面大于最后一张图片，则把当前页面设置成第一张显示。
    currentTag++;
    _type = KNext;
    if (currentTag >= KStartImgTag + _imgArray.count) {
        currentTag = KStartImgTag;
    }
    [self showCurrentImg:_type];
    
}

#pragma mark 翻页显示当前图片
-(void)showCurrentImg:(annimoType)type
{
    UIViewAnimationOptions op;
    if (type == KNext) {
        op = UIViewAnimationOptionTransitionCurlUp;
    }else
    {
        op = UIViewAnimationOptionTransitionCurlDown;
    }
    [UIView transitionWithView:_contentView
                      duration:KSuration
                       options:op
                    animations:^{
                        //根据tag得到需要显示的当前图片
                        UIImageView *imgView = nil;
                        for (UIView *view in _contentView.subviews) {
                            if ([view isKindOfClass:[UIImageView class]]) {
                                imgView = (UIImageView *)view;
                                if (imgView.tag == currentTag) {
                                    [_contentView bringSubviewToFront:imgView];
                                    break;
                                }
                            }
                        }
                    }
                    completion:NULL
     ];
}

#pragma mark 上一页
-(void)plus
{
    currentTag--;
    //判断，如果当前页面小于首张图片，则把当前页面设置成最后一张显示。
    _type = KForward;
    if (currentTag < KStartImgTag) {
        currentTag = KStartImgTag + _imgArray.count - 1;
    }
    [self showCurrentImg:_type];
}


@end
