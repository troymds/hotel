//
//  BaseNaviViewController.h
//  officialDemoNavi
//
//  Created by 刘博 on 14-7-24.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "Toast+UIView.h"
#import "UIView+Geometry.h"

@interface BaseNaviViewController : UIViewController <MAMapViewDelegate,AMapNaviManagerDelegate>

@property (nonatomic, strong) MAMapView *myMapView;

@property (nonatomic, strong) AMapNaviManager *naviManager;


@end
