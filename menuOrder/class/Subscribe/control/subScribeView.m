//
//  subScribeView.m
//  menuOrder
//
//  Created by promo on 15-1-16.
//  Copyright (c) 2015年 promo. All rights reserved.
//

#import "subScribeView.h"
#import "SystemConfig.h"

@interface subScribeView ()

@end

@implementation subScribeView

- (void)viewDidLoad {
    [super viewDidLoad];
    [SystemConfig sharedInstance].isGoHome = YES;
}
@end
