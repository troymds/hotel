//
//  MapController.h
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYAnnotation.h"
#import <AMapNaviKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface MapController : UIViewController<MAMapViewDelegate,AMapNaviManagerDelegate>

@property (nonatomic, strong) MAMapView *myMapView;

@property (nonatomic, strong) AMapNaviManager *naviManager;

@end
