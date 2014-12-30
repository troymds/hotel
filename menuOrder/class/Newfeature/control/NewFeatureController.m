//
//  NewFeatureController.m
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "NewFeatureController.h"
#import "UIImage+MJ.h"
#import "MainController.h"

#define kCount 3

@interface NewFeatureController ()<UIScrollViewDelegate>
{
    UIScrollView *_scroll;
    UIImageView *currentImgView;
    NSTimer *firTimer;
    NSTimer *secTimer;
    NSMutableArray *scrollImgArray;
    
    float x;
}
@end

@implementation NewFeatureController

- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"Default.png"];
    /*
     以3.5inch为例（320x480）
     1> 当没有状态栏，applicationFrame的值{{0, 0}, {320, 480}}
     2> 当有状态栏，applicationFrame的值{{0, 20}, {320, 460}}
     */
    imageView.frame = [UIScreen mainScreen].bounds;
    // 跟用户进行交互（这样才可以接收触摸事件）
    imageView.userInteractionEnabled = YES;
    self.view = imageView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor  = [UIColor blueColor];
    [self addScrollView];
    [self addScrollImages];
}

#pragma mark 添加滚动视图
- (void)addScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = self.view.bounds;
    scroll.showsHorizontalScrollIndicator = NO; // 隐藏水平滚动条
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, kHeight); // 内容尺寸
    scroll.pagingEnabled = YES; // 分页
    scroll.delegate = self;
    scroll.bounces = NO;
    [self.view addSubview:scroll];
    _scroll = scroll;
}

- (void)firCreatTimer
{
    firTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(firChangeImgFrame) userInfo:nil repeats:YES];
    [firTimer fire];
}
- (void)secCreatTimer
{
    secTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(secChangeImgFrame) userInfo:nil repeats:YES];
    [secTimer fire];
}

#pragma mark 添加滚动显示的图片
- (void)addScrollImages
{
    scrollImgArray = [[NSMutableArray alloc] initWithCapacity:0];
    CGSize size = _scroll.frame.size;
    
    for (int i = 0; i<kCount; i++)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        
        scrollView.frame = CGRectMake(i * size.width, 0, size.width, size.height);
        //        scrollView.contentSize = CGSizeMake(500, size.height);
        scrollView.delegate = self;
        [_scroll addSubview:scrollView];
        
        
        
        UIImageView *scrollImgView = [[UIImageView alloc] init];
        // 1.显示图片
        NSString *imgName = [NSString stringWithFormat:@"bg_%d.png", i+1 ];
        scrollImgView.image = [UIImage imageNamed:imgName];
        // 2.设置frame
        scrollImgView.frame = CGRectMake(0, 0, 500, size.height);
        [scrollView addSubview:scrollImgView];
        
        [scrollImgArray addObject:scrollImgView];
        
        if (i == 0)
        {
            currentImgView = scrollImgView;
        }
        
        
        UIImageView *textImgView = [[UIImageView alloc] init];
        // 1.显示图片
        NSString *name = [NSString stringWithFormat:@"text%d.png", i+1 ];
        textImgView.image = [UIImage imageNamed:name];
        // 2.设置frame
        textImgView.frame = CGRectMake(i * size.width, size.height - 227, size.width, 113);
        [_scroll addSubview:textImgView];
        
        
        
        if (i == kCount - 1)
        { // 最后一页，添加2个按钮
            // 3.立即体验（开始）
            UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *startNormal = [UIImage resizedImage:@"ok"];
            [start setBackgroundImage:startNormal forState:UIControlStateNormal];
            [start setBackgroundImage:[UIImage resizedImage:@"ok_pre"] forState:UIControlStateHighlighted];
            start.frame =CGRectMake(75, size.height - 56 - 21 , size.width - 150, 42);
            //            [start setTitle:@"立即进入" forState:UIControlStateNormal];
            //            start.titleLabel.font =[UIFont systemFontOfSize:PxFont(30)];
            
            [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:start];
            
            //            scrollView.userInteractionEnabled = YES;
        }
    }
    
    
    [self firCreatTimer];
}

- (void)firChangeImgFrame
{
    CGRect frame = currentImgView.frame;
    
    frame.origin.x -= 0.1;
    
    if (frame.origin.x <= - 120.000000)
    {
        [firTimer invalidate];
        [self secCreatTimer];
    }
    
    
    currentImgView.frame = frame;
    
    
    //    NSLog(@"%@, -> %@",[NSThread mainThread],currentImgView);
}

- (void)secChangeImgFrame
{
    CGRect frame = currentImgView.frame;
    frame.origin.x += 0.1;
    
    
    if (frame.origin.x >= 0)
    {
        
        [secTimer invalidate];
        [self firCreatTimer];
        
    }
    
    
    currentImgView.frame = frame;
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    x = scrollView.contentOffset.x;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index =  scrollView.contentOffset.x / 320;
    
    if (x != scrollView.contentOffset.x)
    {
        
        if (firTimer)
        {
            [firTimer invalidate];
        }
        if (secTimer)
        {
            [secTimer invalidate];
        }
        
        
        currentImgView = [scrollImgArray objectAtIndex:index];
        [self firCreatTimer];
    }
    
}

-(void)start
{
    if (firTimer)
    {
        [firTimer invalidate];
    }
    if (secTimer)
    {
        [secTimer invalidate];
    }
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.view.window.rootViewController =[[MainController alloc]init];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark ios7 以上隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
}
@end
