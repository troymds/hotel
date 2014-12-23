//
//  MapController.m
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MapController.h"
#import <MapKit/MapKit.h>
#import "phoneView.h"
#import "mapTool.h"
@interface MapController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView *_mapView;
}
@property(nonatomic,copy)NSString *fishLong;
@property(nonatomic,copy)NSString *fishLat;
@property(nonatomic,copy) MKPolyline *routeLine;
@property(nonatomic,copy)MKMapView *mapView;
@property(nonatomic,strong)MKPolylineView *routeLineView;



//getMapPosition
@end

@implementation MapController
@synthesize mapView=_mapView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self addLoadStatus];
    self.title = @"地图";
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self addLoadStatus];
    [self addUIView];
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
    
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]];
    [self.mapView addOverlay:self.routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine) {
        if(nil == self.routeLineView) {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 5;
        }
        return self.routeLineView;
    }
    return nil;
}
#pragma mark ----加载数据
-(void)addLoadStatus{
    [mapTool mapStatusesWithSuccess:^(NSArray *statues) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)drawTestLine
{
    CLLocation *location0 = [[CLLocation alloc] initWithLatitude:39.954245 longitude:116.312455];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:30.247871 longitude:120.127683];
    NSArray *array = [NSArray arrayWithObjects:location0, location1, nil];
    [self drawLineWithLocationArray:array];
}
#pragma mark 打电话
-(void)phoneBtnClick{
    [phoneView callPhoneNumber:@"13913008373" call:^(NSTimeInterval duration) {
        
    } cancel:^{
        
    } finish:^{
        
    }];
}
-(void)addUIView{
    _mapView =[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_mapView];
    _mapView.delegate =self;
    _mapView.showsUserLocation = YES;
    _mapView.userLocation.title = @"当前位置";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"定位" forState:UIControlStateNormal];
    [button setTitleColor:HexRGB(0x899c02) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(220, 20, 100, 50);
    [_mapView addSubview:button];
    
    UIButton *phoneTel = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneTel.backgroundColor =[UIColor clearColor];
    [phoneTel setImage:[UIImage imageNamed:@"Tel"] forState:UIControlStateNormal];
    [phoneTel setImage:[UIImage imageNamed:@"Tel_rep"] forState:UIControlStateHighlighted];
    
    [phoneTel addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    phoneTel.frame = CGRectMake(kWidth-85, kHeight-210, 55, 73);
    [self.view addSubview:phoneTel];
    [self.view bringSubviewToFront:phoneTel];
    
//    for (int i=0; i<100; i++) {
//        ZYAddress *address = [[ZYAddress alloc] init];
//        address.latitude = 118.772698 + i*0.001;
//        address.longitude = 32.074764 + i*0.001;
//        address.name = [NSString stringWithFormat:@"紫金渔府%d", i];
//        address.address = [NSString stringWithFormat:@"江苏南京鼓楼水佐岗鼓楼区水佐岗老菜市%d路", i];
//        
//        ZYAnnotation *annotation = [ZYAnnotation annotationWithAdress:address];
//        [_mapView addAnnotation:annotation];
//    }
    
    
    
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
}
- (void)buttonClick:(id)sender
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_mapView.userLocation.coordinate, 1000, 1000);
    MKCoordinateRegion newRegion = [_mapView regionThatFits:region];
    [_mapView setRegion:newRegion animated:YES];
}


@end
