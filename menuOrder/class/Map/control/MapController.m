//
//  MapController.m
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MapController.h"
#import <MapKit/MapKit.h>
@interface MapController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView *_mapView;
    UIImageView *routeView;
    MKPolyline *routeLine;
    MKPolygonView *routeLineView;
}


@end

@implementation MapController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"地图";
    self.view.backgroundColor = [UIColor orangeColor];
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    _mapView =[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_mapView];
    _mapView.delegate =self;
    _mapView.showsUserLocation = YES;
    
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager.delegate=self;//设置代理
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    locationManager.distanceFilter=1000.0f;//设置距离筛选器
    [locationManager startUpdatingLocation];//启动位置管理器
    MKCoordinateSpan theSpan;
    //    //地图的范围 越小越精确
    theSpan.latitudeDelta=0.05;
    theSpan.longitudeDelta=0.05;
    MKCoordinateRegion theRegion;
    theRegion.center=[[locationManager location] coordinate];
    theRegion.span=theSpan;
    [_mapView setRegion:theRegion];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [_mapView setVisibleMapRect:[routeLine boundingMapRect]];
    [_mapView addOverlay:routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay
{
    if(overlay == routeLine) {
        if(nil == routeLineView) {
            routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine];
            routeLineView.fillColor = [UIColor redColor];
            routeLineView.strokeColor = [UIColor redColor];
            routeLineView.lineWidth = 5;
        }
        return routeLineView;
    }
    return nil;
}
@end
