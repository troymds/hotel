//
//  HomeController.m
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "HomeController.h"
#import "NiceFoodView.h"
#import "NiceFoodModel.h"
#import "MenuController.h"
#import "DetailFoodController.h"

#define KTopImgH  254 // 顶部展示图片高度
#define KStartY   20 //起始Y坐标（状态栏高度）
#define KMenuButtonW 143 //菜单按钮宽度
#define KMenyButtonH    56 //菜单按钮高度
#define KStartX   ((kWidth - KMenuButtonW * 2)/3) //x坐标左右间距
#define KMenuStartY (KTopImgH + KStartX + KStartY) //菜单按钮起始y
#define KNiceViewSpace  8    // 每个招牌美食view间的间距

@interface HomeController ()
{
    UIScrollView *_scroll;
    int viewHight;//sroolview的内容高度
    int niceFoodViewH ;//招牌美食的高度
}

@end

@implementation HomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = HexRGB(0xeeeeee);
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KStartY, kWidth, kHeight - KStartY - 44)];
    [self.view addSubview:_scroll];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.pagingEnabled = NO;
    _scroll.bounces = NO;
    _scroll.scrollEnabled = YES;
    _scroll.userInteractionEnabled = YES;
    [self buildUI];
}

#pragma mark 画UI
- (void)buildUI
{
    // 1 顶部展示图片
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:Rect(0, 0, kWidth, KTopImgH)];
    topImg.image = LOADPNGIMAGE(@"home_banner");
    [_scroll addSubview:topImg];
    
    // 2 添加4个菜单按钮
    int imgTag = 0;
    for (int i = 0; i < 2; i++) {//2行
        for (int j = 0; j < 2 ; j++) {//2列
            UIButton * menu = [UIButton buttonWithType:UIButtonTypeCustom];
            //计算frame
            CGFloat x = KStartX + (KMenuButtonW + KStartX) * j;
            CGFloat y = KMenuStartY + (KMenyButtonH + KStartX) * i;
            menu.frame = Rect(x, y, KMenuButtonW, KMenyButtonH);
           //设置图片和tag
            imgTag++;
            menu.tag = imgTag;
            NSString *imgNomralName = [NSString stringWithFormat:@"menu%d",imgTag];
            NSString *imgClickedName = [NSString stringWithFormat:@"menu%d_pre",imgTag];
            [menu setBackgroundImage:LOADPNGIMAGE(imgNomralName) forState:UIControlStateNormal];
            [menu setBackgroundImage:LOADPNGIMAGE(imgClickedName) forState:UIControlStateHighlighted];
            [menu addTarget:self action:@selector(buttonclicked:) forControlEvents:UIControlEventTouchUpInside];
            [_scroll addSubview:menu];
            if (i == 1) {
                viewHight = y + KMenyButtonH;
            }
        }
    }
    // 3 招牌美食
#warning 不能写死啊 啊啊啊啊
    niceFoodViewH = 100;
    UIImageView *foodImgLogo = [[UIImageView alloc] initWithFrame:Rect(KStartX, viewHight + 10, 30, 30)];
    foodImgLogo.image = LOADPNGIMAGE(@"招牌美食_icon");
    foodImgLogo.contentMode = UIViewContentModeScaleAspectFit;
    [_scroll addSubview:foodImgLogo];
    
    UILabel *foodText = [[UILabel alloc] initWithFrame:Rect(CGRectGetMaxX(foodImgLogo.frame) + 10, viewHight + 10, 100, 30)];
    foodText.text = @"招牌美食";
    foodText.font =[UIFont systemFontOfSize:PxFont(24)];
    foodText.textColor = HexRGB(0x666666);
    foodText.backgroundColor = [UIColor clearColor];
    foodText.textAlignment = NSTextAlignmentLeft;
    [_scroll addSubview:foodText];
    viewHight = CGRectGetMaxY(foodImgLogo.frame) + 5;
    
    for (int i = 0; i < 3; i++) {//3行招牌美食
        CGFloat y = viewHight + (niceFoodViewH + KNiceViewSpace) * i;
        CGFloat w = kWidth - KStartX * 2;
        NiceFoodView *foodView = [[NiceFoodView alloc] initWithBlock:^(NSInteger tag) {
            //进入菜品详情页面
            DetailFoodController * ctl = [[DetailFoodController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }];
        foodView.frame = Rect(KStartX - 2, y, w, niceFoodViewH);
        [_scroll addSubview:foodView];
        if (i == 1) {
            foodView.type = 1;
        }else
        {
            foodView.type = 0;
        }
        NiceFoodModel *data = [[NiceFoodModel alloc] init];
        foodView.data = data;
        if (i == 2) {
            viewHight = y + niceFoodViewH + 20;
        }
    }
    //设置scrollview的内容高度
    _scroll.contentSize = CGSizeMake(kWidth, viewHight) ;
}

#pragma mark 菜单按钮点击事件
- (void) buttonclicked:(UIButton *)btn
{
    switch (btn.tag) {
        case kHotrecommended:
            NSLog(@"热门推荐");
            break;
        case KLatestPrice:
            NSLog(@"最新优惠");
            break;
        case KMenu:
        {
            MenuController * ctl = [[MenuController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
        break;
        case KView:
            NSLog(@"渔府风采");
            break;
        default:
            break;
    }
}

#pragma mark 控件将要显示
- (void)viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

@end
