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
#import "FoodRecommendController.h"
#import "PromotionController.h"
#import "ShowHotelController.h"
#import "GetIndexHttpTool.h"
#import "HomePageDataModel.h"
#import "UIImageView+WebCache.h"

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

//@property (nonatomic, strong) NSString *adsImg;//顶部展示图片
@property (nonatomic, strong) NSArray *homeModelArray;//首页数据数组
@property (nonatomic, strong) NSArray *niceFoodArray;//招牌美食数组
@end

@implementation HomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat startY;
    CGFloat scroolH;
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        startY = KStartY;
    }else
    {
        startY = 0;
    }
    scroolH = kHeight - KStartY - 44;
    self.view.backgroundColor = HexRGB(0xeeeeee);
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, startY, kWidth, scroolH)];
    [self.view addSubview:_scroll];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.pagingEnabled = NO;
    _scroll.bounces = NO;
    _scroll.scrollEnabled = YES;
    _scroll.userInteractionEnabled = YES;
    
    _homeModelArray = [NSArray array];
    [self loadData];
}

#pragma mark 加载数据
- (void) loadData
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    [GetIndexHttpTool GetIndexDataWithSuccess:^(NSArray *data, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (data.count > 0) {
            //成功得到数据
            NSMutableArray *array = [NSMutableArray arrayWithArray:data];
            _homeModelArray = array;
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
    HomePageDataModel *data = [_homeModelArray objectAtIndex:0];

    self.niceFoodArray = data.hotProductList;
    // 1 顶部展示图片
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:Rect(0, 0, kWidth, KTopImgH)];
    [_scroll addSubview:topImg];
    [topImg setImageWithURL:[NSURL URLWithString:data.adsImg] placeholderImage:placeHoderloading];
    
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
            [menu setBackgroundImage:LOADPNGIMAGE(imgClickedName) forState:UIControlStateSelected];
            [menu setBackgroundImage:LOADPNGIMAGE(imgClickedName) forState:UIControlStateHighlighted];
            [menu addTarget:self action:@selector(buttonclicked:) forControlEvents:UIControlEventTouchUpInside];
            [_scroll addSubview:menu];
            if (i == 1) {
                viewHight = y + KMenyButtonH;
            }
        }
    }
    // 3 招牌美食
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
    
    //先判断NiceFoodView数据
    if (![self.niceFoodArray isKindOfClass:[NSNull class]]) {
        NSUInteger count = self.niceFoodArray.count;
        NSMutableArray *array;
        if (count > 0) {
            array = [NSMutableArray arrayWithCapacity:count];
            for (NSDictionary *d in self.niceFoodArray) {
                NiceFoodModel *data = [[NiceFoodModel alloc] initWithDic:d];
                [array addObject:data];
            }
        }
        //画NiceFoodView
        for (int i = 0; i < count; i++) {//count行招牌美食
            CGFloat y = viewHight + (niceFoodViewH + KNiceViewSpace) * i;
            CGFloat w = kWidth - KStartX * 2;
            NiceFoodView *foodView = [[NiceFoodView alloc] initWithBlock:^(NiceFoodModel* data) {
                //进入菜品详情页面
                DetailFoodController * ctl = [[DetailFoodController alloc] init];
                ctl.detailFoodIndex = data.ID;
                [self.navigationController pushViewController:ctl animated:YES];
            }];
            foodView.frame = Rect(KStartX - 2, y, w, niceFoodViewH);
            [_scroll addSubview:foodView];
            if (i % 2 != 0) {
                foodView.type = 1;
            }else
            {
                foodView.type = 0;
            }
            if (i == count - 1) {
                viewHight = y + niceFoodViewH + 20;
            }
            if (array.count > 0) {
                foodView.data = array[i];
            }
        }

    }
           //设置scrollview的内容高度
    _scroll.contentSize = CGSizeMake(kWidth, viewHight) ;
}

#pragma mark 菜单按钮点击事件
- (void) buttonclicked:(UIButton *)btn
{
    btn.selected = !btn.selected;

    [self performSelector:@selector(cancleBtnSelected:) withObject:btn afterDelay:0.1];
}

#pragma mark 取消按钮按下的效果
- (void)cancleBtnSelected:(id)parm
{
    UIButton *btn = (UIButton *)parm;
    btn.selected = !btn.selected;
    
    switch (btn.tag) {
        case kHotrecommended:
        {
            FoodRecommendController *ctl = [[FoodRecommendController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case KLatestPrice:
        {
            PromotionController *ctl = [[PromotionController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case KMenu:
        {
            MenuController * ctl = [[MenuController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case KView:
        {
            ShowHotelController * ctl = [[ShowHotelController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
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
