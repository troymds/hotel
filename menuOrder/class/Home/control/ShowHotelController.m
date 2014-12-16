//
//  ShowHotelController.m
//  menuOrder
//  渔府风采
//  Created by promo on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "ShowHotelController.h"

@interface ShowHotelController ()

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
    
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = Rect(0, 0, kWidth, kWidth/1.25);
    img.image = LOADPNGIMAGE(@"home_banner");
    [self.view addSubview:img];
}

@end
