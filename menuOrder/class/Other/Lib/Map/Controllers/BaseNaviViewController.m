//
//  BaseNaviViewController.m
//  officialDemoNavi
//
//  Created by 刘博 on 14-7-24.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "BaseNaviViewController.h"

@implementation BaseNaviViewController

#pragma mark - Utility

//- (void)clearMapView
//{
//    self.myMapView.showsUserLocation = NO;
//    
//    [self.myMapView removeAnnotations:self.myMapView.annotations];
//    
//    [self.myMapView removeOverlays:self.myMapView.overlays];
//    
//    self.myMapView.delegate = nil;
//}
//
//#pragma mark - Handle Action
//
//- (void)returnAction
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    [self clearMapView];
//}

#pragma mark - Initialization

- (void)createMapView
{
    if (self.myMapView == nil)
    {
        self.myMapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    }
    
    self.myMapView.frame = self.view.bounds;

}

//- (void)initBaseNavigationBar
//{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                                                             style:UIBarButtonItemStyleBordered
//                                                                            target:self
//                                                                            action:@selector(returnAction)];
//}

- (void)initTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor whiteColor];
    titleLabel.text             = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

- (void)initNaviManager
{
    if (self.naviManager == nil)
    {
        _naviManager = [[AMapNaviManager alloc] init];
        [_naviManager setDelegate:self];
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.myMapView.delegate = self;
    [self initTitle:self.title];
    [self createMapView];
    [self initNaviManager];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}




@end
