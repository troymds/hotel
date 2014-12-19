//
//  UIBarButtonItem+MJ.m
//
//
//  Created by apple on 13-10-27.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "UIBarButtonItem+MJ.h"

@implementation UIBarButtonItem (MJ)
- (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    UIView *viewItem =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    viewItem.backgroundColor =[UIColor clearColor];
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置普通背景图片
    UIImage *image = [UIImage imageNamed:icon];
    btn.backgroundColor =[UIColor clearColor];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    // 设置高亮图片
    [btn setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    
    // 设置尺寸
//    btn.bounds = (CGRect){CGPointZero, image.size};
    btn.frame =CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [viewItem addSubview:btn];
    return [self initWithCustomView:viewItem];
}

+ (id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    return [[self alloc] initWithIcon:icon highlightedIcon:highlighted target:target action:action];
}


- (id)initWithSearch:(NSString *)search highlightedSearch:(NSString *)highlighted target:(id)target action:(SEL)action
{
    UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *searchImage =[UIImage imageNamed:search];

    [searchBtn setBackgroundImage:searchImage forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    searchBtn.bounds =(CGRect){CGPointZero,searchImage.size};
//    searchBtn.frame = CGRectMake(-100, 10,230, 30);
    [searchBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [self initWithCustomView:searchBtn];
}
+ (id)itemWithSearch:(NSString *)search highlightedSearch:(NSString *)highlighted target:(id)target action:(SEL)action
{
    return [[self alloc]initWithSearch:search highlightedSearch:highlighted target:target action:action];
}

@end
