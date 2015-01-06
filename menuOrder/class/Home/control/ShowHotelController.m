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
#define KSuration 0.6

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
    
    _imgArray = [NSMutableArray array];
    currentTag = KStartImgTag;
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
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (data.count > 0) {
            //成功得到数据
            _photoList = [NSMutableArray arrayWithArray:data];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIImageView *tmp = [[UIImageView alloc] init];
            [self.view addSubview:tmp];
            NSUInteger count = _photoList.count;
            int i ;
            for (i = 0; i < count; i++) {
                NSLog(@"--------%d",i);
//                __weak UIImageView *imageview = img;
                [tmp setImageWithURL:[NSURL URLWithString:_photoList[i]] placeholderImage:placeHoderloading completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    
                    UIImage *_img = image;
                    [_imgArray addObject:_img];
                    NSLog(@"%d",i);
                    if (i == count - 1) {
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

//- (void)addsub:(UIImageView *)img
//{
//    [_contentView addSubview:img];
//}

#pragma mark 画UI
- (void)buildUI
{
    
    UIView *contentView  = [[UIView alloc] init];
    [self.view addSubview:contentView];
    contentView.frame = Rect(0, 0, kWidth, kWidth/2);
    _contentView = contentView;
    
    //1 拿到所有图片view
    NSUInteger count = _imgArray.count;
    for (int i = 0; i < count; i++) {
        UIImageView *img = [[UIImageView alloc] init];
        img.frame = Rect(0, 0, kWidth, kWidth/2);
        img.tag = KStartImgTag + i;
        img.image = _imgArray[i];
//        [img setImageWithURL:[NSURL URLWithString:_photoList[i]] placeholderImage:placeHoderloading];
//        [self performSelector:@selector(addsub:) withObject:img afterDelay:0.6];
        [contentView addSubview:img];

    }
    
    //2 把第一张图片放在最上层
    UIImageView *firstView = (UIImageView *)[contentView viewWithTag:KStartImgTag];
    [_contentView bringSubviewToFront:firstView];
    
    CGFloat btnY = CGRectGetMaxY(contentView.frame) + 20;
    UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
    add.frame = Rect(180, btnY, 30, 30);
    [self.view addSubview:add];
    [add addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    _addBtn = add;
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeInfoDark];
    plus.frame = Rect(120, btnY, 30, 30);
    [self.view addSubview:plus];
    [plus addTarget:self action:@selector(plus) forControlEvents:UIControlEventTouchUpInside];
    _plusBtn = plus;
    plus.hidden = YES;
}

-(void)add
{
    currentTag += 1;
    if (currentTag > KStartImgTag) {
        _plusBtn.hidden = NO;
    }
    NSInteger maxTag = KStartImgTag + _photoList.count;
    
    [UIView transitionWithView:_contentView
                      duration:KSuration
                       options:UIViewAnimationOptionTransitionCurlUp
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
    
    if (currentTag == maxTag) {
        //没有下一张图片了
        _addBtn.hidden = YES;
    }
}

-(void)plus
{
    NSInteger smallestTag = KStartImgTag;
    currentTag--;
    if (currentTag == KStartImgTag) {
        _plusBtn.hidden = YES;
    }
    if (currentTag < KStartImgTag + _photoList.count) {
        _addBtn.hidden = NO;
    }
    [UIView transitionWithView:_contentView
                      duration:KSuration
                       options:UIViewAnimationOptionTransitionCurlDown
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
    
    if (smallestTag == currentTag) {
        //没有上一张图片了
    }}
@end
